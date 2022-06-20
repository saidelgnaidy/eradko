// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/cart/models/cart_datals.dart';
import 'package:eradko/payment/direct_payment.dart';
import 'package:eradko/orders/successful_order.dart';
import 'package:eradko/profile/add_new_address.dart';
import 'package:provider/provider.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/payment/payment_method_model.dart';
import 'package:eradko/payment/payment_provider.dart';
import 'package:eradko/profile/adresses_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Checkout extends StatefulWidget {
  final CartDetails cartDetails;
  const Checkout({Key? key, required this.cartDetails}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  PaymentResMap _paymentResMap = PaymentResMap(paymentMethodsList: PaymentMethodsList(data: []), message: 'Failed', status: false);
  bool loading = true;
  bool addingOrder = false;
  PaymentMethod? _selectedPaymentMethod;
  UserAddress? _selectedAddress;

  @override
  void initState() {
    PaymentProvider().initiatePayment(amount: '${widget.cartDetails.total}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PaymentProvider().getPaymentMethods(locale: Lang.of(context).localeName).then((value) {
        if (mounted) {
          setState(() {
            _paymentResMap = value;
            loading = false;
          });
        }
      });
    });
    super.initState();
  }

  _selectMethod(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  _selectAddress({UserAddress? address, required PaymentProvider paymentProvider}) {
    paymentProvider.setDeliveryAddress(address!.id);
    setState(() {
      _selectedAddress = address;
    });
  }

  Future addNewOrder(PaymentProvider paymentProvider) async {
    setState(() => addingOrder = true);
    paymentProvider
        .addNewOrder(
      methodId: '${_selectedPaymentMethod!.paymentMethodId}',
      addressId: '${_selectedAddress!.id}',
      locale: Lang.of(context).localeName,
    )
        .then((value) {
      setState(() {
        addingOrder = false;
        if (value.status) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessfulOrder(orderNumber: value.receipt ?? '', step: 1)));
        } else {
          showSnackError(context, msg: value.message);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AddressesProvider addressesProvider = Provider.of<AddressesProvider>(context, listen: true);
    final PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: buildAppBar(context, showCart: true, needPop: true),
      body: FutureProvider<List<UserAddress>>(
          initialData: addressesProvider.getUserAddresses,
          create: (BuildContext context) => addressesProvider.getAddresses(notify: true),
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            Lang.of(context).selectAddress,
                            style: TextStyle(color: textColor, fontSize: 15),
                          ),
                        ),
                        Builder(builder: (context) {
                          final List<UserAddress> addressesList = Provider.of<List<UserAddress>>(context);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            width: size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: addressesProvider.loadingAddresses
                                ? const LinearProgressIndicator()
                                : addressesProvider.getUserAddresses.isEmpty
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Text(
                                              Lang.of(context).noAddresses,
                                              style: TextStyle(color: textColor, fontSize: 13),
                                            ),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AddNewAddress(
                                                            isUpdate: false,
                                                            userAddress: UserAddress(
                                                                id: 00,
                                                                phone: '',
                                                                street: '',
                                                                area: '',
                                                                nearestPlace: '',
                                                                cityId: 00,
                                                                city: '',
                                                                lang: '',
                                                                lat: ''),
                                                          )));
                                            },
                                            child: Text(
                                              Lang.of(context).addNewAddress,
                                              style: const TextStyle(color: Colors.blue, fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Column(
                                            children: addressesList.map((address) {
                                              return InkWell(
                                                onTap: () {
                                                  _selectAddress(paymentProvider: paymentProvider, address: address);
                                                },
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      shape: const StadiumBorder(),
                                                      activeColor: accentColor,
                                                      value: (_selectedAddress == address),
                                                      onChanged: (value) {
                                                        _selectAddress(paymentProvider: paymentProvider, address: address);
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${address.city} , ${address.area} , ${address.nearestPlace} , ${address.street} , ${address.phone}',
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 13,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AddNewAddress(
                                                            isUpdate: false,
                                                            userAddress: UserAddress(
                                                                id: 00,
                                                                phone: '',
                                                                street: '',
                                                                area: '',
                                                                nearestPlace: '',
                                                                cityId: 00,
                                                                city: '',
                                                                lang: '',
                                                                lat: ''),
                                                          )));
                                            },
                                            child: Text(
                                              Lang.of(context).addNewAddress,
                                              style: const TextStyle(color: Colors.blue, fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            Lang.of(context).payingFrom,
                            style: TextStyle(color: textColor, fontSize: 15),
                          ),
                        ),
                        loading
                            ? const LinearProgressIndicator()
                            : Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                width: size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: _paymentResMap.paymentMethodsList.data.map((method) {
                                    return InkWell(
                                      onTap: () => _selectMethod(method),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            shape: const StadiumBorder(),
                                            activeColor: accentColor,
                                            value: (_selectedPaymentMethod == method),
                                            onChanged: (value) => _selectMethod(method),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 40,
                                            child: CachedNetworkImage(
                                              imageUrl: method.image,
                                              fit: BoxFit.contain,
                                              fadeInDuration: const Duration(microseconds: 200),
                                              placeholder: (context, img) => categoryPlaceholder(context),
                                              errorWidget: (context, img, child) => const Placeholder(),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            method.name,
                                            style: TextStyle(color: textColor, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            Lang.of(context).subtotal,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${widget.cartDetails.subtotal} SAR",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
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
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${widget.cartDetails.tax} SAR",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
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
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${widget.cartDetails.total} SAR",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: size.width,
                          height: 40,
                          child: RawMaterialButton(
                            onPressed: (_selectedPaymentMethod == null || _selectedAddress == null)
                                ? null
                                : () {
                                    paymentProvider.resetErrorMsg();
                                    if (_selectedPaymentMethod!.paymentMethodId == 30) {
                                      addNewOrder(paymentProvider);
                                    } else if (_selectedPaymentMethod!.paymentMethodId == 40) {
                                      return;
                                    } else if (_selectedPaymentMethod!.isDirectPayment == 1) {
                                      showBottomSheet(methodId: 20, amount: '${widget.cartDetails.total}', context: context);
                                    } else if (_selectedPaymentMethod!.isDirectPayment == 0) {
                                      paymentProvider.executeRegularPayment(
                                        context: context,
                                        amount: widget.cartDetails.total,
                                        methodId: 2,
                                        addressId: _selectedAddress!.id,
                                        locale: Lang.of(context).localeName,
                                      );
                                    } else {
                                      return;
                                    }
                                  },
                            fillColor: (_selectedPaymentMethod == null || _selectedAddress == null) ? Colors.grey : accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: addingOrder
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    ),
                                  )
                                : Text(
                                    Lang.of(context).checkout,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

showBottomSheet({required BuildContext context, required String amount, required int methodId}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (context) {
      return DirectPayment(
        totalAmount: amount,
        methodId: methodId,
      );
    },
  );
}
