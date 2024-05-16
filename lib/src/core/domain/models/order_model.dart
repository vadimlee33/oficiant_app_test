class OrderModel {
  final int? id;
  final List<int> itemIds;
  final double totalPrice;
  final int tableId;
  String? date;

  OrderModel(
      {this.id,
      this.date,
      required this.itemIds,
      required this.totalPrice,
      required this.tableId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemIds': itemIds.join(','),
      'totalPrice': totalPrice,
      'tableId': tableId,
      'date': date
    };
  }
}
