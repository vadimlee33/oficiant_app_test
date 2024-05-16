import 'package:get_it/get_it.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/cubit/new_order_cubit.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_cubit.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_group_cubit.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_table_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<MyDb>(MyDb());

  sl.registerSingleton<NewOrderCubit>(NewOrderCubit(myDb: sl<MyDb>()));

  sl.registerSingleton<AddItemCubit>(AddItemCubit(myDb: sl<MyDb>()));

  sl.registerSingleton<AddTableCubit>(AddTableCubit(myDb: sl<MyDb>()));

  sl.registerSingleton<AddItemGroupCubit>(AddItemGroupCubit(myDb: sl<MyDb>()));
}
