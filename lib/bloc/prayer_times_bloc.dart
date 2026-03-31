import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/prayer_schedule.dart';
import '../repositories/prayer_time_repository.dart';

part 'prayer_times_event.dart';

part 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  PrayerTimesBloc(this._repository) : super(PrayerTimesInitial()) {
    on<PrayerTimesLoaded>(_onLoad);
  }

  final PrayerTimesRepository _repository;

  Future<void> _onLoad(
    PrayerTimesLoaded event,
    Emitter<PrayerTimesState> emit,
  ) async {
    emit(PrayerTimesLoading());
    try {
      final data = await _repository.fetchSchedule(
        params: PrayerParams(
          provinsi: event.params.provinsi,
          kabkota: event.params.kabkota,
          bulan: event.params.bulan,
          tahun: event.params.tahun,
        ),
      );
      emit(PrayerTimesSuccess(data));
    } catch (e) {
      emit(PrayerTimesFailure(e.toString()));
    }
  }
}
