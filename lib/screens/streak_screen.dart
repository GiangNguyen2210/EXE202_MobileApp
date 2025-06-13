import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/profile_api.dart';
import '../models/DTOs/user_profile_response.dart';
import '../service/user_id_service.dart';

class StreakScreen extends StatefulWidget {
const StreakScreen({super.key});

@override
State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
with TickerProviderStateMixin {
final ProfileApi _profileApi = ProfileApi();
UserProfileResponse? _userProfile;
bool _isLoading = true;
bool _isRewardClaimed = false;

late AnimationController _pulseController;
late AnimationController _slideController;
late AnimationController _rewardController;
late Animation<double> _pulseAnimation;
late Animation<Offset> _slideAnimation;
late Animation<double> _rewardScaleAnimation;

@override
void initState() {
super.initState();
_setupAnimations();
_fetchUserProfile();
}

void _setupAnimations() {
_pulseController = AnimationController(
duration: const Duration(seconds: 2),
vsync: this,
)..repeat(reverse: true);

_slideController = AnimationController(
duration: const Duration(milliseconds: 800),
vsync: this,
);

_rewardController = AnimationController(
duration: const Duration(milliseconds: 600),
vsync: this,
);

_pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
);

_slideAnimation = Tween<Offset>(
begin: const Offset(0, 0.3),
end: Offset.zero,
).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

_rewardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
CurvedAnimation(parent: _rewardController, curve: Curves.bounceOut),
);
}

Future<void> _fetchUserProfile() async {
try {
final int? upId = await UserIdService.getUserId();
print('UPId: $upId'); // Log UPId
if (upId == null) {
throw Exception('Không tìm thấy UPId. Vui lòng đăng nhập lại.');
}
final profile = await _profileApi.fetchUserProfile(upId);
print('Profile fetched: ${profile.toJson()}'); // Log dữ liệu profile
setState(() {
_userProfile = profile;
_isLoading = false;
});
_slideController.forward();
_rewardController.forward();
} catch (e, stackTrace) {
print('Lỗi tải profile: $e\nStackTrace: $stackTrace'); // Log lỗi chi tiết
setState(() {
_isLoading = false;
});
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Lỗi tải streak: $e")),
);
}
}

@override
void dispose() {
_pulseController.dispose();
_slideController.dispose();
_rewardController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
debugPrint('StreakScreen size: ${MediaQuery.of(context).size}');
return Scaffold(
body: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF667eea),
Color(0xFF764ba2),
Color(0xFFf093fb),
Color(0xFFf5576c),
],
stops: [0.0, 0.3, 0.7, 1.0],
),
),
child: SafeArea(
child: Column(
children: [
_buildHeader(),
Expanded(
child: _isLoading
? _buildLoadingState()
    : _userProfile != null
? SingleChildScrollView(
physics: const BouncingScrollPhysics(),
child: _buildStreakContent(),
)
    : _buildErrorState(),
),
],
),
),
),
);
}

Widget _buildHeader() {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
child: Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
GestureDetector(
onTap: () {
// Điều hướng về HomeScreen và xóa các màn hình trung gian
Navigator.pushNamedAndRemoveUntil(
context,
'homescreen',
(route) => false, // Xóa toàn bộ stack, chỉ giữ homescreen
);
},
child: Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.2),
shape: BoxShape.circle,
),
child: const Icon(
Icons.arrow_back,
color: Colors.white,
size: 24,
),
),
),
Row(
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.2),
shape: BoxShape.circle,
),
child: const Icon(
Icons.local_fire_department,
color: Colors.orange,
size: 24,
),
),
const SizedBox(width: 12),
Text(
'Daily Streak',
style: GoogleFonts.poppins(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.white,
shadows: [
Shadow(
offset: Offset(0, 2),
blurRadius: 4,
color: Colors.black.withOpacity(0.3),
),
],
),
),
],
),
const SizedBox(width: 40), // Cân đối layout
],
),
const SizedBox(height: 8),
Text(
'Keep the flame burning! 🔥',
style: GoogleFonts.poppins(
fontSize: 14,
color: Colors.white.withOpacity(0.9),
fontWeight: FontWeight.w500,
),
),
],
),
);
}

Widget _buildLoadingState() {
return Container(
margin: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 15,
offset: Offset(0, 8),
),
],
),
child: const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
strokeWidth: 3,
),
SizedBox(height: 16),
Text(
'Đang tải streak của bạn...',
style: TextStyle(
fontSize: 16,
color: Colors.grey,
fontWeight: FontWeight.w500,
),
),
],
),
),
);
}

