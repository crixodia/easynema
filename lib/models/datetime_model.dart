import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cinema_bloc.dart';
import '../widgets/Widgets.dart';

class ShowModel {
  final List<dynamic> times; // List of maps
  final List<dynamic> rids;
  final dynamic sid;
  final String day;
  final int number;

  ShowModel({
    required this.times,
    required this.rids,
    this.sid,
    required this.day,
    required this.number,
  });

  static ShowModel fromJson(Map<String, dynamic> json) => ShowModel(
        times: json['times'],
        rids: json["rids"],
        sid: json["sid"],
        day: json["day"],
        number: json["number"],
      );

  static Stream<List<ShowModel>> getShowsByRef(List<dynamic> shows) {
    dynamic r = FirebaseFirestore.instance
        .collection('shows')
        .where('sid', whereIn: shows)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShowModel.fromJson(doc.data()))
            .toList());
    return r;
  }

  static ListView buildDates(
      BuildContext context, List<ShowModel> shows, changeData, RoomModel room) {
    List<Widget> widgets = [];
    for (var show in shows) {
      widgets.add(buildDate(context, show, changeData, room));
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

  static ListView buildTimes(
      BuildContext context, times, rids, changeRoom, RoomModel room) {
    List<Widget> widgets = [];

    for (int i = 0; i < times.length; i++) {
      widgets.add(buildTime(context, times[i], rids[i], changeRoom, room));
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

  static Widget buildDate(
          BuildContext context, dynamic show, changeData, RoomModel room) =>
      InkWell(
        onTap: () {
          RoomModel.resetSeats(room,
              BlocProvider.of<CinemaBloc>(context).state.selectedSeatsToMap());

          BlocProvider.of<CinemaBloc>(context)
              .add(OnSelectedDateEvent("${show.number}"));

          List<String> times = [];
          for (var time in show.times) {
            times.add("${time['hour']}:${time['min']}");
          }

          changeData(times, show.rids);

          BlocProvider.of<CinemaBloc>(context).seats.clear();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: BlocBuilder<CinemaBloc, CinemaState>(
            builder: (context, state) => Container(
              height: 100,
              width: 75,
              decoration: BoxDecoration(
                  color: state.date == "${show.number}"
                      ? Colors.amber
                      : const Color(0xff4A5660),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle,
                      color: const Color(0xff21242C).withOpacity(.8), size: 12),
                  const SizedBox(height: 10.0),
                  TextBrand(
                      text: "${show.day}", color: Colors.white, fontSize: 17),
                  const SizedBox(height: 5.0),
                  TextBrand(
                      text: "${show.number}",
                      color: Colors.white,
                      fontSize: 30),
                ],
              ),
            ),
          ),
        ),
      );

  static Widget buildTime(BuildContext context, String time, dynamic rid,
          changeRoom, RoomModel room) =>
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: InkWell(
          onTap: () {
            RoomModel.resetSeats(
                room,
                BlocProvider.of<CinemaBloc>(context)
                    .state
                    .selectedSeatsToMap());

            BlocProvider.of<CinemaBloc>(context).add(OnSelectedTimeEvent(time));
            changeRoom(RoomModel.getRoomByRef(rid.id));

            BlocProvider.of<CinemaBloc>(context).seats.clear();
          },
          child: BlocBuilder<CinemaBloc, CinemaState>(
            builder: (context, state) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                decoration: BoxDecoration(
                    color: state.time == time
                        ? Colors.amber
                        : const Color(0xff4D525A),
                    borderRadius: BorderRadius.circular(8.0)),
                child:
                    TextBrand(text: time, color: Colors.white, fontSize: 16)),
          ),
        ),
      );
}
