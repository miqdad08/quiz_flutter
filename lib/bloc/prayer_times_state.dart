part of 'prayer_times_bloc.dart';

@immutable

abstract class PrayerTimesState {}

class PrayerTimesInitial  extends PrayerTimesState {}
class PrayerTimesLoading  extends PrayerTimesState {}

class PrayerTimesSuccess extends PrayerTimesState {
  PrayerTimesSuccess(this.data);
  final PrayerMonthData data;
}

class PrayerTimesFailure extends PrayerTimesState {
  PrayerTimesFailure(this.message);
  final String message;
}