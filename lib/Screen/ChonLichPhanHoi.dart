import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import 'package:nhakhoa/services/theo_doi_service.dart';

class ChonLichPhanHoi extends StatefulWidget {
  const ChonLichPhanHoi({super.key});

  @override
  State<ChonLichPhanHoi> createState() => _ChonLichPhanHoiState();
}

class _ChonLichPhanHoiState extends State<ChonLichPhanHoi> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  int? _maBenhNhan;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBn = prefs.getInt('maBenhNhan');
      if (maBn != null && maBn > 0) {
        _maBenhNhan = maBn;
        final list = await LichHenService.getAppointmentsByPatient(maBn);
        final completed = list.where((app) => app['TrangThai'] == 'DaHoanTat').toList();
        setState(() {
          _appointments = completed;
        });
      }
    } catch (e) {
      print('Lỗi tải lịch hẹn: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDoctorName(int maBacSi) {
    switch (maBacSi) {
      case 1:
        return "BS. Trần Thùy Dương";
      case 3:
        return "BS. Nguyễn Văn A";
      case 4:
        return "BS. Lê Thị B";
      default:
        return "Bác sĩ Nha Khoa";
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.length >= 5) {
      return timeStr.substring(0, 5);
    }
    return timeStr;
  }

  Future<void> _showFeedbackDialog(int maLichHen, String doctorName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final sheet = await TheoDoiService.getOrCreateTrackingSheet(maLichHen);
    
    if (mounted) Navigator.pop(context);

    if (sheet == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Th\u00f4ng b\u00e1o"),
            content: const Text("Kh\u00f4ng th\u1ec3 t\u1ea3i th\u00f4ng tin b\u1ec7nh \u00e1n \u0111\u1ec3 ph\u1ea3n h\u1ed3i. Vui l\u00f2ng th\u1eed l\u1ea1i sau."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("\u0110\u00f3ng"),
              )
            ],
          ),
        );
      }
      return;
    }

    final int maTheoDoi = sheet['MaTheoDoi'];
    int currentPainLevel = sheet['MucDoDau'] ?? 1;
    final TextEditingController textController1 = TextEditingController(text: sheet['TinhTrangSauDungThuoc'] ?? '');
    final TextEditingController textController2 = TextEditingController(text: sheet['PhanHoiBenhNhan'] ?? '');

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.favorite_outline, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ph\u1ea3n h\u1ed3i s\u1ee9c kh\u1ecfe",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "L\u1ecbch h\u1eb9n v\u1edbi: $doctorName",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "M\u1ee9c \u0111\u1ed9 \u0111au (1: B\u00ecnh th\u01b0\u1eddng - 5: \u0110au nhi\u1ec1u):",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final val = index + 1;
                        final isSelected = currentPainLevel == val;
                        return ChoiceChip(
                          label: Text("$val"),
                          selected: isSelected,
                          selectedColor: Colors.teal.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setDialogState(() {
                                currentPainLevel = val;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "T\u00ecnh tr\u1ea1ng sau d\u00f9ng thu\u1ed1c:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: textController1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Nh\u1eadp c\u1ea3m gi\u00e1c, t\u00ecnh tr\u1ea1ng sau u\u1ed1ng thu\u1ed1c...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "\u00dd ki\u1ebfn ph\u1ea3n h\u1ed3i kh\u00e1c:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: textController2,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Nh\u1eadp ph\u1ea3n h\u1ed3i, c\u00e2u h\u1ecfi cho b\u00e1c s\u0129...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Hu\u1ef7", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    final res = await TheoDoiService.sendFeedback(
                      maTheoDoi: maTheoDoi,
                      mucDoDau: currentPainLevel,
                      tinhTrangSauDungThuoc: textController1.text.trim(),
                      phanHoiBenhNhan: textController2.text.trim(),
                    );

                    if (mounted) Navigator.pop(context);

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(res ? "Th\u00e0nh c\u00f4ng" : "Th\u1ea5t b\u1ea1i"),
                          content: Text(res
                              ? "C\u1ea3m \u01a1n b\u1ea1n \u0111\u00e3 ph\u1ea3n h\u1ed3i t\u00ecnh tr\u1ea1ng s\u1ee9c kh\u1ecfe."
                              : "G\u1eedi ph\u1ea3n h\u1ed3i th\u1ea5t b\u1ea1i. Vui l\u00f2ng th\u1eed l\u1ea1i sau."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _loadAppointments();
                              },
                              child: const Text("\u0110\u1ed3ng \u00fd"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("G\u1eedi ph\u1ea3n h\u1ed3i"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ch\u1ecdn l\u1ecbch h\u1eb9n ph\u1ea3n h\u1ed3i",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Ch\u01b0a c\u00f3 l\u1ecbch h\u1eb9n n\u00e0o ho\u00e0n th\u00e0nh \u0111\u1ec3 ph\u1ea3n h\u1ed3i",
                      style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final app = _appointments[index];
                    final docName = _getDoctorName(app['MaBacSi'] ?? 1);
                    final dateStr = _formatDate(app['NgayHen'] ?? '');
                    final timeStr = _formatTime(app['GioHen'] ?? '');
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 1.5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade50,
                          child: const Icon(Icons.done_all, color: Colors.teal),
                        ),
                        title: Text(
                          "Ng\u00e0y h\u1eb9n: $dateStr \u2022 $timeStr",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text("B\u00e1c s\u0129: $docName", style: const TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text("L\u00fd do: ${app['LyDoKham'] ?? 'Kh\u00f4ng c\u00f3 l\u00fd do'}", style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _showFeedbackDialog(app['MaLichHen'], docName),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text("Ph\u1ea3n h\u1ed3i"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
