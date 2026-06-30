import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nhakhoa/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CapNhatThongTin extends StatefulWidget {
  final Map<String, dynamic>? patientData;
  const CapNhatThongTin({super.key, this.patientData});

  @override
  State<CapNhatThongTin> createState() => _CapNhatThongTinState();
}

class _CapNhatThongTinState extends State<CapNhatThongTin> {
  late final TextEditingController hoTenController;
  late final TextEditingController sdtController;
  late final TextEditingController emailController;
  late final TextEditingController diaChiController;
  late final TextEditingController ngaySinhController;
  String gioiTinh = "Nam";
  bool _isSaving = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với dữ liệu hiện tại (nếu có)
    hoTenController = TextEditingController(text: widget.patientData?['HoTen'] ?? '');
    sdtController = TextEditingController(text: widget.patientData?['SDT'] ?? '');
    emailController = TextEditingController(text: widget.patientData?['Email'] ?? '');
    diaChiController = TextEditingController(text: widget.patientData?['DiaChi'] ?? '');

    String rawNgaySinh = widget.patientData?['NgaySinh'] ?? '';
    String formattedNgaySinh = '';
    if (rawNgaySinh.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawNgaySinh).toLocal();
        formattedNgaySinh = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      } catch (_) {
        if (rawNgaySinh.contains('T')) {
          rawNgaySinh = rawNgaySinh.split('T')[0];
        }
        final parts = rawNgaySinh.split('-');
        if (parts.length == 3) {
          formattedNgaySinh = '${parts[2]}/${parts[1]}/${parts[0]}';
        } else {
          formattedNgaySinh = rawNgaySinh;
        }
      }
    }
    ngaySinhController = TextEditingController(text: formattedNgaySinh);

    final String rawGioiTinh = widget.patientData?['GioiTinh'] ?? 'Nam';
    if (rawGioiTinh == "Nam" || rawGioiTinh == "Nữ") {
      gioiTinh = rawGioiTinh;
    } else {
      gioiTinh = "Nam";
    }
  }

  @override
  void dispose() {
    hoTenController.dispose();
    sdtController.dispose();
    emailController.dispose();
    diaChiController.dispose();
    ngaySinhController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Cập nhật ảnh đại diện',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xff4b5fb5)),
                title: const Text('Chọn ảnh từ thư viện'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _pickedImage = File(image.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xff4b5fb5)),
                title: const Text('Chụp ảnh mới bằng camera'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _pickedImage = File(image.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    
    // Thử parse ngày sinh hiện tại nếu hợp lệ
    final String currentText = ngaySinhController.text.trim();
    if (currentText.isNotEmpty) {
      try {
        final parts = currentText.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {
        // Bỏ qua nếu parse lỗi
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() {
        ngaySinhController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _saveChanges() async {
    final String hoTen = hoTenController.text.trim();
    final String sdt = sdtController.text.trim();
    final String email = emailController.text.trim();
    final String diaChi = diaChiController.text.trim();
    final String ngaySinhRaw = ngaySinhController.text.trim();
    String ngaySinh = '';
    if (ngaySinhRaw.isNotEmpty) {
      final parts = ngaySinhRaw.split('/');
      if (parts.length == 3) {
        ngaySinh = '${parts[2]}-${parts[1]}-${parts[0]}';
      } else {
        ngaySinh = ngaySinhRaw;
      }
    }

    if (hoTen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền họ tên")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final maBenhNhan = prefs.getInt('maBenhNhan') ?? 0;

      if (maBenhNhan == 0) {
        throw Exception("Không tìm thấy mã bệnh nhân");
      }

      // Upload avatar nếu có ảnh mới
      if (_pickedImage != null) {
        final uploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConfig.benhNhanUrl}/$maBenhNhan/upload-avatar'),
        );
        uploadRequest.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            _pickedImage!.path,
          ),
        );
        final streamedResponse = await uploadRequest.send();
        final uploadResponse = await http.Response.fromStream(streamedResponse);
        if (uploadResponse.statusCode != 200 && uploadResponse.statusCode != 201) {
          final errorData = jsonDecode(uploadResponse.body);
          throw Exception(errorData['message'] ?? 'Không thể upload ảnh đại diện');
        }
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.benhNhanUrl}/$maBenhNhan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'HoTen': hoTen,
          'Email': email.isEmpty ? null : email,
          'SDT': sdt,
          'NgaySinh': ngaySinh.isEmpty ? null : ngaySinh,
          'GioiTinh': gioiTinh,
          'DiaChi': diaChi.isEmpty ? null : diaChi,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật thông tin thành công")),
          );
          Navigator.pop(context, true); // Trả về true để reload trang trước
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Không thể cập nhật hồ sơ');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Lỗi cập nhật'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Cập nhật thông tin",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Avatar
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : (widget.patientData?['HinhAnh'] != null
                            ? NetworkImage(widget.patientData!['HinhAnh'].toString().startsWith('http')
                                ? widget.patientData!['HinhAnh'].toString()
                                : '${ApiConfig.domain}${widget.patientData!['HinhAnh']}')
                            : null) as ImageProvider?,
                    child: _pickedImage == null && widget.patientData?['HinhAnh'] == null
                        ? const Icon(
                            Icons.person,
                            size: 65,
                            color: Color(0xff4b5fb5),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xff4b5fb5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// Form nhập liệu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  _textField(
                    "Họ tên",
                    Icons.person_outline,
                    hoTenController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Số điện thoại",
                    Icons.phone,
                    sdtController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Email",
                    Icons.email_outlined,
                    emailController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Địa chỉ",
                    Icons.location_on_outlined,
                    diaChiController,
                  ),
                  const SizedBox(height: 15),
                  _textField(
                    "Ngày sinh",
                    Icons.calendar_today,
                    ngaySinhController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month, color: Color(0xff4b5fb5)),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: gioiTinh,
                    decoration: InputDecoration(
                      labelText: "Giới tính",
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Nam",
                        child: Text("Nam"),
                      ),
                      DropdownMenuItem(
                        value: "Nữ",
                        child: Text("Nữ"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gioiTinh = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// NÚT LƯU THAY ĐỔI
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4b5fb5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _isSaving ? null : _saveChanges,
                icon: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                label: Text(
                  _isSaving ? "Đang lưu..." : "Lưu thay đổi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}