import 'package:flutter/material.dart';
import 'package:nhakhoa/services/auth_service.dart';

class DatLaiMatKhau extends StatefulWidget {
  final String emailOrPhone;

  const DatLaiMatKhau({
    super.key,
    required this.emailOrPhone,
  });

  @override
  State<DatLaiMatKhau> createState() =>
      _DatLaiMatKhauState();
}

class _DatLaiMatKhauState
    extends State<DatLaiMatKhau> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool _isLoading = false;

  void _submitReset() async {
    final password = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu tối thiểu phải từ 6 ký tự trở lên')),
      );
      return;
    }

    if (password.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không được chứa khoảng trắng')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.resetPassword(widget.emailOrPhone, password);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đổi mật khẩu thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          // Quay về màn hình đầu tiên (Login)
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đặt lại mật khẩu thất bại. Vui lòng thử lại sau.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối máy chủ: $e'),
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

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                  "Đặt lại mật khẩu",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b3f99),
                  ),
                ),

                const SizedBox(height: 30),

                /// Icon thành công
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfff3f8ff),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Xác thực thành công!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Vui lòng đặt mật khẩu mới.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                /// Form
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafcff),
                    borderRadius:
                        BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      /// Mật khẩu mới
                      TextField(
                        controller: _newPasswordController,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText:
                              "Mật khẩu mới",
                          hintText:
                              "Nhập mật khẩu mới",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword =
                                    !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons
                                      .visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Xác nhận mật khẩu
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText:
                            hideConfirmPassword,
                        decoration: InputDecoration(
                          labelText:
                              "Xác nhận mật khẩu",
                          hintText:
                              "Nhập lại mật khẩu",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword =
                                    !hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons
                                      .visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Điều kiện mật khẩu
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xfff4f8ff),
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),
                        child: const Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .check_circle,
                                  color:
                                      Colors.green,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Tối thiểu 6 ký tự",
                                ),
                              ],
                            ),



                            SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .check_circle,
                                  color:
                                      Colors.green,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Không chứa khoảng trắng",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Nút đổi mật khẩu
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xff4b5fb5),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submitReset,
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
                            "Đổi mật khẩu",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}