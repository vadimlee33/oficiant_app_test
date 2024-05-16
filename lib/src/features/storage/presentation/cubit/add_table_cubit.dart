import 'package:bloc/bloc.dart';
import 'package:oficiant_app_test/src/core/data/datasources/my_db.dart';
import 'package:oficiant_app_test/src/core/domain/models/table_model.dart';

class AddTableCubit extends Cubit<List<TableModel>> {
  final MyDb myDb;

  AddTableCubit({required this.myDb}) : super([]);

  Future<void> getTables() async {
    final tables = await myDb.getTables();
    emit(tables);
  }

  Future<void> addTable(String name) async {
    await myDb.addTable(TableModel(name: name));
    getTables();
  }

  Future<void> deleteTable(int id) async {
    await myDb.deleteTable(id);
    getTables();
  }
}