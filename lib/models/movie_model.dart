import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/models/user_model.dart';
import 'package:easynema/view/details_movie.dart';
import 'package:easynema/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieModel {
  final String mid;
  final String title;
  final String synopsis;
  final String image;
  final String length;
  final String advisory;
  final String trailer;
  final List<dynamic> shows;
  final List<dynamic> persons;
  final double price;

  MovieModel({
    this.mid = '',
    required this.title,
    required this.synopsis,
    required this.image,
    required this.length,
    required this.advisory,
    required this.trailer,
    this.shows = const [],
    this.persons = const [],
    required this.price,
  });

  /// Creates a [MovieModel] from a [Map]
  static MovieModel fromJson(Map<String, dynamic> json) => MovieModel(
        mid: json['mid'],
        title: json['title'],
        synopsis: json['synopsis'],
        image: json['image'],
        length: json['length'],
        advisory: json['advisory'],
        trailer: json['trailer'],
        shows: json['shows'],
        persons: json['stars'],
        price: json['price'],
      );

  /// Gets all the movies from the Firestore Database and returns a [Stream]
  static Stream<List<MovieModel>> getMovies() {
    return FirebaseFirestore.instance.collection('movies').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => MovieModel.fromJson(doc.data()))
            .toList());
  }

  /// Creates a ListView of all current movies
  static ListView buildMovies(
      BuildContext context, List<MovieModel> movies, UserModel user) {
    List<Widget> widgets = [];
    for (var movie in movies) {
      if (movie.shows.isNotEmpty) {
        widgets.add(buildMovie(context, movie, user));
      }
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return widgets[index];
      },
    );
  }

  /// Creates a ListView of all the upcoming movies
  static ListView buildUpcoming(
      BuildContext context, List<MovieModel> movies, UserModel user) {
    List<Widget> widgets = [];
    for (var movie in movies) {
      if (movie.shows.isEmpty) {
        widgets.add(buildMovie(context, movie, user));
      }
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return widgets[index];
      },
    );
  }

  static Widget buildMovie(
          BuildContext context, MovieModel movie, UserModel userModel) =>
      InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    DetailsMoviePage(movieModel: movie, userModel: userModel))),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 15),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'movie-hero-${movie.mid}',
                child: Container(
                  height: 210,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(movie.image).image),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 160,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextBrand(
                      text: movie.title,
                      color: Colors.white,
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      );

  static Stream<List<MovieModel>> getTrailers(Stream<List<MovieModel>> movies) {
    // Return the shuffled list of movies.
    return movies.map((movies) {
      final shuffled = movies.toList();
      shuffled.shuffle();
      return shuffled;
    });
  }

  static ListView buildTrailers(
      BuildContext context, List<MovieModel> trailers) {
    List<Widget> widgets = [];
    for (var trailer in trailers) {
      widgets.add(buildTrailer(context, trailer));
    }
    widgets.shuffle();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return widgets[index];
      },
    );
  }

  static Widget buildTrailer(BuildContext context, MovieModel movie) => InkWell(
      onTap: () => {launchUrl(Uri.parse(movie.trailer))},
      child: Padding(
          padding:
              const EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 15),
          child: Stack(
            children: [
              Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(movie.image),
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(
                  width: 300,
                  child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                color: Colors.white.withOpacity(0.3),
                                child: const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 45),
                              )))))
            ],
          )));
}
