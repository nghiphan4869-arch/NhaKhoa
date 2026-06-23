import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Đường dẫn API (Sử dụng 10.0.2.2 cho máy ảo Android kết nối localhost của máy host)
  static const String baseUrl = 'http://10.0.2.2:3000/api/tai-khoan';

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
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final Map<String, dynamic> user = data.first;
          
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
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
}
