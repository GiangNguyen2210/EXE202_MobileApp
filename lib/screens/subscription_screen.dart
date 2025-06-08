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

  Future<void> _createPayment(
    String plan,
    int amount,
    String description,
  ) async {
    if (_isPaymentLoading) return;

    setState(() => _isPaymentLoading = true);
    try {
      final userProfile = await _userProfileFuture;
      if (userProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải dữ liệu hồ sơ, vui lòng thử lại'),
          ),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Bạn đang sử dụng gói $plan')));
          return;
        }
      }

      final request = PaymentRequest(
        orderCode: 0,
        amount: amount,
        description: description,
        buyerName: userProfile.fullName.isNotEmpty
            ? userProfile.fullName
            : 'Unknown User',
        buyerEmail: userProfile.email.isNotEmpty
            ? userProfile.email
            : 'unknown@example.com',
        buyerPhone: userProfile.phoneNumber ?? '0123456789',
        items: [Item(name: description, quantity: 1, price: amount)],
      );
      final response = await _payOSService.createPaymentLink(
        request,
        _hardcodedUpId,
      );
      final uri = Uri.parse(response.checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Không thể mở link thanh toán';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi thanh toán: $e')));
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
            debugPrint('Error in FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final userProfile = snapshot.data!;

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
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/LoginBGPicture.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
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
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildPlanCard(
                                    'Basic',
                                    99000,
                                    isBasicSubscribed,
                                    isPremiumSubscribed,
                                    [
                                      '5 recipe suggestions per day',
                                      'Basic ingredient analysis',
                                      'AI chat support (slow, low priority)',
                                      'Save 10 favorite recipes',
                                    ],
                                        () => _createPayment('Basic', 10000, 'vip1'),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPlanCard(
                                    'Premium',
                                    isBasicSubscribed ? 8000 : 199000,
                                    isBasicSubscribed,
                                    isPremiumSubscribed,
                                    [
                                      'Unlimited recipe suggestions',
                                      'Advanced ingredient analysis (with nutrition)',
                                      'AI chat support (fast, high priority)',
                                      'Unlimited recipe storage',
                                    ],
                                        () => _createPayment(
                                      'Premium',
                                      isBasicSubscribed ? 8000 : 15000,
                                      isBasicSubscribed ? 'upgrade_to_vip2' : 'vip2',
                                    ),
                                    isPremium: true,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'All plans include 14-day free trial',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            debugPrint('No data available in FutureBuilder');
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }

  Widget _buildPlanCard(
      String title,
      int amount,
      bool isBasicSubscribed,
      bool isPremiumSubscribed,
      List<String> features,
      VoidCallback onPressed, {
        bool isPremium = false,
      }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPremium ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPremium ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount)} /month',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPremium ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          ...features.map((feature) => _buildPlanFeature(feature, isPremium: isPremium)).toList(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (isPremium ? !isPremiumSubscribed : !isBasicSubscribed) ? (isPremium ? Colors.white : Colors.blue) : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: _isPaymentLoading || (isPremium ? isPremiumSubscribed : isBasicSubscribed) ? null : onPressed,
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
                (isPremium ? isPremiumSubscribed : isBasicSubscribed)
                    ? 'Subscribed'
                    : isPremium && isBasicSubscribed
                    ? 'Upgrade to Premium'
                    : 'Choose ${isPremium ? 'Premium' : 'Basic'}',
                style: TextStyle(
                  fontSize: 14,
                  color: isPremium && !isPremiumSubscribed ? Colors.blue : Colors.white,
                ),
              ),
            ),
          ),
        ],
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
          Expanded(
            // Use Expanded to allow text to wrap
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 12,
                color: isPremium ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
