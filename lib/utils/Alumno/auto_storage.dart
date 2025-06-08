import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../model/Alumno/sistema_reservas.dart';

class AutoStorage {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/autos.json';
  }

  static Future<List<Auto>> cargarAutos(String clienteId) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/autos.json';
    final file = File(path);

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> data = json.decode(content);
      return data
          .map((json) => Auto.fromJson(json))
          .where((car) => car.clienteId == clienteId)
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> guardarAuto(Auto auto) async {
    final path = await _getFilePath();
    final file = File(path);

    List<Auto> autos = await leerAutos();
    autos.add(auto);

    final jsonList = autos.map((a) => a.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<List<Auto>> leerAutos() async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      if (!file.existsSync()) return [];

      final content = await file.readAsString();
      final data = jsonDecode(content) as List;

      return data.map((json) => Auto.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
