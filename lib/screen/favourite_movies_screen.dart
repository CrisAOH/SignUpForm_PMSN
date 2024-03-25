import 'package:flutter/material.dart';
import 'package:pmsn2024/animations/custom_page_transition_animation.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_favourite.dart';
import 'package:pmsn2024/screen/detail_movie_screen.dart';
import 'package:pmsn2024/widgets/movie_list_item.dart';

class FavouriteMoviesScreen extends StatefulWidget {
  const FavouriteMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteMoviesScreen> createState() => _FavouriteMoviesScreenState();
}

class _FavouriteMoviesScreenState extends State<FavouriteMoviesScreen> {
  final ApiFavourites apiFavourites = ApiFavourites();
  late Future<List<Map<String, dynamic>>> _favouriteMoviesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavouriteMovies();
  }

  Future<void> _loadFavouriteMovies() async {
    setState(() {
      _favouriteMoviesFuture = apiFavourites.getFavoriteMovies();
    });
  }

  Future<void> _updateFavouriteMovies() async {
    _loadFavouriteMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent, //Colors.blueGrey[800],
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF000B49),
            margin: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Text(
                "Explore",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 90.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge,
                  children: [
                    TextSpan(
                      text: "Favourite ",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(text: "Movies")
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _favouriteMoviesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final favouriteMovies =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Column(
                      children: favouriteMovies.map<Widget>((movie) {
                        //print("Esto es el objeto movie: $movie");
                        return InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              CustomPageTransition(
                                DetailMovieScreen(
                                  popularModel: PopularModel.fromMap(movie),
                                ),
                              ),
                            );
                            // Navigator.of(context).push(
                            //   CustomPageTransition(
                            //     DetailMovieScreen(
                            //       popularModel: PopularModel.fromMap(movie),
                            //     ),
                            //   ),
                            // );
                            print("Esto es result: $result");
                            if (result != null && result is bool && result) {
                              _updateFavouriteMovies();
                            }
                          },
                          child: MovieListItem(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                            name: movie['title'],
                            information:
                                '${movie['release_date']} | ${movie['original_language']}',
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Ocurrió un error.'));
                  } else {
                    return const Center(
                        child: Text('No hay datos disponibles.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();

    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
