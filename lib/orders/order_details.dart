import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/orders/order_details_model.dart';
import 'package:eradko/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetails extends StatefulWidget {
  final int id;
  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderDetailsModel? orderDetailsModel;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      OrdersProvider().getOrderDetails(locale: Lang.of(context).localeName, id: widget.id).then((value) {
        if (mounted) {
          setState(() {
            orderDetailsModel = value;
            loading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context, showCart: true, needPop: true),
      body: loading
          ? const Center(child: LinearProgressIndicator())
          : orderDetailsModel == null
              ? Center(
                  child: Text(
                  Lang.of(context).conectApp,
                  style: const TextStyle(color: Colors.red),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        height: 100,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.orderDetails,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.orderNumber,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  orderDetailsModel!.receipt,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  orderDetailsModel!.date,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(height: 10, color: Colors.grey[200]),
                      ListView.separated(
                        itemCount: orderDetailsModel!.items.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderDetailsModel!.items[index].productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Lang.of(context).subtotal,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              Lang.of(context).taxFee,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              Lang.of(context).total,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              Lang.of(context).quantity,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${orderDetailsModel!.items[index].subtotal}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${orderDetailsModel!.items[index].tax}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${orderDetailsModel!.items[index].total}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${orderDetailsModel!.items[index].quantity}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.width / 4,
                                  width: size.width / 4,
                                  child: CachedNetworkImage(
                                    imageUrl: orderDetailsModel!.items[index].image,
                                    fit: BoxFit.contain,
                                    fadeInDuration: const Duration(microseconds: 200),
                                    placeholder: (context, img) => categoryPlaceholder(context),
                                    errorWidget: (context, img, child) => const Placeholder(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(height: 10, color: Colors.grey[200]);
                        },
                      ),
                      Container(height: 10, color: Colors.grey[200]),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.paymentMethod,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    orderDetailsModel!.paymentMethod,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    Lang.of(context).subtotal,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${orderDetailsModel!.subtotal} SAR",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    Lang.of(context).taxFee,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${orderDetailsModel!.tax} SAR",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    Lang.of(context).total,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${orderDetailsModel!.total} SAR",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.shippingAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                '${orderDetailsModel!.address.city},${orderDetailsModel!.address.area},${orderDetailsModel!.address.nearestPlace},${orderDetailsModel!.address.street}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${Lang.of(context).phone} : ${orderDetailsModel!.address.phone}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButtonLocation:
          AppLocalizations.of(context)!.localeName == 'ar' ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: accentColor,
        child: Icon(
          AppLocalizations.of(context)!.localeName == 'ar' ? Icons.arrow_back : Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}
