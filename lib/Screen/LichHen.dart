import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';
import 'package:nhakhoa/Screen/DieuTri.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import '../widgets/bottom_nav.dart';

class LichHen extends StatefulWidget {
  const LichHen({super.key});

  @override
  State<LichHen> createState() =>
      _LichHenState();
}

class _LichHenState extends State<LichHen> {

  DateTime selectedDay = DateTime.now();
  int startIndex = 0;

  final List<String> thu = [
    "T2","T3","T4","T5","T6","T7","CN"
  ];

  List<DateTime> get dates =>
      List.generate(
        365,
        (index) => DateTime.now().add(
          Duration(days: index),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      bottomNavigationBar: const BottomNav(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Lịch hẹn",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Quản lý lịch hẹn khám và điều trị",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NhacLich(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// MENU
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [

                  _menu(
                    context,
                    Icons.calendar_today,
                    Colors.blue,
                    "Đặt lịch",
                    const DatLichHen(),
                  ),

                  _menu(
                    context,
                    Icons.medical_services,
                    Colors.green,
                    "Lịch điều trị",
                    const DieuTri(),
                  ),

                  // _menu(
                  //   context,
                  //   Icons.person,
                  //   Colors.purple,
                  //   "Chọn bác sĩ",
                  //   const ChonBacSi(),
                  // ),

                  _menu(
                    context,
                    Icons.schedule,
                    Colors.orange,
                    "Lịch hẹn",
                    null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// LỊCH
              Container(
                padding:
                    const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [

                        Text(
                          "Tháng ${selectedDay.month}, ${selectedDay.year}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = DateTime.now();
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffedf5ff),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Hôm nay",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    
                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 70,
                      child: Row(
                        children: [

                          /// Mũi tên trái
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: startIndex > 0
                                  ? () {
                                      setState(() {
                                        startIndex -= 7;
                                      });
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.chevron_left,
                                size: 16,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                          /// Danh sách ngày
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (context, index) {

                                final date =
                                    dates[startIndex + index];

                                bool selected =
                                    selectedDay.day == date.day &&
                                    selectedDay.month == date.month &&
                                    selectedDay.year == date.year;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDay = date;
                                    });
                                  },

                                  child: Container(
                                    width: 55,
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.blue
                                          : Colors.white,

                                      borderRadius:
                                          BorderRadius.circular(12),

                                      border: Border.all(
                                        color: selected
                                            ? Colors.blue
                                            : Colors.grey.shade300,
                                      ),
                                    ),

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [

                                        Text(
                                          thu[date.weekday - 1],
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          "${date.day}/${date.month}",
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color: selected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// Mũi tên phải
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  startIndex += 7;
                                });
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Lịch hẹn sắp tới",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _appointmentCard(
                color:
                    const Color(0xffedf5ff),
                time: "15:30 - 16:30",
                doctor: "BS. ABC",
                note: "Tái khám điều trị",
              ),

              const SizedBox(height: 15),

              const Text(
                "Lịch hẹn đã qua",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _appointmentCard(
                color:
                    const Color(0xffeefbea),
                time: "15:30 - 17:00",
                doctor: "BS. ABC",
                note: "Tái khám điều trị",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    Widget? page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {

        if(page == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },

      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard({
    required Color color,
    required String time,
    required String doctor,
    required String note,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [

          const Icon(
            Icons.access_time,
            color: Colors.blue,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  time,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(doctor),

                Text(
                  note,
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
          )
        ],
      ),
    );
  }
}