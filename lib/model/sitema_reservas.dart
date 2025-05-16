class Cliente {
  String nombre;
  String apellido;
  String telefono;
  List<Auto> autos;

  Cliente({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.autos,
  });
}

class Auto {
  String chapa;
  String marca;
  String modelo;
  String chasis;

  Auto({
    required this.chapa,
    required this.marca,
    required this.modelo,
    required this.chasis,
  });
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
}

class Lugar {
  String codigoPiso;
  String codigoLugar;
  String descripcionLugar;

  Lugar({
    required this.codigoPiso,
    required this.codigoLugar,
    required this.descripcionLugar,
  });
}

class Reserva {
  String codigoReserva;
  DateTime horarioInicio;
  DateTime horarioSalida;
  double monto;
  String estadoReserva;

  Reserva({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
  });
}

class Pago {
  String codigoPago;
  String codigoReservaAsociada;
  double montoPagado;
  DateTime fechaPago;

  Pago({
    required this.codigoPago,
    required this.codigoReservaAsociada,
    required this.montoPagado,
    required this.fechaPago,
  });
}
