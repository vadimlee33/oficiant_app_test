import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/domain/models/table_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/core/widgets/custom_textfield.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_table_cubit.dart';
import 'package:oficiant_app_test/src/locator.dart';

class AddTablePage extends StatelessWidget {
  const AddTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final addTableCubit = sl<AddTableCubit>();

    return BaseScaffold(
      withPadding: true,
        appTitle: "Добавление стола",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              hintText: 'Название Стола',
              onChanged: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Добавлен стол: ${nameController.text}');
                addTableCubit.addTable(nameController.text);
                nameController.clear();
              },
              child: const Text('Добавить стол'),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AddTableCubit, List<TableModel>>(
              builder: (BuildContext context, List<TableModel> tables) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${tables[index].id}. ${tables[index].name}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => addTableCubit.deleteTable(tables[index].id!),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}