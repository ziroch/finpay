import 'car.dart';

class Reservation {
  final Car auto;
  final String estacionamiento;
  final String horaInicio;
  final String horaFin;
  final String fecha;

  Reservation({
    required this.auto,
    required this.estacionamiento,
    required this.horaInicio,
    required this.horaFin,
    required this.fecha,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      auto: Car.fromJson(json['auto']),
      estacionamiento: json['estacionamiento'],
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() => {
        'auto': auto.toJson(),
        'estacionamiento': estacionamiento,
        'horaInicio': horaInicio,
        'horaFin': horaFin,
        'fecha': fecha,
      };
}
