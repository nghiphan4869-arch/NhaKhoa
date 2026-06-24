import 'dart:convert';
import 'package:http/http.dart' as http;

class LichHenService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/lich-hen';

  /// Lấy danh sách dịch vụ hoạt động
  static Future<List<dynamic>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/dich-vu'),
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

  /// Đặt lịch hẹn mới
  static Future<bool> createAppointment({
    required int maBenhNhan,
    required int maBacSi,
    required String ngayHen,
    required String gioHen,
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

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi đặt lịch hẹn: $e');
      return false;
    }
  }
}
