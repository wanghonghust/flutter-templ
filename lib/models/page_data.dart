class PageData<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  PageData(
      {required this.count,
      required this.next,
      required this.previous,
      required this.results
      });

  factory PageData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PageData(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }

}
