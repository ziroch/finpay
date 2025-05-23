import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:finpay/model/Alumno/reservation.dart';

class FileStorage {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/reservas.json';
  }

  static Future<void> saveReservation(Reservation reservation) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    List<Reservation> current = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      final List data = json.decode(content);
      current = data.map((e) => Reservation.fromJson(e)).toList();
    }

    current.add(reservation);
    await file
        .writeAsString(json.encode(current.map((e) => e.toJson()).toList()));
  }

  static Future<List<Reservation>> loadReservations() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final List data = json.decode(content);
      return data.map((e) => Reservation.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> deleteReservation(Reservation reservation) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!await file.exists()) return;

    final content = await file.readAsString();
    final List data = json.decode(content);
    final reservations = data.map((e) => Reservation.fromJson(e)).toList();

    reservations.removeWhere((r) =>
        r.auto.chapa == reservation.auto.chapa &&
        r.estacionamiento == reservation.estacionamiento &&
        r.horaInicio == reservation.horaInicio &&
        r.horaFin == reservation.horaFin &&
        r.fecha == reservation.fecha);

    await file.writeAsString(
        json.encode(reservations.map((e) => e.toJson()).toList()));
  }
}
