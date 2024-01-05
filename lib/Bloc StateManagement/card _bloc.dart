// card_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import 'card _event.dart';
import 'card _state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(InitialCardState()) {
    on<AddCard>((event, emit) {
      // Handle the AddCard event by emitting a new state
      emit(CardAddedState());
    });
  }

  @override
  Stream<CardState> mapEventToState(CardEvent event) async* {
    // You can implement your event to state mapping logic if needed
  }
}
