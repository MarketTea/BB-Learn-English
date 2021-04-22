class Source {
  final String id;
  final String name;

  Source({this.id, this.name});

  // let's create the factory function to map the json

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name']
    );
  }
}