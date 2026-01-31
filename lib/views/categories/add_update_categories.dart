import 'dart:convert';
import 'dart:typed_data';
import 'package:ecommerce_admin_web_panel/viewModel/category_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class AddUpdateCategories extends StatefulWidget {
  final bool isUpdatingCategory;
  final int priorityOfCategory;
  final String? nameOfCategory;
  final String categoryId;
  final String? imageOfCategory;

  const AddUpdateCategories({
    super.key,
    required this.isUpdatingCategory,
    required this.priorityOfCategory,
    this.nameOfCategory,
    required this.categoryId,
    this.imageOfCategory,
  });

  @override
  State<AddUpdateCategories> createState() => _AddUpdateCategoriesState();
}

class _AddUpdateCategoriesState extends State<AddUpdateCategories> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController imageTextEditingController = TextEditingController();
  TextEditingController priorityTextEditingController = TextEditingController();

  Uint8List? webImage;
  PlatformFile? pickedFile;
  bool isLoading = false;

  CategoryViewModel categoryViewModel = CategoryViewModel();

  pickImageAndConvertToBase64() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.bytes == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    pickedFile = result.files.first;

    // Validate file size (reject > 10MB)
    final int fileSizeBytes =
        pickedFile!.size ?? pickedFile!.bytes!.lengthInBytes;
    const int maxBytes = 10 * 1024 * 1024; // 10 MB
    if (fileSizeBytes > maxBytes) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Image size exceeds 10MB. Please choose a smaller image.",
          ),
        ),
      );
      return;
    }

    final extension = pickedFile!.extension?.toLowerCase();
    final supportedFormats = ['jpg', 'jpeg', 'png', 'webp'];

    if (extension == null || !supportedFormats.contains(extension)) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unsupported image format: .$extension")),
      );
      return;
    }

    final originalBytes = pickedFile!.bytes!;
    final decodedImage = img.decodeImage(originalBytes);

    if (decodedImage == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to decode image.")));
      return;
    }

    // Compress image as JPEG (70% quality)
    final compressedBytes = Uint8List.fromList(
      img.encodeJpg(decodedImage, quality: 70),
    );

    setState(() {
      webImage = compressedBytes;
      imageTextEditingController.text = base64Encode(compressedBytes);
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image compressed and converted to base64")),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isUpdatingCategory && widget.nameOfCategory != null) {
      categoryTextEditingController.text = widget.nameOfCategory!;
      imageTextEditingController.text = widget.imageOfCategory ?? '';
      priorityTextEditingController.text = widget.priorityOfCategory.toString();

      if (widget.imageOfCategory != null &&
          widget.imageOfCategory!.isNotEmpty) {
        try {
          webImage = base64Decode(widget.imageOfCategory!);
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      title: Text(
        widget.isUpdatingCategory ? "Update Category" : "Add Category",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "All will be converted to lowercase",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryTextEditingController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  labelText: "Category Name",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "This will be used in ordering categories",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priorityTextEditingController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Priority",
                  labelText: "Priority",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              if (imageTextEditingController.text.isNotEmpty) ...[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      base64Decode(imageTextEditingController.text),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],

              Center(
                child: ElevatedButton.icon(
                  onPressed: pickImageAndConvertToBase64,
                  icon: Icon(Icons.image_outlined, color: Colors.white),
                  label: Text(
                    isLoading ? "please wait..." : "Pick Image",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: imageTextEditingController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  enabled: false,
                  hintText: "Base64 Image String",
                  labelText: "Image Data",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formGlobalKey.currentState!.validate()) {
              Map<String, dynamic> dataMapCategory = {
                "name": categoryTextEditingController.text.toLowerCase(),
                "image": imageTextEditingController.text,
                "priority": int.parse(priorityTextEditingController.text),
              };

              if (widget.isUpdatingCategory) {
                await categoryViewModel.updateCategory(
                  docId: widget.categoryId,
                  dataMap: dataMapCategory,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Category Updated"),
                  ),
                );
              } else {
                await categoryViewModel.addNewCategory(
                  dataMap: dataMapCategory,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("New Category Added"),
                  ),
                );
              }

              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            widget.isUpdatingCategory ? "Update" : "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
