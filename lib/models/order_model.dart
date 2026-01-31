import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_product_model.dart';

class OrderModel {
  String id_order;
  String user_id;
  String email;
  String name;
  String phone;
  String status;
  String address;
  int discount;
  int total;
  int created_at;
  List<OrderProductModel> productsList;

  OrderModel({
    required this.id_order,
    required this.user_id,
    required this.created_at,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.discount,
    required this.total,
    required this.productsList,
  });

  factory OrderModel.fromJson(Map<String, dynamic> jsonData, String idOrder) {
    return OrderModel(
      id_order: idOrder,
      user_id: jsonData["user_id"] ?? "",
      created_at: jsonData["created_at"] ?? 0,
      email: jsonData["email"] ?? "",
      name: jsonData["name"] ?? "",
      phone: jsonData["phone"] ?? "",
      status: jsonData["status"] ?? "",
      address: jsonData["address"] ?? "",
      discount: jsonData["discount"] ?? 0,
      total: jsonData["total"] ?? 0,
      productsList: jsonData["productList"] != null
          ? List<OrderProductModel>.from(
              (jsonData["productList"] as List).map(
                (e) => OrderProductModel.fromJSON(e),
              ),
            )
          : [],
    );
  }

  static List<OrderModel> fromJsonList(List<QueryDocumentSnapshot> ordersList) {
    return ordersList
        .map(
          (order) => OrderModel.fromJson(
            order.data() as Map<String, dynamic>,
            order.id,
          ),
        )
        .toList();
  }
}
