import 'package:equatable/equatable.dart';

abstract class KonselingEvent extends Equatable {}

class GetKonseling extends KonselingEvent {
  @override
  List<Object> get props => [];

  GetKonseling();
}

