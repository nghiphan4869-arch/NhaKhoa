import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import '../widgets/bottom_nav.dart';
import 'package:nhakhoa/services/benh_an_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DieuTri extends StatefulWidget {
  const DieuTri({super.key});

  @override
  State<DieuTri> createState() => _DieuTriState();
}

class _DieuTriState extends State<DieuTri> {
  List<dynamic> _medicalRecords = [];
  bool _isLoading = true;
  int? _maBenhNhan;

  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }

  Future<void> _loadMedicalRecords() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBn = prefs.getInt('maBenhNhan');
      if (maBn != null && maBn > 0) {
        _maBenhNhan = maBn;
        final list = await BenhAnService.getBenhAnByPatient(maBn);
        setState(() {
          _medicalRecords = list;
        });
      } else {
        setState(() {
          _maBenhNhan = null;
        });
      }
    } catch (e) {
      print('Lỗi tải bệnh án: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Chưa cập nhật';
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

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
//Header
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Điều trị",
                      style: TextStyle(
                        fontSize: width * 0.08,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NhacLich(),),);
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                      ),
                    )
                  ],
                ),

                Text(
                  "Theo dõi quá trình điều trị và kế hoạch của bạn",
                  style: TextStyle(
                    color: Colors.grey,
                     fontSize: width * 0.035,
                  ),
                ),

                const SizedBox(height: 20),
//Kế hoạch điều trị
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffeef5ff),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.blue.shade100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kế hoạch điều trị hiện tại",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: width * 0.03,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              _medicalRecords.isNotEmpty
                                  ? (_medicalRecords.first['ChanDoan'] ?? 'Khám & Điều trị')
                                  : "Không có kế hoạch điều trị",
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size:  width * 0.03,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _medicalRecords.isNotEmpty
                                      ? "Ngày lập: ${_formatDate(_medicalRecords.first['NgayLap'])}"
                                      : "Chưa bắt đầu",
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),
//Tab
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        labelStyle: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: width * 0.035,
                        ),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        tabs: const [
                          Tab(text: "Tổng quan"),
                          Tab(text: "Lịch điều trị"),
                          Tab(text: "Hồ sơ "),
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TabBarView(
                          children: [
                            _tongQuan(),
                            _lichDieuTri(),
                            _hoSoDieuTri(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar:
          const BottomNav(
        currentIndex: 1,
      ),
    );
  }
  Widget _tongQuan() {
    if (_medicalRecords.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Chưa có thông tin tiến trình điều trị",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Column(
      children: [

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xfff8fbff),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tiến độ điều trị",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "60% hoàn thành",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Chuẩn bị"),
                  Text("Đang điều trị"),
                  Text("Hoàn tất"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xfff8fbff),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child:  Center(
                  child: Text(
                    "28",
                    style: TextStyle(
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "15:30 - BS.ABC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Tái khám và điều chỉnh mắc cài",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding:
              const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xfff8fbff),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _info(
                "Phương pháp điều trị",
                _medicalRecords.isNotEmpty
                    ? (_medicalRecords.first['ChanDoan'] ?? 'Khám & Điều trị')
                    : "Chưa bắt đầu",
              ),
              _info(
                "Số bệnh án ghi nhận",
                "${_medicalRecords.length} bệnh án",
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xfff8fbff),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
            title: const Text(
              "BS. ABC",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Chỉnh nha",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade100,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.message_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green.shade100,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _lichDieuTri() {
    if (_medicalRecords.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Chưa có lịch trình điều trị",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    final chronList = _medicalRecords.reversed.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chronList.length,
      itemBuilder: (context, index) {
        final record = chronList[index];
        final ngayLap = _formatDate(record['NgayLap'] ?? '');
        final title = index == 0
            ? "Thăm khám & Chẩn đoán"
            : "Điều trị: ${record['ChanDoan'] ?? 'Khám định kỳ'}";

        return _treatmentItem(
          "$title ($ngayLap)",
          true,
        );
      },
    );
  }
//TAB HỒ SƠ ĐIỀU TRỊ
  Widget _hoSoDieuTri() {
    if (_medicalRecords.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: Text(
                "Chưa có bệnh án nào ghi nhận",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _medicalRecords.length,
      itemBuilder: (context, index) {
        final record = _medicalRecords[index];
        final ngayLap = _formatDate(record['NgayLap'] ?? '');
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bệnh án #${record['MaBenhAn']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ngayLap,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                const Text(
                  "Chẩn đoán:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(record['ChanDoan'] ?? 'Chưa ghi nhận'),
                const SizedBox(height: 12),
                const Text(
                  "Kết quả điều trị:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(record['KetQuaDieuTri'] ?? 'Đang trong quá trình theo dõi & điều trị'),
              ],
            ),
          ),
        );
      },
    );
  }
//Hàm phụ
  Widget _info(String title, String value) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.grey,
                fontSize: width * 0.035,
              ),
            ),
          ],
        ),
      );
    },
  );
}
  Widget _card(String title, String content) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xfff8fbff),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

  Widget _treatmentItem(
    String title,
    bool done,
  ) {
    return Card(
      color: const Color(0xfff8fbff),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          Icons.event_note,
          color: done ? Colors.green : Colors.blue,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text("BS. ABC"),
        trailing: done
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(
                Icons.access_time,
                color: Colors.orange,
              ),
      ),
    );
  }
}