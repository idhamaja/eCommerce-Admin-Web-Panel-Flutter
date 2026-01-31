import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildCategoryTextFormField(
  BuildContext context,
  TextEditingController categoryController,
) {
  return TextFormField(
    controller: categoryController,
    readOnly: true,
    validator: (v) => v!.isEmpty ? "Please select a category." : null,
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Select Category"),
          content: Consumer<AdminWebPanelProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  children: provider.categoriesList
                      .map(
                        (cat) => ListTile(
                          title: Text(cat["name"]),
                          onTap: () {
                            categoryController.text = cat["name"];
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
      );
    },
    decoration: InputDecoration(
      labelText: "Category",
      filled: true,
      fillColor: Colors.green.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
