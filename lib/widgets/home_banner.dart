import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xffd9e8ff),
            Color(0xfff7f9ff),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bạn chưa có lịch hẹn?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Đặt lịch để được tư vấn\nvà chăm sóc sớm nhất",
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DatLichHen(),),);
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  label: const Text(
                    "Đặt lịch ngay",
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.medical_services,
            size: 90,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}