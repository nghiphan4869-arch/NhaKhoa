import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class BenhAnService {
  static const String baseUrl = ApiConfig.benhAnUrl;

  /// Lấy danh sách bệnh án theo mã bệnh nhân
  static Future<List<dynamic>> getBenhAnByPatient(int maBenhNhan) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/benhnhan/$maBenhNhan'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách bệnh án: $e');
      return [];
    }
  }
}
