import 'package:flutter/material.dart';

class TaiKham extends StatefulWidget {
  const TaiKham({super.key});

  @override
  State<TaiKham> createState() => _TaiKhamState();
}


class _TaiKhamState extends State<TaiKham> {

  int selectedDate = 0;

  // đổi int -> String
  String selectedTime = "9:00";

  int startIndex = 0;

  DateTime selectedDay = DateTime.now();

  List<DateTime> get dates =>
      List.generate(
        365,
        (index) => DateTime.now().add(
          Duration(days: index),
        ),
      );

  final List<String> thu = [
    "T2","T3","T4","T5",
    "T6","T7","CN",
  ];

  final List<String> times = [
    "8:00","8:30","9:00",
    "9:30","10:00",
    "10:30","11:00",
    "11:30","14:00",
    "14:30","15:00",
    "15:30","16:00",
    "16:30","17:00"
  ];

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xfff3f7fb),

    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Tái khám",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
    ),

    body: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  /// THÔNG TIN ĐIỀU TRỊ
                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Row(
                          children: [

                            Icon(
                              Icons.local_hospital,
                              color: Colors.blue,
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Thông tin điều trị hiện tại",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [

                            Expanded(
                              child: _infoBox(
                                Icons.medical_services,
                                "Răng số 16",
                                "Răng bị sâu nặng",
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _infoBox(
                                Icons.person,
                                "BS. ABC",
                                "27/05/2026",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// LÝ DO
                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Lý do tái khám",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          maxLines: 3,
                          decoration:
                              InputDecoration(
                            hintText:
                                "Chi tiết vấn đề bạn đang gặp phải...",
                            filled: true,
                            fillColor:
                                Colors.grey.shade100,
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      15),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CHỌN THỜI GIAN TÁI KHÁM
                  const Text(
                    "Chọn thời gian tái khám",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Expanded(
                        child: SizedBox(
                          height: 75,
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
                                  width: 75,
                                  margin: const EdgeInsets.only(
                                    right: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
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
                                        ),
                                      ),

                                      Text(
                                        "${date.day}/${date.month}",
                                        style: TextStyle(
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
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          size: 32,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            startIndex += 7;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// CHỌN GIỜ KHÁM
                  const Text(
                    "Chọn giờ tái khám",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: times.map((time) {

                      bool selected =
                          selectedTime == time;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.blue
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height:20),

                  _card(
                    color:
                        const Color(0xffe9f4ff),

                    child: Column(
                      children: [

                        _scheduleRow(
                          Icons.person,
                          "BS. ABC",
                        ),

                        const SizedBox(
                            height:10),

                        _scheduleRow(
                          Icons.calendar_today,
                          "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                        ),

                        const SizedBox(
                            height:10),

                        _scheduleRow(
                          Icons.access_time,
                          selectedTime,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 55,

            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
              ),

              onPressed: () {},

              child: const Text(
                "Xác nhận đặt lịch",
                style: TextStyle(
                  fontSize:16,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

  Widget _card({
    required Widget child,
    Color color=Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

Widget _title(String text){
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _infoBox(
  IconData icon,
  String title,
  String sub,
){
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Icon(
          icon,
          color: Colors.blue,
        ),

        const SizedBox(height:8),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height:5),

        Text(
          sub,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget _scheduleRow(
  IconData icon,
  String text,
){
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.blue,
      ),

      const SizedBox(width:10),

      Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      )
    ],
  );
}