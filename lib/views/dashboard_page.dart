import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget buildTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(38),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(77),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminprovider = Provider.of<AdminWebPanelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            const Text(
              "Admin Management Panel",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  buildDashboardButton(
                    icon: Icons.shopping_cart,
                    label: "Orders",
                    onTap: () => Navigator.pushNamed(context, "/orders"),
                    color: Colors.teal,
                  ),

                  buildDashboardButton(
                    icon: Icons.store,
                    label: "Products",
                    onTap: () => Navigator.pushNamed(context, "/products"),
                    color: Colors.deepPurple,
                  ),

                  buildDashboardButton(
                    icon: Icons.local_offer,
                    label: "Promos",
                    onTap: () => Navigator.pushNamed(
                      context,
                      "/promos_banners",
                      arguments: {"promo": true},
                    ),
                    color: Colors.orange,
                  ),

                  buildDashboardButton(
                    icon: Icons.photo_library,
                    label: "Banners",
                    onTap: () => Navigator.pushNamed(
                      context,
                      "/promos_banners",
                      arguments: {"promo": false},
                    ),
                    color: Colors.pinkAccent,
                  ),

                  buildDashboardButton(
                    icon: Icons.category,
                    label: "Categories",
                    onTap: () => Navigator.pushNamed(context, "/category"),
                    color: Colors.blueAccent,
                  ),

                  buildDashboardButton(
                    icon: Icons.card_giftcard,
                    label: "Coupons",
                    onTap: () => Navigator.pushNamed(context, "/coupons"),
                    color: Colors.green,
                  ),
                ],
              ),

              SizedBox(height: 30),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade100,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTile(
                      icon: Icons.category,
                      label: "Total Categories",
                      value: adminprovider.categoriesList.length.toString(),
                      color: Colors.blueAccent,
                    ),

                    buildTile(
                      icon: Icons.shopping_bag,
                      label: "Total Products",
                      value: adminprovider.productsList.length.toString(),
                      color: Colors.deepPurple,
                    ),

                    buildTile(
                      icon: Icons.receipt_long,
                      label: "Total Orders",
                      value: adminprovider.totalOrdersNum.toString(),
                      color: Colors.teal,
                    ),

                    buildTile(
                      icon: Icons.hourglass_bottom,
                      label: "Order Not Shipped Yet",
                      value: adminprovider.orderPendingProcessNum.toString(),
                      color: Colors.orange,
                    ),

                    buildTile(
                      icon: Icons.local_shipping,
                      label: "Orders Shipped",
                      value: adminprovider.ordersOnTheWayNum.toString(),
                      color: Colors.indigo,
                    ),

                    buildTile(
                      icon: Icons.check_circle,
                      label: "Orders Delivered",
                      value: "0",
                      color: Colors.green,
                    ),

                    buildTile(
                      icon: Icons.cancel,
                      label: "Orders Cancelled",
                      value: adminprovider.ordersCancelledNum.toString(),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
