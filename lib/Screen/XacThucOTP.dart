import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLaiMatKhau.dart';
import 'package:nhakhoa/services/auth_service.dart';

class XacThucOTP extends StatefulWidget {
  final String email;

  const XacThucOTP({
    super.key,
    required this.email,
  });

  @override
  State<XacThucOTP> createState() => _XacThucOTPState();
}

class _XacThucOTPState extends State<XacThucOTP> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  Timer? _countdownTimer;
  int _resendCountdown = 60;
  int _expireCountdown = 120; // 2 phút

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _expireCountdown = 120;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          }
          if (_expireCountdown > 0) {
            _expireCountdown--;
          } else {
            _countdownTimer?.cancel();
          }
        });
      } else {
        _countdownTimer?.cancel();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void _verifyOtp() async {
    if (_expireCountdown == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã OTP đã hết hạn. Vui lòng gửi lại mã mới.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ 6 chữ số OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isCorrect = await AuthService.verifyOtp(widget.email, enteredOtp);
      if (isCorrect) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xác thực OTP thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatLaiMatKhau(
                emailOrPhone: widget.email,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mã OTP không chính xác, vui lòng thử lại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối đến máy chủ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final res = await AuthService.requestOtp(widget.email);
      if (res['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mã OTP mới đã được gửi về Gmail của bạn!'),
              backgroundColor: Colors.green,
            ),
          );
          _startCountdown();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gửi lại OTP thất bại. Vui lòng thử lại sau.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

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
                  "Mã xác thực đã được gửi đến email",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 20,
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
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _focusNodes[index].unfocus();
                            }
                          } else {
                            if (index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    children: [
                      const TextSpan(
                        text: "Mã OTP sẽ hết hạn sau ",
                      ),
                      TextSpan(
                        text: _formatTime(_expireCountdown),
                        style: TextStyle(
                          color: _expireCountdown > 0 ? Colors.blue : Colors.red,
                          fontWeight: FontWeight.bold,
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
                    "Nếu bạn không nhận được mã,\nvui lòng kiểm tra lại địa chỉ Gmail hoặc gửi lại mã mới.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextButton(
                  onPressed: _resendCountdown == 0 && !_isLoading ? _resendOtp : null,
                  child: Text(
                    _resendCountdown > 0
                        ? "Gửi lại OTP (${_resendCountdown}s)"
                        : "Gửi lại OTP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _resendCountdown > 0 ? Colors.grey : const Color(0xff1b3f99),
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
                    onPressed: _isLoading || _expireCountdown == 0 ? null : _verifyOtp,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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