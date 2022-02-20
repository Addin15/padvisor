class Advisor {
  String? name;
  List<dynamic>? cohorts;

  Advisor({
    this.name,
    this.cohorts,
  });

  Advisor.fromJson(String id, Map<String, dynamic> json)
      : name = json['name'],
        cohorts = json['cohorts'];
}