Widget _buildErrorState() {
return Container(
margin: const EdgeInsets.all(16),
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 15,
offset: Offset(0, 8),
),
],
),
child: const Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.error_outline,
size: 50,
color: Colors.redAccent,
),
SizedBox(height: 16),
Text(
'Có lỗi xảy ra!',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.black87,
),
),
SizedBox(height: 8),
Text(
'Không thể tải dữ liệu streak',
style: TextStyle(
fontSize: 14,
color: Colors.grey,
),
),
],
),
);
}

Widget _buildStreakContent() {
final streak = _userProfile!.streak ?? 1;
final currentDay = (streak == 0 ? 1 : streak).clamp(1, 7);
final rewards = [
{'discount': '5%', 'icon': Icons.local_offer, 'color': Colors.green},
{'discount': '10%', 'icon': Icons.card_giftcard, 'color': Colors.blue},
{'discount': '15%', 'icon': Icons.star, 'color': Colors.purple},
{'discount': '20%', 'icon': Icons.diamond, 'color': Colors.indigo},
{'discount': '25%', 'icon': Icons.auto_awesome, 'color': Colors.pink},
{'discount': '30%', 'icon': Icons.emoji_events, 'color': Colors.orange},
{'discount': '50%', 'icon': Icons.military_tech, 'color': Colors.red},
];

return SlideTransition(
position: _slideAnimation,
child: Container(
margin: const EdgeInsets.all(16),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 15,
offset: Offset(0, 8),
),
],
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
_buildProgressHeader(currentDay),
const SizedBox(height: 20),
_buildStreakDays(rewards, currentDay),
const SizedBox(height: 20),
_buildTodayReward(rewards, currentDay),
const SizedBox(height: 16),
_buildClaimButton(),
const SizedBox(height: 20),
_buildFooterInfo(currentDay),
const SizedBox(height: 16),
],
),
),
);
}

Widget _buildProgressHeader(int currentDay) {
return Column(
children: [
Text(
'Tiến độ Streak của bạn',
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.black87,
),
),
const SizedBox(height: 8),
Container(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [Color(0xFF667eea), Color(0xFF764ba2)],
),
borderRadius: BorderRadius.circular(16),
),
child: Text(
'Ngày $currentDay / 7',
style: const TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
const SizedBox(height: 12),
LinearProgressIndicator(
value: currentDay / 7,
backgroundColor: Colors.grey.shade300,
valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
minHeight: 6,
),
],
);
}

Widget _buildStreakDays(List<Map<String, dynamic>> rewards, int currentDay) {
return Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: Colors.grey.shade50,
borderRadius: BorderRadius.circular(12),
),
child: Column(
children: [
Text(
'Phần thưởng hàng tuần',
style: GoogleFonts.poppins(
fontSize: 14,
fontWeight: FontWeight.w600,
color: Colors.black87,
),
),
const SizedBox(height: 12),
Wrap(
alignment: WrapAlignment.center,
spacing: 8,
runSpacing: 8,
children: List.generate(7, (index) {
final day = index + 1;
final isCompleted = day < currentDay;
final isCurrentDay = day == currentDay;
final reward = rewards[index];

return SizedBox(
width: 80,
child: AnimatedContainer(
duration: Duration(milliseconds: 300 + (index * 100)),
margin: const EdgeInsets.symmetric(vertical: 4),
child: Column(
children: [
Container(
width: 40,
height: 40,
decoration: BoxDecoration(
shape: BoxShape.circle,
gradient: isCompleted
? const LinearGradient(
colors: [Colors.green, Colors.lightGreen],
)
    : isCurrentDay
? LinearGradient(
colors: [
reward['color'],
reward['color'].withOpacity(0.7),
],
)
    : LinearGradient(
colors: [
Colors.grey.shade300,
Colors.grey.shade400,
],
),
boxShadow: isCurrentDay
? [
BoxShadow(
color: reward['color'].withOpacity(0.4),
blurRadius: 8,
spreadRadius: 1,
),
]
    : null,
),
child: isCurrentDay
? AnimatedBuilder(
animation: _pulseAnimation,
builder: (context, child) {
return Transform.scale(
scale: _pulseAnimation.value,
child: Icon(
reward['icon'],
color: Colors.white,
size: 20,
),
);
},
)
    : Icon(
isCompleted ? Icons.check : reward['icon'],
color: Colors.white,
size: 20,
),
),
const SizedBox(height: 6),
Text(
'${reward['discount']} OFF',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.bold,
color: isCompleted || isCurrentDay
? Colors.black87
    : Colors.grey,
),
textAlign: TextAlign.center,
),
Text(
'Ngày $day',
style: TextStyle(
fontSize: 9,
color: isCompleted || isCurrentDay
? Colors.black54
    : Colors.grey,
),
textAlign: TextAlign.center,
),
],
),
),
);
}),
),
],
),
);
}

