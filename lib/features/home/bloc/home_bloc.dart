import 'dart:async';
import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    // Remove the generic on<HomeEvent> - only register specific events
    on<HomeInitialEvent>(loadAllData);
  }

  Future<void> loadAllData(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Emit loading state
    emit(HomeLoading());

    try {
      // Mock data
      final data = ['Item 1', 'Item 2', 'Item 3'];

      // Emit success state with data
      emit(HomeLoaded());
    } catch (e) {
      // Emit error state
      emit(HomeError());
    }
  }
}
