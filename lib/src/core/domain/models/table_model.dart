class TableModel {
  final int? id;
  final String name;

  TableModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
    };
    return map;
  }
}