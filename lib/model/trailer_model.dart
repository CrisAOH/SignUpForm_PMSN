class TrailerModel {
  // String iso6391;
  // String iso31661;
  // String name;
  String? key;
  // String site;
  // int size;
  String? type;
  // bool official;
  // String publishedAt;
  String? id;

  TrailerModel({
    // this.iso6391,
    // this.iso31661,
    // this.name,
    this.key,
    // this.site,
    // this.size,
    this.type,
    // this.official,
    // this.publishedAt,
    this.id,
  });

  factory TrailerModel.fromMap(Map<String, dynamic> trailer) {
    return TrailerModel(
      id: trailer['id'],
      key: trailer['key'],
      type: trailer['type'],
    );
  }
}
