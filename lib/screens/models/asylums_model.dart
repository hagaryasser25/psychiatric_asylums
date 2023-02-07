import 'package:flutter/cupertino.dart';

class Asylums {
  Asylums({
    String? id,
    String? code,
    String? name,
    String? imageUrl,
    String? governorate,
    String? address,
    String? phoneNumber,
    int? rating,
  }) {
    _id = id;
    _code = code;
    _name = name;
    _imageUrl = imageUrl;
    _governorate = governorate;
    _address = address;
    _phoneNumber = phoneNumber;
    _rating = rating;
  }

  Asylums.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _imageUrl = json['imageUrl'];
    _governorate = json['governorate'];
    _address = json['address'];
    _phoneNumber = json['phoneNumber'];
    _rating = json['rating'];
  }

  String? _id;
  String? _code;
  String? _name;
  String? _imageUrl;
  String? _governorate;
  String? _address;
  String? _phoneNumber;
  int? _rating;

  String? get id => _id;
  String? get code => _code;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  String? get governorate => _governorate;
  String? get address => _address;
  String? get phoneNumber => _phoneNumber;
  int? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    map['imageUrl'] = _imageUrl;
    map['governorate'] = _governorate;
    map['address'] = _address;
    map['phoneNumber'] = _phoneNumber;
    map['rating'] = _rating;

    return map;
  }
}
