import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../../../model/Alumno/sistema_reservas.dart';

// Pantalla de registro de usuario
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// Lógica de autenticación que puede usarse en login_screen.dart
Future<List<Cliente>> cargarClientes() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/clientes.json');
  if (!file.existsSync()) return [];
  final data = json.decode(await file.readAsString());
  return (data as List).map((e) => Cliente.fromJson(e)).toList();
}

Future<Cliente?> autenticarUsuario(String login, String password) async {
  final clientes = await cargarClientes();
  for (var cliente in clientes) {
    if (cliente.login == login && cliente.checkPassword(password)) {
      return cliente;
    }
  }
  return null;
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final nuevoCliente = Cliente(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      login: loginController.text,
      nombre: nombreController.text,
      apellido: apellidoController.text,
      telefono: telefonoController.text,
      passwordHash: Cliente.hashPassword(passwordController.text),
      autos: [],
    );

    final clientes = await cargarClientes();
    clientes.add(nuevoCliente);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/clientes.json');
    await file
        .writeAsString(json.encode(clientes.map((c) => c.toJson()).toList()));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: loginController,
                decoration: InputDecoration(labelText: 'Usuario'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un usuario' : null,
              ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un apellido' : null,
              ),
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un teléfono' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese una contraseña' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
