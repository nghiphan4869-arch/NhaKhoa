import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  int startIndex = 0;
  int minStartIndex = 0;

  List<dynamic> _doctorAppointments = [];
  bool _isLoadingAppointments = false;
  List<dynamic> _patientAppointments = [];
  bool _isLoadingPatientAppointments = false;

  Future<void> _loadDoctorAppointments() async {
    setState(() {
      _isLoadingAppointments = true;
    });
    try {
      final doctorId = selectedDoctor == 0 ? 1 : (selectedDoctor == 1 ? 3 : 4);
      final list = await LichHenService.getAppointmentsByDoctor(doctorId);
      setState(() {
        _doctorAppointments = list;
      });
    } catch (e) {
      print('Lỗi tải lịch hẹn bác sĩ: $e');
    } finally {
      setState(() {
        _isLoadingAppointments = false;
      });
    }
  }

  Future<void> _loadPatientAppointments() async {
    setState(() {
      _isLoadingPatientAppointments = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBenhNhan = prefs.getInt('maBenhNhan') ?? 0;
      if (maBenhNhan > 0) {
        final list = await LichHenService.getAppointmentsByPatient(maBenhNhan);
        setState(() {
          _patientAppointments = list;
        });
      }
    } catch (e) {
      print('Lỗi tải lịch hẹn bệnh nhân: $e');
    } finally {
      setState(() {
        _isLoadingPatientAppointments = false;
      });
      _updateSelectedTime();
    }
  }

  int _timeToMinutes(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  bool _isTimeSlotBlocked(String timeSlot) {
    if (selectedService == null) return false;

    final slotStart = _timeToMinutes(timeSlot);
    final selectedDuration = serviceDurations[selectedService!] ?? 30;
    final slotEnd = slotStart + selectedDuration;

    final selectedDateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    // 1. Kiểm tra trùng lịch của Bác sĩ (tính cả lịch chờ duyệt và đã duyệt)
    for (var app in _doctorAppointments) {
      final status = app['TrangThai'];
      if (status == 'DaHuy') {
        continue;
      }

      try {
        final appDate = DateTime.parse(app['NgayHen']).toLocal();
        final appDateOnly = DateTime(appDate.year, appDate.month, appDate.day);
        if (!appDateOnly.isAtSameMomentAs(selectedDateOnly)) {
          continue;
        }
      } catch (e) {
        continue;
      }

      final appStart = _timeToMinutes(app['GioHen'] ?? '');
      final lyDoKham = app['LyDoKham'] ?? '';
      final serviceName = lyDoKham.split(':')[0].trim();
      final appDuration = serviceDurations[serviceName] ?? 30;
      final appEnd = appStart + appDuration;

      if (slotStart < appEnd && appStart < slotEnd) {
        return true;
      }
    }

    // 2. Kiểm tra trùng lịch của chính Bệnh nhân (tính cả lịch chờ duyệt và đã duyệt)
    for (var app in _patientAppointments) {
      final status = app['TrangThai'];
      if (status == 'DaHuy') {
        continue;
      }

      try {
        final appDate = DateTime.parse(app['NgayHen']).toLocal();
        final appDateOnly = DateTime(appDate.year, appDate.month, appDate.day);
        if (!appDateOnly.isAtSameMomentAs(selectedDateOnly)) {
          continue;
        }
      } catch (e) {
        continue;
      }

      final appStart = _timeToMinutes(app['GioHen'] ?? '');
      final lyDoKham = app['LyDoKham'] ?? '';
      final serviceName = lyDoKham.split(':')[0].trim();
      final appDuration = serviceDurations[serviceName] ?? 30;
      final appEnd = appStart + appDuration;

      if (slotStart < appEnd && appStart < slotEnd) {
        return true;
      }
    }

    return false;
  }

  void _updateSelectedTime() {
    final validTimes = _filteredTimes;
    final availableTimes = validTimes.where((time) => !_isTimeSlotBlocked(time)).toList();

    if (!availableTimes.contains(selectedTime)) {
      setState(() {
        selectedTime = availableTimes.isNotEmpty ? availableTimes.first : '';
      });
    }
  }

  List<DateTime> get dates {
    final now = DateTime.now();
    final currentMonday = DateTime(now.year, now.month, now.day).subtract(
      Duration(days: now.weekday - 1),
    );
    return List.generate(
      450,
      (index) => currentMonday.add(
        Duration(days: index),
      ),
    ).where((date) => date.weekday != DateTime.sunday).toList();
  }

  int _getWeekStartIndex(DateTime date) {
    final list = dates;
    for (int i = 0; i < list.length; i++) {
      if (list[i].day == date.day &&
          list[i].month == date.month &&
          list[i].year == date.year) {
        return (i / 6).floor() * 6;
      }
    }
    return 0;
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
    _loadDoctorAppointments();
    _loadPatientAppointments();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));
    if (tomorrow.weekday == DateTime.sunday) {
      tomorrow = tomorrow.add(const Duration(days: 1));
    }
    selectedDay = tomorrow;

    minStartIndex = _getWeekStartIndex(tomorrow);
    startIndex = minStartIndex;
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
          _updateSelectedTime();
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
      _updateSelectedTime();
    });
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
                      _loadDoctorAppointments().then((_) {
                        _updateSelectedTime();
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
                        _updateSelectedTime();
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
                              startIndex -= 6;
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
                      children: List.generate(6, (index) {
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
                                      _updateSelectedTime();
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
                        startIndex += 6;
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
                bool isBlocked = _isTimeSlotBlocked(time);

                return GestureDetector(
                  onTap: isBlocked
                      ? null
                      : () {
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
                      color: isBlocked
                          ? Colors.grey.shade100
                          : (selected ? Colors.blue : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isBlocked
                            ? Colors.grey.shade200
                            : (selected ? Colors.blue : Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isBlocked
                            ? Colors.grey.shade400
                            : (selected ? Colors.white : Colors.black),
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

