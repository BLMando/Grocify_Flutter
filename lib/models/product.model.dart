import '../utils/utils.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String quantity;
  final String image;
  final double discount;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    this.discount = 0.0,
  });

  // Factory constructor to create an instance from Firestore document
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: Utils.capitalizeFirstLetter(json['nome'].toString()),
      price: double.tryParse(json['prezzo_unitario']?.toString() ?? '') ?? 0.0,
      quantity: json['quantita']?.toString() ?? '',
      image: json['immagine']?.toString() ?? '',
      discount: double.tryParse(json['sconto']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  // Method to convert a ProductType instance to a Map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'prezzo_unitario': price,
      'quantita': quantity,
      'immagine': image,
      'sconto': discount,
    };
  }
}