class Exp {
  Exp({
      String? status, 
      String? name,
      String? id,
      String? result,
      

  }){
    _status = status;
    _name = name;
    _id = id;
    _result = result;
   

  }

  Exp.fromJson(dynamic json) {
    _status = json['status'];
    _name = json['name'];
    _id = json['id'];
    _result = json['result'];

  }
  String? _status;
  String? _name;
  String? _id;
  String? _result;



  String? get status => _status;
  String? get name => _name;
  String? get id => _id;
  String? get result => _result;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['name'] = _name;
    map['id'] = _id;
    map['result'] = _result;
   
    return map;
  }

}