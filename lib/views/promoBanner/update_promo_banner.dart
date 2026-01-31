import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:ecommerce_admin_web_panel/viewModel/promo_banner_view_model.dart';
import 'package:ecommerce_admin_web_panel/widgets/category_text_form_field.dart';
import 'package:ecommerce_admin_web_panel/widgets/text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../../models/promo_banner_model.dart';

class UpdatePromoBannerPage extends StatefulWidget {
  const UpdatePromoBannerPage({super.key});

  @override
  State<UpdatePromoBannerPage> createState() => _UpdatePromoBannerPageState();
}

class _UpdatePromoBannerPageState extends State<UpdatePromoBannerPage> {
  bool initialized = false;
  bool promoPage = true;

  final formGlobalKey = GlobalKey<FormState>();
  bool isUploading = false;
  Uint8List? imageBytes;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  late String promoBannerId = "";
  PromoBannerViewModel promoBannerViewModel = PromoBannerViewModel();

  pickImageAndCompressBase64() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => isUploading = true);

      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      if (fileBytes != null) {
        final decodedImage = img.decodeImage(fileBytes);
        if (decodedImage != null) {
          final compressed = img.encodeJpg(decodedImage, quality: 70);
          final base64Str = base64Encode(compressed);

          imageController.text = base64Str;
          imageBytes = Uint8List.fromList(compressed);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Image compressed and loaded",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }

      setState(() => isUploading = false);
    }
  }

  displayDataOnTextFormField(PromoBannerModel promoBannerData) {
    promoBannerId = promoBannerData.idPromoBanner;
    titleController.text = promoBannerData.titlePromoBanner;
    categoryController.text = promoBannerData.categoryPromoBanner;
    imageController.text = promoBannerData.imagePromoBanner;

    try {
      imageBytes = base64Decode(promoBannerData.imagePromoBanner);
    } catch (e) {
      imageBytes = null;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      if (!initialized) {
        final args = ModalRoute.of(context)?.settings.arguments;

        if (args != null && args is Map<String, dynamic>) {
          if (args["detail"] is PromoBannerModel) {
            displayDataOnTextFormField(args["detail"] as PromoBannerModel);
          }

          promoPage = args['promoBannerInfo'] ?? true;
        }

        initialized = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(promoPage ? "Update Promo" : "Update Banner"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
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
                    controller: titleController,
                    label: "Title",
                    validatorMsg: "This field cannot be empty.",
                  ),

                  SizedBox(height: 16),

                  buildCategoryTextFormField(context, categoryController),

                  SizedBox(height: 16),

                  imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            imageBytes!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),

                  SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: isUploading ? null : pickImageAndCompressBase64,
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: Text(
                      isUploading ? "Uploading..." : "Pick Image & Compress",
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 28,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  buildTextFormField(
                    controller: imageController,
                    label: "Base64 Image String",
                    validatorMsg: "Please upload an image.",
                    readOnly: true,
                    maxLines: 3,
                  ),

                  SizedBox(height: 24),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        if (formGlobalKey.currentState!.validate()) {
                          final Map<String, dynamic> data = {
                            "title": titleController.text,
                            "category": categoryController.text,
                            "image": imageController.text,
                          };

                          if (promoBannerId.isNotEmpty) {
                            promoBannerViewModel.updatePromoBanner(
                              docID: promoBannerId,
                              dataMap: data,
                              promoPage: promoPage,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "${promoPage ? "Promo" : "Banner"} Updated",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          } else {
                            promoBannerViewModel.createPromoBanner(
                              dataMap: data,
                              promoPage: promoPage,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "New ${promoPage ? "Promo" : "Banner"} Saved",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        promoPage ? "Update Promo" : "Update Banner",
                        style: const TextStyle(color: Colors.white),
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
