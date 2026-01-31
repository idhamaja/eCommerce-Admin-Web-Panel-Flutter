import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_admin_web_panel/models/product_model.dart';
import 'package:ecommerce_admin_web_panel/viewModel/product_view_model.dart';
import 'package:ecommerce_admin_web_panel/widgets/category_text_form_field.dart';
import 'package:ecommerce_admin_web_panel/widgets/text_form_field.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class UpdateProductsPage extends StatefulWidget {
  const UpdateProductsPage({super.key});

  @override
  State<UpdateProductsPage> createState() => _UpdateProductsPageState();
}

class _UpdateProductsPageState extends State<UpdateProductsPage> {
  // ================= CONTROLLERS =================
  final nameTextEditingController = TextEditingController();
  final oldPriceTextEditingController = TextEditingController();
  final newPriceTextEditingController = TextEditingController();
  final quantityTextEditingController = TextEditingController();
  final categoryTextEditingController = TextEditingController();
  final descTextEditingController = TextEditingController();
  final imageController = TextEditingController();

  // ================= VARIABLES =================
  final formGlobalKey = GlobalKey<FormState>();
  final ProductViewModel productViewModel = ProductViewModel();

  Uint8List? selectedImageBytes;
  String productId = "";

  // FLAG AGAR DATA HANYA DIISI SEKALI
  bool _isInit = true;

  // ================= SUBMIT FORM =================
  void submitForm() {
    if (formGlobalKey.currentState!.validate()) {
      final productDataMap = {
        "name": nameTextEditingController.text,
        "old_price": int.parse(oldPriceTextEditingController.text),
        "new_price": int.parse(newPriceTextEditingController.text),
        "quantity": int.parse(quantityTextEditingController.text),
        "category": categoryTextEditingController.text,
        "desc": descTextEditingController.text,
        "image": imageController.text,
      };

      if (productId.isNotEmpty) {
        productViewModel.updateProduct(
          docId: productId,
          dataMap: productDataMap,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product Updated"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        productViewModel.addNewProduct(dataMap: productDataMap);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New Product Added"),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  // ================= PICK & COMPRESS IMAGE =================
  Future<void> pickImageAndCompress() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final image = img.decodeImage(bytes);

      if (image != null) {
        final compressed = img.encodeJpg(image, quality: 70);
        final base64Image = base64Encode(compressed);

        setState(() {
          imageController.text = base64Image;
          selectedImageBytes = Uint8List.fromList(compressed);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image compressed & selected"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // ================= DISPLAY DATA (EDIT MODE) =================
  void displayDataOnTextFormField(ProductModel data) {
    productId = data.idProduct;

    nameTextEditingController.text = data.nameProduct;
    oldPriceTextEditingController.text = data.old_price_Product.toString();
    newPriceTextEditingController.text = data.new_price_Product.toString();
    quantityTextEditingController.text = data.maxQuantityProduct.toString();
    categoryTextEditingController.text = data.categoryProduct;
    descTextEditingController.text = data.descriptionProduct;
    imageController.text = data.imageProduct;

    try {
      selectedImageBytes = base64Decode(data.imageProduct);
    } catch (_) {
      selectedImageBytes = null;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is ProductModel) {
        displayDataOnTextFormField(args);
      }
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // 🔥 PENTING: HANYA DIPANGGIL SEKALI
    if (_isInit && args != null && args is ProductModel) {
      displayDataOnTextFormField(args);
      _isInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          productId.isNotEmpty ? "Update Product" : "Add New Product",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              minWidth: 300,
            ),
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  buildTextFormField(
                    controller: nameTextEditingController,
                    label: "Product Name",
                    validatorMsg: "This field cannot be empty.",
                  ),

                  const SizedBox(height: 10),

                  buildTextFormField(
                    controller: oldPriceTextEditingController,
                    label: "Original Price",
                    validatorMsg: "This field cannot be empty.",
                  ),

                  const SizedBox(height: 10),

                  buildTextFormField(
                    controller: newPriceTextEditingController,
                    label: "Sell Price",
                    validatorMsg: "This field cannot be empty.",
                  ),

                  const SizedBox(height: 10),

                  buildTextFormField(
                    controller: quantityTextEditingController,
                    label: "Quantity Left",
                    validatorMsg: "This field cannot be empty.",
                  ),

                  const SizedBox(height: 10),

                  // ✅ CATEGORY (SEKARANG BISA DIUBAH)
                  buildCategoryTextFormField(
                    context,
                    categoryTextEditingController,
                  ),

                  const SizedBox(height: 10),

                  buildTextFormField(
                    controller: descTextEditingController,
                    label: "Description",
                    validatorMsg: "This field cannot be empty.",
                    maxLines: 5,
                  ),

                  if (selectedImageBytes != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: Image.memory(
                        selectedImageBytes!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: pickImageAndCompress,
                    icon: const Icon(Icons.image),
                    label: const Text("Pick & Compress Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildTextFormField(
                    controller: imageController,
                    label: "Base64 Image",
                    validatorMsg: "Please select image first.",
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: Text(
                        productId.isNotEmpty
                            ? "Update Product"
                            : "Add New Product",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
