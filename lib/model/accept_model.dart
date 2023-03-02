// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AcceptOrder {
  var id;
  bool? isSelected = false;
  String? message;
  String? orderId;
  String? sHLength;
  String? sHWidth;
  String? sHHeight;
  String? sHWeight;
  String? boxCount;
  String? totalPrice;
  String? paymentMethod;
  String? pickUpDate;
  String? dropOffDate;
  String? pickUp;
  String? dropOff;
  String? reference;
  String? status;
  String? cODAmount;
  String? returned;
  String? invoiced;
  String? discountValue;
  String? createdAt;
  String? updatedAt;
  User? user;
  Sender? sender;
  Receiver? receiver;
  List<String>? items;
  List<String>? history;
  Package? package;
  String? driver;
  String? isDeposit;

  var deliveryPrice;
  double? distance = 0.0;
  var total_Price;

  AcceptOrder({
    this.id,
    this.isSelected,
    this.distance,
    this.message,
    this.orderId,
    this.sHLength,
    this.sHWidth,
    this.sHHeight,
    this.sHWeight,
    this.boxCount,
    this.totalPrice,
    this.paymentMethod,
    this.pickUpDate,
    this.dropOffDate,
    this.pickUp,
    this.dropOff,
    this.reference,
    this.status,
    this.cODAmount,
    this.returned,
    this.invoiced,
    this.discountValue,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.sender,
    this.receiver,
    this.items,
    this.history,
    this.package,
    this.driver,
    this.isDeposit,
    this.deliveryPrice,
    this.total_Price,
  });

  AcceptOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    message = json['message'] ?? '';
    orderId = json['order_id'] ?? '';
    sHLength = json['SH_length'] ?? '';
    sHWidth = json['SH_width'] ?? '';
    sHHeight = json['SH_height'] ?? '';
    sHWeight = json['SH_weight'] ?? '';
    boxCount = json['boxCount'] ?? '';
    totalPrice = json['totalPrice'] ?? '';
    paymentMethod = json['paymentMethod'] ?? '';
    pickUpDate = json['pickUp_date'] ?? '';
    dropOffDate = json['dropOff_date'] ?? '';
    pickUp = json['pickUp'] ?? '';
    dropOff = json['dropOff'] ?? '';
    reference = json['reference'] ?? '';
    status = json['status'] ?? '';
    cODAmount = json['COD_amount'] ?? '';
    returned = json['returned'] ?? '';
    invoiced = json['invoiced'] ?? '';
    discountValue = json['discountValue'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    // user = json['user'] != null ? User.fromJson(json['user']) : null;
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
    // if (json['items'] != null) {
    //   items = <String>[];
    // json['items'].forEach((v) {
    //   items!.add(new Null.fromJson(v));
    // });
    // }
    // if (json['history'] != null) {
    //   history = <String>[];
    //   // json['history'].forEach((v) {
    //   //   history!.add(new Null.fromJson(v));
    //   // });
    // }
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
    // driver = json['driver'];
    // isDeposit = json['isDeposit'];
    deliveryPrice = json['delivery_price'];

    total_Price = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['order_id'] = orderId;
    data['SH_length'] = sHLength;
    data['SH_width'] = sHWidth;
    data['SH_height'] = sHHeight;
    data['SH_weight'] = sHWeight;
    data['boxCount'] = boxCount;
    data['totalPrice'] = totalPrice;
    data['paymentMethod'] = paymentMethod;
    data['pickUp_date'] = pickUpDate;
    data['dropOff_date'] = dropOffDate;
    data['pickUp'] = pickUp;
    data['dropOff'] = dropOff;
    data['reference'] = reference;
    data['status'] = status;
    data['COD_amount'] = cODAmount;
    data['returned'] = returned;
    data['invoiced'] = invoiced;
    data['discountValue'] = discountValue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    if (items != null) {
      data['items'];
    }
    if (history != null) {
      data['history'];
    }
    if (package != null) {
      data['package'] = package!.toJson();
    }
    data['driver'] = driver;
    data['isDeposit'] = isDeposit;
    data['delivery_price'] = deliveryPrice;
    data['total_price'] = total_Price;
    return data;
  }
}

class User {
  String? email;
  String? phoneNumber;
  String? name;
  String? role;
  String? status;

  User({this.email, this.phoneNumber, this.name, this.role, this.status});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    name = json['name'] ?? '';
    role = json['role'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['role'] = role;
    data['status'] = status;
    return data;
  }
}

class Sender {
  String? name;
  String? phoneNumber;
  String? email;
  String? country;
  String? city;
  String? street;
  String? area;
  String? buildingNumber;
  String? role;
  String? lat;
  String? lng;
  LatLng? location;

  Sender(
      {this.name,
      this.phoneNumber,
      this.email,
      this.country,
      this.city,
      this.street,
      this.area,
      this.buildingNumber,
      this.role,
      this.lat,
      this.location,
      this.lng});

  Sender.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    country = json['country'] ?? '';
    city = json['city'] ?? '';
    street = json['street'] ?? '';
    area = json['area'] ?? '';
    buildingNumber = json['buildingNumber'] ?? '';
    role = json['role'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    location = LatLng(double.parse(lat!), double.parse(lng!));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['country'] = country;
    data['city'] = city;
    data['street'] = street;
    data['area'] = area;
    data['buildingNumber'] = buildingNumber;
    data['role'] = role;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Receiver {
  int? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? country;
  String? city;
  String? street;
  String? area;
  String? buildingNumber;
  String? role;
  String? lat;
  String? lng;

  Receiver(
      {this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.country,
      this.city,
      this.street,
      this.area,
      this.buildingNumber,
      this.role,
      this.lat,
      this.lng});

  Receiver.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'];
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    country = json['country'] ?? '';
    city = json['city'] ?? '';
    street = json['street'] ?? '';
    area = json['area'];
    buildingNumber = json['buildingNumber'] ?? '';
    role = json['role'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['country'] = country;
    data['city'] = city;
    data['street'] = street;
    data['area'] = area;
    data['buildingNumber'] = buildingNumber;
    data['role'] = role;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Package {
  String? name;
  String? description;
  String? status;
  String? basePrice;
  String? priceKG;
  String? kGIncluded;
  Service? service;

  Package(
      {this.name,
      this.description,
      this.status,
      this.basePrice,
      this.priceKG,
      this.kGIncluded,
      this.service});

  Package.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    status = json['status'] ?? '';
    basePrice = json['basePrice'] ?? '';
    priceKG = json['price_KG'] ?? '';
    kGIncluded = json['KG_included'] ?? '';
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['basePrice'] = basePrice;
    data['price_KG'] = priceKG;
    data['KG_included'] = kGIncluded;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class Service {
  String? name;
  String? code;
  String? description;
  String? status;

  Service({this.name, this.code, this.description, this.status});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    code = json['code'] ?? '';
    description = json['description'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
