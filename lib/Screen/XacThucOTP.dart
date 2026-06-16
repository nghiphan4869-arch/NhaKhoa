import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLaiMatKhau.dart';

class XacThucOTP extends StatelessWidget {
  const XacThucOTP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                /// Nút quay lại
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff1b3f99),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Tiêu đề
                const Text(
                  "Quên mật khẩu ?",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Mã xác thực đã được gửi đến số",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "0123 456 789",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),

                const SizedBox(height: 35),

                /// Ảnh OTP
                Image.asset(
                  "assets/email.png",
                  width: 130,
                ),

                const SizedBox(height: 25),

                const Text(
                  "Nhập mã OTP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),

                const SizedBox(height: 25),

                /// OTP BOX
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 45,
                      height: 55,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType:
                            TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Mã OTP sẽ hết hạn sau ",
                      ),
                      TextSpan(
                        text: "09:30",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// Thông báo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffeaf3ff),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Nếu bạn không nhận được mã,\nvui lòng kiểm tra lại số điện thoại hoặc gửi lại mã mới.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Gửi lại OTP (1:00)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1b3f99),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff4b5fb5),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DatLaiMatKhau(),),);
                    },
                    child: const Text(
                      "Xác nhận",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}