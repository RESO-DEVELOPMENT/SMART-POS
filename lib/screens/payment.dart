import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/view_models/index.dart';

import '../enums/status_enums.dart';
import '../theme/theme.dart';
import '../widgets/bill_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String id;
  const PaymentScreen({
    super.key,
    required this.id,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  OrderViewModel orderViewModel = OrderViewModel();
  bool isQrCodeOpen = false;
  @override
  void initState() {
    orderViewModel.getOrderDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
          model: orderViewModel,
          child: ScopedModelDescendant<OrderViewModel>(
              builder: (context, build, model) {
            return Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: BillScreen(),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                              onPressed: () {
                                model.completeOrder(widget.id);
                              },
                              child: const Text("Thanh toán")),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              model.completeOrder(widget.id);
                            },
                            child: Text(
                              "Hủy đơn",
                              style: POSTextTheme.bodyL
                                  .copyWith(color: ThemeColor.errorColor),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            );
          })),
    );
  }
}

Widget paymentTypeSelect() {
  TextEditingController codeController = TextEditingController();
  return ScopedModelDescendant<OrderViewModel>(
      builder: (context, build, model) {
    if (model.status == ViewStatus.Loading || model.currentOrder == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text("Thanh toán", style: Get.textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Column(
                children: [
                  Center(
                    child: Card(
                      color: Get.theme.colorScheme.onPrimary,
                      child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.network(
                              model.payment.picUrl!,
                              width: 160,
                              height: 120,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                model.payment.name!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                        hintText: "Quét mã để thanh toán",
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
                            codeController.text = "";
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
                    onChanged: (value) {
                      model.setPaymentCode(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  });
}
