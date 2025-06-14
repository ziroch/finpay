// lib/pages/home_page.dart
import 'package:finpay/model/Alumno/reservation.dart';
import 'package:flutter/material.dart';

import '../../../model/Alumno/sistema_reservas.dart'; // Asegúrate que Cliente esté aquí

import '../../card/Alumno/registrar_auto.dart';
import '../../card/Alumno/listar_autos.dart';
import '../../../pages/reservas.dart';
import '../../../model/Alumno/pagos_page.dart';
import '../../../utils/Alumno/pago_storage.dart';
import '../../../utils/Alumno/auto_storage.dart';

import '../../card/Alumno/listar_autos.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  final Cliente cliente;

  const HomePage({Key? key, required this.cliente}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pago> pagos = [];
  int cantidadAutos = 0;
  int pagosDelMes = 0;
  int pagosPendientes = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<int> _obtenerCantidadAutos() async {
    final todosLosAutos = await AutoStorage.leerAutos();
    return todosLosAutos
        .where((auto) => auto.clienteId == widget.cliente.id)
        .length;
  }

  Future<void> _cargarDatos() async {
    final lista = await PagoStorage.cargarPagos();
    final ahora = DateTime.now();

    final formato = DateFormat('dd/MM/yyyy');

    // Contar pagos del mes actual
    final pagosMes = lista.where((p) {
      //final fecha = DateTime.tryParse(p.fechaPago);
      //return fecha != null &&
      try {
        final fecha = formato.parse(p.fechaPago);
        return fecha.month == ahora.month && fecha.year == ahora.year;
      } catch (_) {
        return false;
      }
    }).toList();

    // Contar pagos pendientes desde reservas.json
    final dir = await getApplicationDocumentsDirectory();
    final reservasFile = File('${dir.path}/reservas.json');
    int pendientes = 0;

    if (await reservasFile.exists()) {
      final contenido = await reservasFile.readAsString();
      final data = json.decode(contenido);
      final reservas =
          (data as List).map((r) => Reservation.fromJson(r)).toList();

      pendientes = reservas.where((r) => r.estado != 'PAGADO').length;
    }

    // Contar autos
    final autosFile = File('${dir.path}/autos.json');
    if (autosFile.existsSync()) {
      final autosData = json.decode(await autosFile.readAsString());
      final autos = (autosData as List)
          .map((e) => Auto.fromJson(e))
          .where((auto) => auto.clienteId == widget.cliente.id)
          .toList();
      cantidadAutos = autos.length;
    }

    setState(() {
      pagos = lista;
      pagosDelMes = pagosMes.length;
      pagosPendientes = pendientes;
    });
  }

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
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card superior con resumen
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Resumen del Cliente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.directions_car, color: Colors.blue),
                              SizedBox(height: 4),
                              Text('Autos: $cantidadAutos'),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.payment, color: Colors.green),
                              SizedBox(height: 4),
                              Text('Pagos: $pagosDelMes'),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.pending_actions, color: Colors.orange),
                              SizedBox(height: 4),
                              Text('Pendientes: $pagosPendientes'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Segundo Card con botones
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: ListView(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.local_parking),
                          label: Text('Reservar Estacionamiento'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CarParkingPage(
                                    clienteId: widget.cliente.id),
                              ),
                            ).then((_) => _cargarDatos());
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.manage_search),
                          label: Text('Administrar Reservas'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/reservations')
                                .then((_) => _cargarDatos());
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.receipt_long),
                          label: Text('Ver Pagos'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/pagos')
                                .then((_) => _cargarDatos());
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.directions_car),
                          label: Text('Registrar Auto'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegistrarAutoPage(
                                    clienteId: widget.cliente.id),
                              ),
                            ).then((_) => _cargarDatos());
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.list),
                          label: Text('Mis Autos'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListarAutosPage(
                                    clienteId: widget.cliente.id),
                              ),
                            ).then((_) => _cargarDatos());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
