part of 'prayer_times_bloc.dart';

@immutable
abstract class PrayerTimesEvent {}

class PrayerTimesLoaded extends PrayerTimesEvent {
  PrayerTimesLoaded({required this.params});

  final PrayerParams params;
}
