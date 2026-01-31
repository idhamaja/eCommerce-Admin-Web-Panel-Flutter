import 'package:ecommerce_admin_web_panel/viewModel/coupon_view_model.dart';

import 'package:flutter/material.dart';

class UpdateCouponDialog extends StatefulWidget {
  final String idCoupon;
  final String codeCoupon;
  final String descCoupon;
  final int discountCoupon;

  const UpdateCouponDialog({
    super.key,
    required this.idCoupon,
    required this.codeCoupon,
    required this.descCoupon,
    required this.discountCoupon,
  });

  @override
  State<UpdateCouponDialog> createState() => _UpdateCouponDialogState();
}

class _UpdateCouponDialogState extends State<UpdateCouponDialog> {
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController codeTextEditingController =
      TextEditingController();
  final TextEditingController descTextEditingController =
      TextEditingController();
  final TextEditingController disPercentTextEditingController =
      TextEditingController();
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    codeTextEditingController.text = widget.codeCoupon;
    descTextEditingController.text = widget.descCoupon;
    disPercentTextEditingController.text = widget.discountCoupon.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdateCoupon = widget.idCoupon.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUpdateCoupon ? "Update Coupon" : "Add New Coupon",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: codeTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Coupon Code",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Coupon code cannot be empty." : null,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: descTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Description cannot be empty." : null,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: disPercentTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Discount (%)",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v!.isEmpty ? "Discount % cannot be empty." : null,
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          final couponDataMap = {
                            "code": codeTextEditingController.text
                                .toUpperCase(),
                            "desc": descTextEditingController.text,
                            "discount": int.tryParse(
                              disPercentTextEditingController.text,
                            ),
                          };

                          try {
                            if (isUpdateCoupon) {
                              await couponViewModel.updateCoupon(
                                docId: widget.idCoupon,
                                couponDataMap: couponDataMap,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: const Text(
                                    "Coupon Data updated successfully",
                                  ),
                                ),
                              );
                            } else {
                              await couponViewModel.addNewCoupon(
                                couponDataMap: couponDataMap,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: const Text(
                                    "New Coupon saved successfully",
                                  ),
                                ),
                              );
                            }

                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Failed to save coupon: ${e.toString()}",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        isUpdateCoupon ? "Update Coupon" : "Add New Coupon",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
