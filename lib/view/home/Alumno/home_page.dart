// lib/pages/home_page.dart
import 'package:flutter/material.dart';

import '../../../model/Alumno/sistema_reservas.dart'; // Asegúrate que Cliente esté aquí

import '../../card/Alumno/registrar_auto.dart';
import '../../card/Alumno/listar_autos.dart';
import '../../../pages/reservas.dart';
import '../../../model/Alumno/pagos_page.dart';

class HomePage extends StatelessWidget {
  final Cliente cliente;

  const HomePage({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              // Volver a login y borrar toda la pila de navegación
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.local_parking),
                label: Text('Reservar Estacionamiento'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarParkingPage(clienteId: cliente.id),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.manage_search),
                label: Text('Administrar Reservas'),
                onPressed: () => Navigator.pushNamed(context, '/reservations'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.receipt_long),
                label: Text('Ver Pagos'),
                onPressed: () => Navigator.pushNamed(context, '/pagos'),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.directions_car),
                label: Text('Registrar Auto'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistrarAutoPage(clienteId: cliente.id),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.list),
                label: Text('Mis Autos'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListarAutosPage(clienteId: cliente.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
