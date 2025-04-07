class AttendanceOverviewChartData {
  List<String> labels;
  List<double> valueForLabels;

  AttendanceOverviewChartData({this.labels, this.valueForLabels});

  AttendanceOverviewChartData.fromJson(Map<String, dynamic> json) {
    labels = json['Labels'].cast<String>();
    valueForLabels = json['ValueForLabels'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Labels'] = this.labels;
    data['ValueForLabels'] = this.valueForLabels;
    return data;
  }
}
