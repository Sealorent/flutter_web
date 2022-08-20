import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class GetInformation extends HomeEvent {
  @override
  List<Object> get props => [];

  GetInformation();
}

