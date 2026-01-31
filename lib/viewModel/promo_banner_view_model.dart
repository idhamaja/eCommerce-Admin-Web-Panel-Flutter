import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannerViewModel {
  createPromoBanner({
    required Map<String, dynamic> dataMap,
    required bool promoPage,
  }) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .add(dataMap);
  }

  updatePromoBanner({
    required Map<String, dynamic> dataMap,
    required bool promoPage,
    required String docID,
  }) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .doc(docID)
        .update(dataMap);
  }

  deletePromoBanner({required bool promoPage, required String docID}) async {
    await FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .doc(docID)
        .delete();
  }

  Stream<QuerySnapshot> fetchPromoBanner(bool promoPage) {
    return FirebaseFirestore.instance
        .collection(promoPage ? "promos" : "banners")
        .snapshots();
  }
}
