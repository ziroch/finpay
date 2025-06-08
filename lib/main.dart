import 'package:finpay/model/Alumno/pagos_page.dart';
import 'package:flutter/material.dart';
import '../view/login/Alumno/login_screen.dart';
import '../view/login/Alumno/registro_usuario.dart';
import '../pages/reservas.dart';
import '../pages/administrar_reservas.dart';

import '../view/home/Alumno/home_page.dart';

import 'package:finpay/view/card/Alumno/registrar_auto.dart';
import 'package:finpay/model/Alumno/sistema_reservas.dart'; // Asegúrate que esta es la ruta del modelo Cliente
import '../../../model/Alumno/pagos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Reservas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginPage());

          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterPage());

          case '/home':
            final cliente = settings.arguments as Cliente?;
            if (cliente == null) {
              return MaterialPageRoute(
                  builder: (_) => const Scaffold(
                        body: Center(
                            child: Text('Error: cliente no proporcionado')),
                      ));
            }
            return MaterialPageRoute(
                builder: (_) => HomePage(cliente: cliente));

          case '/parking':
            final clienteId = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => CarParkingPage(clienteId: clienteId));

          case '/pagos':
            return MaterialPageRoute(
              builder: (_) => PagosPage(),
            );
          case '/reservations':
            return MaterialPageRoute(
              builder: (_) => AdministrarReservasPage(),
            );

          case '/registrar_auto':
            final clienteId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => RegistrarAutoPage(clienteId: clienteId),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Ruta desconocida: ${settings.name}')),
              ),
            );
        }
      },
    );
  }
}
