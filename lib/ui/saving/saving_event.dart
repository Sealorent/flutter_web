import 'package:equatable/equatable.dart';

abstract class SavingEvent extends Equatable {}

class GetSavings extends SavingEvent {
  @override
  List<Object> get props => [];

  GetSavings();
}

