import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/CaNhan.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
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

              const Text(
                "Bùi Thị Ngọc Như",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Icon(
                    Icons.favorite_outline,
                    color: Colors.blue,
                    size: 18,
                  ),

                  const SizedBox(width: 5),

                  const Expanded(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => NhacLich(),),);
              },
              icon: const Icon(
                Icons.notifications_none,
                size: 26,
              ),
            ),

            GestureDetector(
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => CaNhan(),),);
              },
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xffd6df73),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}