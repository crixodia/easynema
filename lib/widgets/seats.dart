import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cinema_bloc.dart';
import '../helpers/paint_chair.dart';
import '../models/room_model.dart';

class SeatsRow extends StatelessWidget {
  final int numSeats;
  final List<int> freeSeats;
  final String rowSeats;
  final String rid;
  final RoomModel roomModel;
  final dynamic changeSelectedSeats;
  final List<String> seatsToChange;

  const SeatsRow(
      {Key? key,
      required this.rowSeats,
      required this.numSeats,
      required this.freeSeats,
      required this.rid,
      required this.roomModel,
      required this.changeSelectedSeats,
      required this.seatsToChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cinemaBloc = BlocProvider.of<CinemaBloc>(context);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(numSeats, (i) {
          if (freeSeats.contains(i + 1) ||
              cinemaBloc.state.selectedSeats
                  .contains(rowSeats + (i + 1).toString())) {
            return InkWell(onTap: () {
              cinemaBloc.add(OnSelectedSeatsEvent(
                  '$rowSeats${i + 1}', changeSelectedSeats));
              roomModel.addAvailable(rowSeats, i + 1);
            }, child: BlocBuilder<CinemaBloc, CinemaState>(builder: (_, state) {
              roomModel.saveRoom(state.selectedSeatsToMap());
              if (!state.selectedSeats.contains('$rowSeats${i + 1}')) {
                if (state.selectedSeats.isNotEmpty) {
                  roomModel.addAvailable(rowSeats, i + 1);
                }
                return const PaintChair(color: Colors.white);
              }
              return const PaintChair(color: Colors.amber);
            }));
          }
          return const PaintChair();
        }),
      ),
    );
  }
}
