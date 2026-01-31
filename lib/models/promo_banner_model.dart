import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannerModel {
  final String titlePromoBanner;
  final String imagePromoBanner;
  final String categoryPromoBanner;
  final String idPromoBanner;

  PromoBannerModel({
    required this.titlePromoBanner,
    required this.imagePromoBanner,
    required this.categoryPromoBanner,
    required this.idPromoBanner,
  });

  factory PromoBannerModel.fromJson(
    Map<String, dynamic> jsonData,
    String docID,
  ) {
    return PromoBannerModel(
      titlePromoBanner: jsonData["title"] ?? "",
      imagePromoBanner: jsonData["image"] ?? "",
      categoryPromoBanner: jsonData["category"] ?? "",
      idPromoBanner: docID,
    );
  }

  static List<PromoBannerModel> fromJsonList(
    List<QueryDocumentSnapshot> promosBannersList,
  ) {
    return promosBannersList
        .map(
          (promoBanner) => PromoBannerModel.fromJson(
            promoBanner.data() as Map<String, dynamic>,
            promoBanner.id,
          ),
        )
        .toList();
  }
}
