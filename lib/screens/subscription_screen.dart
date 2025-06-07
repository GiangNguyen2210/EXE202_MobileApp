import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/payos_service.dart';
import '../api/profile_api.dart';
import '../models/DTOs/user_profile_response.dart';
import '../models/DTOs/payment_request.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PayOSService _payOSService = PayOSService();
  final ProfileApi _profileApi = ProfileApi();
  static const int _hardcodedUpId = 1;
  late Future<UserProfileResponse> _userProfileFuture;
  bool _isPaymentLoading = false;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _profileApi.fetchUserProfile(_hardcodedUpId);
  }

  Future<void> _createPayment(String plan, int amount, String description) async {
    if (_isPaymentLoading) return;

    setState(() => _isPaymentLoading = true);
    try {
      final userProfile = await _userProfileFuture;
      if (userProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải dữ liệu hồ sơ, vui lòng thử lại')),
        );
        return;
      }

      // Log thông tin userProfile trong _createPayment
      debugPrint('User Profile in _createPayment:');
      debugPrint('  upId: ${userProfile.upId}');
      debugPrint('  fullName: ${userProfile.fullName}');
      debugPrint('  email: ${userProfile.email}');
      debugPrint('  phoneNumber: ${userProfile.phoneNumber}');
      debugPrint('  subcriptionId: ${userProfile.subscriptionId}');
      debugPrint('  endDate: ${userProfile.endDate}');

      // Logic kiểm tra subscription
      if (userProfile.subscriptionId != 1 &&
          userProfile.endDate != null &&
          userProfile.endDate!.isAfter(DateTime.now())) {
        if ((userProfile.subscriptionId == 2 && plan == 'Basic') ||
            (userProfile.subscriptionId == 3 && plan == 'Premium')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bạn đang sử dụng gói $plan')),
          );
          return;
        }
      }

      final request = PaymentRequest(
        orderCode: 0,
        amount: amount,
        description: description,
        buyerName: userProfile.fullName.isNotEmpty ? userProfile.fullName : 'Unknown User',
        buyerEmail: userProfile.email.isNotEmpty ? userProfile.email : 'unknown@example.com',
        buyerPhone: userProfile.phoneNumber ?? '0123456789',
        items: [
          Item(
            name: description,
            quantity: 1,
            price: amount,
          ),
        ],
      );
      final response = await _payOSService.createPaymentLink(request, _hardcodedUpId);
      final uri = Uri.parse(response.checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Không thể mở link thanh toán';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi thanh toán: $e')),
      );
    } finally {
      setState(() => _isPaymentLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfileResponse>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log lỗi nếu có
            debugPrint('Error in FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final userProfile = snapshot.data!;

            // Log thông tin userProfile trong FutureBuilder
            debugPrint('User Profile in FutureBuilder:');
            debugPrint('  upId: ${userProfile.upId}');
            debugPrint('  fullName: ${userProfile.fullName}');
            debugPrint('  email: ${userProfile.email}');
            debugPrint('  phoneNumber: ${userProfile.phoneNumber}');
            debugPrint('  subcriptionId: ${userProfile.subscriptionId}');
            debugPrint('  endDate: ${userProfile.endDate}');

            final isBasicSubscribed = userProfile.subscriptionId == 2 &&
                userProfile.endDate != null &&
                userProfile.endDate!.isAfter(DateTime.now());
            final isPremiumSubscribed = userProfile.subscriptionId == 3 &&
                userProfile.endDate != null &&
                userProfile.endDate!.isAfter(DateTime.now());
            final subscriptionStatus = userProfile.subscriptionId == 1
                ? 'Free'
                : isBasicSubscribed
                ? 'Basic (Hết hạn: ${DateFormat('dd/MM/yyyy').format(userProfile.endDate!)})'
                : isPremiumSubscribed
                ? 'Premium (Hết hạn: ${DateFormat('dd/MM/yyyy').format(userProfile.endDate!)})'
                : 'Free';

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/LoginBGPicture.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/logo.png',
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'App Chảo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Choose Your Plan',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Current Plan: $subscriptionStatus',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Basic',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '99 000 VND /month',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildPlanFeature('5 recipe suggestions per day'),
                                    _buildPlanFeature('Basic ingredient analysis'),
                                    _buildPlanFeature('AI chat support (slow, low priority)'),
                                    _buildPlanFeature('Save 10 favorite recipes'),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isBasicSubscribed ? Colors.grey : Colors.blue,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: isBasicSubscribed || _isPaymentLoading
                                            ? null
                                            : () => _createPayment('Basic', 10000, 'vip1'),
                                        child: _isPaymentLoading
                                            ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          isBasicSubscribed ? 'Subscribed' : 'Choose Basic',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Premium',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      isBasicSubscribed ? '8 000 VND /month (Upgrade)' : '199 000 VND /month',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildPlanFeature('Unlimited recipe suggestions', isPremium: true),
                                    _buildPlanFeature('Advanced ingredient analysis (with nutrition)', isPremium: true),
                                    _buildPlanFeature('AI chat support (fast, high priority)', isPremium: true),
                                    _buildPlanFeature('Unlimited recipe storage', isPremium: true),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isPremiumSubscribed ? Colors.grey : Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: isPremiumSubscribed || _isPaymentLoading
                                            ? null
                                            : () => _createPayment(
                                          'Premium',
                                          isBasicSubscribed ? 8000 : 15000,
                                          isBasicSubscribed ? 'upgrade_to_vip2' : 'vip2',
                                        ),
                                        child: _isPaymentLoading
                                            ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          isPremiumSubscribed
                                              ? 'Subscribed'
                                              : isBasicSubscribed
                                              ? 'Upgrade to Premium'
                                              : 'Choose Premium',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isPremiumSubscribed ? Colors.white : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'All plans include 14-day free trial',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Log khi không có dữ liệu
            debugPrint('No data available in FutureBuilder');
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }

  Widget _buildPlanFeature(String feature, {bool isPremium = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: isPremium ? Colors.white : Colors.black87,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            feature,
            style: TextStyle(
              fontSize: 12,
              color: isPremium ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}