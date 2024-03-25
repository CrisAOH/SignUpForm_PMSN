import 'package:flutter/material.dart';
import 'package:pmsn2024/animations/custom_page_transition_animation.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/screen/detail_movie_screen.dart';
import 'package:pmsn2024/widgets/movie_list_item.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPopular = ApiPopular();
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
                      text: "Popular ",
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
              FutureBuilder(
                future: apiPopular!.getPopularMovie(),
                builder:
                    (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map<Widget>((movie) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            CustomPageTransition(
                              DetailMovieScreen(
                                popularModel: movie,
                              ),
                            ),
                          ),
                          /*Navigator.pushNamed(context, "/detail",
                              arguments: movie),*/
                          child: MovieListItem(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                            name: movie.title,
                            information:
                                '${movie.releaseDate} | ${movie.originalLanguage}',
                          ),
                        );
                      }).toList(),
                    );
                    // return Flexible(
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: snapshot.data!.length,
                    //     itemBuilder: (context, index) {
                    //       final movie = snapshot.data![index];
                    //       return InkWell(
                    //         onTap: () => Navigator.pushNamed(context, "/detail",
                    //             arguments: movie),
                    //         child: MovieListItem(
                    //             imageUrl:
                    //                 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                    //             name: movie.title,
                    //             information:
                    //                 '${movie.releaseDate} | ${movie.originalLanguage}'),
                    //       );
                    //       // return GestureDetector(
                    //       //   onTap: () => Navigator.pushNamed(context, "/detail",
                    //       //       arguments: snapshot.data![index]),
                    //       //   child: ClipRRect(
                    //       //     borderRadius: BorderRadius.circular(20),
                    //       //     child: FadeInImage(
                    //       //         placeholder:
                    //       //             const AssetImage('images/loading.gif'),
                    //       //         image: NetworkImage(
                    //       //             'https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}')),
                    //       //   ),
                    //       // );
                    //     },
                    //   ),
                    // );
                  } else {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Ocurrió un error.'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
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
