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
  String? selectedService;
  List<dynamic> _services = [];
  bool _isLoadingServices = true;
  Map<String, int> serviceDurations = {};

  List<dynamic> _availableDoctors = [];
  bool _isLoadingDoctors = false;
  int? _selectedDoctorId;
  String? _selectedDoctorName;

  int startIndex = 0;
  int minStartIndex = 0;

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
    ).toList();
  }

  int _getWeekStartIndex(DateTime date) {
    final list = dates;
    for (int i = 0; i < list.length; i++) {
      if (list[i].day == date.day &&
          list[i].month == date.month &&
          list[i].year == date.year) {
        return (i / 7).floor() * 7;
      }
    }
    return 0;
  }

  late DateTime selectedDay;
  DateTime focusedDay = DateTime.now();

  final TextEditingController reasonController =
    TextEditingController();

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
    DateTime tomorrow = today.add(const Duration(days: 1));
    selectedDay = tomorrow;

    minStartIndex = _getWeekStartIndex(tomorrow);
    startIndex = minStartIndex;

    _loadAvailableDoctors();
  }

  Future<void> _loadAvailableDoctors() async {
    setState(() {
      _isLoadingDoctors = true;
    });
    try {
      final dateStr = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
      final list = await LichHenService.getAvailableDoctors(dateStr);
      setState(() {
        _availableDoctors = list;
        if (list.isNotEmpty) {
          final hasOld = list.any((d) => d['MaNhanVien'] == _selectedDoctorId);
          if (!hasOld) {
            _selectedDoctorId = list.first['MaNhanVien'];
            _selectedDoctorName = list.first['HoTen'];
          }
        } else {
          _selectedDoctorId = null;
          _selectedDoctorName = null;
        }
      });
    } catch (e) {
      print('Lỗi tải danh sách bác sĩ rảnh: $e');
    } finally {
      setState(() {
        _isLoadingDoctors = false;
      });
    }
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

            _sectionTitle("1. Chọn ngày khám"),

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
                                    _loadAvailableDoctors();
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
                        child: Text(service),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedService = value!;
                      });
                    },
                  ),

            const SizedBox(height: 15),

            _sectionTitle("3. Chọn bác sĩ rảnh trong ngày"),

            _isLoadingDoctors
                ? const Center(child: CircularProgressIndicator())
                : _availableDoctors.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            "Không có bác sĩ nào có lịch trống trong ngày này. Vui lòng chọn ngày khác.",
                            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            _availableDoctors.length,
                            (index) {
                              final doctor = _availableDoctors[index];
                              final docId = doctor['MaNhanVien'];
                              final docName = doctor['HoTen'];
                              final isSelected = _selectedDoctorId == docId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDoctorId = docId;
                                    _selectedDoctorName = docName;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 110,
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.1),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xffeaf4ff),
                                        child: Icon(Icons.person, color: Colors.blue),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        docName,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? Colors.blue : Colors.black87,
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

            const SizedBox(height: 15),

            _sectionTitle("4. Lý do khám"),

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

            const SizedBox(height: 25),

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
                onPressed: selectedService == null || _selectedDoctorId == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => XacNhanLichHen(
                              selectedDay: selectedDay,
                              selectedTime: "", // No time selection, pass empty
                              duration: serviceDurations[selectedService!] ?? 30,
                              doctorId: _selectedDoctorId!,
                              doctorName: _selectedDoctorName ?? "",
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

