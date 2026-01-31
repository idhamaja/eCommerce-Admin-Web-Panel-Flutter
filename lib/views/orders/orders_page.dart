import 'package:ecommerce_admin_web_panel/models/order_model.dart';
import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _searchQueryOrders = "";
  String _selectedStatus = "All";

  Widget statusBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: .circular(6)),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  Widget setStatus(String status) {
    if (status == "PAID") {
      return statusBadge(
        text: "PAID",
        bgColor: Colors.lightGreen,
        textColor: Colors.white,
      );
    } else if (status == "ON_THE_WAY") {
      return statusBadge(
        text: "ON_THE_WAY",
        bgColor: Colors.yellow,
        textColor: Colors.black,
      );
    } else if (status == "DELIVERED") {
      return statusBadge(
        text: "DELIVERED",
        bgColor: Colors.green.shade700,
        textColor: Colors.white,
      );
    } else {
      return statusBadge(
        text: "CANCELLED",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurpleAccent.shade200,
        title: const Text("Orders Page"),
        centerTitle: true,
      ),
      body: Consumer<AdminWebPanelProvider>(
        builder: (context, value, child) {
          List<OrderModel> AllOrdersList = OrderModel.fromJsonList(
            value.ordersList,
          );

          //Apply filters Orders
          List<OrderModel> filteredOrders = AllOrdersList.where((
            orderFiltered,
          ) {
            final adminInputSearchText = _searchQueryOrders.toLowerCase();
            final matchesSearchOrders =
                orderFiltered.name.toLowerCase().contains(
                  adminInputSearchText,
                ) ||
                orderFiltered.id_order.toLowerCase().contains(
                  adminInputSearchText,
                );
            final matchesStatus =
                _selectedStatus == "All" ||
                orderFiltered.status == _selectedStatus;
            return matchesSearchOrders && matchesStatus;
          }).toList();

          //
          return Column(
            children: [
              Padding(
                padding: const .symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQueryOrders = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search by customers or order ID",
                          prefixIcon: Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: .symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: .none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    //dropdown filter
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(value: "PAID", child: Text("PAID")),
                          DropdownMenuItem(
                            value: "ON_THE_WAY",
                            child: Text("ON_THE_WAY"),
                          ),
                          DropdownMenuItem(
                            value: "DELIVERED",
                            child: Text("DELIVERED"),
                          ),
                          DropdownMenuItem(
                            value: "CANCELLED",
                            child: Text("CANCELLED"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: .symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: .circular(12),
                            borderSide: .none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              //display ORDERS
              Expanded(
                child: filteredOrders.isEmpty
                    ? const Center(child: Text("No Matching Orders Found"))
                    : ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final orderDisplay = filteredOrders[index];
                          final orderDate = DateTime.fromMillisecondsSinceEpoch(
                            orderDisplay.created_at,
                          );
                          final formattedDate = DateFormat(
                            'MMM d, yyyy . h:mm a',
                          ).format(orderDate);

                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Card(
                                elevation: 2,
                                margin: .symmetric(vertical: 6, horizontal: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/orders_details",
                                      arguments: orderDisplay,
                                    );
                                  },
                                  contentPadding: .symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  title: Center(
                                    child: Text(
                                      "Order ID# ${orderDisplay.id_order}",
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Purchase by ${orderDisplay.name}\n Order placed on $formattedDate",
                                  ),
                                  trailing: setStatus(orderDisplay.status),
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
