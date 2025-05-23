class Car {
  final String chapa;
  final String marca;
  final String modelo;
  final String chasis;
  final String clienteId;

  Car({
    required this.chapa,
    required this.marca,
    required this.modelo,
    required this.chasis,
    required this.clienteId,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      chapa: json['chapa'],
      marca: json['marca'],
      modelo: json['modelo'],
      chasis: json['chasis'],
      clienteId: json['clienteId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chapa': chapa,
        'marca': marca,
        'modelo': modelo,
        'chasis': chasis,
        'clienteId': clienteId,
      };

  @override
  String toString() => '$marca $modelo ($chapa)';
}
