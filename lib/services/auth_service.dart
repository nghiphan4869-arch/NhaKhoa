import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  // Đường dẫn API (Sử dụng local hoặc deploy)
  static const String baseUrl = ApiConfig.taiKhoanUrl;

  /// Gửi yêu cầu Đăng nhập lên server
  /// Trả về thông tin tài khoản nếu đăng nhập thành công, ngược lại trả về null
  static Future<Map<String, dynamic>?> login(String usernameOrEmailOrPhone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dang-nhap'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'TenDangNhap': usernameOrEmailOrPhone.trim(),
          'MatKhau': password,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic>? user;

        if (decoded is List) {
          if (decoded.isNotEmpty) {
            user = decoded.first as Map<String, dynamic>;
          }
        } else if (decoded is Map) {
          if (decoded.containsKey('user')) {
            user = decoded['user'] as Map<String, dynamic>;
          } else {
            user = decoded as Map<String, dynamic>;
          }
        }

        if (user != null) {
          // Lưu thông tin đăng nhập vào SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt('maTaiKhoan', user['MaTaiKhoan'] ?? 0);
          await prefs.setString('tenDangNhap', user['TenDangNhap'] ?? '');
          await prefs.setInt('maVaiTro', user['MaVaiTro'] ?? 1);
          
          // Lưu thông tin cá nhân động của bệnh nhân
          await prefs.setInt('maBenhNhan', user['MaBenhNhan'] ?? 0);
          await prefs.setString('hoTen', user['HoTen'] ?? 'Khách');
          await prefs.setString('email', user['Email'] ?? 'Chưa cập nhật');
          await prefs.setString('sdt', user['SDT'] ?? 'Chưa cập nhật');
          await prefs.setString('ngaySinh', user['NgaySinh'] ?? 'Chưa cập nhật');
          await prefs.setString('gioiTinh', user['GioiTinh'] ?? 'Chưa cập nhật');
          await prefs.setString('diaChi', user['DiaChi'] ?? 'Chưa cập nhật');
          await prefs.setString('hinhAnh', user['HinhAnh'] ?? '');
          
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Lỗi kết nối API đăng nhập: $e');
      rethrow; // Ném lỗi ra ngoài để UI xử lý thông báo lỗi mạng
    }
  }

  /// Gửi yêu cầu Đăng ký lên server
  static Future<bool> register({
    required String hoTen,
    required String email,
    required String sdt,
    required String matKhau,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dang-ky'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'HoTen': hoTen,
          'Email': email,
          'SDT': sdt,
          'MatKhau': matKhau,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['message'] == 'Đăng ký thành công') {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Lỗi kết nối API đăng ký: $e');
      rethrow;
    }
  }

  /// Gửi yêu cầu Thay đổi mật khẩu lên server
  static Future<Map<String, dynamic>> changePassword({
    required int maTaiKhoan,
    required String matKhauCu,
    required String matKhauMoi,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/doi-mat-khau'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'MaTaiKhoan': maTaiKhoan,
          'MatKhauCu': matKhauCu,
          'MatKhauMoi': matKhauMoi,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Đổi mật khẩu thành công'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Đổi mật khẩu thất bại'};
      }
    } catch (e) {
      print('Lỗi kết nối API đổi mật khẩu: $e');
      return {'success': false, 'message': 'Không thể kết nối đến máy chủ'};
    }
  }

  /// Đăng xuất - xóa thông tin phiên đăng nhập
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Kiểm tra xem người dùng đã đăng nhập trước đó chưa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Gửi yêu cầu lấy mã OTP về Gmail
  static Future<Map<String, dynamic>> requestOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quen-mat-khau'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'TenDangNhap': email.trim(),
        }),
      );

      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Mã OTP đã được gửi.'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Không thể gửi mã OTP.'};
      }
    } catch (e) {
      print('Lỗi kết nối API quên mật khẩu: $e');
      return {'success': false, 'message': 'Lỗi kết nối máy chủ'};
    }
  }

  /// Xác thực mã OTP qua backend
  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/xac-thuc-otp'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'Email': email.trim(),
          'OTP': otp.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Lỗi kết nối API xác thực OTP: $e');
      return false;
    }
  }

  /// Đặt lại mật khẩu mới
  static Future<bool> resetPassword(String emailOrPhone, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/dat-lai-mat-khau'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'TenDangNhap': emailOrPhone.trim(),
          'MatKhauMoi': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'Đổi mật khẩu thành công') {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Lỗi đặt lại mật khẩu: $e');
      rethrow;
    }
  }
}
