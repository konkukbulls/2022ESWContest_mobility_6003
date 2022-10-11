class VideoModel{
  String? time, drivemediaurl, drivethumbnail, parkthumbnail, parkmediaurl, lat, lon;

  VideoModel({required this.time});

  VideoModel.fromJson(Map<String,dynamic> json)
  {
    time = json['time'];
    drivethumbnail = json['drivethumbnail'];
    drivemediaurl = json['drivemediaurl'];
    parkmediaurl = json['parkmediaurl'];
    parkthumbnail = json['parkthumbnail'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String,dynamic> toJson() {
    final Map<String,dynamic> data = <String,dynamic>{};
    data['time'] = time;
    data['drivethumbnail'] = drivethumbnail;
    data['parkthumbnail'] = parkthumbnail;
    data['drivemediaurl'] = drivemediaurl;
    data['parkmedaiurl'] = parkmediaurl;
    data['lat'] = lat;
    data['lon'] = lon;

    return data;
  }
}
