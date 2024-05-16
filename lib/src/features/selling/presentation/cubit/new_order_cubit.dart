import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_group_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/order_model.dart';

abstract class NewOrderState {}

class NewOrderStateInitial extends NewOrderState {}

class NewOrderStateLoading extends NewOrderState {}

class NewOrderStateLoaded extends NewOrderState {
  int? selectedTable;
  int? selectedGroupId;
  OrderModel order;
  double totalPrice;
  bool loading;
  List<ItemGroupModel>? itemGroups;
  List<ItemModel>? items;

  NewOrderStateLoaded({
    this.selectedTable,
    this.selectedGroupId,
    required this.order,
    required this.totalPrice,
    required this.loading,
    this.itemGroups,
    this.items,
  });

  NewOrderStateLoaded copyWith({
    int? selectedTable,
    int? selectedGroupId,
    OrderModel? order,
    double? totalPrice,
    bool? loading,
    List<ItemGroupModel>? itemGroups,
    List<ItemModel>? items,
  }) {
    return NewOrderStateLoaded(
      selectedTable: selectedTable ?? this.selectedTable,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      order: order ?? this.order,
      totalPrice: totalPrice ?? this.totalPrice,
      loading: loading ?? this.loading,
      itemGroups: itemGroups ?? this.itemGroups,
      items: items ?? this.items,
    );
  }
}

class NewOrderCubit extends Cubit<NewOrderState> {
  final MyDb myDb;
  int? _selectedTable;
  NewOrderCubit({required this.myDb}) : super(NewOrderStateInitial());

  int get selectedTable => _selectedTable ?? 1;
  set selectedTable(int tableId) => _selectedTable = tableId;

  Future<void> fetchData() async {
    emit(NewOrderStateLoading());
    final itemGroups = await myDb.getItemGroups();
    final items = await myDb.getItems();
    emit(NewOrderStateLoaded(
        order:
            OrderModel(totalPrice: 0.0, itemIds: [], tableId: _selectedTable!),
        totalPrice: 0.0,
        loading: false,
        itemGroups: itemGroups,
        items: items));
  }

  void selectGroup(int groupId) {
    if (state is NewOrderStateLoaded) {
      emit((state as NewOrderStateLoaded).copyWith(selectedGroupId: groupId));
    }
  }

  void addItem(int itemId, double price) {
    if (state is NewOrderStateLoaded) {
      (state as NewOrderStateLoaded).order.itemIds.add(itemId);
      emit((state as NewOrderStateLoaded).copyWith(
        totalPrice: (state as NewOrderStateLoaded).totalPrice + price,
      ));
    }
  }

  void removeItem(int itemId, double price) {
    if (state is NewOrderStateLoaded) {
      (state as NewOrderStateLoaded).order.itemIds.remove(itemId);
      emit((state as NewOrderStateLoaded).copyWith(
        totalPrice: (state as NewOrderStateLoaded).totalPrice - price,
      ));
    }
  }

  void setLoading(bool loading) {
    if (state is NewOrderStateLoaded) {
      emit((state as NewOrderStateLoaded).copyWith(loading: loading));
    }
  }

  void resetCubit() {
    if (state is NewOrderStateLoaded) {
      emit((state as NewOrderStateLoaded).copyWith( selectedTable: null,
        selectedGroupId: 1,
        order: OrderModel(itemIds: [], totalPrice: 0, tableId: 1),
        totalPrice: 0.0,
        loading: false));
    }
    _selectedTable = null;
  }
}
