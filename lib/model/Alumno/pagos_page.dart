import 'package:flutter/material.dart';
import './sistema_reservas.dart';
import '../../utils/Alumno/pago_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/Alumno/reservation.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

class PagosPage extends StatefulWidget {
  @override
  _PagosPageState createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  List<Pago> pagos = [];
  int pagosDelMes = 0;
  int pagosPendientes = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final lista = await PagoStorage.cargarPagos();
    final ahora = DateTime.now();

    final formato = DateFormat('dd/MM/yyyy');

    // Filtrar pagos del mes actual
    final pagosMes = lista.where((p) {
      //final fecha = DateTime.tryParse(p.fechaPago);
      //return fecha != null &&
      try {
        final fecha = formato.parse(p.fechaPago);
        return fecha.month == ahora.month && fecha.year == ahora.year;
        fecha.month == ahora.month && fecha.year == ahora.year;
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

    setState(() {
      pagos = lista;
      pagosDelMes = pagosMes.length;
      pagosPendientes = pendientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Pagos')),
      body: Column(
        children: [
          Expanded(
            child: pagos.isEmpty
                ? Center(child: Text('No hay pagos registrados'))
                : ListView.builder(
                    itemCount: pagos.length,
                    itemBuilder: (context, index) {
                      final pago = pagos[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text('Pago ID: ${pago.codigoPago}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Reserva asociada: ${pago.codigoReservaAsociada}'),
                              Text('Monto pagado: ${pago.montoPagado} Gs'),
                              Text('Fecha: ${pago.fechaPago}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
