import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/Widgets.dart';

class PersonModel {
  final String pid;
  final String image;
  final String name;

  PersonModel({
    this.pid = '',
    required this.image,
    required this.name,
  });

  static PersonModel fromJson(Map<String, dynamic> json) => PersonModel(
        pid: json['pid'],
        image: json['image'],
        name: json['name'],
      );

  static Stream<List<PersonModel>> getPeople() {
    return FirebaseFirestore.instance.collection('persons').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => PersonModel.fromJson(doc.data()))
            .toList());
  }

  static ListView buildPeople(
      BuildContext context, List<PersonModel> persons, List<dynamic> refs) {
    List<Widget> widgets = [];
    for (var person in persons) {
      for (var ref in refs) {
        if (ref.id == person.pid) {
          widgets.add(buildPerson(context, person));
        }
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

  static Widget buildPerson(BuildContext context, PersonModel person) =>
      InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'movie-hero-${person.pid}',
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(person.image).image),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 100,
                child: TextBrand(
                    text: person.name,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      );
}
