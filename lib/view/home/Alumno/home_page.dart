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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cantidad de Autos: $cantidadAutos',
                  style: TextStyle(fontSize: 16)),
              Text('Pagos realizados este mes: $pagosDelMes',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.local_parking),
                label: Text('Reservar Estacionamiento'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CarParkingPage(clienteId: widget.cliente.id),
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
                      builder: (_) =>
                          RegistrarAutoPage(clienteId: widget.cliente.id),
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
                      builder: (_) =>
                          ListarAutosPage(clienteId: widget.cliente.id),
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
