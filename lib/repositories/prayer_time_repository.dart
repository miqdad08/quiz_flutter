// repository/prayer_times_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_schedule.dart';

class PrayerTimesRepository {
  static const _baseUrl = 'https://equran.id/api/v2/shalat';

  Future<PrayerMonthData> fetchSchedule({required PrayerParams params}) async {
    final uri = Uri.parse(_baseUrl);

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(params.toJson())
    );

    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch prayer times (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] != 200) {
      throw Exception(json['message'] ?? 'Unknown API error');
    }

    return PrayerMonthData.fromJson(json);
  }
}
