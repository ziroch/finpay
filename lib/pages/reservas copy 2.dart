// lib/pages/car_parking_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../model/Alumno/sistema_reservas.dart';
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
  List<Map<String, dynamic>> pisos = [];
  List<Map<String, dynamic>> lugares = [];
  List<Map<String, dynamic>> lugaresDisponibles = [];
  List<Reservation> reservas = [];
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
    _loadPisosYLugares();
    _loadReservas();
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalLugaresFile() async {
    final path = await _getLocalPath();
    return File('$path/lugares.json');
  }

  Future<void> _loadCars() async {
    final loadedCars = await AutoStorage.cargarAutos(widget.clienteId);
    print('Autos cargados: $loadedCars');
    setState(() {
      auto = loadedCars;
    });
  }

  Future<void> _loadReservas() async {
    final loaded = await FileStorage.loadReservations();
    setState(() {
      reservas = loaded;
    });
  }

  Future<void> _loadPisosYLugares() async {
    final pisosJson = await rootBundle.loadString('assets/data/pisos.json');
    final decodedPisos =
        List<Map<String, dynamic>>.from(json.decode(pisosJson));

    final lugaresFile = await _getLocalLugaresFile();
    if (!(await lugaresFile.exists())) {
      final defaultLugaresJson =
          await rootBundle.loadString('assets/data/lugares.json');
      await lugaresFile.writeAsString(defaultLugaresJson);
    }

    final lugaresJson = await lugaresFile.readAsString();
    final decodedLugares =
        List<Map<String, dynamic>>.from(json.decode(lugaresJson));

    setState(() {
      pisos = decodedPisos;
      lugares = decodedLugares;
      lugaresDisponibles = decodedLugares;
    });
  }

  bool _estaOcupado(String lugar) {
    if (selectedStartTime == null || selectedEndTime == null) return false;
    final start = int.parse(selectedStartTime!.split(":")[0]);
    final end = int.parse(selectedEndTime!.split(":")[0]);

    return reservas.any((r) {
      if (r.estacionamiento != lugar) return false;
      final rStart = int.parse(r.horaInicio.split(":")[0]);
      final rEnd = int.parse(r.horaFin.split(":")[0]);
      return (start < rEnd && end > rStart);
    });
  }

  void _calculateCost() {
    if (selectedStartTime != null && selectedEndTime != null) {
      final startHour = int.parse(selectedStartTime!.split(":")[0]);
      final endHour = int.parse(selectedEndTime!.split(":")[0]);
      int duration = endHour - startHour;
      if (duration < 0) duration += 24;
      setState(() {
        totalCost = duration * 30000;
      });
    }
  }

  Future<void> _confirmReservation() async {
    final existingReservations = await FileStorage.loadReservations();

    final startHour = int.parse(selectedStartTime!.split(":")[0]);
    final endHour = int.parse(selectedEndTime!.split(":")[0]);

    final conflict = existingReservations.any((r) {
      if (r.estacionamiento != selectedSpot) return false;
      final rStart = int.parse(r.horaInicio.split(":")[0]);
      final rEnd = int.parse(r.horaFin.split(":")[0]);
      return (startHour < rEnd && endHour > rStart);
    });

    if (conflict) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Ese lugar ya está reservado en el horario elegido.')),
      );
      return;
    }

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
              final currentContext = context;
              Navigator.pop(context);
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
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                auto: selectedCar!,
                estacionamiento: selectedSpot!,
                horaInicio: selectedStartTime!,
                horaFin: selectedEndTime!,
                fecha: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                costoTotal: (totalCost ?? 0).toDouble(),
                estado: 'OCUPADO',
              );
              await FileStorage.saveReservation(reservation);

              final lugaresFile = await _getLocalLugaresFile();
              final content = await lugaresFile.readAsString();
              final lugaresData =
                  List<Map<String, dynamic>>.from(json.decode(content));
              final updatedData = lugaresData.map((lugar) {
                if (lugar['codigoLugar'] == selectedSpot) {
                  return {...lugar, 'estado': 'OCUPADO'};
                }
                return lugar;
              }).toList();
              await lugaresFile.writeAsString(json.encode(updatedData));

              await _loadReservas();
              await _loadPisosYLugares();
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
                children: lugaresDisponibles.map((spot) {
                  bool ocupado = _estaOcupado(spot['codigoLugar']);
                  return ElevatedButton(
                    onPressed: ocupado
                        ? null
                        : () {
                            setState(() {
                              selectedSpot = spot['codigoLugar'];
                            });
                          },
                    child: Text(
                        '${spot['codigoLugar']} (${spot['descripcionLugar']})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ocupado
                          ? Colors.grey
                          : selectedSpot == spot['codigoLugar']
                              ? Colors.green
                              : null,
                    ),
                  );
                }).toList(),
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
