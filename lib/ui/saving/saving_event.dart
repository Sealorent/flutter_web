import 'package:equatable/equatable.dart';

import '../../network/param/top_up_tabungan_param.dart';

abstract class SavingEvent extends Equatable {}

class GetSavings extends SavingEvent {
  @override
  List<Object> get props => [];

  GetSavings();
}

class TopUpTabungan extends SavingEvent {
  TopUpTabunganParam param;
  @override
  List<Object> get props => [];

  TopUpTabungan(this.param);
}
