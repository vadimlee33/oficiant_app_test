import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_group_model.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_model.dart';

abstract class AddItemState {}

class AddItemInitialState extends AddItemState {}

class AddItemLoadingState extends AddItemState {}

class AddItemLoadedState extends AddItemState {
  final List<ItemGroupModel> itemGroups;

  AddItemLoadedState(this.itemGroups);
}

class AddItemErrorState extends AddItemState {
  final String error;

  AddItemErrorState(this.error);
}

class AddItemCubit extends Cubit<AddItemState> {
  final MyDb myDb;
  late List<ItemGroupModel> itemGroupsList;

  AddItemCubit({required this.myDb}) : super(AddItemInitialState());

  int _selectedGroupId = 0;
  int _quantity = 1;
  String _name = '';
  int _price = 0;

  int get selectedGroupId => _selectedGroupId;

  int get quantity => _quantity;

  String _imagePath = '';

  String get imagePath => _imagePath;

  void setImage(String path) {
    _imagePath = path;
    emit(AddItemLoadedState(itemGroupsList));
  }

  void fetchItemGroups() async {
    try {
      resetForms();
      emit(AddItemLoadingState());
      final List<ItemGroupModel> itemGroups = await myDb.getItemGroups();
      itemGroups.insert(0, ItemGroupModel(id: 0, name: 'Выберите категорию'));
      itemGroupsList = itemGroups;

      emit(AddItemLoadedState(itemGroups));
    } catch (e) {
      emit(AddItemErrorState('Failed to fetch item groups'));
    }
  }

  void setPrice(int price) {
    _price = price;
  }

  void setQuantity(int quantity) {
    _quantity = quantity;
  }

  void selectGroupId(int groupId) {
    _selectedGroupId = groupId;
  }

  void incrementQuantity() {
    _quantity++;
  }

  void setName(String name) {
    _name = name;
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
    }
  }

  void addItem() async {
    try {
      emit(AddItemLoadingState());
      print("Saving iamge path: $_imagePath");
      await myDb.saveItem(ItemModel(
          name: _name,
          groupId: _selectedGroupId,
          price: _price,
          image: _imagePath,
          quantity: _quantity));
      emit(AddItemLoadedState(itemGroupsList));
      resetForms();
    } catch (e) {
      emit(AddItemErrorState('Failed to add item'));
    }
  }

  void resetForms() {
    _selectedGroupId = 0;
    _quantity = 1;
    _name = '';
    _imagePath = '';
  }
}
