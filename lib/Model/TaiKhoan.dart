class TaiKhoan {
  final int maTaiKhoan;
  final String tenDangNhap;

  TaiKhoan({
    required this.maTaiKhoan,
    required this.tenDangNhap,
  });

  factory TaiKhoan.fromJson(Map<String, dynamic> json) {
    return TaiKhoan(
      maTaiKhoan: json['MaTaiKhoan'],
      tenDangNhap: json['TenDangNhap'],
    );
  }
}