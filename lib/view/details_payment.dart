import 'package:easynema/models/room_model.dart';
import 'package:easynema/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../blocs/cinema_bloc.dart';

class DetailsPaymentPage extends StatelessWidget {
  final double price;
  final RoomModel room;
  const DetailsPaymentPage({Key? key, required this.price, required this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cinemabloc = BlocProvider.of<CinemaBloc>(context);
    ScreenshotController sc = ScreenshotController();

    return Scaffold(
        backgroundColor: const Color(0xff21242C),
        body: SafeArea(
          child: Screenshot(
            controller: sc,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: size.height * .3,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      cinemabloc.state.imageMovie))),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'FECHA',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  TextBrand(text: cinemabloc.state.date),
                                ],
                              ),
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'TICKETS',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  TextBrand(
                                      text:
                                          '${cinemabloc.state.selectedSeats.length}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'HORA',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  TextBrand(text: cinemabloc.state.time),
                                ],
                              ),
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'BUTACAS',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  Row(
                                    children: List.generate(
                                        cinemabloc.state.selectedSeats.length,
                                        (i) {
                                      return TextBrand(
                                          text:
                                              '${cinemabloc.state.selectedSeats[i]} ');
                                    }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'SALA',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  TextBrand(text: room.name),
                                ],
                              ),
                              Column(
                                children: [
                                  const TextBrand(
                                      text: 'TOTAL',
                                      color: Colors.grey,
                                      fontSize: 12),
                                  TextBrand(
                                      text: '\$${price.toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              31,
                              (index) => const TextBrand(
                                  text: '- ', color: Colors.grey)),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                            height: 200,
                            width: 200,
                            child: QrImage(
                              data:
                                  'DATE: ${cinemabloc.state.date} \nTIME: ${cinemabloc.state.time} \nSEATS: ${cinemabloc.state.selectedSeats.join(', ')} \nROOM: ${room.name} \nPRICE: ${price.toStringAsFixed(2)}',
                              version: QrVersions.auto,
                              size: 200,
                              gapless: false,
                            )),
                        const SizedBox(height: 10.0),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              sc.captureAndSave('/storage/emulated/0/Download',
                                  fileName:
                                      '${DateTime.now().microsecondsSinceEpoch}.png');

                              BlocProvider.of<CinemaBloc>(context)
                                  .seats
                                  .clear();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: const TextBrand(
                                  text: 'Descargar',
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: size.height * .501,
                    left: 15,
                    child: const Icon(Icons.circle, color: Color(0xff21242C))),
                Positioned(
                    top: size.height * .501,
                    right: 15,
                    child: const Icon(Icons.circle, color: Color(0xff21242C))),
              ],
            ),
          ),
        ));
  }
}
