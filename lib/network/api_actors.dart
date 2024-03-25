import 'package:dio/dio.dart';
import '../model/actors_model.dart';

class ApiActors {
  late final int movieID;

  ApiActors({required this.movieID});

  // final URL =
  //     "https://api.themoviedb.org/3/movie/$movieID/credits?api_key=a140c1e45b5ef81ac4f15d1c0d6124be&language=es-MX";
  final dio = Dio();
  Future<List<ActorsModel>?> getActorsMovie() async {
    //print("Este es el ID de la película: $movieID");
    Response response = await dio.get(
        "https://api.themoviedb.org/3/movie/$movieID/credits?api_key=a140c1e45b5ef81ac4f15d1c0d6124be&language=es-MX");
    //print(response.statusCode);
    //print(response.statusMessage);
    if (response.statusCode == 200) {
      //print(response.data['cast']);
      final listActorsMap = response.data['cast'] as List;
      return listActorsMap.map((actor) => ActorsModel.fromMap(actor)).toList();
    }
    return null;
  }
}
