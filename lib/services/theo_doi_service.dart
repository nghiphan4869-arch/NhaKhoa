import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TheoDoiService {
  static const String baseUrl = ApiConfig.theoDoiUrl;

  /// Lấy hoặc tạo phiếu theo dõi sức khỏe cho một lịch hẹn đã hoàn thành
  static Future<Map<String, dynamic>?> getOrCreateTrackingSheet(int maLichHen) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lich-hen/$maLichHen'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }
      return null;
    } catch (e) {
      print('Lỗi lấy/tạo phiếu theo dõi sức khỏe: $e');
      return null;
    }
  }

  /// Gửi phản hồi tình trạng sức khỏe
  static Future<bool> sendFeedback({
    required int maTheoDoi,
    required int mucDoDau,
    required String tinhTrangSauDungThuoc,
    required String phanHoiBenhNhan,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/phan-hoi/$maTheoDoi'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'MucDoDau': mucDoDau,
          'TinhTrangSauDungThuoc': tinhTrangSauDungThuoc,
          'PhanHoiBenhNhan': phanHoiBenhNhan,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi gửi phản hồi sức khỏe: $e');
      return false;
    }
  }
}
