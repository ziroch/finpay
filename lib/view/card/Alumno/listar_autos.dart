import 'package:flutter/material.dart';

import '../../../utils/Alumno/auto_storage.dart';
import '../../../model/Alumno/sistema_reservas.dart';

class ListarAutosPage extends StatelessWidget {
  final String clienteId;

  const ListarAutosPage({Key? key, required this.clienteId}) : super(key: key);

  Future<List<Auto>> _obtenerAutosDelCliente() async {
    final todosLosAutos = await AutoStorage.leerAutos();
    return todosLosAutos.where((auto) => auto.clienteId == clienteId).toList();
  }

  Future<int> obtenerCantidadAutosDelCliente() async {
    final todosLosAutos = await AutoStorage.leerAutos();
    return todosLosAutos.where((auto) => auto.clienteId == clienteId).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Autos Registrados')),
      body: FutureBuilder<List<Auto>>(
        future: _obtenerAutosDelCliente(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los autos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes autos registrados'));
          }

          final autos = snapshot.data!;
          return ListView.builder(
            itemCount: autos.length,
            itemBuilder: (context, index) {
              final auto = autos[index];
              return ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('${auto.marca} - ${auto.modelo}'),
                subtitle: Text('Placa: ${auto.chapa}'),
              );
            },
          );
        },
      ),
    );
  }
}
