import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'DangNhap.dart';
import 'XacNhanMatKhauMoi.dart';

class DoiMatKhau extends StatefulWidget {
  const DoiMatKhau({super.key});

  @override
  State<DoiMatKhau> createState() => _DoiMatKhauState();
}

class _DoiMatKhauState extends State<DoiMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;
  int? _maTaiKhoan;

  @override
  void initState() {
    super.initState();
    _loadMaTaiKhoan();
  }

  Future<void> _loadMaTaiKhoan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _maTaiKhoan = prefs.getInt('maTaiKhoan');
      });
    } catch (e) {
      print('Lỗi tải mã tài khoản: $e');
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_maTaiKhoan == null || _maTaiKhoan == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi: Không tìm thấy phiên đăng nhập. Vui lòng đăng nhập lại."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentPw = _currentPasswordController.text;
    final newPw = _newPasswordController.text;

    if (currentPw == newPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mật khẩu mới không được trùng với mật khẩu cũ!"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.changePassword(
        maTaiKhoan: _maTaiKhoan!,
        matKhauCu: currentPw,
        matKhauMoi: newPw,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;
        
        // Show success alert and pop back to previous screen
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  "Thành công",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              "Đổi mật khẩu thành công!",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx); // Đóng dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XacNhanMatKhauMoi(
                        newPassword: newPw,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Đồng ý",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Có lỗi xảy ra, vui lòng thử lại."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi kết nối tới hệ thống. Vui lòng kiểm tra lại."),
          backgroundColor: Colors.red,
        ),
      );
    }
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

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  /// nút quay lại
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff1b3f99),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// tiêu đề
                  const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1b3f99),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// icon
                  Container(
                    width: 120,
                    height: 120,

                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xfff3f8ff),
                    ),

                    child: const Icon(
                      Icons.lock_reset,
                      color: Colors.blue,
                      size: 70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Bảo mật tài khoản",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Thay đổi mật khẩu định kỳ giúp bảo vệ tài khoản tốt hơn",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// FORM
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

                        _buildPasswordField(
                          controller:
                              _currentPasswordController,

                          label:
                              "Mật khẩu hiện tại",

                          icon:
                              Icons.lock_outline,

                          obscure:
                              _hideCurrentPassword,

                          onTap: (){
                            setState(() {
                              _hideCurrentPassword =
                                  !_hideCurrentPassword;
                            });
                          },

                          validator: (value){
                            if(value == null ||
                                value.isEmpty){
                              return "Nhập mật khẩu hiện tại";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height:20),

                        _buildPasswordField(
                          controller:
                              _newPasswordController,

                          label:
                              "Mật khẩu mới",

                          icon:
                              Icons.lock_reset,

                          obscure:
                              _hideNewPassword,

                          onTap: (){
                            setState(() {
                              _hideNewPassword =
                                  !_hideNewPassword;
                            });
                          },

                          validator: (value){
                            if(value == null ||
                                value.isEmpty){
                              return "Nhập mật khẩu mới";
                            }

                            if(value.length < 6){
                              return "Mật khẩu phải tối thiểu 6 ký tự";
                            }

                            if(value.contains(' ')){
                              return "Mật khẩu không được chứa khoảng trắng";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height:20),

                        _buildPasswordField(
                          controller:
                              _confirmPasswordController,

                          label:
                              "Xác nhận mật khẩu",

                          icon:
                              Icons.verified_user_outlined,

                          obscure:
                              _hideConfirmPassword,

                          onTap: (){
                            setState(() {
                              _hideConfirmPassword =
                                  !_hideConfirmPassword;
                            });
                          },

                          validator: (value){
                            if(value !=
                                _newPasswordController.text){
                              return "Mật khẩu không khớp";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height:30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                      ),

                      onPressed: _isLoading
                          ? null
                          : _handleChangePassword,

                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Cập nhật mật khẩu",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget input password
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onTap,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),

        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(
            obscure
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),

        filled: true,
        fillColor: const Color(0xfff5f7fb),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

