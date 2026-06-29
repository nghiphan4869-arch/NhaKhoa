class ApiConfig {
  // localhost đối với giả lập Android là 'http://10.0.2.2:3000'
  // Đối với thiết bị thật hoặc iOS là 'http://localhost:3000'
  static const String domain = 'http://10.0.2.2:3000';
  
  static const String taiKhoanUrl = '$domain/api/tai-khoan';
  static const String benhNhanUrl = '$domain/api/benh-nhan';
  static const String lichHenUrl = '$domain/api/lich-hen';
  static const String dichVuUrl = '$domain/api/dich-vu';
}
