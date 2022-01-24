class Post {
  final String coordX1;
  final String coordY1;
  final String coordX2;
  final String coordY2;
  final String coordX3;
  final String coordY3;

  Post(
      {required this.coordX1,
      required this.coordY1,
      required this.coordX2,
      required this.coordY2,
      required this.coordX3,
      required this.coordY3});

  factory Post.fromJson(Map json) {
    return Post(
      coordX1: json['x1-coord'],
      coordY1: json['y1-coord'],
      coordX2: json['x2-coord'],
      coordY2: json['y2-coord'],
      coordX3: json['x3-coord'],
      coordY3: json['y3-coord'],
    );
  }

  Map toMap() {
    var map = new Map();
    map['x1-coord'] = coordX1;
    map['y1-coord'] = coordY1;
    map['x2-coord'] = coordX2;
    map['y2-coord'] = coordY2;
    map['x3-coord'] = coordX3;
    map['y3-coord'] = coordY3;

    return map;
  }
}
