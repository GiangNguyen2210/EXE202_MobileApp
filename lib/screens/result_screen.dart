import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.orderCode});

  final String orderCode;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<Map<String, dynamic>> fetchPaymentInfo() async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/payment/info/${widget.orderCode}');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Ép kiểu orderCode thành String
      data['orderCode'] = data['orderCode'].toString();
      return data;
    } else {
      throw Exception('Không thể lấy thông tin thanh toán');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LoginBGPicture.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: fetchPaymentInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.orange));
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
              }

              final data = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'App Chảo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 22),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Đơn hàng #${data['orderCode']}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['status'] == 'PAID' ? 'Đã thanh toán thành công' : 'Thanh toán chưa hoàn tất',
                            style: TextStyle(
                              fontSize: 16,
                              color: data['status'] == 'PAID' ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Số tiền: ${data['amount']} VND'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Quay lại', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}