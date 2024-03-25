//import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/popular_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=a140c1e45b5ef81ac4f15d1c0d6124be&language=es-MX&page=1";
  final dio = Dio();
  Future<List<PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(URL);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}
