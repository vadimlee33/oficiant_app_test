import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/provider/navigation_provider.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/cubit/new_order_cubit.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/pages/table_selection_page.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_cubit.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_group_cubit.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_table_cubit.dart';
import 'package:oficiant_app_test/src/locator.dart';
import 'package:provider/provider.dart';

import 'package:oficiant_app_test/src/locator.dart' as di;

void main() async {
  await di.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<NewOrderCubit>()),
          BlocProvider(create: (context) => sl<AddItemCubit>()),
          BlocProvider(create: (context) => sl<AddTableCubit>()..getTables()),
          BlocProvider(create: (context) => sl<AddItemGroupCubit>()..getItemGroups()),
        ],
        child: const MaterialApp(
          title: 'Test Task App',
          home: TableSelectionPage(),
        ));
  }
}
