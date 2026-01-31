import 'dart:convert';

import 'package:ecommerce_admin_web_panel/viewModel/promo_banner_view_model.dart';
import 'package:ecommerce_admin_web_panel/widgets/confirm_aciton_dialog.dart';
import 'package:flutter/material.dart';

import '../../models/promo_banner_model.dart';

class PromosBannersPage extends StatefulWidget {
  const PromosBannersPage({super.key});

  @override
  State<PromosBannersPage> createState() => _PromosBannersPageState();
}

class _PromosBannersPageState extends State<PromosBannersPage> {
  bool initialized = false;
  bool promoPage = true;

  PromoBannerViewModel promoBannerViewModel = PromoBannerViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      if (!initialized) {
        final args = ModalRoute.of(context)?.settings.arguments;

        if (args != null && args is Map<String, dynamic>) {
          promoPage = args['promo'] ?? true;
        }

        initialized = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: promoPage ? Colors.blueAccent : Colors.orange,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        titleSpacing: 20,
        title: Text(promoPage ? "Promos" : "Banners"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: promoPage ? Colors.blueAccent : Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/update_promo_banner",
            arguments: {"promoBannerInfo": promoPage},
          );
        },
        child: Icon(Icons.add),
      ),
      body: initialized
          ? StreamBuilder(
              stream: promoBannerViewModel.fetchPromoBanner(promoPage),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PromoBannerModel> promosBannersList =
                      PromoBannerModel.fromJsonList(snapshot.data!.docs);

                  if (promosBannersList.isEmpty) {
                    return Center(
                      child: Text(
                        "No ${promoPage ? "Promos" : "Banners"} record found",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: promosBannersList.length,
                    itemBuilder: (context, index) {
                      final promoBannerInfo = promosBannersList[index];
                      final imageBytes = base64Decode(
                        promoBannerInfo.imagePromoBanner,
                      );

                      return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      child: AlertDialog(
                                        title: Text("What do you want to do?"),
                                        content: Text(
                                          "Delete action is permanent.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) => Center(
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
                                                        promoBannerViewModel
                                                            .deletePromoBanner(
                                                              docID: promoBannerInfo
                                                                  .idPromoBanner,
                                                              promoPage:
                                                                  promoPage,
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
                                            child: Text(
                                              "Delete ${promoPage ? "Promo" : "Banner"}",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                "/update_promo_banner",
                                                arguments: {
                                                  "promoBannerInfo": promoPage,
                                                  "detail": promoBannerInfo,
                                                },
                                              );
                                            },
                                            child: Text(
                                              "Update ${promoPage ? "Promo" : "Banner"}",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                promoBannerInfo.titlePromoBanner,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                promoBannerInfo.categoryPromoBanner,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/update_promo_banner",
                                    arguments: {
                                      "promoBannerInfo": promoPage,
                                      "detail": promoBannerInfo,
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            )
          : SizedBox(),
    );
  }
}
