import 'package:bloc/bloc.dart';
import 'package:soleh/features/calendar/models/islamic_date.dart';
import 'package:soleh/features/calendar/repositories/calendar_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository repository;

  CalendarBloc({required this.repository}) : super(CalendarInitial()) {
    on<LoadDataByYearEvent>(onLoadDataByYear);
  }

  Future<void> onLoadDataByYear(
      LoadDataByYearEvent event, Emitter<CalendarState> emit) async {
    try {
      emit(CalendarLoading());

      final List<IslamicDate> islamicDate =
          await repository.getIslamicDates(event.events, event.year);

      emit(CalendarLoaded(islamicDate: islamicDate));
    } catch (e) {
      emit(CalendarError(error: e.toString()));
    }
  }
}
