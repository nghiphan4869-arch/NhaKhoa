import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import 'package:nhakhoa/services/benh_an_service.dart';

class TaiKham extends StatefulWidget {
  const TaiKham({super.key});

  @override
  State<TaiKham> createState() => _TaiKhamState();
}

class _TaiKhamState extends State<TaiKham> {
  int selectedDoctor = 0;
  String selectedTime = "9:00";
  int startIndex = 0;
  int minStartIndex = 0;
  DateTime selectedDay = DateTime.now();
  final TextEditingController _reasonController = TextEditingController();
  int? _maBenhNhan;
  List<dynamic> _medicalRecords = [];
  bool _isLoading = true;

  List<dynamic> _doctorAppointments = [];
  bool _isLoadingAppointments = false;
  List<dynamic> _patientAppointments = [];
  bool _isLoadingPatientAppointments = false;

  final List<String> doctors = [
    "BS. Tr\u1ea7n Th\u00f9y D\u01b0\u01a1ng",
    "BS. Nguy\u1ec5n V\u0103n A",
    "BS. L\u00ea Th\u1ecb B",
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

  final int reExamDuration = 30;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBn = prefs.getInt('maBenhNhan');
      if (maBn != null && maBn > 0) {
        _maBenhNhan = maBn;
        final list = await BenhAnService.getBenhAnByPatient(maBn);
        _medicalRecords = list;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        DateTime tomorrow = today.add(const Duration(days: 1));
        if (tomorrow.weekday == DateTime.sunday) {
          tomorrow = tomorrow.add(const Duration(days: 1));
        }
        selectedDay = tomorrow;
        minStartIndex = _getWeekStartIndex(tomorrow);
        startIndex = minStartIndex;

        await _loadDoctorAppointments();
        await _loadPatientAppointments();
      }
    } catch (e) {
      print('L\u1ed7i t\u1ea3i d\u1eef li\u1ec7u: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      print('L\u1ed7i t\u1ea3i l\u1ecbch h\u1eb9n b\u00e1c s\u0129: $e');
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
      if (_maBenhNhan != null && _maBenhNhan! > 0) {
        final list = await LichHenService.getAppointmentsByPatient(_maBenhNhan!);
        setState(() {
          _patientAppointments = list;
        });
      }
    } catch (e) {
      print('L\u1ed7i t\u1ea3i l\u1ecbch h\u1eb9n b\u1ec7nh nh\u00e2n: $e');
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
    final slotStart = _timeToMinutes(timeSlot);
    final slotEnd = slotStart + reExamDuration;
    final selectedDateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    for (var app in _doctorAppointments) {
      final status = app['TrangThai'];
      if (status == 'DaHuy') continue;

      try {
        final appDate = DateTime.parse(app['NgayHen']).toLocal();
        final appDateOnly = DateTime(appDate.year, appDate.month, appDate.day);
        if (!appDateOnly.isAtSameMomentAs(selectedDateOnly)) continue;
      } catch (e) {
        continue;
      }

      final appStart = _timeToMinutes(app['GioHen'] ?? '');
      final appEnd = appStart + 30;

      if (slotStart < appEnd && appStart < slotEnd) {
        return true;
      }
    }

    for (var app in _patientAppointments) {
      final status = app['TrangThai'];
      if (status == 'DaHuy') continue;

      try {
        final appDate = DateTime.parse(app['NgayHen']).toLocal();
        final appDateOnly = DateTime(appDate.year, appDate.month, appDate.day);
        if (!appDateOnly.isAtSameMomentAs(selectedDateOnly)) continue;
      } catch (e) {
        continue;
      }

      final appStart = _timeToMinutes(app['GioHen'] ?? '');
      final appEnd = appStart + 30;

      if (slotStart < appEnd && appStart < slotEnd) {
        return true;
      }
    }

    return false;
  }

  void _updateSelectedTime() {
    final availableTimes = times.where((time) => !_isTimeSlotBlocked(time)).toList();
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

  bool _isDateDisabled(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today.add(const Duration(days: 1)));
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Ch\u01b0a c\u1eadp nh\u1eadt';
    }
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

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

    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _maBenhNhan == null
            ? const Center(
                child: Text(
                  "Vui l\u00f2ng \u0111\u0103ng nh\u1eadp \u0111\u1ec3 \u0111\u1eb7t l\u1ecbch t\u00e1i kh\u00e1m.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : Padding(
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
                                _medicalRecords.isNotEmpty
                                    ? (_medicalRecords.first['KetQuaDieuTri'] ?? 'Đang theo dõi')
                                    : 'Chưa bắt đầu',
                                _medicalRecords.isNotEmpty
                                    ? (_medicalRecords.first['ChanDoan'] ?? 'Khám tổng quát')
                                    : 'Chưa có bệnh án',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _infoBox(
                                Icons.person,
                                "BS. Trần Thùy Dương",
                                _medicalRecords.isNotEmpty
                                    ? _formatDate(_medicalRecords.first['NgayLap'])
                                    : 'Chưa cập nhật',
                              ),
                            ),
                          ],
                        )
                      ],
                     const SizedBox(height: 18),

                  /// CHỌN BÁC SĨ
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "1. Ch\u1ecdn b\u00e1c s\u0129",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                              color: Colors.white,
                              border: Border.all(
                                color: selectedDoctor == index
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                width: selectedDoctor == index ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: selectedDoctor == index
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade100,
                                  child: Icon(
                                    Icons.person,
                                    color: selectedDoctor == index
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  doctors[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: selectedDoctor == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CHỌN NGÀY TÁI KHÁM
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "2. Ch\u1ecdn ng\u00e0y t\u00e1i kh\u00e1m",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
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

                  const SizedBox(height: 20),

                  /// CHỌN GIỜ KHÁM
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "3. Ch\u1ecdn gi\u1edd t\u00e1i kh\u00e1m",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: times.map((time) {
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

                  const SizedBox(height: 20),

                  /// LÝ DO TÁI KHÁM
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "L\u00fd do t\u00e1i kh\u00e1m",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _reasonController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Chi ti\u1ebft v\u1ea5n \u0111\u1ec1 b\u1ea1n \u0111ang g\u1eb7p ph\u1ea3i...",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TÓM TẮT
                  _card(
                    color: const Color(0xffe9f4ff),
                    child: Column(
                      children: [
                        _scheduleRow(
                          Icons.person,
                          doctors[selectedDoctor],
                        ),
                        const SizedBox(height: 10),
                        _scheduleRow(
                          Icons.calendar_today,
                          "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                        ),
                        const SizedBox(height: 10),
                        _scheduleRow(
                          Icons.access_time,
                          selectedTime.isEmpty ? 'Ch\u01b0a ch\u1ecdn' : selectedTime,
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

              onPressed: () async {
                if (_maBenhNhan == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Th\u00f4ng b\u00e1o"),
                      content: const Text("Vui l\u00f2ng \u0111\u0103ng nh\u1eadp \u0111\u1ec3 \u0111\u1eb7t l\u1ecbch t\u00e1i kh\u00e1m."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("\u0110\u00f3ng"),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );

                final String formattedDate = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
                final String reason = _reasonController.text.trim();
                final String reasonStr = reason.isEmpty ? "T\u00e1i kh\u00e1m \u0111\u1ecbnh k\u1ef3" : "T\u00e1i kh\u00e1m \u0111\u1ecbnh k\u1ef3: $reason";

                final errorMsg = await LichHenService.createAppointment(
                  maBenhNhan: _maBenhNhan!,
                  maBacSi: selectedDoctor == 0 ? 1 : (selectedDoctor == 1 ? 3 : 4),
                  ngayHen: formattedDate,
                  gioHen: selectedTime,
                  lyDoKham: reasonStr,
                );

                if (mounted) Navigator.pop(context); // Close loading dialog

                if (errorMsg == null) {
                  if (mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                "Th\u00e0nh c\u00f4ng",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: const Text("\u0110\u1eb7t l\u1ecbch t\u00e1i kh\u00e1m th\u00e0nh c\u00f4ng."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext); // Close success dialog
                                Navigator.pop(context); // Back to previous page
                              },
                              child: const Text("\u0110\u1ed3ng \u00fd"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Row(
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                "Th\u1ea5t b\u1ea1i",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: Text("Kh\u00f4ng th\u1ec3 \u0111\u1eb7t l\u1ecbch h\u1eb9n. L\u1ed7i: $errorMsg"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text("\u0110\u00f3ng"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },

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