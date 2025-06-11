// Actualización del modelo Cliente con campo de contraseña y encriptación MD5
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Cliente {
  String id;
  String login;
  String nombre;
  String apellido;
  String telefono;
  String passwordHash; // nueva propiedad encriptada
  List<Auto> autos;

  Cliente({
    required this.id,
    required this.login,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.passwordHash,
    required this.autos,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'],
        login: json['login'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        telefono: json['telefono'],
        passwordHash: json['passwordHash'],
        autos:
            List<Auto>.from((json['autos'] ?? []).map((a) => Auto.fromJson(a))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'passwordHash': passwordHash,
        'autos': autos.map((a) => a.toJson()).toList(),
      };

  static String hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  bool checkPassword(String password) {
    return passwordHash == Cliente.hashPassword(password);
  }
}

class Auto {
  String chapa;
  String marca;
  String modelo;
  String clienteId;

  Auto(
      {required this.chapa,
      required this.marca,
      required this.modelo,
      required this.clienteId});

  factory Auto.fromJson(Map<String, dynamic> json) => Auto(
        chapa: json['chapa'],
        marca: json['marca'],
        modelo: json['modelo'],
        clienteId: json['clienteId'],
      );

  Map<String, dynamic> toJson() => {
        'chapa': chapa,
        'marca': marca,
        'modelo': modelo,
        'clienteId': clienteId
      };

  // Método toString para mostrar el auto en la UI de forma amigable
  @override
  String toString() {
    return '$marca $modelo ($chapa)';
  }
}

class Pago {
  String codigoPago;
  String codigoReservaAsociada;
  double montoPagado;
  String fechaPago;

  Pago({
    required this.codigoPago,
    required this.codigoReservaAsociada,
    required this.montoPagado,
    required this.fechaPago,
  });

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        codigoPago: json['codigoPago'],
        codigoReservaAsociada: json['codigoReservaAsociada'],
        montoPagado: json['montoPagado'].toDouble(),
        //fechaPago: DateTime.now().toIso8601String(), //,
        fechaPago: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );

  Map<String, dynamic> toJson() => {
        'codigoPago': codigoPago,
        'codigoReservaAsociada': codigoReservaAsociada,
        'montoPagado': montoPagado,
        'fechaPago': fechaPago,
      };
}

class Piso {
  String codigo;
  String descripcion;
  List<Lugar> lugares;

  Piso({
    required this.codigo,
    required this.descripcion,
    required this.lugares,
  });

  factory Piso.fromJson(Map<String, dynamic> json) => Piso(
        codigo: json['codigo'],
        descripcion: json['descripcion'],
        lugares:
            (json['lugares'] as List).map((l) => Lugar.fromJson(l)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descripcion': descripcion,
        'lugares': lugares.map((l) => l.toJson()).toList(),
      };
}

class Lugar {
  String codigoPiso;
  String codigoLugar;
  String descripcionLugar;
  String estado; // disponible, reservado, ocupado

  Lugar({
    required this.codigoPiso,
    required this.codigoLugar,
    required this.descripcionLugar,
    this.estado = "disponible",
  });

  factory Lugar.fromJson(Map<String, dynamic> json) => Lugar(
        codigoPiso: json['codigoPiso'],
        codigoLugar: json['codigoLugar'],
        descripcionLugar: json['descripcionLugar'],
        estado: json['estado'] ?? "disponible",
      );

  Map<String, dynamic> toJson() => {
        'codigoPiso': codigoPiso,
        'codigoLugar': codigoLugar,
        'descripcionLugar': descripcionLugar,
        'estado': estado,
      };
}

class Reserva {
  String codigoReserva;
  DateTime horarioInicio;
  DateTime horarioSalida;
  double monto;
  String estadoReserva;
  String chapaAuto; // solo la chapa

  Reserva({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
    required this.chapaAuto,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
        codigoReserva: json['codigoReserva'],
        horarioInicio: DateTime.parse(json['horarioInicio']),
        horarioSalida: DateTime.parse(json['horarioSalida']),
        monto: json['monto'].toDouble(),
        estadoReserva: json['estadoReserva'],
        chapaAuto: json['chapaAuto'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'codigoReserva': codigoReserva,
        'horarioInicio': horarioInicio.toIso8601String(),
        'horarioSalida': horarioSalida.toIso8601String(),
        'monto': monto,
        'estadoReserva': estadoReserva,
        'chapaAuto': chapaAuto,
      };
}
