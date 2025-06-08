import 'package:flutter/material.dart';
import './sistema_reservas.dart';
import '../../utils/Alumno/pago_storage.dart';

class PagosPage extends StatefulWidget {
  @override
  _PagosPageState createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  List<Pago> pagos = [];

  @override
  void initState() {
    super.initState();
    _cargarPagos();
  }

  Future<void> _cargarPagos() async {
    final lista = await PagoStorage.cargarPagos();
    setState(() {
      pagos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagos Registrados')),
      body: pagos.isEmpty
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
                        Text('Reserva asociada: ${pago.codigoReservaAsociada}'),
                        Text('Monto pagado: ${pago.montoPagado} Gs'),
                        Text('Fecha: ${pago.fechaPago}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
