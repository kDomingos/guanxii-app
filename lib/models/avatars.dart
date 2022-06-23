class Tag {
  int id;
  String image;

  Tag(this.id, this.image);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['id'] as int, json['image'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id} , ${this.image} }';
  }
}
