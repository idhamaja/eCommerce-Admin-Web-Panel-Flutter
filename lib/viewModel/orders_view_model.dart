import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersViewModel {
  saveNewOrderInfo({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("orders").add(data);
  }

  Stream<QuerySnapshot> fetchOrders() {
    return FirebaseFirestore.instance
        .collection("orders")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  updateOrdersStatus({
    required String docID,
    required Map<String, dynamic> orderData,
  }) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(docID)
        .update(orderData);
  }
}
