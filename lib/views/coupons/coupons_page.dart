import 'package:ecommerce_admin_web_panel/models/coupon_model.dart';
import 'package:ecommerce_admin_web_panel/viewModel/coupon_view_model.dart';
import 'package:ecommerce_admin_web_panel/views/coupons/update_coupon_dialog.dart';
import 'package:ecommerce_admin_web_panel/widgets/confirm_aciton_dialog.dart';

import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: const Text("Coupons"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: const UpdateCouponDialog(
                  idCoupon: "",
                  codeCoupon: "",
                  descCoupon: "",
                  discountCoupon: 0,
                ),
              ),
            ),
          );
        },
        tooltip: "Add New Coupon",
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: couponViewModel.fetchCoupons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> couponsList = CouponModel.fromJsonList(
              snapshot.data!.docs,
            );

            if (couponsList.isEmpty) {
              return const Center(child: Text("No couponsList record found"));
            }

            return ListView.builder(
              itemCount: couponsList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final coupon = couponsList[index];

                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        title: Text(
                          coupon.codeCoupon,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(coupon.descCoupon),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) => Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: UpdateCouponDialog(
                                    idCoupon: coupon.idCoupon,
                                    codeCoupon: coupon.codeCoupon,
                                    descCoupon: coupon.descCoupon,
                                    discountCoupon: coupon.discountCoupon,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (c) => Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: AlertDialog(
                                  title: const Text("What do you want to do?"),
                                  content: const Text(
                                    "Delete action is permanent.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (c) => Center(
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.7,
                                              child: ConfirmActionDialog(
                                                dialogBodyText:
                                                    "Are you sure you want to delete this?",
                                                onYesCallback: () {
                                                  couponViewModel.deleteCoupon(
                                                    docId: coupon.idCoupon,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                onNoCallback: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Delete Coupon",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (c) => Center(
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.7,
                                              child: UpdateCouponDialog(
                                                idCoupon: coupon.idCoupon,
                                                codeCoupon: coupon.codeCoupon,
                                                descCoupon: coupon.descCoupon,
                                                discountCoupon:
                                                    coupon.discountCoupon,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Update Coupon",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
