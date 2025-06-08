// lib/pages/car_parking_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/Alumno/sistema_reservas.dart';

//import '../model/Alumno/car.dart';
import '../model/Alumno/reservation.dart';
import '../utils/Alumno/file_storage.dart';
import '../utils/Alumno/auto_storage.dart';

class CarParkingPage extends StatefulWidget {
  final String clienteId;
  const CarParkingPage({Key? key, required this.clienteId}) : super(key: key);

  @override
  _CarParkingPageState createState() => _CarParkingPageState();
}

class _CarParkingPageState extends State<CarParkingPage> {
  List<Auto> auto = [];
  final List<String> parkingSpots = ["A1", "B2", "C3", "D4"];
  final List<String> times =
      List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  Auto? selectedCar;
  String? selectedSpot;
  String? selectedStartTime;
  String? selectedEndTime;
  int? totalCost;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final loadedCars = await AutoStorage.cargarAutos(widget.clienteId);
    print('Autos cargados: $loadedCars');
    setState(() {
      auto = loadedCars;
    });
  }

  void _calculateCost() {
    if (selectedStartTime != null && selectedEndTime != null) {
      final startHour = int.parse(selectedStartTime!.split(":")[0]);
      final endHour = int.parse(selectedEndTime!.split(":")[0]);
      int duration = endHour - startHour;
      if (duration < 0) duration += 24; // Considera cruce de medianoche
      setState(() {
        totalCost = duration * 30000;
      });
    }
  }

  void _confirmReservation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Reserva'),
        content: Text(
            '¿Confirmas la reserva del auto "${selectedCar.toString()}" en el lugar "$selectedSpot" de $selectedStartTime a $selectedEndTime?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Cargar reservas existentes
              List<Reservation> existingReservations =
                  await FileStorage.loadReservations();

              // Obtener el ID más alto
              int nextId = 1;

              if (existingReservations.isNotEmpty) {
                final ids = existingReservations
                    .map((r) => int.tryParse(r.id ?? '0') ?? 0)
                    .toList();

                final lastId =
                    ids.isNotEmpty ? ids.reduce((a, b) => a > b ? a : b) : 0;

                nextId = lastId + 1;
              }
              final reservation = Reservation(
                id: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(), // ID único simple
                auto: selectedCar!,
                estacionamiento: selectedSpot!,
                horaInicio: selectedStartTime!,
                horaFin: selectedEndTime!,
                fecha: DateTime.now().toIso8601String(),
                costoTotal: (totalCost ?? 0).toDouble(),
                estado: 'OCUPADO', // Estado inicial
              );
              await FileStorage.saveReservation(reservation);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reserva confirmada')),
              );
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _goToReservationManagement() {
    Navigator.pushNamed(context, '/reservations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva de Estacionamiento'),
        actions: [
          IconButton(
            icon: Icon(Icons.manage_search),
            onPressed: _goToReservationManagement,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecciona un auto:', style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 10,
                children: auto
                    .map((car) => ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCar = car;
                            });
                          },
                          child: Text(car.toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedCar == car ? Colors.blueAccent : null,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Text('Estacionamientos disponibles:',
                  style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 10,
                children: parkingSpots
                    .map((spot) => ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedSpot = spot;
                            });
                          },
                          child: Text(spot),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSpot == spot ? Colors.green : null,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hora de inicio:', style: TextStyle(fontSize: 18)),
                        DropdownButton<String>(
                          value: selectedStartTime,
                          hint: Text('Hora inicio'),
                          items: times
                              .map((t) =>
                                  DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => selectedStartTime = val);
                            _calculateCost();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hora de fin:', style: TextStyle(fontSize: 18)),
                        DropdownButton<String>(
                          value: selectedEndTime,
                          hint: Text('Hora fin'),
                          items: times
                              .map((t) =>
                                  DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => selectedEndTime = val);
                            _calculateCost();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              if (selectedCar != null &&
                  selectedSpot != null &&
                  selectedStartTime != null &&
                  selectedEndTime != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Auto seleccionado: ${selectedCar.toString()}',
                          style: TextStyle(fontSize: 16)),
                      Text('Estacionamiento seleccionado: $selectedSpot',
                          style: TextStyle(fontSize: 16)),
                      Text('Desde: $selectedStartTime',
                          style: TextStyle(fontSize: 16)),
                      Text('Hasta: $selectedEndTime',
                          style: TextStyle(fontSize: 16)),
                      if (totalCost != null)
                        Text('Costo estimado: $totalCost Gs',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _confirmReservation,
                        child: Text('Confirmar Reserva'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
