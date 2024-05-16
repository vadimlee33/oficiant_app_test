import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/pages/add_item_group_page.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/pages/add_item_page.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/pages/add_table_page.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/pages/all_items_page.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        withPadding: true,
        appTitle: "Склад",
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllItemsPage()));
                },
                child: const Text(
                  "Все товары",
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddItemPage()));
                },
                child: const Text(
                  "Добавить продукт",
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddGroupItemPage()));
                },
                child: const Text(
                  "Добавить категорию",
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddTablePage()));
                },
                child: const Text(
                  "Добавить новый стол",
                  style: TextStyle(fontSize: 18),
                )),
          ],
        )));
  }
}
