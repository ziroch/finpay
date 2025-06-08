import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../model/Alumno/sistema_reservas.dart';

class PagoStorage {
  static Future<void> guardarPago(Pago pago) async {
    final pagos = await cargarPagos();
    pagos.add(pago);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pagos.json');
    await file
        .writeAsString(json.encode(pagos.map((p) => p.toJson()).toList()));
  }

  static Future<List<Pago>> cargarPagos() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/pagos.json');
      if (!(await file.exists())) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Pago.fromJson(json)).toList();
    } catch (e) {
      print('Error al cargar pagos: $e');
      return [];
    }
  }
}
