// prayer_times_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/prayer_times_bloc.dart';
import '../models/prayer_schedule.dart';
import '../repositories/prayer_time_repository.dart';

const _kProvinsi = 'DKI JAKARTA';
const _kKabkota = 'Kota Jakarta';

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (_) => PrayerTimesBloc(PrayerTimesRepository())
        ..add(
          PrayerTimesLoaded(
            params: PrayerParams(
              provinsi: _kProvinsi,
              kabkota: _kKabkota,
              bulan: now.month.toString(),
              tahun: now.year.toString(),
            ),
          ),
        ),
      child: const _PrayerTimesView(),
    );
  }
}

// ─── Main view ────────────────────────────────────────────────────────────────
class _PrayerTimesView extends StatelessWidget {
  const _PrayerTimesView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoading || state is PrayerTimesInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D6B6B)),
          );
        }

        if (state is PrayerTimesFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 48,
                    color: Color(0xFF5A7070),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF5A7070)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6B6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final now = DateTime.now();
                      context.read<PrayerTimesBloc>().add(
                        PrayerTimesLoaded(
                          params: PrayerParams(
                            provinsi: _kProvinsi,
                            kabkota: _kKabkota,
                            bulan: now.month.toString(),
                            tahun: now.year.toString(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = (state as PrayerTimesSuccess).data;
        final now = DateTime.now();
        final schedule = data.scheduleForDate(now);

        if (schedule == null) {
          return const Center(child: Text('No schedule for today.'));
        }

        return _ScheduleBody(
          schedule: schedule,
          kabkota: data.kabkota,
          bulanNama: data.bulanNama,
          tahun: data.tahun,
          now: now,
        );
      },
    );
  }
}

// ─── Schedule body ────────────────────────────────────────────────────────────
class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({
    required this.schedule,
    required this.kabkota,
    required this.bulanNama,
    required this.tahun,
    required this.now,
  });

  final PrayerSchedule schedule;
  final String kabkota;
  final String bulanNama;
  final int tahun;
  final DateTime now;

  // Parses "HH:mm" into today's DateTime
  DateTime _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Returns ("PRAYER_NAME", time) of the next upcoming prayer
  ({String name, DateTime time})? _nextPrayer() {
    final prayers = [
      ('Subuh', _parseTime(schedule.subuh)),
      ('Dhuhr', _parseTime(schedule.dzuhur)),
      ('Asr', _parseTime(schedule.ashar)),
      ('Maghrib', _parseTime(schedule.maghrib)),
      ('Isha', _parseTime(schedule.isya)),
    ];
    for (final p in prayers) {
      if (p.$2.isAfter(now)) return (name: p.$1, time: p.$2);
    }
    return null;
  }

  String _countdown(DateTime target) {
    final diff = target.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) {
      return 'in $h hour${h > 1 ? 's' : ''} and $m minute${m != 1 ? 's' : ''}';
    }
    return 'in $m minute${m != 1 ? 's' : ''}';
  }

  // Which prayer is currently active (past but closest before now)
  String? _activePrayer() {
    final prayers = [
      ('Subuh', _parseTime(schedule.subuh)),
      ('Dhuhr', _parseTime(schedule.dzuhur)),
      ('Asr', _parseTime(schedule.ashar)),
      ('Maghrib', _parseTime(schedule.maghrib)),
      ('Isha', _parseTime(schedule.isya)),
    ];
    String? active;
    for (final p in prayers) {
      if (p.$2.isBefore(now)) active = p.$1;
    }
    return active;
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextPrayer();
    final active = _activePrayer();
    final dayStr = DateFormat('EEEE, d MMMM yyyy').format(now);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero card ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D6B6B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  next != null
                      ? 'NEXT PRAYER: ${next.name.toUpperCase()}'
                      : 'ALL PRAYERS DONE',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  next != null ? DateFormat('hh:mm a').format(next.time) : '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                if (next != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _countdown(next.time),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kabkota,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            dayStr,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Prayer list ────────────────────────────────────────────────────
          ...schedule.displayPrayers.map((p) {
            final name = p.$1;
            final time = p.$2;
            final isSunrise = p.$3;
            final isUpcoming = next?.name == name;
            final isActive = active == name && !isUpcoming;

            return _PrayerRow(
              name: name,
              time: time,
              isSunrise: isSunrise,
              isUpcoming: isUpcoming,
              isActive: isActive,
            );
          }),
        ],
      ),
    );
  }
}

// ─── Prayer Row ───────────────────────────────────────────────────────────────
class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.isSunrise,
    required this.isUpcoming,
    required this.isActive,
  });

  final String name;
  final String time;
  final bool isSunrise;
  final bool isUpcoming;
  final bool isActive;

  IconData get _icon {
    return switch (name) {
      'Subuh' => Icons.wb_twilight_rounded,
      'Sunrise' => Icons.wb_sunny_outlined,
      'Dhuhr' => Icons.wb_sunny_rounded,
      'Asr' => Icons.sunny_snowing,
      'Maghrib' => Icons.nights_stay_outlined,
      'Isha' => Icons.dark_mode_rounded,
      _ => Icons.access_time_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0D6B6B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isUpcoming ? Colors.white : const Color(0xFFF5F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUpcoming ? teal : const Color(0xFFDDE8E8),
          width: isUpcoming ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon box
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isUpcoming ? teal : const Color(0xFFE4ECEC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _icon,
                  size: 22,
                  color: isUpcoming ? Colors.white : teal,
                ),
              ),
              const SizedBox(width: 14),
              // Name + badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isUpcoming ? teal : const Color(0xFF1A2B2B),
                    ),
                  ),
                  if (isUpcoming)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DBDBD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'UPCOMING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  if (isSunrise && !isUpcoming)
                    const Text(
                      'Makruh time ends',
                      style: TextStyle(fontSize: 11, color: Color(0xFF5A7070)),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isUpcoming ? teal : const Color(0xFF1A2B2B),
                ),
              ),
            ],
          ),
          // Progress bar for upcoming
          if (isUpcoming) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 4,
                backgroundColor: const Color(0xFFDDE8E8),
                valueColor: const AlwaysStoppedAnimation<Color>(teal),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
