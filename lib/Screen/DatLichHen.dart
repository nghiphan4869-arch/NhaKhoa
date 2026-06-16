import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/XacNhanLichHen.dart';

class DatLichHen extends StatefulWidget {
  const DatLichHen({super.key});

  @override
  State<DatLichHen> createState() => _DatLichHen();
}

class _DatLichHen extends State<DatLichHen> {
  int selectedDoctor = 0;
  String selectedTime = "9:00";
  String selectedService = "Khám tổng quát";

  int selectedDate = 0;
  int startIndex = 0;

  late DateTime monday;
  late List<DateTime> weekDays;

  List<DateTime> get dates =>
    List.generate(
      365,
      (index) => DateTime.now().add(
        Duration(days: index),
      ),
    );

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController reasonController =
    TextEditingController();

  final List<String> doctors = [
    "BS. Trần Thùy Dương",
    "BS. Nguyễn Văn A",
    "BS. Lê Thị B",
  ];

  final List<String> times = [
    "8:00","8:30","9:00","9:30","10:00",
    "10:30","11:00","11:30","14:00","14:30",
    "15:00","15:30","16:00","16:30","17:00"
  ];

  final List<String> thu = [
    "T2","T3","T4","T5","T6","T7","CN",
  ];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    monday = now.subtract(
      Duration(days: now.weekday - 1),
    );

    _loadWeek();
  }

  void _loadWeek() {
    weekDays = List.generate(
      7,
      (index) => monday.add(
        Duration(days: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: const Text("Đặt lịch hẹn"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffeaf4ff),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.medical_services,
                      color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Đặt lịch dễ dàng\nChọn bác sĩ phù hợp và thời gian thuận tiện.",
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("1. Chọn bác sĩ"),

            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDoctor = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDoctor == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "BS. Trần Thùy Dương",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            _sectionTitle("2. Chọn dịch vụ"),

            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Khám tổng quát",
                  child: Text("Khám tổng quát"),
                ),
                DropdownMenuItem(
                  value: "Cạo vôi răng",
                  child: Text("Cạo vôi răng"),
                ),
                DropdownMenuItem(
                  value: "Nhổ răng",
                  child: Text("Nhổ răng"),
                ),
                DropdownMenuItem(
                  value: "Niềng răng",
                  child: Text("Niềng răng"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedService = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            _sectionTitle("3. Chọn ngày khám"),

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

            const SizedBox(height: 15),

            _sectionTitle("4. Chọn giờ khám"),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: times.map((time) {
                bool selected = selectedTime == time;

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
                      borderRadius: BorderRadius.circular(10),
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

            const SizedBox(height: 15),

            _sectionTitle("5. Lý do khám"),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Nhập lý do khám...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => XacNhanLichHen(
                        selectedDay: selectedDay,
                        selectedTime: selectedTime,
                        doctorName: doctors[selectedDoctor],
                        serviceName: selectedService,
                        reason: reasonController.text,
                      ),
                    ),
                  );
                },
                child: const Text("Tiếp tục"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

