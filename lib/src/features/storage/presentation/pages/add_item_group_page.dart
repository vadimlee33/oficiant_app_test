import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oficiant_app_test/src/core/domain/models/item_group_model.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/core/widgets/custom_textfield.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_group_cubit.dart';
import 'package:oficiant_app_test/src/locator.dart';

class AddGroupItemPage extends StatelessWidget {
  const AddGroupItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final itemGroupCubit = sl<AddItemGroupCubit>();

    return BaseScaffold(
      withPadding: true,
      appTitle: "Добавление категории", body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                keyboardType: TextInputType.text,
                controller: nameController,
                hintText: 'Название категории',
                onChanged: null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  itemGroupCubit.addItemGroup(nameController.text);
                  nameController.clear();
                },
                child: Text('Добавить категорию'),
              ),
              const SizedBox(height: 12),
              BlocBuilder<AddItemGroupCubit, List<ItemGroupModel>>(
                builder: (context, itemGroups) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemGroups.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(itemGroups[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => itemGroupCubit.deleteItemGroup(itemGroups[index].id!),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ));
  }
}