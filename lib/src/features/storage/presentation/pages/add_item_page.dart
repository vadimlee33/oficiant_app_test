import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oficiant_app_test/src/core/widgets/base_scaffold.dart';
import 'package:oficiant_app_test/src/core/widgets/custom_textfield.dart';
import 'package:oficiant_app_test/src/features/storage/presentation/cubit/add_item_cubit.dart';
import 'package:oficiant_app_test/src/locator.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      withPadding: true,
      appTitle: 'Добавление продукта',
      body: AddItemForm(),
    );
  }
}

class AddItemForm extends StatelessWidget {
  const AddItemForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController quantityController =
        TextEditingController(text: "1");
    final TextEditingController priceController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    final cubit = sl<AddItemCubit>();
    cubit.fetchItemGroups();

    Future<void> doAddPhoto() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        cubit.setImage(pickedFile.path);
      }
    }

    return BlocBuilder<AddItemCubit, AddItemState>(
      builder: (context, state) {
        if (state is AddItemLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AddItemLoadedState) {
          final itemGroups = (state).itemGroups;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cubit.imagePath.isNotEmpty)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: FileImage(File(cubit.imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey,
                      ),
                      width: 200,
                      height: 200,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () async {
                          await doAddPhoto();
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      hintText: "Название товара",
                      onChanged: (value) => cubit.setName(value)),
                  const SizedBox(height: 16),
                  FormBuilderDropdown(
                      initialValue: 0,
                      name: "name",
                      items: itemGroups.map((itemGroup) {
                        return DropdownMenuItem<int>(
                          value: itemGroup.id,
                          child: Text(itemGroup.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        cubit.selectGroupId(value!);
                      }),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cubit.decrementQuantity();
                          quantityController.text = cubit.quantity.toString();
                        },
                      ),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            cubit.setQuantity(int.parse(value));
                            quantityController.text = cubit.quantity.toString();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cubit.incrementQuantity();
                          quantityController.text = cubit.quantity.toString();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: CustomTextField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          hintText: "Цена",
                          onChanged: (value) =>
                              cubit.setPrice(int.parse(value)))),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          cubit.selectedGroupId != 0) {
                        cubit.addItem();

                        nameController.clear();
                        priceController.clear();
                        quantityController.text = "1";
                      }
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AddItemErrorState) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
