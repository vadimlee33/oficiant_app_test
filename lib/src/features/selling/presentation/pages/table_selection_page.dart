
import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/table_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/cubit/new_order_cubit.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/pages/new_order_page.dart';
import 'package:oficiant_app_test/src/locator.dart';

class TableSelectionPage extends StatelessWidget {
  const TableSelectionPage({super.key});

  Future<List<TableModel>> _fetchTables() async {
    final myDb = sl<MyDb>();
    final tables = await myDb.getTables();
    return tables;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      withPadding: true,
      appTitle: "Выбор стола",
      body: FutureBuilder<List<TableModel>>(
        future: _fetchTables(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TableModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.5,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    final newOrderCubit = sl<NewOrderCubit>();
                    newOrderCubit.selectedTable = snapshot.data![index].id!;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewOrderPage()));
                  },
                  child: Card(
                    elevation: 2,
                    child: Center(
                      child: Text(
                        snapshot.data![index].name,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
