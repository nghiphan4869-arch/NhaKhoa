import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import '../widgets/bottom_nav.dart';

class DieuTri extends StatefulWidget {
  const DieuTri({super.key});

  @override
  State<DieuTri> createState() => _DieuTriState();
}


class _DieuTriState extends State<DieuTri> {


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
                              "Niềng răng chỉnh nha",
                              style: TextStyle(
                                fontSize: width * 0.055,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size:  width * 0.03,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Bắt đầu: 27/05/2026",
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
//TAB TỔNG QUAN
  Widget _tongQuan() {
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
                "Niềng răng mắc cài kim loại",
              ),
              _info(
                "Tổng số buổi dự kiến",
                "24 buổi",
              ),
              _info(
                "Số buổi đã thực hiện",
                "1/24 buổi",
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
//TAB LỊCH ĐIỀU TRỊ
  Widget _lichDieuTri() {
    return Column(
      children: [
        _treatmentItem(
          "Thăm khám và chuẩn đoán",
          true,
        ),
        _treatmentItem(
          "Lập kế hoạch điều trị",
          true,
        ),
        _treatmentItem(
          "Đang điều trị",
          false,
        ),
        _treatmentItem(
          "Điều chỉnh mắc cài lần 1",
          false,
        ),
      ],
    );
  }
//TAB HỒ SƠ ĐIỀU TRỊ
  Widget _hoSoDieuTri() {
    return Column(
      children: [

        Container(
          padding:
              const EdgeInsets.all(15),
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
          child: const Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.calendar_month,
                      color: Colors.blue),
                  Text("24"),
                  Text("Tổng số buổi"),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.green),
                  Text("14"),
                  Text("Đã thực hiện"),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.access_time,
                      color: Colors.orange),
                  Text("10"),
                  Text("Còn lại"),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        _card(
          "Chuẩn đoán",
          "Răng hô nhẹ, khớp cắn hạng III do sai lệch răng.",
        ),

        const SizedBox(height: 10),

        _card(
          "Phương pháp điều trị",
          "Niềng răng mắc cài kim loại",
        ),

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