class HobbiesModel {
  final String hobbyName;
  final List<HobbyData> hobbyDataList;

  HobbiesModel({
    required this.hobbyName,
    required this.hobbyDataList,
  });

  HobbiesModel.fromJson(Map<String, dynamic> json)
      : hobbyName = json['hobbyName'],
        hobbyDataList = List<HobbyData>.from(json['hobbyList'].map((x) => HobbyData.fromJson(x)));
}

class HobbyData {
  final String link;
  final String hobbyName;

  HobbyData({
    required this.link,
    required this.hobbyName,
  });

  HobbyData.fromJson(Map<String, dynamic> json)
      : hobbyName = json['hobby'],
        link = json['image'];
}
