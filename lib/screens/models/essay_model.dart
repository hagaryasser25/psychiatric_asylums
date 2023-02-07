import 'package:flutter/cupertino.dart';

class Essay {
  Essay({
    String? id,
    String? code,
    String? title,
    String? essay,
    int? date,
  }) {
    _id = id;
    _code = code;
    _title = title;
    _essay = essay;
    _date = date;
  }

  Essay.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _title = json['title'];
    _essay = json['essay'];
     _date = json['date'];
  }

  String? _id;
  String? _code;
  String? _title;
  String? _essay;
  int? _date;

  String? get id => _id;
  String? get code => _code;
  String? get title => _title;
  String? get essay => _essay;
  int? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['title'] = _title;
    map['essay'] = _essay;
    map['date'] = _date;

    return map;
  }
}