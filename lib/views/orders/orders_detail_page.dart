import 'dart:convert';

import 'package:ecommerce_admin_web_panel/models/order_model.dart';
import 'package:ecommerce_admin_web_panel/views/orders/update_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersDetailPage extends StatefulWidget {
  const OrdersDetailPage({super.key});

  @override
  State<OrdersDetailPage> createState() => _OrdersDetailPageState();
}

class _OrdersDetailPageState extends State<OrdersDetailPage> {
  formatDateTime(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat("dd MM yyyy . hh:mm a").format(dateTime);
  }

  Widget detailRowWidget(
    String title,
    String value, {
    bool bold = false,
    bool highlight = false,
    Color? color,
  }) {
    return Padding(
      padding: .symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Text("${title}", style: const TextStyle(fontWeight: .w500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? .bold : .normal,
                color: highlight ? Colors.black87 : (color ?? Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: const Text("Order Details"),
      ),
      body: SingleChildScrollView(
        padding: const .all(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 600;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen
                      ? constraints.maxWidth * 0.7
                      : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Delivery Details",
                      style: TextStyle(fontSize: 18, fontWeight: .w700),
                    ),
                    SizedBox(height: 8),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(10),
                      ),
                      child: Padding(
                        padding: const .all(14),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            detailRowWidget("Order ID: ", args.id_order),
                            detailRowWidget(
                              "Ordered ON: ",
                              formatDateTime(args.created_at),
                            ),
                            detailRowWidget("Customer: ", args.name),
                            detailRowWidget("Phone: ", args.phone),
                            detailRowWidget("Address: ", args.address),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Items",
                      style: TextStyle(fontSize: 18, fontWeight: .w700),
                    ),
                    SizedBox(height: 8),

                    Column(
                      children: args.productsList.map((e) {
                        return Card(
                          elevation: 1,
                          margin: const .symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(10),
                          ),
                          child: Padding(
                            padding: const .all(12),
                            child: Column(
                              crossAxisAlignment: .end,
                              children: [
                                Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: .circular(8),
                                      child: Image.memory(
                                        base64Decode(e.image),
                                        height: 60,
                                        width: 60,
                                        fit: .cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Rp. ${e.single_price} * ${e.quantity} Quantity",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Rp. ${e.total_price}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Price Summary",
                      style: TextStyle(fontSize: 18, fontWeight: .w800),
                    ),

                    const SizedBox(height: 8),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(10),
                      ),

                      child: Padding(
                        padding: const .all(14),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            detailRowWidget(
                              "Discount: ",
                              "Rp. ${args.discount}",
                            ),
                            detailRowWidget(
                              "Total: ",
                              "Rp. ${args.total}",
                              bold: true,
                              highlight: true,
                            ),

                            detailRowWidget(
                              "Status: ",
                              args.status,
                              bold: true,
                              color: args.status.toLowerCase() == "delivered"
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                UpdateOrdersPage(orderData: args),
                          );
                        },
                        icon: const Icon(Icons.edit_note_rounded, size: 22),
                        label: const Text(
                          "Update Order",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
