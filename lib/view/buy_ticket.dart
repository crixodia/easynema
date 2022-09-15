import 'dart:ui';

import 'package:easynema/models/invoice_model.dart';
import 'package:easynema/models/movie_model.dart';
import 'package:easynema/models/user_model.dart';
import 'package:easynema/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../blocs/cinema_bloc.dart';
import '../controllers/stripe_api.dart';
import '../helpers/painter.dart';
import '../models/room_model.dart';
import '../models/datetime_model.dart';
import '../widgets/seats.dart';
import 'checkout_page.dart';
import 'details_payment.dart';

class BuyTicketPage extends StatefulWidget {
  final MovieModel movieModel;
  final UserModel userModel;

  const BuyTicketPage(
      {Key? key, required this.movieModel, required this.userModel})
      : super(key: key);

  @override
  _BuyTicketPageState createState() =>
      _BuyTicketPageState(movieModel: movieModel, userModel: userModel);
}

class _BuyTicketPageState extends State<BuyTicketPage> {
  List<String> timesToChange = [];
  List<dynamic> ridsToChange = [];
  List<String> seatsToChange = [];

  Stream<RoomModel> roomToChange = const Stream<RoomModel>.empty();

  RoomModel room_tosend =
      RoomModel(name: '', rid: '', rowSeats: [], usedSeats: {});

  final MovieModel movieModel;
  final UserModel userModel;
  _BuyTicketPageState({required this.movieModel, required this.userModel})
      : super();

  void changeData(List<String> data, List<dynamic> rids) {
    setState(() {
      timesToChange = data;
      ridsToChange = rids;
    });
  }

  void changeRoom(Stream<RoomModel> room) {
    setState(() {
      roomToChange = room;
    });
  }

  void changeSelectedSeats(List<String> seats) {
    debugPrint(seats.toString());
    setState(() {
      seatsToChange = seats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final showModel =
        ShowModel.getShowsByRef(movieModel.shows.map((e) => e.id).toList());

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: size.height,
              width: size.width,
              color: const Color(0xff21242C)),
          Container(
            height: size.height * .7,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(movieModel.image))),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                  const Color(0xff21242C),
                  const Color(0xff21242C).withOpacity(.9),
                  const Color(0xff21242C).withOpacity(.1),
                ]),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Container(
                    color: const Color(0xff21242C).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 30,
              child: SizedBox(
                width: size.width,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        const SizedBox(width: 20.0),
                        TextBrand(
                            text: movieModel.title,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)
                      ],
                    )),
              )),
          Positioned(
              top: 100,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: 90,
                      width: size.width,
                      child: StreamBuilder<List<ShowModel>>(
                          stream: showModel,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final dates = snapshot.data!;
                              return ShowModel.buildDates(
                                  context, dates, changeData, room_tosend);
                            }
                            return Container();
                          }),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: 40,
                      width: size.width,
                      child: ShowModel.buildTimes(context, timesToChange,
                          ridsToChange, changeRoom, room_tosend),
                    ),
                    const SizedBox(height: 15.0),
                    const PainterScreenMovie(),
                    const TextBrand(
                        text: 'Pantalla',
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    const SizedBox(height: 40.0),
                    SizedBox(
                        height: 240,
                        width: size.width,
                        child: StreamBuilder<RoomModel>(
                            stream: roomToChange,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                room_tosend = snapshot.data!;
                                final room = Room.listChairs(snapshot.data!);
                                return Column(
                                  children: List.generate(room.length, (i) {
                                    var a = SeatsRow(
                                      numSeats: room[i].seats,
                                      freeSeats: room[i].usedSeats,
                                      rowSeats: room[i].rowSeat,
                                      rid: room[i].rid,
                                      roomModel: snapshot.data!,
                                      changeSelectedSeats: changeSelectedSeats,
                                      seatsToChange: seatsToChange,
                                    );
                                    return a;
                                  }),
                                );
                              } else {
                                return Container();
                              }
                            })),
                    const SizedBox(height: 10.0),
                    _ItemsDescription(size: size)
                  ],
                ),
              )),
          Positioned(
            left: 60,
            right: 60,
            bottom: 20,
            child: InkWell(
              onTap: () async {
                if (seatsToChange.isNotEmpty) {
                  // Open webview with stripe checkout and if the pop handler is successfull, open the payment page
                  Stripe? stripe = await Stripe.createCheckoutSession(
                      prices: [movieModel.price],
                      productNames: [movieModel.title],
                      quantities: [seatsToChange.length]);

                  // ignore: use_build_context_synchronously
                  final resultCheckout = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        stripe: stripe,
                      ),
                    ),
                  );

                  if (resultCheckout == 'success') {
                    // ignore: use_build_context_synchronously
                    final cbloc = BlocProvider.of<CinemaBloc>(context);
                    InvoiceModel im = InvoiceModel(
                        date: '${cbloc.state.date} ${cbloc.state.time}',
                        image: movieModel.image,
                        roomName: room_tosend.name,
                        seats: cbloc.state.selectedSeats,
                        title: movieModel.title,
                        total: movieModel.price * seatsToChange.length,
                        to: [userModel.email!],
                        qrData:
                            'DATE: ${cbloc.state.date} \nTIME: ${cbloc.state.time} \nSEATS: ${cbloc.state.selectedSeats.join(', ')} \nROOM: ${room_tosend.name} \nPRICE: ${(movieModel.price * seatsToChange.length).toStringAsFixed(2)}');
                    im.createInvoice();

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsPaymentPage(
                                price: movieModel.price * seatsToChange.length,
                                room: room_tosend)));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Se ha cancelado la compra",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "No ha seleccionado ninguna butaca",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0)),
                child: TextBrand(
                    text:
                        'Comprar Entrada \$${(movieModel.price * seatsToChange.length).toStringAsFixed(2)}',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsDescription extends StatelessWidget {
  const _ItemsDescription({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: const [
              Icon(Icons.circle, color: Colors.white, size: 10),
              SizedBox(width: 10.0),
              TextBrand(text: 'Disponible', fontSize: 20, color: Colors.white)
            ],
          ),
          Row(
            children: const [
              Icon(Icons.circle, color: Color(0xff4A5660), size: 10),
              SizedBox(width: 10.0),
              TextBrand(
                  text: 'Reservado', fontSize: 20, color: Color(0xff4A5660))
            ],
          ),
          Row(
            children: const [
              Icon(Icons.circle, color: Colors.amber, size: 10),
              SizedBox(width: 10.0),
              TextBrand(text: 'Ocupado', fontSize: 20, color: Colors.amber)
            ],
          ),
        ],
      ),
    );
  }
}
