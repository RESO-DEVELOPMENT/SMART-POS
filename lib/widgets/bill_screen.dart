import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/models/order_detail_model.dart';
import 'package:smart_pos/utils/format.dart';

import '../enums/order_enum.dart';
import '../enums/status_enums.dart';
import '../view_models/index.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OrderViewModel>(
        builder: (context, build, model) {
      if (model.status == ViewStatus.Loading || model.currentOrder == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("Thông tin đơn hàng",
                            style: Get.textTheme.titleSmall),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.currentOrder!.productList!.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, i) {
                          return productItem(
                              model.currentOrder!.productList![i]);
                        },
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Mã đơn',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              model.currentOrder!.invoiceId!,
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
                              'STT',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              (model.currentOrder?.customerNumber ?? 1)
                                  .toString(),
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
                              'Nhận món',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              showOrderType(model.currentOrder!.orderType!)
                                  .label,
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      customerInfo(model.currentOrder?.customerInfo),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Trạng thái đơn hàng',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              showOrderStatus(
                                  model.currentOrder!.orderStatus ?? ""),
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
                                  model.currentOrder!.paymentType ?? ""),
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
                              'Thời gian',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatTime(model.currentOrder?.checkInDate ?? ""),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tạm tính',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatPrice(model.currentOrder!.totalAmount!),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      model.currentOrder!.promotionList != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  model.currentOrder!.promotionList!.length,
                              physics: ScrollPhysics(),
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
                                        "- ${model.currentOrder!.promotionList![i].promotionName}",
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      Text(
                                        model.currentOrder!.promotionList![i]
                                                    .effectType ==
                                                "GET_POINT"
                                            ? ("+${model.currentOrder!.promotionList![i].discountAmount} Điểm")
                                            : ("- ${formatPrice(model.currentOrder!.promotionList![i].discountAmount ?? 0)}"),
                                        style: Get.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
                      model.currentOrder!.discount != 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tổng giảm",
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    " - ${formatPrice(model.currentOrder!.discount ?? 0)}",
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      // model.currentOrder!.discountProduct != null &&
                      //         model.currentOrder!.discountProduct != 0
                      //     ? Padding(
                      //         padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               "Giảm giá sản phẩm" ?? '',
                      //               style: Get.textTheme.bodyMedium,
                      //             ),
                      //             Text(
                      //               " - ${formatPrice(model.currentOrder!.discountProduct ?? 0)}",
                      //               style: Get.textTheme.bodyMedium,
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : SizedBox(),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'VAT (${percentCalculation(model.currentOrder!.vat!)})',
                      //         style: Get.textTheme.bodyMedium,
                      //       ),
                      //       Text(
                      //         formatPrice(model.currentOrder!.vatAmount!),
                      //         style: Get.textTheme.bodyMedium,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tổng tiền',
                              style: Get.textTheme.titleMedium,
                            ),
                            Text(
                              formatPrice(model.currentOrder!.finalAmount!),
                              style: Get.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      model.customerMoney > 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Khách đưa',
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  Text(
                                    formatPrice(model.customerMoney),
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      model.customerMoney >= model.currentOrder!.finalAmount!
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Trả lại',
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  Text(
                                    formatPrice(model.returnMoney),
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   width: double.infinity,
            //   height: 64,
            //   child: FilledButton.icon(
            //     onPressed: () async {
            //       var result = await showConfirmDialog(
            //           title: 'Xác nhận',
            //           content: 'Xác nhận hoàn thành đơn hàng');
            //       if (result) {
            //         model.completeOrder(
            //           model.currentOrder!.orderId!,
            //         );
            //       }
            //     },
            //     icon: Icon(Icons.check),
            //     label: Text(
            //       'Hoàn thành',
            //       style: Get.textTheme.titleMedium
            //           ?.copyWith(color: Get.theme.colorScheme.background),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  Widget customerInfo(CustomerInfo? info) {
    if (info == null) {
      return SizedBox();
    }
    return Column(
      children: [
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
                info.name ?? "Khách",
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
                info.phone ?? "Khách",
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
                'Địa chỉ giao',
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                info.address ?? "",
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
                'Trạng thái thanh toán',
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                showPaymentStatusEnum(
                    info.paymentStatus ?? PaymentStatusEnum.PENDING),
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget productItem(ProductList item) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
    child: Column(
      children: [
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name!,
                    style: Get.textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    formatPrice(item.sellingPrice ?? 0),
                    style: Get.textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${item.quantity}",
                    style: Get.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Column(
                  children: [
                    Text(
                      formatPrice(item.finalAmount!),
                      style: Get.textTheme.bodyLarge,
                    ),
                    item.discount != 0
                        ? Text(
                            "-${formatPrice(item.discount!)}",
                            style: Get.textTheme.bodyMedium,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: item.extras?.length,
          physics: ScrollPhysics(),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      "+${item.extras![i].name!}",
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        formatPrice(item.extras![i].sellingPrice!),
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (item.note != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(item.note ?? '',
                  style: Get.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
      ],
    ),
  );
}

void hideDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

void hideBottomSheet() {
  if (Get.isBottomSheetOpen ?? false) {
    Get.back();
  }
}

Future<String?> inputDialog(String title, String hint, String? value,
    {bool isNum = false}) async {
  hideDialog();
  String? result;
  await Get.dialog(AlertDialog(
    title: Text(title),
    content: TextField(
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNum ? [FilteringTextInputFormatter.digitsOnly] : null, // Only numb
      controller: TextEditingController(text: value),
      decoration: InputDecoration(hintText: hint),
      onChanged: (value) {
        result = value;
      },
    ),
    actions: [
      TextButton(
          onPressed: () {
            Get.back(result: result);
          },
          child: Text('Cập nhật')),
      TextButton(
          onPressed: () {
            Get.back(result: value);
          },
          child: Text('Huỷ')),
    ],
  ));
  return result;
}
