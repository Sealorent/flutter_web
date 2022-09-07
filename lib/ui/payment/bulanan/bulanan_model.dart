
class BulananModel{
  String title;
  String startYear;
  String endYear;
  String total;
  String dibayar;
  List<BulananItemModel> items;

  BulananModel(this.title, this.startYear, this.endYear, this.total, this.dibayar,this.items,);
}

class BulananItemModel{
  String month;
  String year;
  String total;
  String status;

  BulananItemModel(this.month, this.year, this.total, this.status);

}