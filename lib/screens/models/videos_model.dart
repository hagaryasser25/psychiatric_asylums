class VideosV {
  VideosV({
      String? videoUrl, 
      String? title,
      String? id,
      

  }){
    _videoUrl = videoUrl;
    _title = title;
    _id = id;
   

  }

  VideosV.fromJson(dynamic json) {
    _videoUrl = json['videoUrl'];
    _title = json['title'];
    _id = json['id'];

  }
  String? _videoUrl;
  String? _title;
  String? _id;



  String? get videoUrl => _videoUrl;
  String? get title => _title;
  String? get id => _id;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['videoUrl'] = _videoUrl;
    map['title'] = _title;
    map['id'] = _id;
   
    return map;
  }

}