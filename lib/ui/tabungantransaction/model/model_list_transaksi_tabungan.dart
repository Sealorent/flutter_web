class ListTransaksiTabunganModel {
  bool? isCorrect;
  List<ListTransaksiTabungan>? listTransaksiTabungan;
  String? message;

  ListTransaksiTabunganModel(
      {this.isCorrect, this.listTransaksiTabungan, this.message});

  ListTransaksiTabunganModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    if (json['list_transaksi'] != null) {
      listTransaksiTabungan = <ListTransaksiTabungan>[];
      json['list_transaksi'].forEach((v) {
        listTransaksiTabungan!.add(ListTransaksiTabungan.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    if (listTransaksiTabungan != null) {
      data['list_transaksi'] =
          listTransaksiTabungan!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ListTransaksiTabungan {
  String? idTransaksi;
  String? status;
  String? noref;
  String? tanggal;

  ListTransaksiTabungan(
      {this.idTransaksi, this.status, this.noref, this.tanggal});

  ListTransaksiTabungan.fromJson(Map<String, dynamic> json) {
    idTransaksi = json['id_transaksi'];
    status = json['status'];
    noref = json['noref'];
    tanggal = json['tanggal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_transaksi'] = idTransaksi;
    data['status'] = status;
    data['noref'] = noref;
    data['tanggal'] = tanggal;
    return data;
  }
}

class PaginationResponse<T> {
  final List<ListTransaksiTabungan>? data;
  final int currentPage;
  final int totalPages;

  PaginationResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });
}

PaginationResponse<T> paginateList<T>(
    List<ListTransaksiTabungan>? originalList, int currentPage, int pageSize) {
  final totalItems = originalList!.length;
  final startIndex = (currentPage - 1) * pageSize;
  final endIndex = startIndex + pageSize;

  final List<ListTransaksiTabungan> paginatedList = originalList.sublist(
    startIndex < totalItems ? startIndex : totalItems,
    endIndex < totalItems ? endIndex : totalItems,
  );

  final totalPages = (totalItems / pageSize).ceil();

  return PaginationResponse<T>(
    data: paginatedList,
    currentPage: currentPage,
    totalPages: totalPages,
  );
}
