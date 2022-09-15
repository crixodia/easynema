import 'dart:ui';

import 'package:easynema/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cinema_bloc.dart';
import '../models/movie_model.dart';
import '../models/person_model.dart';
import '../models/user_model.dart';
import 'buy_ticket.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsMoviePage extends StatelessWidget {
  final MovieModel movieModel;
  final UserModel userModel;

  const DetailsMoviePage(
      {Key? key, required this.movieModel, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cinemaBloc = BlocProvider.of<CinemaBloc>(context);
    Stream<List<PersonModel>> allPersons = PersonModel.getPeople();

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: size.height,
              width: size.width,
              color: const Color(0xff21242C)),
          SizedBox(
            height: size.height * .6,
            width: size.width,
            child: Hero(
                tag: 'movie-hero-${movieModel.mid}',
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(movieModel.image))),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        const Color(0xff21242C),
                        const Color(0xff21242C).withOpacity(.8),
                        const Color(0xff21242C).withOpacity(.1),
                      ]),
                    ),
                  ),
                )),
          ),
          Positioned(
            top: 250,
            child: Column(
              children: [
                SizedBox(
                    height: 80,
                    width: size.width,
                    child: InkWell(
                      onTap: () {
                        _launchURL(movieModel.trailer);
                      },
                      child: Center(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              color: Colors.white.withOpacity(0.3),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 45)),
                        ),
                      )),
                    )),
                const SizedBox(height: 20.0),
                TextBrand(
                  text: movieModel.title,
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                Row(children: [
                  const Icon(Icons.watch_later_outlined, color: Colors.white),
                  TextBrand(
                      text: ' ${movieModel.length}   ', color: Colors.white70),
                  const Icon(Icons.child_care_outlined, color: Colors.white),
                  TextBrand(
                      text: ' ${movieModel.advisory}', color: Colors.white70),
                ]),
                const SizedBox(height: 25.0),
                /*const TextBrand(
                    text: 'Sinopsis',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                const SizedBox(height: 15.0),*/
                SizedBox(
                  width: size.width * .9,
                  child: Wrap(
                    children: [
                      TextBrand(
                          text: movieModel.synopsis,
                          color: Colors.white,
                          maxLines: 6,
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 200,
                        child: StreamBuilder<List<PersonModel>>(
                            stream: allPersons,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final persons = snapshot.data!;
                                return PersonModel.buildPeople(
                                    context, persons, movieModel.persons);
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 30,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white))),
          Positioned(
            left: 60,
            right: 60,
            bottom: 30,
            child: InkWell(
              onTap: () {
                // ADD TO BLOC
                cinemaBloc.add(
                    OnSelectMovieEvent(movieModel.title, movieModel.image));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BuyTicketPage(
                            movieModel: movieModel, userModel: userModel)));
              },
              child: movieModel.shows.isNotEmpty
                  ? Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: const TextBrand(
                          text: 'Comprar Entrada', fontWeight: FontWeight.bold),
                    )
                  : Container(height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlStr) async {
    final Uri url = Uri.parse(urlStr);
    if (!await launchUrl(url)) {
      throw 'No se pudo abrir $url';
    }
  }
}
