import 'package:ecommerce_admin_web_panel/providers/admin_web_panel_provider.dart';
import 'package:ecommerce_admin_web_panel/views/categories/categories_page.dart';
import 'package:ecommerce_admin_web_panel/views/coupons/coupons_page.dart';
import 'package:ecommerce_admin_web_panel/views/dashboard_page.dart';
import 'package:ecommerce_admin_web_panel/views/orders/orders_detail_page.dart';
import 'package:ecommerce_admin_web_panel/views/orders/orders_page.dart';
import 'package:ecommerce_admin_web_panel/views/products/products_page.dart';
import 'package:ecommerce_admin_web_panel/views/products/update_products_page.dart';
import 'package:ecommerce_admin_web_panel/views/promoBanner/promo_banners_page.dart';
import 'package:ecommerce_admin_web_panel/views/promoBanner/update_promo_banner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB5XzP6ki0SvFqAGqnjA3vHSeebn7O6AH8",
      authDomain: "snapshopecommerceapp-8e2c4.firebaseapp.com",
      projectId: "snapshopecommerceapp-8e2c4",
      storageBucket: "snapshopecommerceapp-8e2c4.firebasestorage.app",
      messagingSenderId: "953110265618",
      appId: "1:953110265618:web:893b4a778293d0c6117dcb",
      measurementId: "G-J7YVNV08N9",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminWebPanelProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Web E-Commerce Panel',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        routes: {
          "/": (context) => DashboardPage(),
          "/promos_banners": (context) => PromosBannersPage(),
          "/update_promo_banner": (context) => const UpdatePromoBannerPage(),
          "/category": (context) => const CategoriesPage(),
          "/products": (context) => const ProductsPage(),
          "/update_products": (context) => const UpdateProductsPage(),
          "/coupons": (context) => const CouponsPage(),
          "/orders": (context) => const OrdersPage(),
          "/orders_details": (context) => const OrdersDetailPage(),
        },
      ),
    );
  }
}
