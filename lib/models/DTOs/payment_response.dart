class PaymentResponse {
  final String checkoutUrl;

  PaymentResponse({required this.checkoutUrl});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(checkoutUrl: json['checkoutUrl']);
  }
}