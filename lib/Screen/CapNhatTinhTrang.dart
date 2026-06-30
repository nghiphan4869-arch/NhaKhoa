import 'package:flutter/material.dart';

class CapNhatTinhTrang extends StatefulWidget {
  const CapNhatTinhTrang({super.key});

  @override
  State<CapNhatTinhTrang> createState() =>
      _CapNhatTinhTrangState();
}

class _CapNhatTinhTrangState
    extends State<CapNhatTinhTrang> {

  final moTaController =
      TextEditingController();

  final ghiChuController =
      TextEditingController();

  DateTime selectedDate =
      DateTime.now();

  TimeOfDay selectedTime =
      TimeOfDay.now();

  String selectedLevel = "Nhẹ";

  List<String> symptoms = [
    "Đau",
    "Sưng",
    "Chảy máu",
    "Khó chịu",
    "Nhiễm trùng",
    "Khác"
  ];

  List<String> selectedSymptoms =
      [];

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('vi', 'VN'),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time =
        await showTimePicker(
      context: context,
      initialTime:
          selectedTime,
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(
              0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),

        title: const Text(
          "Cập nhật tình trạng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [

            /// card bệnh nhân
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xfff4f8ff),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.blue.shade50,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [

                  /// Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.green.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 15),

                  /// Thông tin
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Phan C",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A237E),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Mã bệnh nhân: 8",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6),
                            Text("0902691111"),
                          ],
                        ),

                        SizedBox(height: 5),

                        const Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "c@gmail.com",
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Logo
                  Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 70,
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Mô tả tình trạng",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
                height: 10),

            TextField(
              controller:
                  moTaController,
              maxLines: 4,

              decoration:
                  InputDecoration(
                hintText:
                    "Mô tả tình trạng hiện tại...",
                filled: true,
                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              15),
                  borderSide:
                      BorderSide
                          .none,
                ),
              ),
            ),

            const SizedBox(
                height: 25),

            const Text(
              "Mức độ",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
                height: 10),

            Wrap(
              spacing: 10,
              children: [
                "Không có",
                "Nhẹ",
                "Trung bình",
                "Nặng"
              ].map((e) {

                bool selected = selectedLevel == e;

                return ChoiceChip(
                  label: Text(
                    e,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  selected: selected,

                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey.shade100,

                  checkmarkColor: Colors.white,

                  onSelected: (_) {
                    setState(() {
                      selectedLevel = e;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(
                height: 25),

            const Text(
              "Triệu chứng",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
                height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: symptoms.map((e) {

                bool selected =
                    selectedSymptoms.contains(e);

                return FilterChip(
                  label: Text(
                    e,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  selected: selected,

                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey.shade100,

                  checkmarkColor: Colors.white,

                  onSelected: (value) {
                    setState(() {
                      value
                          ? selectedSymptoms.add(e)
                          : selectedSymptoms.remove(e);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(
                height: 25),

            const Text(
              "Thời gian bắt đầu",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
                height: 10),

            Row(
              children: [

                Expanded(
                  child:
                      GestureDetector(
                    onTap:
                        pickDate,

                    child:
                        _timeBox(
                      Icons
                          .calendar_month,
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                  ),
                ),

                const SizedBox(
                    width: 12),

                Expanded(
                  child:
                      GestureDetector(
                    onTap:
                        pickTime,

                    child:
                        _timeBox(
                      Icons
                          .access_time,
                      selectedTime
                          .format(
                              context),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
                height: 25),

            const Text(
              "Ghi chú",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(
                height: 10),

            TextField(
              controller:
                  ghiChuController,
              maxLines: 3,

              decoration:
                  InputDecoration(
                hintText:
                    "Nhập ghi chú thêm...",
                filled: true,
                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              15),
                  borderSide:
                      BorderSide
                          .none,
                ),
              ),
            ),

            const SizedBox(
                height: 30),

            SizedBox(
              width:
                  double.infinity,
              height: 55,

              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                          0xff1A73E8),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                ),

                onPressed:
                    () {},

                icon:
                    const Icon(
                  Icons.send,
                  color:
                      Colors.white,
                ),

                label:
                    const Text(
                  "Gửi cập nhật",
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _timeBox(
      IconData icon,
      String text) {
    return Container(
      padding:
          const EdgeInsets.all(
              15),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                15),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black12
                    .withOpacity(
                        .05),
            blurRadius: 8,
          )
        ],
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.blue,
          ),

          const SizedBox(
              width: 10),

          Text(text)
        ],
      ),
    );
  }
}