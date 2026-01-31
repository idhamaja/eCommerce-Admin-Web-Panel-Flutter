import 'package:ecommerce_admin_web_panel/models/order_model.dart';
import 'package:ecommerce_admin_web_panel/viewModel/orders_view_model.dart';
import 'package:flutter/material.dart';

class UpdateOrdersPage extends StatefulWidget {
  final OrderModel orderData;

  const UpdateOrdersPage({super.key, required this.orderData});

  @override
  State<UpdateOrdersPage> createState() => _UpdateOrdersPageState();
}

class _UpdateOrdersPageState extends State<UpdateOrdersPage> {
  OrdersViewModel ordersViewModel = OrdersViewModel();

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: .w500),
        ),
        icon: Icon(icon, size: 20),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const .symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      title: Row(
        children: const [
          Icon(Icons.edit_note_rounded, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text("Update Order Status", style: TextStyle(fontWeight: .w600)),
        ],
      ),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          const Padding(
            padding: .only(bottom: 12),
            child: Text(
              "Choose new status for this order",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),

          _buildActionButton(
            icon: Icons.check_circle_outline_rounded,
            label: "Mark as Paid",
            color: Colors.green,
            onPressed: () async {
              await ordersViewModel.updateOrdersStatus(
                docID: widget.orderData.id_order,
                orderData: {"status: ": "PAID"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.check_circle_outline_rounded,
            label: "Mark as Delivered",
            color: Colors.lightBlue,
            onPressed: () async {
              await ordersViewModel.updateOrdersStatus(
                docID: widget.orderData.id_order,
                orderData: {"status: ": "DELIVERED"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.local_shipping_rounded,
            label: "Mark as shipped",
            color: Colors.deepOrange,
            onPressed: () async {
              await ordersViewModel.updateOrdersStatus(
                docID: widget.orderData.id_order,
                orderData: {"status: ": "ON_THE_WAY"},
              );

              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.cancel_presentation_rounded,
            label: "Cancel Order",
            color: Colors.red,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Cancel Order?"),
                  content: const Text(
                    "After Canceling, this order cannot be changed."
                    "The Customer will need to place a new order.",
                    style: TextStyle(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Yes, Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ordersViewModel.updateOrdersStatus(
                  docID: widget.orderData.id_order,
                  orderData: {"status ": "CANCELLED"},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
