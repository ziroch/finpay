// lib/pages/registrar_auto.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../login/Alumno/registro_usuario.dart';
import '../../../model/Alumno/sistema_reservas.dart';

import '../../../utils/Alumno/auto_storage.dart';

class RegistrarAutoPage extends StatefulWidget {
  final String clienteId;

  RegistrarAutoPage({required this.clienteId});

  @override
  _RegistrarAutoPageState createState() => _RegistrarAutoPageState();
}

class _RegistrarAutoPageState extends State<RegistrarAutoPage> {
  final _formKey = GlobalKey<FormState>();
  final chapaController = TextEditingController();
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();

  Future<void> _guardarAuto() async {
    if (!_formKey.currentState!.validate()) return;

    final auto = Auto(
      chapa: chapaController.text.trim(),
      marca: marcaController.text.trim(),
      modelo: modeloController.text.trim(),
      clienteId: widget.clienteId,
    );

    final clientes = await cargarClientes();
    final cliente = clientes.firstWhere((c) => c.id == widget.clienteId);
    cliente.autos.add(auto);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/clientes.json');
    await file
        .writeAsString(json.encode(clientes.map((c) => c.toJson()).toList()));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Auto registrado exitosamente')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Auto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: chapaController,
                decoration: InputDecoration(labelText: 'Chapa'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la chapa' : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la marca' : null,
              ),
              TextFormField(
                controller: modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el modelo' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Auto nuevoAuto = Auto(
                    chapa: chapaController.text,
                    marca: marcaController.text,
                    modelo: modeloController.text,
                    clienteId: widget.clienteId,
                  );

                  await AutoStorage.guardarAuto(nuevoAuto);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Auto registrado')));
                  Navigator.pop(context);
                },
                child: Text('Guardar Auto'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
