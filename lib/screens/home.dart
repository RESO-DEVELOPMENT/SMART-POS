import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/theme/theme.dart';

import '../enums/order_enum.dart';
import '../enums/status_enums.dart';
import '../utils/format.dart';
import '../view_models/cart_view_model.dart';
import '../widgets/cart.dart';
import '../widgets/dialog.dart';
import '../widgets/scan_membership_card_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CartViewModel cartViewModel = Get.find<CartViewModel>();

  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  startCountdown() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      cartViewModel.scanProductFromRedis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.backgroundColor,
      body: ScopedModel<CartViewModel>(
          model: cartViewModel,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ScopedModelDescendant<CartViewModel>(
                      builder: (context, child, model) {
                    if (model.status == ViewStatus.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.onInverseSurface,
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    'Tên',
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'SL',
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Tổng',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Expanded(
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.cart.productList!.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return cartItem(model.cart.productList![i], i);
                            },
                          )),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(
                                  thickness: 1,
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       Expanded(
                                //         child: FilledButton.tonal(
                                //           onPressed: () async {
                                //             // selectPromotionDialog();
                                //           },
                                //           child: Padding(
                                //             padding:
                                //                 const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                //             child: Text(
                                //               'Giảm giá',
                                //               style: Get.textTheme.bodyMedium,
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Số lượng: ${model.countCartQuantity().toString()}',
                                          style: Get.textTheme.bodyMedium),
                                      Text(
                                          'Tạm tính: ${formatPrice(model.cart.totalAmount ?? 0)}',
                                          style: Get.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                                model.cart.promotionList!.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            model.cart.promotionList!.length,
                                        physics: const ScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "-${model.cart.promotionList![i].name}",
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                                Text(
                                                  model.cart.promotionList![i]
                                                              .effectType ==
                                                          "GET_POINT"
                                                      ? "+${model.cart.promotionList![i].discountAmount} Điểm"
                                                      : ("-${formatPrice(model.cart.promotionList![i].discountAmount!)}"),
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          'Tổng giảm: ${formatPrice(model.cart.discountAmount ?? 0)}',
                                          style: Get.textTheme.bodyMedium),
                                      Text(
                                          'Tổng tiền: ${formatPrice(model.cart.finalAmount ?? 0)}',
                                          style: Get.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 8),
                                        child: IconButton(
                                            onPressed: () async {
                                              var result = await showConfirmDialog(
                                                  title: 'Xác nhận',
                                                  content:
                                                      'Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng không?');
                                              if (result) {
                                                model.clearCartData();
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_outlined,
                                              size: 40,
                                            )),
                                      ),
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: () async {
                                            if (model.countCartQuantity() ==
                                                0) {
                                              showAlertDialog(
                                                title: 'Thông báo',
                                                content: 'Giỏ hàng trống',
                                              );
                                              return;
                                            } else {
                                              model.createOrder();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 12, 0, 12),
                                            child: Text(
                                              'Tạo đơn hàng',
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .background),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      FilledButton.tonal(
                                        onPressed: () async {
                                          // selectPromotionDialog();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(
                                            'Khuyến mãi',
                                            style: Get.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                Expanded(flex: 1, child: customerInfo())
              ],
            ),
          )),
    );
  }
}

Widget customerInfo() {
  TextEditingController value = TextEditingController();
  return ScopedModelDescendant<CartViewModel>(builder: (context, build, model) {
    if (model.status == ViewStatus.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (model.customer == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: value,
                decoration: InputDecoration(
                    hintText: "Quét mã Thành viên để tiếp tục",
                    hintStyle: POSTextTheme.bodyM,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    isDense: true,
                    labelStyle: POSTextTheme.labelL,
                    fillColor: ThemeColor.backgroundColor,
                    prefixIcon: const Icon(
                      Icons.portrait_rounded,
                      color: ThemeColor.onBackgroundColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        value.text = "";
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    contentPadding: const EdgeInsets.all(16),
                    isCollapsed: true,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.errorColor, width: 2.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.tonal(
                  onPressed: () {
                    Get.find<CartViewModel>().scanCustomer(value.text ?? '');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tiếp tục', style: Get.textTheme.titleMedium),
                  )),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child:
              Text("Thông tin khách hàng   ", style: Get.textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Khách hàng',
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                model.customer?.fullName ?? "Khách",
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'SDT',
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                model.customer?.phoneNumber ?? "Khách",
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thanh toán',
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                getPaymentName(
                    model.cart.paymentType ?? PaymentTypeEnums.POINTIFY),
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    ));
  });
}
