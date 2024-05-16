// ignore_for_file: depend_on_referenced_packages
import 'dart:io' as io;

import 'package:oficiant_app_test/src/core/domain/models/item_group_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/order_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/table_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDb {
  static final MyDb _instance = MyDb.internal();
  factory MyDb() => _instance;
  static Database? _db;

  MyDb.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDb();
    return _db!;
  }

  setDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'main.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Item(id INTEGER PRIMARY KEY, image TEXT, name TEXT, groupId INTEGER, quantity INTEGER, price INTEGER)");
    await db
        .execute("CREATE TABLE ItemGroup(id INTEGER PRIMARY KEY, name TEXT)");
    await db.execute(
        "CREATE TABLE Orders(id INTEGER PRIMARY KEY, itemIds TEXT, totalPrice INTEGER, tableId INTEGER, date TEXT)");
    await db.execute(
        "CREATE TABLE Tables(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");

    var defaultItemGroups = [
      {'id': 1, 'name': 'Супы'},
      {'id': 2, 'name': 'Бургеры'},
      {'id': 3, 'name': 'Салаты'},
      {'id': 4, 'name': 'Напитки'},
    ];

    for (var itemGroup in defaultItemGroups) {
      await db.insert('ItemGroup', itemGroup);
    }

    var defaultTables = [
      {'name': 'Стол1'},
      {'name': 'Стол2'},
      {'name': 'VIP1'},
      {'name': 'VIP2'},
    ];

    for (var table in defaultTables) {
      await db.insert('Tables', table);
    }

    var defaultItems = [
      {'name': 'Суп1', 'groupId': 1, 'quantity': 10, 'price': 100},
      {'name': 'Суп2', 'groupId': 1, 'quantity': 10, 'price': 100},
      {'name': 'Бургер1', 'groupId': 2, 'quantity': 10, 'price': 200},
      {'name': 'Бургер2', 'groupId': 2, 'quantity': 10, 'price': 200},
      {'name': 'Салат1', 'groupId': 3, 'quantity': 10, 'price': 150},
      {'name': 'Салат2', 'groupId': 3, 'quantity': 10, 'price': 150},
      {'name': 'Напиток1', 'groupId': 4, 'quantity': 10, 'price': 50},
      {'name': 'Напиток2', 'groupId': 4, 'quantity': 10, 'price': 50},
    ];

    for (var item in defaultItems) {
      await db.insert('Item', item);
    }

    print("Tables created");
  }

  Future<int> saveItem(ItemModel item) async {
    var dbClient = await db;
    print("saving item ${item.name + item.image!}");
    int res = await dbClient.insert("Item", item.toMap());
    return res;
  }

  Future<int> saveItemGroup(ItemGroupModel itemGroup) async {
    var dbClient = await db;
    int res = await dbClient.insert("ItemGroup", itemGroup.toMap());
    return res;
  }

  Future<int> saveOrder(OrderModel order) async {
    var dbClient = await db;
    String currentDate = DateTime.now().toIso8601String();
    order.date = currentDate;
    int res = await dbClient.insert("Orders", order.toMap());
    return res;
  }

  Future<int> updateItemQuantity(int itemId, int quantity) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        'UPDATE Item SET quantity = ? WHERE id = ?', [quantity, itemId]);
    return res;
  }

  Future<int> updateItemPrice(int itemId, int price) async {
    var dbClient = await db;
    int res = await dbClient
        .rawUpdate('UPDATE Item SET price = ? WHERE id = ?', [price, itemId]);
    return res;
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int res = await dbClient.delete("Item", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> deleteItemGroup(int id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete("ItemGroup", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<List<ItemModel>> getItems() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Item');
    List<ItemModel> items = [];
    for (int i = 0; i < list.length; i++) {
      var item = ItemModel(
          id: list[i]["id"],
          name: list[i]["name"],
          groupId: list[i]["groupId"],
          price: list[i]["price"],
          image: list[i]["image"],
          quantity: list[i]["quantity"]);
      items.add(item);
    }
    print("Returned ${items.length} items");
    return items;
  }

  Future<List<TableModel>> getTables() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Tables');
    List<TableModel> tables = [];
    for (int i = 0; i < list.length; i++) {
      var table = TableModel(id: list[i]["id"], name: list[i]["name"]);
      tables.add(table);
    }
    return tables;
  }

  Future<void> addTable(TableModel table) async {
    var dbClient = await db;
    await dbClient.insert('Tables', table.toMap());
  }

  Future<void> deleteTable(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      'Tables',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<ItemGroupModel>> getItemGroups() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ItemGroup');
    List<ItemGroupModel> itemGroups = [];
    for (int i = 0; i < list.length; i++) {
      var itemGroup = ItemGroupModel(id: list[i]["id"], name: list[i]["name"]);
      itemGroups.add(itemGroup);
    }
    print("Returned ${itemGroups.length} item groups");
    return itemGroups;
  }

  Future<List<OrderModel>> getOrders() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Orders');
    List<OrderModel> orders = [];
    for (int i = 0; i < list.length; i++) {
      var itemIds = list[i]["itemIds"]
          .split(',')
          .map<int>((item) => int.parse(item))
          .toList();
      var order = OrderModel(
          id: list[i]["id"],
          itemIds: itemIds,
          tableId: list[i]["tableId"],
          totalPrice: (list[i]["totalPrice"] as int).toDouble(),
          date: list[i]["date"]);
      orders.add(order);
    }
    print("Returned ${orders.length} orders");
    return orders;
  }
}
