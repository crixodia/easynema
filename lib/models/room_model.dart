import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/blocs/cinema_bloc.dart';

class RoomModel {
  final List<dynamic> rowSeats;
  final Map<dynamic, dynamic> usedSeats;
  final String rid;
  final String name;

  RoomModel(
      {required this.rowSeats,
      required this.rid,
      required this.usedSeats,
      required this.name});

  static RoomModel fromJson(Map<String, dynamic> json) => RoomModel(
        rowSeats: json['seats'],
        rid: json['rid'],
        usedSeats: json['used_seats'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'seats': rowSeats,
        'rid': rid,
        'used_seats': usedSeats,
      };

  void saveRoom(Map<String, int> currentSeats) {
    currentSeats.forEach((key, value) {
      usedSeats[key].removeWhere((element) => element == value);
    });
    // Iden
    FirebaseFirestore.instance.collection('rooms').doc(rid).update(toJson());
  }

  void addAvailable(String row, int seat) {
    if (!usedSeats[row].contains(seat)) {
      usedSeats[row].add(seat);
      FirebaseFirestore.instance.collection('rooms').doc(rid).update(toJson());
    }
  }

  static void resetSeats(RoomModel room, Map<String, int> selectedSeats) {
    selectedSeats.forEach((key, value) {
      room.addAvailable(key, value);
    });
  }

  static Stream<RoomModel> getRoomByRef(String rid) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(rid)
        .snapshots()
        .map((snapshot) => RoomModel.fromJson(snapshot.data()!));
  }

  static Stream<List<RoomModel>> getRooms() {
    return FirebaseFirestore.instance.collection('rooms').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => RoomModel.fromJson(doc.data()))
            .toList());
  }
}

class Room {
  final String rowSeat;
  final int seats;
  final List<int> usedSeats;
  final String rid;

  Room(
      {required this.rowSeat,
      required this.seats,
      required this.usedSeats,
      required this.rid});

  static List<Room> listChairs(RoomModel roomModel) {
    List<Room> rooms = [];
    SplayTreeMap sortedMap = SplayTreeMap.from(roomModel.usedSeats);
    for (var i = 0; i < roomModel.rowSeats.length; i++) {
      rooms.add(Room(
          rowSeat: sortedMap.keys.toList()[i],
          seats: roomModel.rowSeats[i],
          usedSeats: List<int>.from(sortedMap.values.toList()[i]),
          rid: roomModel.rid));
    }
    return rooms;
  }
}
