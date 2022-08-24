import 'package:equatable/equatable.dart';

abstract class MudifEvent extends Equatable {}

class GetMudif extends MudifEvent {
  @override
  List<Object> get props => [];

  GetMudif();
}

