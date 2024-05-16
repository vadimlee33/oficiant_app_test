
import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/provider/navigation_provider.dart';
import 'package:oficiant_app_test/src/features/orders/presentation/pages/orders_page.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/pages/table_selection_page.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/pages/storage_page.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return BottomNavigationBar(
          onTap: (index) {
            navigationProvider.currentIndex = index;
            switch (index) {
              case 0:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TableSelectionPage()),
                    (route) => false);
                break;
              case 1:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoragePage()),
                    (route) => false);
                break;
              case 2:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersPage()),
                    (route) => false);
                break;
            }
          },
          currentIndex: navigationProvider.currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Продажа',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              label: 'Склад',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Заказы',
            )
          ],
        );
      },
    );
  }
}
