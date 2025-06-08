import 'sistema_reservas.dart';

class Reservation {
  final Auto auto;
  final String estacionamiento;
  final String horaInicio;
  final String horaFin;
  final String fecha;
  final double costoTotal;
  final String estado;
  final String id;

  Reservation({
    required this.auto,
    required this.estacionamiento,
    required this.horaInicio,
    required this.horaFin,
    required this.fecha,
    required this.costoTotal,
    required this.estado,
    required this.id,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    return Reservation(
      id: idValue?.toString() ?? '0',
      auto: Auto.fromJson(json['auto']),
      estacionamiento: json['estacionamiento'],
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
      fecha: json['fecha'],
      costoTotal: json['costoTotal'] ?? 0,
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() => {
        'auto': auto.toJson(),
        'estacionamiento': estacionamiento,
        'horaInicio': horaInicio,
        'horaFin': horaFin,
        'fecha': fecha,
        'costoTotal': costoTotal,
        'estado': estado,
        'id': id,
      };
}
