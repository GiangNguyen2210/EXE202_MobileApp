import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/DTOs/notification_response.dart';
import '../api/notification_api.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final int _pageSize = 10;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final List<ScrollController> _scrollControllers = [];
  int _currentPage = 0;
  int _totalPages = 1;
  String? _searchTerm;
  late Future<NotificationResponse> _fetchNotificationsFuture;
  List<NotificationItem> _allNotifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotificationsFuture = _loadNotifications(page: 1);
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        _scrollToTop();
        _loadNotifications(page: newPage + 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollControllers.isNotEmpty &&
        _currentPage < _scrollControllers.length) {
      _scrollControllers[_currentPage].animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<NotificationResponse> _loadNotifications({required int page}) async {
    try {
      final api = NotificationApi();
      final response = await api.fetchNotifications(
        page: page,
        pageSize: _pageSize,
        searchTerm: _searchTerm,
      );

      setState(() {
        _totalPages = (response.totalCount / _pageSize).ceil();
        _allNotifications = response.items;
      });

      return response;
    } catch (e) {
      setState(() {
        _allNotifications = [];
        _totalPages = 1;
      });
      rethrow;
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchTerm = value.trim().isEmpty ? null : value.trim();
      _currentPage = 0;
      _allNotifications = [];
      _totalPages = 1;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    setState(() {
      _fetchNotificationsFuture = _loadNotifications(page: 1);
    });

    _searchController.clear();
  }

  Widget _buildNotificationCard(NotificationItem noti) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.notifications_active_outlined, color: Colors.orange),
        title: Text(noti.title ?? 'No title', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(noti.body ?? 'No content'),
            const SizedBox(height: 4),
            Text(
              'Type: ${noti.type ?? 'N/A'} - Status: ${noti.status ?? 'Unknown'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (noti.createdAt != null)
              Text(
                'Created at: ${noti.createdAt!.toLocal().toString().split('.')[0]}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          )
        ],
      ),
      body: FutureBuilder<NotificationResponse>(
        future: _fetchNotificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = _allNotifications;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            itemBuilder: (context, pageIndex) {
              if (_scrollControllers.length <= pageIndex) {
                _scrollControllers.add(ScrollController());
              }
              final start = pageIndex * _pageSize;
              final end = (start + _pageSize).clamp(0, notifications.length);
              final items = notifications.sublist(start, end);

              return ListView.builder(
                controller: _scrollControllers[pageIndex],
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final noti = items[index];
                  return _buildNotificationCard(noti);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Notifications'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Enter keyword...'),
            onSubmitted: (value) {
              Navigator.of(context).pop();
              _onSearchSubmitted(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onSearchSubmitted(_searchController.text);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
