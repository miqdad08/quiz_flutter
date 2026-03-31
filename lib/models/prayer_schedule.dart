
class PrayerParams {
  const PrayerParams({
    required this.provinsi,
    required this.kabkota,
    required this.bulan,
    required this.tahun,
  });

  final String provinsi;
  final String kabkota;
  final String bulan;
  final String tahun;

  Map<String, dynamic> toJson() {
    return {
      'provinsi': provinsi,
      'kabkota': kabkota,
      'bulan': bulan,
      'tahun': tahun,
    };
  }
}

// models/prayer_schedule.dart

class PrayerSchedule {
  const PrayerSchedule({
    required this.tanggal,
    required this.tanggalLengkap,
    required this.hari,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  final int    tanggal;
  final String tanggalLengkap;
  final String hari;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) => PrayerSchedule(
    tanggal:        json['tanggal']         as int,
    tanggalLengkap: json['tanggal_lengkap'] as String,
    hari:           json['hari']            as String,
    imsak:          json['imsak']           as String,
    subuh:          json['subuh']           as String,
    terbit:         json['terbit']          as String,
    dhuha:          json['dhuha']           as String,
    dzuhur:         json['dzuhur']          as String,
    ashar:          json['ashar']           as String,
    maghrib:        json['maghrib']         as String,
    isya:           json['isya']            as String,
  );

  /// Ordered list of [name, time] for the 6 main prayers shown in the UI
  List<(String name, String time, bool isSunrise)> get displayPrayers => [
    ('Subuh',   subuh,   false),
    ('Sunrise', terbit,  true),
    ('Dhuhr',   dzuhur,  false),
    ('Asr',     ashar,   false),
    ('Maghrib', maghrib, false),
    ('Isha',    isya,    false),
  ];
}

class PrayerMonthData {
  const PrayerMonthData({
    required this.provinsi,
    required this.kabkota,
    required this.bulan,
    required this.tahun,
    required this.bulanNama,
    required this.jadwal,
  });

  final String               provinsi;
  final String               kabkota;
  final int                  bulan;
  final int                  tahun;
  final String               bulanNama;
  final List<PrayerSchedule> jadwal;

  factory PrayerMonthData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PrayerMonthData(
      provinsi:  data['provinsi']   as String,
      kabkota:   data['kabkota']    as String,
      bulan:     data['bulan']      as int,
      tahun:     data['tahun']      as int,
      bulanNama: data['bulan_nama'] as String,
      jadwal: (data['jadwal'] as List)
          .map((e) => PrayerSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Returns today's schedule, or null if not found
  PrayerSchedule? scheduleForDate(DateTime date) {
    if (date.month != bulan || date.year != tahun) return null;
    try {
      return jadwal.firstWhere((s) => s.tanggal == date.day);
    } catch (_) {
      return null;
    }
  }
}