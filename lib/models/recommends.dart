class RecommendItemModel {

  String title;
  // List<Map<String, String>> main;
  List<dynamic> main;
  // List<Map<String, String>> alternate;
  List<dynamic> alternate;

  RecommendItemModel(
      this.title,
      this.main,
      this.alternate,
      );

  factory RecommendItemModel.fromJson(dynamic json) {
    return RecommendItemModel(
      json['title'] ?? '',
      json['main'] ?? [],
      json['alternate'] ?? []
    );
  }
}
