class ActorsModel {
  //bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  //double? popularity;
  String? profilePath;
  //int? castId;
  String? character;
  //String? creditId;
  //int? order;

  ActorsModel({
    //this.adult,
    //this.gender,
    this.id,
    //this.knownForDepartment,
    this.name,
    this.originalName,
    //this.popularity,
    this.profilePath,
    //this.castId,
    this.character,
    //this.creditId,
    //this.order,
  });

  factory ActorsModel.fromMap(Map<String, dynamic> actor) {
    return ActorsModel(
      id: actor['id'],
      //gender: actor['gender'],
      //knownForDepartment: actor['knownForDepartment'],
      name: actor['name'],
      originalName: actor['original_name'],
      profilePath: actor['profile_path'],
      character: actor['character'],
    );
  }
}
