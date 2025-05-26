// lib/pages/car_parking_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/Alumno/car.dart';
import '../model/Alumno/reservation.dart';
import '../utils/Alumno/file_storage.dart';

class CarParkingPage extends StatefulWidget {
  @override
  _CarParkingPageState createState() => _CarParkingPageState();
}

class _CarParkingPageState extends State<CarParkingPage> {
  List<Car> cars = [];
  final List<String> parkingSpots = ["A1", "B2", "C3", "D4"];
  final List<String> times =
      List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  Car? selectedCar;
  String? selectedSpot;
  String? selectedStartTime;
  String? selectedEndTime;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final String response =
        await rootBundle.loadString('assets/data/autos.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      cars = data.map((json) => Car.fromJson(json)).toList();
    });
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
              final reservation = Reservation(
                auto: selectedCar!,
                estacionamiento: selectedSpot!,
                horaInicio: selectedStartTime!,
                horaFin: selectedEndTime!,
                fecha: DateTime.now().toIso8601String(),
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
                children: cars
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
              Text('Hora de inicio:', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: selectedStartTime,
                hint: Text('Seleccionar hora inicio'),
                items: times
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStartTime = val),
              ),
              Text('Hora de fin:', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: selectedEndTime,
                hint: Text('Seleccionar hora fin'),
                items: times
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => selectedEndTime = val),
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
