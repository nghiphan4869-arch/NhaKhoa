import 'package:flutter/material.dart';

class XacNhanLichHen extends StatelessWidget {

  final DateTime selectedDay;
  final String selectedTime;
  final String doctorName;
  final String serviceName;
  final String reason;

  const XacNhanLichHen({
    super.key,
    required this.selectedDay,
    required this.selectedTime,
    required this.doctorName,
    required this.serviceName,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
       backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Xác nhận lịch hẹn",
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
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
                    serviceName,
                  ),
                  const Divider(),
                  _infoRow(
                    Icons.calendar_month,
                    "Ngày khám",
                    "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                  ),
                  const Divider(),
                  _infoRow(
                    Icons.access_time,
                    "Giờ khám",
                    selectedTime,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Lý do khám
            _sectionCard(
              title: "3. Lý do khám",
              child: Text(reason),
            ),

            const SizedBox(height: 15),

            // Bệnh nhân
            _sectionCard(
              title: "4. Thông tin bệnh nhân",
              child: Column(
                children: const [
                  _PatientInfo(
                    label: "Họ và tên",
                    value: "Nguyễn Văn An",
                  ),
                  Divider(),
                  _PatientInfo(
                    label: "Số điện thoại",
                    value: "0123456789",
                  ),
                  Divider(),
                  _PatientInfo(
                    label: "Email",
                    value: "nguyenvanan@gmail.com",
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
                  backgroundColor:Colors.blue,
                ),
                onPressed: () {},
                child: const Text(
                  "Xác nhận đặt lịch",
                  style: TextStyle(
                    color: Colors.white,
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
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
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