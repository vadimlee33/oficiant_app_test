class ItemGroupModel {
  final int? id;
  final String name;

  ItemGroupModel({this.id, required this.name});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
