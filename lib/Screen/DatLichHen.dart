import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/XacNhanLichHen.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';

class DatLichHen extends StatefulWidget {
  const DatLichHen({super.key});

  @override
  State<DatLichHen> createState() => _DatLichHen();
}

class _DatLichHen extends State<DatLichHen> {
  int selectedDoctor = 0;
  String selectedTime = "9:00";
  String? selectedService;
  List<dynamic> _services = [];
  bool _isLoadingServices = true;
  Map<String, int> serviceDurations = {};

  String _getEndTime() {
    if (selectedService == null) return selectedTime;
    final duration = serviceDurations[selectedService!] ?? 30;
    final parts = selectedTime.split(':');
    if (parts.length != 2) return selectedTime;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    
    final startDateTime = DateTime(2000, 1, 1, hour, minute);
    final endDateTime = startDateTime.add(Duration(minutes: duration));
    
    final endHour = endDateTime.hour.toString().padLeft(2, '0');
    final endMinute = endDateTime.minute.toString().padLeft(2, '0');
    return "$endHour:$endMinute";
  }

  List<String> get _filteredTimes {
    if (selectedService == null) return times;
    final duration = serviceDurations[selectedService!] ?? 30;

    return times.where((time) {
      final parts = time.split(':');
      if (parts.length != 2) return false;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final startDateTime = DateTime(2000, 1, 1, hour, minute);
      final endDateTime = startDateTime.add(Duration(minutes: duration));

      final limitTime = DateTime(2000, 1, 1, 17, 0);

      // Check if it ends after 17:00
      if (endDateTime.isAfter(limitTime)) {
        return false;
      }

      // Check overlap with lunch break [12:00, 13:00]
      final lunchStart = DateTime(2000, 1, 1, 12, 0);
      final lunchEnd = DateTime(2000, 1, 1, 13, 0);

      final overlapsLunch = startDateTime.isBefore(lunchEnd) && lunchStart.isBefore(endDateTime);
      if (overlapsLunch) {
        return false;
      }

      return true;
    }).toList();
  }

  int selectedDate = 0;
  int startIndex = 0;
  int minStartIndex = 0;

  late DateTime monday;
  late List<DateTime> weekDays;

  List<DateTime> get dates {
    final now = DateTime.now();
    final currentMonday = DateTime(now.year, now.month, now.day).subtract(
      Duration(days: now.weekday - 1),
    );
    return List.generate(
      365,
      (index) => currentMonday.add(
        Duration(days: index),
      ),
    );
  }

  late DateTime selectedDay;
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
    "10:30","11:00","11:30","13:00","13:30",
    "14:00","14:30","15:00","15:30","16:00",
    "16:30","17:00"
  ];

  final List<String> thu = [
    "T2","T3","T4","T5","T6","T7","CN",
  ];

  bool _isDateDisabled(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today.add(const Duration(days: 1)));
  }

  @override
  void initState() {
    super.initState();
    _loadServices();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    selectedDay = tomorrow;

    monday = now.subtract(
      Duration(days: now.weekday - 1),
    );
    final currentMonday = today.subtract(Duration(days: today.weekday - 1));
    final differenceInDays = tomorrow.difference(currentMonday).inDays;
    minStartIndex = (differenceInDays / 7).floor() * 7;
    startIndex = minStartIndex;

    _loadWeek();
  }

  Future<void> _loadServices() async {
    try {
      final list = await LichHenService.getServices();
      if (list.isNotEmpty) {
        setState(() {
          _services = list;
          serviceDurations.clear();
          for (var item in list) {
            final name = item['TenDichVu'] ?? '';
            final duration = item['ThoiGian'] ?? 30;
            serviceDurations[name] = duration;
          }
          selectedService = _services.first['TenDichVu'];
          _isLoadingServices = false;

          final validTimes = _filteredTimes;
          if (!validTimes.contains(selectedTime)) {
            selectedTime = validTimes.isNotEmpty ? validTimes.first : '';
          }
        });
      } else {
        _loadFallbackServices();
      }
    } catch (e) {
      print('Lỗi tải danh sách dịch vụ: $e');
      _loadFallbackServices();
    }
  }

  void _loadFallbackServices() {
    setState(() {
      serviceDurations = {
        "Khám tổng quát": 30,
        "Cạo vôi răng": 45,
        "Nhổ răng": 60,
        "Niềng răng": 120,
      };
      _services = serviceDurations.keys.map((k) => {'TenDichVu': k, 'ThoiGian': serviceDurations[k]}).toList();
      selectedService = "Khám tổng quát";
      _isLoadingServices = false;

      final validTimes = _filteredTimes;
      if (!validTimes.contains(selectedTime)) {
        selectedTime = validTimes.isNotEmpty ? validTimes.first : '';
      }
    });
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Đặt lịch hẹn",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
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
                      height: 100,
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
                      child: Column(
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            doctors[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
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

            _isLoadingServices
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    value: selectedService,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: serviceDurations.keys.map((service) {
                      return DropdownMenuItem(
                        value: service,
                        child: Text("$service (${serviceDurations[service]} phút)"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedService = value!;
                        final validTimes = _filteredTimes;
                        if (!validTimes.contains(selectedTime)) {
                          selectedTime = validTimes.isNotEmpty ? validTimes.first : '';
                        }
                      });
                    },
                  ),

            const SizedBox(height: 15),

            _sectionTitle("3. Chọn ngày khám"),

            Row(
              children: [
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
                    onPressed: startIndex > minStartIndex
                        ? () {
                            setState(() {
                              startIndex -= 7;
                              if (startIndex < minStartIndex) startIndex = minStartIndex;
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 16,
                      color: startIndex > minStartIndex ? Colors.black : Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final date = dates[startIndex + index];
                        bool isDisabled = _isDateDisabled(date);
                        bool selected = !isDisabled &&
                            selectedDay.day == date.day &&
                            selectedDay.month == date.month &&
                            selectedDay.year == date.year;

                        return Expanded(
                          child: GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () {
                                    setState(() {
                                      selectedDay = date;
                                    });
                                  },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.blue
                                    : (isDisabled ? Colors.grey.shade100 : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? Colors.blue
                                      : (isDisabled ? Colors.grey.shade200 : Colors.grey.shade300),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    thu[date.weekday - 1],
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : (isDisabled ? Colors.grey.shade400 : Colors.black),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${date.day}/${date.month}",
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : (isDisabled ? Colors.grey.shade400 : Colors.black87),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

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
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _sectionTitle("4. Chọn giờ khám"),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filteredTimes.map((time) {
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

            const SizedBox(height: 10),
            if (selectedService != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Thời gian dự kiến: $selectedTime - ${_getEndTime()} (${serviceDurations[selectedService!]} phút)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: selectedService == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => XacNhanLichHen(
                              selectedDay: selectedDay,
                              selectedTime: selectedTime,
                              duration: serviceDurations[selectedService!] ?? 30,
                              doctorName: doctors[selectedDoctor],
                              serviceName: selectedService!,
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

