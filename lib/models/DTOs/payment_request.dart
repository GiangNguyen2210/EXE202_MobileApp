class PaymentRequest {
  final int orderCode;
  final int amount;
  final String description;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final List<Item> items;

  PaymentRequest({
    required this.orderCode,
    required this.amount,
    required this.description,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'orderCode': orderCode,
    'amount': amount,
    'description': description,
    'buyerName': buyerName,
    'buyerEmail': buyerEmail,
    'buyerPhone': buyerPhone,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class Item {
  final String name;
  final int quantity;
  final int price;

  Item({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}