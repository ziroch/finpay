// lib/pages/administrar_reservas.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../model/Alumno/reservation.dart';
import '../utils/Alumno/pago_storage.dart';
import '../utils/Alumno/lugares_storage.dart';
import '../model/Alumno/sistema_reservas.dart';

class AdministrarReservasPage extends StatefulWidget {
  @override
  _AdministrarReservasPageState createState() =>
      _AdministrarReservasPageState();
}

class _AdministrarReservasPageState extends State<AdministrarReservasPage> {
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Reserva'),
        content: Text(
            '¿Estás seguro de que deseas eliminar esta reserva?\n\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Eliminar')),
        ],
      ),
    );

    if (confirm != true) return;

    reservations.removeAt(index);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reservas.json');
    await file.writeAsString(
      json.encode(reservations.map((r) => r.toJson()).toList()),
    );

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reserva eliminada')),
    );
  }

  List<Reservation> _filteredReservations() {
    return reservations.where((r) {
      final matchesDate = filterDate == null || r.fecha.startsWith(filterDate!);
      final matchesClient =
          filterClientId == null || r.auto.clienteId == filterClientId;
      return matchesDate && matchesClient;
    }).toList();
  }

  Future<void> _payReservation(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Pago'),
        content: Text(
          '¿Deseas marcar esta reserva como pagada?\n\nCosto: ${reservations[index].costoTotal} Gs',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final reservaPagada = reservations[index];

    // Eliminamos la reserva pagada
    setState(() {
      reservations.removeAt(index);
    });

    // Guardar todas las reservas actualizadas
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reservas.json');
    await file.writeAsString(
      json.encode(reservations.map((r) => r.toJson()).toList()),
    );

    // Crear y guardar el pago en pagos.json
    final pago = Pago(
      codigoPago: DateTime.now().millisecondsSinceEpoch.toString(),
      codigoReservaAsociada: reservations[index].id ?? '',
      montoPagado: reservations[index].costoTotal,
      //fechaPago: DateTime.now().toIso8601String(),
      fechaPago: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );

    await PagoStorage.guardarPago(pago);

    // Liberar el lugar
    await _liberarLugar(reservaPagada.estacionamiento);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El pago ha sido registrado')),
    );
  }

  Future<void> _liberarLugar(String codigoLugar) async {
    await LugaresStorage.actualizarEstadoLugar(codigoLugar, 'DISPONIBLE');
    if (mounted) setState(() {}); // o refrescar lista si es necesario
  }

  Future<void> _cancelReservation(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar Reserva'),
        content: Text(
            '¿Deseas cancelar esta reserva?\n\nEsto eliminará la reserva y liberará el lugar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final reservaCancelada = reservations[index];

    // Eliminar reserva
    setState(() {
      reservations.removeAt(index);
    });

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reservas.json');
    await file.writeAsString(
      json.encode(reservations.map((r) => r.toJson()).toList()),
    );

    // Liberar el lugar
    await _liberarLugar(reservaCancelada.estacionamiento);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reserva cancelada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReservations();
    return Scaffold(
      appBar: AppBar(title: Text('Administrar Reservas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                        //'Fecha: ${r.fecha}\nCliente: ${r.auto.clienteId}\nCosto Total: ${r.costoTotal} Gs\nEstado: ${r.estado}',
                        'Fecha: ${r.fecha}\nCosto Total: ${r.costoTotal} Gs\nEstado: ${r.estado}',
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        direction: Axis.vertical,
                        children: [
                          if (r.estado != 'PAGADO') ...[
                            ElevatedButton(
                              onPressed: () => _payReservation(index),
                              child: Text('Pagar'),
                            ),
                            ElevatedButton(
                              onPressed: () => _cancelReservation(index),
                              child: Text('Cancelar'),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
