import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';

class HuyLichHen extends StatefulWidget {
  const HuyLichHen({super.key});

  @override
  State<HuyLichHen> createState() => _HuyLichHenState();
}

class _HuyLichHenState extends State<HuyLichHen> {

  int selectedIndex = 0;

  final reasons = [
    {
      "icon": Icons.calendar_month,
      "title": "Không sắp xếp được thời gian",
      "color": Colors.blue,
    },
    {
      "icon": Icons.sentiment_dissatisfied,
      "title": "Sức khỏe không đảm bảo",
      "color": Colors.purple,
    },
    {
      "icon": Icons.car_repair,
      "title": "Có việc đột xuất",
      "color": Colors.orange,
    },
    {
      "icon": Icons.flight,
      "title": "Đi công tác / du lịch",
      "color": Colors.green,
    },
    {
      "icon": Icons.more_horiz,
      "title": "Lý do khác",
      "color": Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {

    Widget _infoRow(
      IconData icon,
      String text,
    ) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Icon(
              icon,
              size: 18,
              color: Colors.grey[700],
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),

        title: const Text(
          "Hủy lịch hẹn",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Center(
              child: Text(
                "Vui lòng xác nhận thông tin và lý do hủy lịch hẹn.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height:25),

            /// THÔNG TIN LỊCH
            const Text(
              "Thông tin lịch hẹn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height:15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.03),
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(
                children: [

                  /// Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          size: 38,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Điều chỉnh mắc cài lần 4",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: const Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Đã xác nhận",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 10),

                  _infoRow(
                    Icons.person_outline,
                    "BS. Nguyễn Minh Anh",
                  ),

                  _infoRow(
                    Icons.calendar_today,
                    "Thứ 4, 29/05/2024",
                  ),

                  _infoRow(
                    Icons.access_time,
                    "09:00 - 09:30",
                  ),

                  _infoRow(
                    Icons.location_on_outlined,
                    "Smile Care - Cơ sở 1\n123 Nguyễn Trãi, Q1, TP.HCM",
                  ),
                ],
              ),
            ),

            
            const SizedBox(height:15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.blue.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const DatLichHen(),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.blue,
                ),

                label: const Text(
                  "Chọn lịch khác",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height:20),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: const Row(
                children: [

                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  SizedBox(width:10),

                  Expanded(
                    child: Text(
                      "Bạn có thể hủy lịch hẹn trước ít nhất 2 giờ.",
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height:25),

            const Text(
              "Lý do hủy lịch hẹn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height:15),

            ...List.generate(
              reasons.length,
              (index) {

                final item = reasons[index];

                bool selected =
                    selectedIndex == index;

                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                  },

                  child: Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    padding:
                        const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                              20),

                      border: Border.all(
                        color: selected
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),

                    child: Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              (item["color"] as Color)
                                  .withOpacity(.1),

                          child: Icon(
                            item["icon"] as IconData,
                            color:
                                item["color"] as Color,
                          ),
                        ),

                        const SizedBox(width:15),

                        Expanded(
                          child: Text(
                            item["title"]
                                as String,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),

                        Radio(
                          value: index,
                          groupValue:
                              selectedIndex,

                          onChanged: (value){
                            setState(() {
                              selectedIndex =
                                  value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height:20),

            const Text(
              "Ghi chú thêm (không bắt buộc)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height:10),

            TextField(
              maxLines: 4,
              maxLength: 200,

              decoration: InputDecoration(
                hintText:
                    "Nhập ghi chú của bạn...",

                filled: true,
                fillColor: Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Container(
              padding:
                  const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                      ),
                      SizedBox(width:10),
                      Text(
                        "Lưu ý",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height:10),

                  Text(
                      "• Lịch hẹn sẽ được hủy sau khi xác nhận"),

                  SizedBox(height:5),

                  Text(
                      "• Bạn có thể đặt lịch mới bất kỳ lúc nào")
                ],
              ),
            ),

            const SizedBox(height:25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            30),
                  ),
                ),

                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        title: const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Xác nhận hủy",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        content: const Text(
                          "Bạn có chắc chắn muốn hủy lịch hẹn này không?",
                        ),

                        actions: [

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Quay lại",
                            ),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                            ),

                            onPressed: () {

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Đã hủy lịch hẹn thành công",
                                  ),
                                  backgroundColor:
                                      Colors.green,
                                ),
                              );
                            },

                            child: const Text(
                              "Xác nhận",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),

                label: const Text(
                  "Xác nhận hủy lịch",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height:15),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: OutlinedButton(
                style:
                    OutlinedButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            30),
                  ),
                ),

                onPressed: (){
                  Navigator.pop(context);
                },

                child: const Text(
                  "Quay lại",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}