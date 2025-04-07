class MealSetting {
  bool showIftarLink;

  MealSetting({this.showIftarLink=false});

  MealSetting.fromJson(Map<String, dynamic> json) {
    showIftarLink = json['show_iftar_link']??false;
  }
}