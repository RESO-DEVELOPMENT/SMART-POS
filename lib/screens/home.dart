import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../enums/status_enums.dart';
import '../utils/format.dart';
import '../view_models/cart_view_model.dart';
import '../widgets/cart.dart';
import '../widgets/dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel<CartViewModel>(
        model: Get.find<CartViewModel>(),
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
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              itemCount: model.cart.promotionList!.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "-${model.cart.promotionList![i].name}",
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      Text(
                                        model.cart.promotionList![i]
                                                    .effectType ==
                                                "GET_POINT"
                                            ? "+${model.cart.promotionList![i].discountAmount} Điểm"
                                            : ("-${formatPrice(model.cart.promotionList![i].discountAmount!)}"),
                                        style: Get.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                  if (model.countCartQuantity() == 0) {
                                    showAlertDialog(
                                      title: 'Thông báo',
                                      content: 'Giỏ hàng trống',
                                    );
                                    return;
                                  } else {
                                    // model.createOrder();
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                  child: Text(
                                    'Tạo đơn hàng',
                                    style: Get.textTheme.titleMedium?.copyWith(
                                        color:
                                            Get.theme.colorScheme.background),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
    );
  }
}
