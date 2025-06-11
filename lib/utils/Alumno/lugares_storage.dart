import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class LugaresStorage {
  static Future<List<Map<String, dynamic>>> cargarLugares() async {
    final dir = await getApplicationDocumentsDirectory();
    final lugaresFile = File('${dir.path}/lugares.json');

    if (!(await lugaresFile.exists())) {
      final defaultLugaresJson =
          await rootBundle.loadString('assets/data/lugares.json');
      await lugaresFile.writeAsString(defaultLugaresJson);
    }

    final lugaresJson = await lugaresFile.readAsString();
    return List<Map<String, dynamic>>.from(json.decode(lugaresJson));
  }

  static Future<void> actualizarEstadoLugar(
      String codigoLugar, String nuevoEstado) async {
    final lugares = await cargarLugares();
    final updated = lugares.map((lugar) {
      if (lugar['codigoLugar'] == codigoLugar) {
        return {...lugar, 'estado': nuevoEstado};
      }
      return lugar;
    }).toList();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/lugares.json');
    await file.writeAsString(json.encode(updated));
  }
}
