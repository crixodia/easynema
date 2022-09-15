part of 'cinema_bloc.dart';

@immutable
class CinemaState {
  final String nameMovie;
  final String imageMovie;
  final String date;
  final String time;
  final List<String> selectedSeats;

  CinemaState(
      {this.nameMovie = '',
      this.imageMovie = '',
      this.date = '0',
      this.time = '00',
      List<String>? selectedSeats})
      : selectedSeats = selectedSeats ?? [];

  CinemaState copyWith(
          {String? date,
          String? time,
          List<String>? selectedSeats,
          String? nameMovie,
          String? imageMovie}) =>
      CinemaState(
          nameMovie: nameMovie ?? this.nameMovie,
          imageMovie: imageMovie ?? this.imageMovie,
          date: date ?? this.date,
          time: time ?? this.time,
          selectedSeats: selectedSeats ?? this.selectedSeats);

  Map<String, int> selectedSeatsToMap() {
    Map<String, int> rselectedSeats = {};
    for (var seat in selectedSeats) {
      String charPart = '';
      String numPart = '';
      for (int i = 0; i < seat.length; i++) {
        if (double.tryParse(seat[i]) != null) {
          // Is numeric?
          numPart += seat[i];
        } else {
          charPart += seat[i];
        }
      }
      rselectedSeats[charPart] = int.parse(numPart);
    }
    return rselectedSeats;
  }
}
