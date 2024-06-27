class OrderModel {
  final String orderId;
  final List<Map<String, dynamic>> cart;
  final String userId;
  final String status;
  final String destination;
  final double totalPrice;
  final String type;
  final String date;
  final String time;
  final String driverId;

  OrderModel({
    required this.orderId,
    this.cart = const [],
    required this.userId,
    required this.status,
    required this.destination,
    required this.totalPrice,
    required this.type,
    required this.date,
    required this.time,
    required this.driverId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> cartList = List<Map<String, dynamic>>.from(json['cart'] ?? []);
    return OrderModel(
      orderId: json['orderId'] ?? "",
      cart: cartList,
      userId: json['userId'] ?? "",
      status: json['status'] ?? "",
      destination: json['destination'] ?? "",
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      type: json['type'] ?? "",
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      driverId: json['driverId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'cart': cart,
      'userId': userId,
      'status': status,
      'destination': destination,
      'totalPrice': totalPrice,
      'type': type,
      'date': date,
      'time': time,
      'driverId': driverId,
    };
  }
}
