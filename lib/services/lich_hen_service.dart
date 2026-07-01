import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class LichHenService {
  static const String baseUrl = ApiConfig.lichHenUrl;

  /// Lấy danh sách dịch vụ hoạt động
  static Future<List<dynamic>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.dichVuUrl),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách dịch vụ: $e');
      return [];
    }
  }

  /// Lấy danh sách lịch hẹn của bệnh nhân
  static Future<List<dynamic>> getAppointmentsByPatient(int maBenhNhan) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/benhnhan/$maBenhNhan'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách lịch hẹn: $e');
      return [];
    }
  }

  /// Lấy danh sách lịch hẹn của bác sĩ
  static Future<List<dynamic>> getAppointmentsByDoctor(int maBacSi) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bacsi/$maBacSi'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách lịch hẹn bác sĩ: $e');
      return [];
    }
  }

  /// Lấy danh sách bác sĩ rảnh theo ngày
  static Future<List<dynamic>> getAvailableDoctors(String ngayHen) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bacsi-ranh?ngay=$ngayHen'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách bác sĩ rảnh: $e');
      return [];
    }
  }

  /// Đặt lịch hẹn mới
  static Future<String?> createAppointment({
    required int maBenhNhan,
    required int maBacSi,
    required String ngayHen,
    required String? gioHen,
    required String lyDoKham,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'MaBenhNhan': maBenhNhan,
          'MaBacSi': maBacSi,
          'NgayHen': ngayHen,
          'GioHen': gioHen,
          'LyDoKham': lyDoKham,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // Thành công
      } else {
        try {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          return data['message'] ?? data['error'] ?? 'Đặt lịch thất bại';
        } catch (_) {
          return 'Lỗi xử lý phản hồi từ server';
        }
      }
    } catch (e) {
      print('Lỗi đặt lịch hẹn: $e');
      return 'Không thể kết nối tới máy chủ. Vui lòng thử lại sau.';
    }
  }

  /// Hủy lịch hẹn
  static Future<bool> cancelAppointment(int maLichHen) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/huy/$maLichHen'),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi hủy lịch hẹn: $e');
      return false;
    }
  }
}
