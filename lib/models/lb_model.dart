class LBModel {
  double? d15;
  List<String>? partId;
  double? d0to1;
  double? d1to4;
  double? d5to9;
  double? d10to14;
  double? d15up;

  LBModel(
      {this.d15,
      this.partId,
      this.d0to1,
      this.d1to4,
      this.d5to9,
      this.d10to14,
      this.d15up});

  LBModel.fromJson(Map<String, dynamic> json) {
    d15 = json['15'];
    partId = json['partId'].cast<String>();
    d0to1 = json['0to1'];
    d1to4 = json['1to4'];
    d5to9 = json['5to9'];
    d10to14 = json['10to14'];
    d15up = json['15up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['15'] = d15;
    data['partId'] = partId;
    data['0to1'] = d0to1;
    data['1to4'] = d1to4;
    data['5to9'] = d5to9;
    data['10to14'] = d10to14;
    data['15up'] = d15up;
    return data;
  }
}
