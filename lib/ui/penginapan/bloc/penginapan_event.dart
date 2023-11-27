part of 'penginapan_bloc.dart';

class PenginapanEvent extends Equatable {
  const PenginapanEvent();

  @override
  List<Object> get props => [];
}

class GetPenginapan extends PenginapanEvent {

  @override
  List<Object> get props => [];
}

class GetDetailPenginapan extends PenginapanEvent {

  String? homestayId;
  
  GetDetailPenginapan(this.homestayId);

@override
List<Object> get props => [];
}
