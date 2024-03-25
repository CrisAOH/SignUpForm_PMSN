import 'package:flutter/material.dart';
import 'package:pmsn2024/model/actors_model.dart';
import 'package:pmsn2024/model/details_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/trailer_model.dart';
import 'package:pmsn2024/network/api_actors.dart';
import 'package:pmsn2024/network/api_details.dart';
import 'package:pmsn2024/network/api_favourite.dart';
import 'package:pmsn2024/network/api_trailer.dart';
import 'package:pmsn2024/widgets/cast_cards.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pmsn2024/widgets/rating_circle.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  final PopularModel popularModel;
  const DetailMovieScreen({Key? key, required this.popularModel /*super.key*/});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  ApiActors? apiActors;
  ApiTrailer? apiTrailer;
  ApiDetails? apiDetails;
  DetailsModel? _detailsModel;
  bool isFavorite = false;
  final ApiFavourites apiFavourites = ApiFavourites();
  Key favouriteKey = UniqueKey();
  YoutubePlayerController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiActors = ApiActors(movieID: widget.popularModel.id!);
    apiTrailer = ApiTrailer(movieID: widget.popularModel.id!);
    apiDetails = ApiDetails(movieID: widget.popularModel.id!);
    _fetchTrailerKey();
    //_trailerFuture = apiTrailer!.getTrailerMovie(widget.popularModel.id!);
    _checkIsFavorite();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    DetailsModel? details = await apiDetails!.getMovieDetails();
    if (details != null) {
      setState(() {
        _detailsModel = details;
      });
    } else {
      print(
          "Error al obtener los detalles"); // Maneja el caso en que no se pudieron obtener los detalles
    }
  }

  Future<void> _fetchTrailerKey() async {
    final trailers = await apiTrailer!.getTrailerMovie();
    if (trailers != null && trailers.isNotEmpty) {
      // Utiliza firstWhere para encontrar el primer trailer cuyo tipo sea "trailer"
      final trailerKey = trailers
          .firstWhere(
            (trailer) => trailer.type == "Trailer",
            orElse: () =>
                TrailerModel(), // Retorna null si no se encuentra ningún trailer con el tipo "trailer"
          )
          ?.key;

      if (trailerKey != null) {
        _controller = YoutubePlayerController(
          initialVideoId: trailerKey,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
    // final trailers = await apiTrailer!.getTrailerMovie();
    // if (trailers != null && trailers.isNotEmpty) {
    //   final trailerKey = trailers.first
    //       .key; // Asume que el primer trailer es el que quieres reproducir
    //   _controller = YoutubePlayerController(
    //     initialVideoId: trailerKey!,
    //     flags: YoutubePlayerFlags(
    //       autoPlay: true,
    //       mute: false,
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    final popularModel = widget.popularModel;
    try {
      if (isFavorite) {
        await apiFavourites.removeFromFavorites(popularModel.id!);
      } else {
        await apiFavourites.addToFavorites(popularModel.id!);
      }

      _checkIsFavorite();

      setState(() {
        favouriteKey = UniqueKey();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _checkIsFavorite() async {
    final popularModel = widget.popularModel;
    try {
      final favoriteMovies = await apiFavourites.getFavoriteMovies();
      setState(() {
        isFavorite =
            favoriteMovies.any((movie) => movie['id'] == popularModel.id);
      });
    } catch (e) {
      print('Error al verificar si la película está en favoritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;*/
    final popularModel = widget.popularModel;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ), //const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            key: favouriteKey,
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ..._buildBackground(context, popularModel),
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(
                  //   height: AppBar().preferredSize.height,
                  // ),
                  _buildMovieInformation(context, popularModel, _detailsModel!),
                  Text(
                    "Trailer",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          height: 1.75,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (_controller != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 250,
                        width: 300,
                        child: YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            print('Player is ready.');
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ), //Text(popularModel.title!),
    );
  }

  // Padding _buildActions(BuildContext context) {
  //   return const Padding(
  //     padding: EdgeInsets.all(20.0),
  //   );
  //   //isLoading ? CircularProgressIndicator() : _controller != null ? YoutubePlayer(controller: _controller, showVideoProgressIndicator: true,):Text("No se encontró ningún trailer");,
  // }

  Padding _buildMovieInformation(BuildContext context,
      PopularModel popularModel, DetailsModel? detailsModel) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            popularModel.title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${popularModel.releaseDate} | ${popularModel.originalLanguage} | ${detailsModel?.runtime ?? 'Desconocido'} minutos',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Géneros: ${detailsModel?.genres?.map((genre) => genre.name).join(", ") ?? 'Desconocido'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Productoras: ${detailsModel?.productionCompanies?.map((prod) => prod.name).join(", ") ?? 'Desconocido'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingCircle(rating: popularModel.voteAverage!),
          const SizedBox(
            height: 20,
          ),
          Text(
            popularModel.overview!,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 1.75,
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Cast",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  height: 1.75,
                  color: Colors.white,
                ),
          ),
          FutureBuilder(
            future: apiActors!.getActorsMovie(),
            builder: (context, AsyncSnapshot<List<ActorsModel>?> snapshot) {
              //print(snapshot);
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.zero,
                  height: 325,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.map<Widget>(
                      (actor) {
                        //print(actor.name);
                        return CastList(
                          imageUrl: actor.profilePath,
                          name: actor.name!,
                          character: actor.character!,
                        );
                      },
                    ).toList(),
                  ),
                );
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
    );
  }

  List<Widget> _buildBackground(context, popularModel) {
    return [
      Container(
        height: double.infinity,
        color: const Color(0xFF000B49),
      ),
      Image.network(
        'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}',
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        fit: BoxFit.cover,
      ),
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF000B49),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.5],
            ),
          ),
        ),
      ),
    ];
  }
}
