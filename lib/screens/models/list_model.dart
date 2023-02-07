import 'package:flutter/cupertino.dart';

class BookingListV {
  BookingListV({
    String? id,
    String? userCode,
    String? asylumCode,
    String? asylumName,
    String? userName,
    String? status,
    int? date,
  }) {
    _id = id;
    _userCode = userCode;
    _asylumCode = asylumCode;
    _asylumName = asylumName;
    _userName = userName;
    _status = status;
    _date = date;
  }

  BookingListV.fromJson(dynamic json) {
    _id = json['id'];
    _userCode = json['userCode'];
    _asylumCode = json['asylumCode'];
    _asylumName = json['asylumName'];
    _userName = json['userName'];
    _status = json['status'];
     _date = json['date'];
  }

  String? _id;
  String? _userCode;
  String? _asylumCode;
  String? _asylumName;
  String? _userName;
  String? _status;
  int? _date;

  String? get id => _id;
  String? get userCode => _userCode;
  String? get asylumCode => _asylumCode;
  String? get asylumName => _asylumName;
  String? get userName => _userName;
  String? get status => _status;
  int? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userCode'] = _userCode;
    map['asylumCode'] = _asylumCode;
    map['asylumName'] = _asylumName;
    map['userName'] = _userName;
    map['status'] = _status;
    map['date'] = _date;

    return map;
  }
}