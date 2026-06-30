import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/CaNhan.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import 'package:nhakhoa/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hoTen': prefs.getString('hoTen') ?? 'Khách',
      'hinhAnh': prefs.getString('hinhAnh') ?? '',
    };
  }   

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        final userInfo = snapshot.data ?? {};
        final hoTen = userInfo['hoTen'] ?? '...';
        final hinhAnh = userInfo['hinhAnh'] ?? '';
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Xin chào,",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    hoTen,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        color: Colors.blue,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "Chăm sóc nụ cười, nâng tầm tự tin",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NhacLich(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 26,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CaNhan(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xffd6df73),
                    backgroundImage: hinhAnh.isNotEmpty
                        ? NetworkImage(hinhAnh.startsWith('http')
                            ? hinhAnh
                            : '${ApiConfig.domain}$hinhAnh')
                        : null,
                    child: hinhAnh.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}