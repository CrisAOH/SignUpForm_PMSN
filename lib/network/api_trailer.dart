import 'package:dio/dio.dart';
import 'package:pmsn2024/model/trailer_model.dart';

class ApiTrailer {
  late final int movieID;

  ApiTrailer({required this.movieID});

  final dio = Dio();

  Future<List<TrailerModel>?> getTrailerMovie() async {
    Response response = await dio.get(
        "https://api.themoviedb.org/3/movie/$movieID/videos?api_key=a140c1e45b5ef81ac4f15d1c0d6124be&language=en-US");
    if (response.statusCode == 200) {
      final listTrailerMap = response.data['results'] as List;
      return listTrailerMap
          .map((trailer) => TrailerModel.fromMap(trailer))
          .toList();
    }
    return null;
  }
}
