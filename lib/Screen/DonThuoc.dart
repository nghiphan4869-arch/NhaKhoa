import 'package:flutter/material.dart';

class DonThuoc extends StatelessWidget {
  const DonThuoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Đơn thuốc",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff1A237E),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            /// THÔNG TIN BỆNH NHÂN
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0,4),
                  )
                ],
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        Colors.blue.shade100,

                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width:15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Nguyễn Minh Anh",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height:5),

                        Text(
                          "BN-000123",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height:8),

                        Text(
                          "15/05/1995 • Nữ • 29 tuổi",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color:
                          Colors.blue.shade50,

                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),

                    child: const Column(
                      children: [

                        Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        SizedBox(height:5),

                        Text(
                          "15/05/2024",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text("09:30")
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height:20),

            /// BÁC SĨ ĐIỀU TRỊ
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.04),
                    blurRadius: 10,
                  )
                ],
              ),

              child: Column(
                children: [

                  Row(
                    children: [

                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green.shade100,

                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width:15),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Bác sĩ điều trị",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "BS. Nguyễn Minh Anh",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,

                        children: [

                          Text(
                            "Khoa",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          SizedBox(height:5),

                          Text(
                            "Nha tổng quát",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Divider(),
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Chẩn đoán",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height:8),

                        Text(
                          "Răng hô nhẹ, khớp cắn hạng III do sai lệch răng.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height:20),

            /// DANH SÁCH THUỐC
            Container(
              padding:
                  const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black12.withOpacity(.04),
                    blurRadius: 10,
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Thuốc được kê",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:15),

                  /// HEADER TABLE
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),

                    child: const Row(
                      children: [

                        SizedBox(
                          width: 30,
                          child: Text(""),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            "Thuốc",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            "Cách dùng",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "SL",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height:10),

                  _thuoc(
                    "1",
                    "Amoxicillin 500mg",
                    "1 viên/lần\nNgày 2 lần",
                    "1 hộp",
                  ),

                  Divider(),

                  _thuoc(
                    "2",
                    "Ibuprofen 400mg",
                    "1 viên/lần\nSau ăn",
                    "1 hộp",
                  ),

                  Divider(),

                  _thuoc(
                    "3",
                    "Metronidazole",
                    "1 viên/lần\nSau ăn",
                    "1 hộp",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thuoc(
    String stt,
    String ten,
    String cachDung,
    String soLuong,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 30,
            child: Text(stt),
          ),

          Expanded(
            flex: 3,
            child: Text(
              ten,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              cachDung,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              soLuong,
            ),
          )
        ],
      ),
    );
  }
}