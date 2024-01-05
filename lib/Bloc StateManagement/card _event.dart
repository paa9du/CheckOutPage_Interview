// card_event.dart

import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class AddCard extends CardEvent {
  const AddCard();

  @override
  List<Object> get props => [];
}