Widget _buildTodayReward(List<Map<String, dynamic>> rewards, int currentDay) {
final todayReward = rewards[currentDay - 1];

return ScaleTransition(
scale: _rewardScaleAnimation,
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
todayReward['color'].withOpacity(0.1),
todayReward['color'].withOpacity(0.05),
],
),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: todayReward['color'].withOpacity(0.3),
width: 2,
),
),
child: Column(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: todayReward['color'],
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: todayReward['color'].withOpacity(0.3),
blurRadius: 8,
spreadRadius: 1,
),
],
),
child: Icon(
todayReward['icon'],
size: 32,
color: Colors.white,
),
),
const SizedBox(height: 12),
Text(
"PHẦN THƯỞNG HÔM NAY",
style: GoogleFonts.poppins(
fontSize: 12,
fontWeight: FontWeight.w600,
color: Colors.black54,
letterSpacing: 1.2,
),
),
const SizedBox(height: 4),
Text(
'${todayReward['discount']} OFF',
style: GoogleFonts.poppins(
fontSize: 24,
fontWeight: FontWeight.bold,
color: todayReward['color'],
),
),
],
),
),
);
}

Widget _buildClaimButton() {
return _isRewardClaimed
? Container(
padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
decoration: BoxDecoration(
color: Colors.green,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.green.withOpacity(0.3),
blurRadius: 8,
offset: Offset(0, 4),
),
],
),
child: const Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.check_circle, color: Colors.white, size: 20),
SizedBox(width: 8),
Text(
'Đã nhận thưởng!',
style: TextStyle(
color: Colors.white,
fontSize: 14,
fontWeight: FontWeight.bold,
),
),
],
),
)
    : Container(
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [Color(0xFF667eea), Color(0xFF764ba2)],
),
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Color(0xFF667eea).withOpacity(0.4),
blurRadius: 12,
offset: Offset(0, 6),
),
],
),
child: ElevatedButton(
onPressed: () {
setState(() {
_isRewardClaimed = true;
});
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.transparent,
shadowColor: Colors.transparent,
padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
),
child: const Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.card_giftcard, color: Colors.white, size: 20),
SizedBox(width: 8),
Text(
'Nhận phần thưởng hôm nay',
style: TextStyle(
color: Colors.white,
fontSize: 14,
fontWeight: FontWeight.bold,
),
),
],
),
),
);
}

Widget _buildFooterInfo(int currentDay) {
return Column(
children: [
Container(
padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
decoration: BoxDecoration(
color: Colors.orange.shade100,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: Colors.orange.shade300),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.emoji_events, color: Colors.orange.shade700, size: 18),
const SizedBox(width: 6),
ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 200),
child: Text(
"Hoàn thành 7 ngày để nhận MEGA REWARD 50% OFF!",
style: TextStyle(
color: Colors.orange.shade800,
fontSize: 10,
fontWeight: FontWeight.bold,
),
overflow: TextOverflow.ellipsis,
),
),
],
),
),
const SizedBox(height: 12),
Text(
'Quay lại ngày mai để nhận thêm phần thưởng! 🎁',
style: GoogleFonts.poppins(
fontSize: 12,
color: Colors.black54,
fontWeight: FontWeight.w500,
),
),
const SizedBox(height: 4),
Text(
'Streak hiện tại: $currentDay ngày 🔥',
style: GoogleFonts.poppins(
fontSize: 12,
fontWeight: FontWeight.bold,
color: Colors.black87,
),
),
const SizedBox(height: 6),
Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.access_time, size: 10, color: Colors.red.shade400),
const SizedBox(width: 4),
ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 150),
child: Text(
'Phần thưởng hết hạn sau 24h',
style: TextStyle(
fontSize: 10,
color: Colors.red.shade400,
fontWeight: FontWeight.w500,
),
overflow: TextOverflow.ellipsis,
),
),
],
),
const SizedBox(height: 4),
GestureDetector(
onTap: () {},
child: const Text(
'ĐIỀU KHOẢN',
style: TextStyle(
fontSize: 10,
color: Colors.blue,
fontWeight: FontWeight.bold,
decoration: TextDecoration.underline,
),
),
),
],
),
],
);
}
}
