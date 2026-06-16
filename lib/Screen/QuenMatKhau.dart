import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/XacThucOTP.dart';

class QuenMatKhau extends StatelessWidget {
  const QuenMatKhau({super.key});

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

                /// Hình minh họa
                Image.asset(
                  "assets/matkhau.png",
                  width: 250,
                  height: 250,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Quên mật khẩu ?",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Đừng lo lắng! Chúng tôi sẽ giúp bạn\nđặt lại mật khẩu mới.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                /// Khung OTP
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nhập số điện thoại",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1b3f99),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Chúng tôi sẽ gửi OTP để xác\nthực tài khoản của bạn.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        keyboardType:
                            TextInputType.phone,
                        decoration: InputDecoration(
                          hintText:
                              "Nhập số điện thoại",
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                                    0xff4b5fb5),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const XacThucOTP(),),);
                          },
                          child: const Text(
                            "Gửi OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}