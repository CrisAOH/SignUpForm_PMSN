import 'package:dio/dio.dart';
import 'package:pmsn2024/model/details_model.dart';

class ApiDetails {
  late final int movieID;

  ApiDetails({required this.movieID});

  final dio = Dio();

  Future<DetailsModel?> getMovieDetails() async {
    Response response = await dio.get(
        "https://api.themoviedb.org/3/movie/$movieID?api_key=a140c1e45b5ef81ac4f15d1c0d6124be&language=es-MX");
    if (response.statusCode == 200) {
      return DetailsModel.fromMap(response.data);
    }
    return null;
  }
}
