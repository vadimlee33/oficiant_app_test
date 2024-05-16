import 'package:bloc/bloc.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_group_model.dart';

class AddItemGroupCubit extends Cubit<List<ItemGroupModel>> {
  final MyDb myDb;

  AddItemGroupCubit({required this.myDb}) : super([]);

  Future<void> getItemGroups() async {
    final itemGroups = await myDb.getItemGroups();
    emit(itemGroups);
  }

  Future<void> addItemGroup(String name) async {
    await myDb.saveItemGroup(ItemGroupModel(name: name));
    getItemGroups();
  }

  Future<void> deleteItemGroup(int id) async {
    await myDb.deleteItemGroup(id);
    getItemGroups();
  }
}