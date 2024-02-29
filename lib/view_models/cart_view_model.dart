import 'package:get/get.dart';
import 'package:redis/redis.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/enums/status_enums.dart';
import 'package:smart_pos/models/account_model.dart';
import 'package:smart_pos/services/promotion_services.dart';

import '../enums/order_enum.dart';
import '../models/cart_model.dart';
import '../models/payment_provider.dart';
import '../models/promotion_model.dart';

class CartViewModel extends Model {
  CartModel cart = CartModel();
  AccountModel accountData = AccountModel();
  List<PromotionPointify>? promotions = [];
  PromotionServices promotionServices = PromotionServices();
  late ViewStatus status;
  List<PaymentProvider> listPayment = [
    PaymentProvider(
        name: "Tiền mặt",
        type: PaymentTypeEnums.CASH,
        picUrl:
            'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fcash.png?alt=media&token=42566a9d-b092-4e80-90dd-9313aeee081d'),
    PaymentProvider(
        name: "Momo",
        type: PaymentTypeEnums.MOMO,
        picUrl:
            'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fmomo.png?alt=media&token=d0d2e4f2-b035-4989-b04f-2ef55b9d0606'),
    PaymentProvider(
        name: "Ngân hàng",
        type: PaymentTypeEnums.BANKING,
        picUrl:
            'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fbanking.png?alt=media&token=f4dba580-bd73-433d-9b8c-ed8a79958ed9'),
    PaymentProvider(
        name: "Visa/Mastercard",
        type: PaymentTypeEnums.VISA,
        picUrl:
            'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fvisa-credit-card.png?alt=media&token=1cfb48ab-b957-47db-8f52-89da33d0fb39'),
    PaymentProvider(
        name: "Thẻ thành viên",
        type: PaymentTypeEnums.POINTIFY,
        picUrl:
            "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fpointify.jpg?alt=media&token=c1953b7c-23d4-4fb6-b866-ac13ae639a00")
  ];
  CartViewModel() {
    cart.productList = [];
    cart.promotionList = [];
    cart.paymentType = PaymentTypeEnums.CASH;
    cart.totalAmount = 0;
    cart.finalAmount = 0;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.promotionCode = null;
    cart.voucherCode = null;
    cart.orderType = DeliType().eatIn.type;
    cart.customerNumber = 1;
    status = ViewStatus.Completed;
  }

  // Future scanCustomer(String phone) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     customer = await accountData.scanCustomer(phone);
  //     await prepareOrder();
  //     notifyListeners();
  //     setState(ViewStatus.Completed);
  //   } catch (e) {
  //     setState(ViewStatus.Error, e.toString());
  //   }
  // }
  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }

  Future<void> addToCart(ProductList cartModel) async {
    cart.productList!.add(cartModel);
    countCartAmount();
    countCartQuantity();
    // await prepareOrder();
    notifyListeners();
  }

  Future<void> updateCart(ProductList cartModel, int cartIndex) async {
    cart.productList![cartIndex] = cartModel;
    countCartAmount();
    countCartQuantity();
    // await prepareOrder();
    notifyListeners();
  }

  void countCartAmount() {
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    for (ProductList item in cart.productList!) {
      cart.totalAmount = cart.totalAmount! + item.totalAmount!;
    }
    cart.finalAmount = cart.totalAmount! - cart.discountAmount!;
  }

  countCartQuantity() {
    num quantity = 0;
    for (ProductList item in cart.productList!) {
      quantity = quantity + item.quantity!;
    }
    return quantity;
  }

  bool isPromotionApplied(String code) {
    return cart.promotionCode == code;
  }

  void clearCartData() {
    cart.paymentType = PaymentTypeEnums.CASH;
    cart.orderType = DeliType().eatIn.type;
    cart.customerNumber = 1;
    cart.productList = [];
    cart.finalAmount = 0;
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    cart.promotionList = [];
    cart.voucherCode = null;
    cart.promotionCode = null;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.customerName = null;

    notifyListeners();
  }

  Future getListPromotion() async {
    try {
      promotions = await promotionServices.getListPromotionOfStore();
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  bool isPromotionExist(String code) {
    return cart.promotionCode == code;
  }

  Future<void> removePromotion() async {
    cart.promotionCode = null;
    cart.voucherCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  Future<void> selectPromotion(String code) async {
    cart.promotionCode = code;
    cart.voucherCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  Future<void> removeVoucher() async {
    cart.voucherCode = null;
    cart.promotionCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  void setCartNote(String note) {
    cart.notes = note;
    notifyListeners();
  }

  // Future<void> prepareOrder() async {
  //   cart.paymentType = Get.find<OrderViewModel>().selectedPaymentMethod!.type!;
  //   cart.discountAmount = 0;
  //   cart.bonusPoint = 0;
  //   cart.customerId = customer?.id;
  //   cart.customerName = customer?.fullName;
  //   cart.finalAmount = cart.totalAmount;
  //   for (var element in cart.productList!) {
  //     element.discount = 0;
  //     element.finalAmount = element.totalAmount;
  //     element.promotionCodeApplied = null;
  //   }
  //   cart.promotionList!.clear();
  //   if (cart.promotionCode == null &&
  //       cart.voucherCode == null &&
  //       cart.customerId == null) {
  //     hideDialog();
  //     return;
  //   }
  //   Account? userInfo = await getUserInfo();
  //   await api.prepareOrder(cart, userInfo!.storeId).then((value) => {
  //         cart = value,
  //       });
  //   hideDialog();
  // }

  // Future<void> createOrder() async {
  //   bool res = false;
  //   for (var item in cart.productList!) {
  //     if (item.attributes != null) {
  //       for (var attribute in item.attributes!) {
  //         item.note = (attribute.value != null && attribute.value!.isNotEmpty)
  //             ? "${attribute.name} ${attribute.value}, ${item.note}"
  //             : item.note;
  //       }
  //     }
  //   }
  //   await Get.find<OrderViewModel>().placeOrder(cart).then((value) => {
  //         res = value,
  //         if (res == true) {clearCartData()}
  //       });
  // }
}
