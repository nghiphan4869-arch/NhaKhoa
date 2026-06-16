import 'package:flutter/material.dart';

class PhanHoi extends StatefulWidget {
  const PhanHoi({super.key});

  @override
  State<PhanHoi> createState() => _PhanHoiState();
}

class _PhanHoiState extends State<PhanHoi> {
  int rating = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Phản hồi",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Thông tin trải nghiệm
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin trải nghiệm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.event_note,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Lập kế hoạch điều trị",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "15:30 - 27/05/2026",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "BS. ABC",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Colors.green.shade100,
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),
                            child: const Text(
                              "Đã hoàn thành",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Xem chi tiết",
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Đánh giá
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Đánh giá",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 36,
                          color: index < rating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Chia sẻ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chia sẻ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText:
                          "Nhập cảm nhận chi tiết về dịch vụ, bác sĩ,...",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff1e88f5),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Gửi phản hồi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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