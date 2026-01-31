import 'dart:convert';

import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:ecommerce_admin_web_panel/viewModel/product_view_model.dart';
import 'package:ecommerce_admin_web_panel/widgets/confirm_aciton_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = "All";
  ProductViewModel productViewModel = ProductViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: Text("All Products"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/update_products");
        },
      ),
      body: Consumer<AdminWebPanelProvider>(
        builder: (context, value, child) {
          List<ProductModel> allProducts = ProductModel.fromJsonList(
            value.productsList,
          );

          List<String> categories =
              allProducts
                  .map((product) => product.categoryProduct)
                  .toSet()
                  .toList()
                ..sort();
          categories.insert(0, "All");

          // Apply filter
          List<ProductModel> filteredProducts = selectedCategory == "All"
              ? allProducts
              : allProducts
                    .where(
                      (product) => product.categoryProduct == selectedCategory,
                    )
                    .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Filter by Category",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(child: Text("No Products Found"))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          var product = filteredProducts[index];
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.7,
                                          child: AlertDialog(
                                            title: Text("Delete Product"),
                                            content: Text(
                                              "Delete action is permanent.",
                                            ),
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
                                                        child: ConfirmActionDialog(
                                                          dialogBodyText:
                                                              "Proceed with deleting this product?",
                                                          onYesCallback: () {
                                                            productViewModel
                                                                .deleteProduct(
                                                                  docId: product
                                                                      .idProduct,
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          onNoCallback: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Delete Product",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    "/update_products",
                                                    arguments: product,
                                                  );
                                                },
                                                child: Text(
                                                  "Edit Product",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: product.imageProduct.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(product.imageProduct),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.broken_image,
                                                  );
                                                },
                                          )
                                        : Icon(Icons.image_not_supported),
                                  ),
                                  title: Text(
                                    product.nameProduct,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rp.${product.new_price_Product.toString()}",
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        color: Colors.green,
                                        child: Text(
                                          product.categoryProduct.toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/update_products",
                                        arguments: product,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
