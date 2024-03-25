import 'package:dio/dio.dart';

class ApiFavourites {
  final String apiKey = 'a140c1e45b5ef81ac4f15d1c0d6124be';
  final String sessionID = 'f85c570450bc20d4fd219e05ab5803e64293edbd';

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/account/21063478/favorite/movies',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionID,
          'language': 'es-MX'
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> favoriteMovies =
            List<Map<String, dynamic>>.from(response.data['results']);
        return favoriteMovies;
      } else {
        throw Exception('Failed to retrieve favorite movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21063478/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionID,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200) {
        print('Película agregada a favoritos');
      } else {
        print('Película agregada a favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21063478/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionID,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200) {
        print('Película eliminada de favoritos');
      } else {
        throw Exception('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
