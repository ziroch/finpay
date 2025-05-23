// lib/pages/reservation_management_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/Alumno/reservation.dart';
import '../model/Alumno/car.dart';

class ReservationManagementPage extends StatefulWidget {
  @override
  _ReservationManagementPageState createState() =>
      _ReservationManagementPageState();
}

class _ReservationManagementPageState extends State<ReservationManagementPage> {
  List<Reservation> reservations = [];
  String? filterDate;
  String? filterClientId;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reservas.json');
    if (file.existsSync()) {
      final data = json.decode(await file.readAsString());
      setState(() {
        reservations =
            (data as List).map((e) => Reservation.fromJson(e)).toList();
      });
    }
  }

  Future<void> _deleteReservation(int index) async {
    reservations.removeAt(index);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reservas.json');
    await file.writeAsString(
        json.encode(reservations.map((r) => r.toJson()).toList()));
    setState(() {});
  }

  List<Reservation> _filteredReservations() {
    return reservations.where((r) {
      final matchesDate = filterDate == null || r.fecha.startsWith(filterDate!);
      final matchesClient =
          filterClientId == null || r.auto.clienteId == filterClientId;
      return matchesDate && matchesClient;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReservations();
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Reservas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration:
                  InputDecoration(labelText: 'Filtrar por fecha (YYYY-MM-DD)'),
              onChanged: (value) => setState(() => filterDate = value),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Filtrar por clienteId'),
              onChanged: (value) => setState(() => filterClientId = value),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final r = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          '${r.auto} -> ${r.estacionamiento} (${r.horaInicio} - ${r.horaFin})'),
                      subtitle: Text(
                          'Fecha: ${r.fecha}\nCliente: ${r.auto.clienteId}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReservation(index),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
