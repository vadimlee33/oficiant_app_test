import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/core/widgets/image_widget.dart';
import 'package:oficiant_app_test/src/locator.dart';

class AllItemsPage extends StatelessWidget {
  final myDb = sl<MyDb>();

  AllItemsPage({super.key});

  Future<void> _updateQuantity(int? id, String quantity) async {
    int intQuantity = int.tryParse(quantity) ?? 0;
    await myDb.updateItemQuantity(id!, intQuantity);
  }

  Future<void> _updatePrice(int? id, String price) async {
    int intPrice = int.tryParse(price) ?? 0;
    await myDb.updateItemPrice(id!, intPrice);
  }

  Future<void> _deleteItem(int? id) async {
    await myDb.deleteItem(id!);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appTitle: "Все товары",
        withPadding: false,
        body: FutureBuilder<List<ItemModel>>(
          future: myDb.getItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Название'),
                  ),
                  DataColumn(
                    label: Text('Цена'),
                  ),
                  DataColumn(
                    label: Text('Кол-во'),
                  ),
                  DataColumn(
                    label: Text('Удалит'),
                  ),
                ],
                rows: snapshot.data!
                    .map<DataRow>((item) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(item.name)),
                            DataCell(TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: '${item.price ?? 0}'),
                              onSubmitted: (value) =>
                                  _updatePrice(item.id, value),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            )),
                            DataCell(TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: '${item.quantity}'),
                              onSubmitted: (value) =>
                                  _updateQuantity(item.id, value),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            )),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteItem(item.id),
                            )),
                          ],
                        ))
                    .toList(),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
