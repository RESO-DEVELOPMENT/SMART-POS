class CustomerInfoModel {
  String? id;
  String? brandId;
  String? phoneNumber;
  String? fullName;
  String? gender;
  String? email;
  String? memberLevelName;
  num? point;
  num? balance;

  CustomerInfoModel(
      {this.id,
      this.brandId,
      this.phoneNumber,
      this.fullName,
      this.gender,
      this.email,
      this.memberLevelName,
      this.point,
      this.balance});

  CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    gender = json['gender'];
    email = json['email'];
    memberLevelName = json['memberLevelName'];
    point = json['point'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['brandId'] = brandId;
    data['phoneNumber'] = phoneNumber;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['email'] = email;
    data['memberLevelName'] = memberLevelName;
    data['point'] = point;
    data['balance'] = balance;
    return data;
  }
}
