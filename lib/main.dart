import 'package:flutter/material.dart';
import '../view/login/Alumno/login_screen.dart';
import '../pages/reservas.dart';
import '../pages/administrar_reservas.dart';

void main() {
  runApp(ParkingReservationApp());
}

class ParkingReservationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/parking': (context) => CarParkingPage(),
        '/reservations': (context) => AdministrarReservasPage(),
      },
    );
  }
}
