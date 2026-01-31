import 'dart:convert';

import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:ecommerce_admin_web_panel/viewModel/category_view_model.dart';

import 'package:ecommerce_admin_web_panel/views/categories/add_update_categories.dart';
import 'package:ecommerce_admin_web_panel/widgets/confirm_aciton_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoryViewModel categoryViewModel = CategoryViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: Text("Categories"),
      ),
      body: Consumer<AdminWebPanelProvider>(
        builder: (context, value, child) {
          List<CategoryModel> categoriesList = CategoryModel.fromJsonList(
            value.categoriesList,
          );

          if (categoriesList.isEmpty) {
            return Center(child: Text("No Categories Found"));
          }

          return ListView.builder(
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: categoriesList[index].imageCategory.isNotEmpty
                            ? Image.memory(
                                base64Decode(
                                  categoriesList[index].imageCategory,
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Base64 decode error: $error');
                                  return Icon(Icons.broken_image);
                                },
                              )
                            : Icon(Icons.image_not_supported),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: AlertDialog(
                                title: Text("What you want to do?"),
                                content: Text("Delete action is permanent."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => Center(
                                          child: SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.7,
                                            //confirm dialog
                                            child: ConfirmActionDialog(
                                              dialogBodyText:
                                                  "Are you sure you want to delete this?",
                                              onYesCallback: () {
                                                categoryViewModel
                                                    .deleteCategory(
                                                      docId:
                                                          categoriesList[index]
                                                              .idCategory,
                                                    );
                                                Navigator.pop(context);
                                              },
                                              onNoCallback: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Delete Category",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => Center(
                                          child: SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.7,
                                            child: AddUpdateCategories(
                                              isUpdatingCategory: true,
                                              categoryId: categoriesList[index]
                                                  .idCategory,
                                              priorityOfCategory:
                                                  categoriesList[index]
                                                      .priorityCategory,
                                              imageOfCategory:
                                                  categoriesList[index]
                                                      .imageCategory,
                                              nameOfCategory:
                                                  categoriesList[index]
                                                      .nameCategory,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Update Category",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      title: Text(
                        categoriesList[index].nameCategory,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "Priority : ${categoriesList[index].priorityCategory}",
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: AddUpdateCategories(
                                  isUpdatingCategory: true,
                                  categoryId: categoriesList[index].idCategory,
                                  priorityOfCategory:
                                      categoriesList[index].priorityCategory,
                                  imageOfCategory:
                                      categoriesList[index].imageCategory,
                                  nameOfCategory:
                                      categoriesList[index].nameCategory,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AddUpdateCategories(
                  isUpdatingCategory: false,
                  priorityOfCategory: 0,
                  categoryId: "",
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
