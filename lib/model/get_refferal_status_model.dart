class StatusModel {
  List<dynamic> all;
  List<dynamic> interested;
  List<dynamic> notInterested;
  Map<String, dynamic> counts;

  StatusModel({
    required this.all,
    required this.interested,
    required this.notInterested,
    required this.counts,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return StatusModel(
      all: data['all'] ?? [],
      interested: data['interested'] ?? [],
      notInterested: data['notInterested'] ?? [],
      counts: data['counts'] ?? {},
    );
  }
}