import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/view/login.dart';
import 'package:easynema/view/snacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../models/user_model.dart';
import '../widgets/Widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUserModel = UserModel();

  Stream<List<MovieModel>> allMovies = MovieModel.getMovies();
  Stream<List<MovieModel>> allMovies2 = MovieModel.getMovies();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection(
          'users',
        )
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedUserModel = UserModel.fromJson(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff21242C),
        appBar: AppBar(
          backgroundColor: const Color(0xff21242C),
          //leading: const Icon(Icons.menu, color: Colors.black, size: 30),
          elevation: 0,
          actions: [
            InkWell(
                onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Snacks(
                            title: 'Tienda',
                            userModel: loggedUserModel,
                          ),
                        ),
                      )
                    },
                child: const Icon(Icons.shopping_cart_rounded, size: 30)),
            const SizedBox(width: 10),
            InkWell(
                onTap: () => logout(context),
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://picsum.photos/200/300/?random',
                      ),
                    ),
                  ),
                )),
            const SizedBox(width: 15),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            const _ItemTitle(title: 'Tráilers'),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 20),
              height: 200,
              child: StreamBuilder<List<MovieModel>>(
                  stream: allMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final trailers = snapshot.data!;
                      return MovieModel.buildTrailers(context, trailers);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            const SizedBox(height: 20),
            const _ItemTitle(title: 'Estrenos'),
            Container(
              margin: const EdgeInsets.only(left: 20),
              height: 280,
              child: StreamBuilder<List<MovieModel>>(
                stream: allMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final movies = snapshot.data!;
                    return MovieModel.buildMovies(
                        context, movies, loggedUserModel);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const _ItemTitle(title: 'Próximamente'),
            Container(
                margin: const EdgeInsets.only(left: 20),
                height: 280,
                child: StreamBuilder<List<MovieModel>>(
                  stream: allMovies2,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final movies = snapshot.data!;
                      return MovieModel.buildUpcoming(
                          context, movies, loggedUserModel);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
          ],
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Loginpagina(),
      ),
    );
  }
}

class _ItemTitle extends StatelessWidget {
  final String title;

  const _ItemTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextBrand(
                text: title,
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500),
            const TextBrand(text: '', color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
