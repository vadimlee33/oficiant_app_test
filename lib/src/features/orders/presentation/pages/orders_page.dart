import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/order_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/table_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/locator.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<TableModel> tablesList = [];
    final myDb = sl<MyDb>();

    Future<List<OrderModel>> fetchData() async {
      final tables = await myDb.getTables();
      tablesList = tables;
      final orders = await myDb.getOrders();
      return orders;
    }

    return BaseScaffold(
        withPadding: false,
        appTitle: "Заказы",
        body: FutureBuilder<List<OrderModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var orders = snapshot.data ?? [];
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var date = DateFormat('yyyy-MM-ddTHH:mm:ss')
                      .parse(orders[index].date!);
                  var formattedDate = DateFormat('dd.MM.yyyy').format(date);
                  final table = tablesList.firstWhere((table) => table.id == orders[index].tableId, orElse: () => TableModel(name: ""));
                  return Column(
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ListTile(
                        title: Text(table.name),
                        subtitle: Text(
                            'Сумма: ${orders[index].totalPrice}, Дата: $formattedDate'),
                      )),
                      Divider(
                        height: 1.0,
                        color: Colors.grey[300],
                        thickness: 1.5,
                      )
                    ],
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                  child: Text('Произошла ошибка при загрузке заказов'));
            }
          },
        ));
  }
}
