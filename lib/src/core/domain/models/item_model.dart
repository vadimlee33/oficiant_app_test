class ItemModel {
  final int? id;
  final String name;
  final int? groupId;
  final int quantity;
  final int? price;
  final String? image;

  ItemModel(
      {this.id,
      this.image,
      required this.name,
      this.price,
      this.groupId,
      required this.quantity});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groupId': groupId,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }
}
