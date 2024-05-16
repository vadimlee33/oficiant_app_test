import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/order_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/core/widgets/image_widget.dart';
import 'package:oficiant_app_test/src/features/selling/presentation/cubit/new_order_cubit.dart';
import 'package:oficiant_app_test/src/locator.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myDb = sl<MyDb>();
    final newOrderCubit = sl<NewOrderCubit>();
    newOrderCubit.fetchData();

    Future<void> doSaveOrder(NewOrderStateLoaded state) async {
      final int selectedTableId = newOrderCubit.selectedTable;
      await myDb.saveOrder(OrderModel(
          itemIds: state.order.itemIds,
          totalPrice: state.totalPrice,
          tableId: selectedTableId));
      newOrderCubit.resetCubit();
    }

    return BaseScaffold(
        withPadding: false,
        appTitle: "Новый заказ",
        body: BlocBuilder<NewOrderCubit, NewOrderState>(
          builder: (context, state) {
            if (state is NewOrderStateLoaded) {
              return DefaultTabController(
                length: state.itemGroups?.length ?? 0,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      onTap: (index) {
                        newOrderCubit.selectGroup(state.itemGroups![index].id!);
                      },
                      tabs: state.itemGroups!.map((itemGroup) {
                        return Tab(text: itemGroup.name);
                      }).toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: state.itemGroups!.map((itemGroup) {
                          final itemsInGroup = state.items!
                              .where((item) => item.groupId == itemGroup.id)
                              .toList();
                          return itemsInGroup.isEmpty
                              ? const Text('Нет товаров')
                              : ListView.builder(
                                  itemCount: itemsInGroup.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: itemsInGroup[index].quantity > 0
                                          ? () {
                                              if (state.order.itemIds.contains(
                                                  itemsInGroup[index].id)) {
                                                newOrderCubit.removeItem(
                                                    itemsInGroup[index].id!,
                                                    itemsInGroup[index]
                                                        .price!
                                                        .toDouble());
                                              } else {
                                                newOrderCubit.addItem(
                                                    itemsInGroup[index].id!,
                                                    itemsInGroup[index]
                                                        .price!
                                                        .toDouble());
                                              }
                                            }
                                          : null,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4),
                                        child: ListTile(
                                          leading: ImageWidget(
                                              imagePath:
                                                  itemsInGroup[index].image),
                                          title: Text(itemsInGroup[index].name),
                                          subtitle: Text(
                                              'Цена: ${itemsInGroup[index].price}, Количество: ${itemsInGroup[index].quantity}'),
                                          tileColor: itemsInGroup[index]
                                                      .quantity <=
                                                  0
                                              ? Colors.grey
                                              : state.order.itemIds.contains(
                                                      itemsInGroup[index].id)
                                                  ? Colors.blueAccent
                                                  : null,
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }).toList(),
                      ),
                    ),
                    Text('Итого: ${state.totalPrice}'),
                    ElevatedButton(
                      onPressed: () async {
                        await doSaveOrder(state);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text('Оформить'),
                    ),
                  ],
                ),
              );
            } else if (state is NewOrderStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Initial state'));
            }
          },
        ));
  }
}
