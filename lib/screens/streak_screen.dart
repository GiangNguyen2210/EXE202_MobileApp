import 'package:flutter/material.dart';
import '../api/profile_api.dart';
import '../models/DTOs/user_profile_response.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  final ProfileApi _profileApi = ProfileApi();
  UserProfileResponse? _userProfile;
  bool _isLoading = true;
  bool _isRewardClaimed = false; // Trạng thái đã claim phần thưởng chưa

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      const upId = 1; // Hardcode upId (thay bằng upId bạn lấy từ Swagger)
      final profile = await _profileApi.fetchUserProfile(upId);
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading streak: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daily Rewards'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile != null
          ? SingleChildScrollView(
        child: _buildStreakContent(),
      )
          : const Center(
        child: Text(
          "Failed to load streak",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildStreakContent() {
    final currentDay = _userProfile!.streak!.clamp(1, 7); // Ngày hiện tại (1-7)
    final rewards = ['5% OFF', '10% OFF', '15% OFF', '20% OFF', '25% OFF', '30% OFF', '50% OFF'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const Text(
            "Log in daily to earn amazing rewards!",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          // Hàng 7 ngày
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final day = index + 1;
              final isCompleted = day < currentDay;
              final isCurrentDay = day == currentDay;

              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : (isCurrentDay ? Colors.blue : Colors.grey.shade300),
                      border: isCurrentDay
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                          : Text(
                        "$day",
                        style: TextStyle(
                          color: isCurrentDay ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    rewards[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted || isCurrentDay ? Colors.black : Colors.grey,
                      fontWeight: isCurrentDay ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            "Day $currentDay of 7",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          // Phần Today's Reward
          const Icon(
            Icons.card_giftcard,
            size: 50,
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          const Text(
            "TODAY'S REWARD",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            rewards[currentDay - 1],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Phần Complete 7 Days For
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Text(
                  "Complete 7 Days For 50% OFF COUPON",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Nút Claim Reward
          _isRewardClaimed
              ? const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          )
              : ElevatedButton(
            onPressed: () {
              setState(() {
                _isRewardClaimed = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Claim Reward",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            "Come back tomorrow for more rewards!",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            "Current Streak: ${_userProfile!.streak} days",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rewards expire in 24h+ ",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "TERMS",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}