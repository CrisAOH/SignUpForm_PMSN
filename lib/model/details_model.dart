class DetailsModel {
  List<Genre>? genres;
  int? id;
  List<ProductionCompany>? productionCompanies;
  int? runtime;
  String? status;

  DetailsModel({
    this.genres,
    this.id,
    this.productionCompanies,
    this.runtime,
    this.status,
  });

  factory DetailsModel.fromMap(Map<String, dynamic> detalles) {
    // List<dynamic>? genreList = detalles['genres'];
    // List<Genre>? genres = genreList != null
    //     ? genreList.map((genre) => Genre.fromMap(genre)).toList()
    //     : null;

    // List<dynamic>? productionCompaniesList = detalles['production_companies'];
    // List<ProductionCompany>? productionCompanies =
    //     productionCompaniesList != null
    //         ? productionCompaniesList
    //             .map((company) => ProductionCompany.fromMap(company))
    //             .toList()
    //         : null;

    // return DetailsModel(
    //   genres: genres,
    //   id: detalles['id'],
    //   productionCompanies: productionCompanies,
    //   runtime: detalles['runtime'],
    //   status: detalles['status'],
    // );
    return DetailsModel(
      genres: (detalles['genres'] as List<dynamic>?)
          ?.map((genre) => Genre.fromMap(genre))
          .toList(),
      id: detalles['id'],
      productionCompanies: (detalles['production_companies'] as List<dynamic>?)
          ?.map((company) => ProductionCompany.fromMap(company))
          .toList(),
      runtime: detalles['runtime'],
      status: detalles['status'],
    );
  }
}

class Genre {
  int? id;
  String? name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'],
      name: map['name'],
    );
  }
}

class ProductionCompany {
  int? id;
  String? name;

  ProductionCompany({
    this.id,
    this.name,
  });

  factory ProductionCompany.fromMap(Map<String, dynamic> map) {
    return ProductionCompany(
      id: map['id'],
      name: map['name'],
    );
  }
}
