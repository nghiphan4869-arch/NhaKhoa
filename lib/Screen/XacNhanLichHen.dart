import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import 'package:nhakhoa/Screen/TrangChu.dart';

class XacNhanLichHen extends StatefulWidget {
  final DateTime selectedDay;
  final String selectedTime;
  final int duration;
  final String doctorName;
  final String serviceName;
  final String reason;

  const XacNhanLichHen({
    super.key,
    required this.selectedDay,
    required this.selectedTime,
    required this.duration,
    required this.doctorName,
    required this.serviceName,
    required this.reason,
  });

  @override
  State<XacNhanLichHen> createState() => _XacNhanLichHenState();
}

class _XacNhanLichHenState extends State<XacNhanLichHen> {
  String _hoTen = "Khách";
  String _sdt = "Chưa cập nhật";
  String _email = "Chưa cập nhật";
  int _maBenhNhan = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _hoTen = prefs.getString('hoTen') ?? 'Khách';
        _sdt = prefs.getString('sdt') ?? 'Chưa cập nhật';
        _email = prefs.getString('email') ?? 'Chưa cập nhật';
        _maBenhNhan = prefs.getInt('maBenhNhan') ?? 0;
      });
    } catch (e) {
      print('Lỗi tải thông tin cá nhân: $e');
    }
  }

  String get _endTime {
    final parts = widget.selectedTime.split(':');
    if (parts.length != 2) return widget.selectedTime;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    
    final startDateTime = DateTime(2000, 1, 1, hour, minute);
    final endDateTime = startDateTime.add(Duration(minutes: widget.duration));
    
    final endHour = endDateTime.hour.toString().padLeft(2, '0');
    final endMinute = endDateTime.minute.toString().padLeft(2, '0');
    return "$endHour:$endMinute";
  }

  int _getDoctorId(String name) {
    switch (name) {
      case "BS. Trần Thùy Dương":
        return 1;
      case "BS. Nguyễn Văn A":
        return 2;
      case "BS. Lê Thị B":
        return 3;
      default:
        return 1;
    }
  }

  Future<void> _confirmBooking() async {
    if (_maBenhNhan == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi: Không tìm thấy thông tin bệnh nhân. Vui lòng đăng nhập lại."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Format ngày hẹn sang YYYY-MM-DD
    final String ngayHen = "${widget.selectedDay.year}-${widget.selectedDay.month.toString().padLeft(2, '0')}-${widget.selectedDay.day.toString().padLeft(2, '0')}";
    
    // Format giờ hẹn sang HH:MM:SS
    String gioHen = widget.selectedTime;
    if (gioHen.split(':')[0].length == 1) {
      gioHen = "0$gioHen";
    }
    if (gioHen.split(':').length == 2) {
      gioHen = "$gioHen:00";
    }

    final int maBacSi = _getDoctorId(widget.doctorName);
    final String lyDo = "${widget.serviceName}: ${widget.reason.trim().isNotEmpty ? widget.reason.trim() : 'Đặt lịch khám qua ứng dụng'}";

    final success = await LichHenService.createAppointment(
      maBenhNhan: _maBenhNhan,
      maBacSi: maBacSi,
      ngayHen: ngayHen,
      gioHen: gioHen,
      lyDoKham: lyDo,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("Thành công", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text("Lịch hẹn của bạn đã được gửi thành công và đang chờ duyệt."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const TrangChu()),
                    (route) => false, // Xóa stack điều hướng về trang chủ
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi: Không thể kết nối tới máy chủ. Vui lòng thử lại sau."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Xác nhận lịch hẹn",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Thông báo
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffeaf4ff),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Vui lòng kiểm tra thông tin lịch hẹn trước khi xác nhận.",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Bác sĩ
                  _sectionCard(
                    title: "1. Thông tin bác sĩ",
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Chuyên khoa Răng Hàm Mặt",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lịch hẹn
                  _sectionCard(
                    title: "2. Thông tin lịch hẹn",
                    child: Column(
                      children: [
                        _infoRow(
                          Icons.medical_services,
                          "Dịch vụ khám",
                          widget.serviceName,
                        ),
                        const Divider(),
                        _infoRow(
                          Icons.calendar_month,
                          "Ngày khám",
                          "${widget.selectedDay.day}/${widget.selectedDay.month}/${widget.selectedDay.year}",
                        ),
                        const Divider(),
                        _infoRow(
                          Icons.access_time,
                          "Giờ khám",
                          "${widget.selectedTime} - $_endTime (${widget.duration} phút)",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lý do khám
                  _sectionCard(
                    title: "3. Lý do khám",
                    child: Text(
                      widget.reason.trim().isNotEmpty
                          ? widget.reason
                          : "(Không có lý do cụ thể)",
                      style: TextStyle(
                        fontStyle: widget.reason.trim().isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: widget.reason.trim().isEmpty
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Bệnh nhân
                  _sectionCard(
                    title: "4. Thông tin bệnh nhân",
                    child: Column(
                      children: [
                        _PatientInfo(
                          label: "Họ và tên",
                          value: _hoTen,
                        ),
                        const Divider(),
                        _PatientInfo(
                          label: "Số điện thoại",
                          value: _sdt,
                        ),
                        const Divider(),
                        _PatientInfo(
                          label: "Email",
                          value: _email,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _confirmBooking,
                      child: const Text(
                        "Xác nhận đặt lịch",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Quay lại chỉnh sửa",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1c3faa),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _PatientInfo extends StatelessWidget {
  final String label;
  final String value;

  const _PatientInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}