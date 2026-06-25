import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/HoSoBenhNhan.dart';

class CapNhatThongTin extends StatefulWidget {
  const CapNhatThongTin({super.key});

  @override
  State<CapNhatThongTin> createState() =>
      _CapNhatThongTinState();
}

class _CapNhatThongTinState
    extends State<CapNhatThongTin> {

  final hoTenController =
      TextEditingController(text: "Phan C");

  final sdtController =
      TextEditingController(text: "0902691111");

  final emailController =
      TextEditingController(
          text: "c@gmail.com");

  final diaChiController =
      TextEditingController();

  final ngaySinhController =
      TextEditingController();

  String gioiTinh = "Nam";

  final ghiChuController =
    TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff6f8fc),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [

                CircleAvatar(
                  radius: 55,
                  backgroundColor:
                      Colors.green.shade200,

                  child: const Icon(
                    Icons.person,
                    size: 65,
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  bottom: -5,
                  right: -5,

                  child: Container(
                    padding:
                        const EdgeInsets.all(
                            8),

                    decoration:
                        const BoxDecoration(
                      color:
                          Colors.white,
                      shape:
                          BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt,
                      color:
                          Colors.blue,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
                height: 30),

            /// Form
            Container(
              padding:
                  const EdgeInsets.all(
                      20),

              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius
                        .circular(
                            25),
              ),

              child: Column(
                children: [

                  _textField(
                    "Họ tên",
                    Icons.person_outline,
                    hoTenController,
                  ),

                  const SizedBox(
                      height: 15),

                  _textField(
                    "Số điện thoại",
                    Icons.phone,
                    sdtController,
                  ),

                  const SizedBox(
                      height: 15),

                  _textField(
                    "Email",
                    Icons.email_outlined,
                    emailController,
                  ),

                  const SizedBox(
                      height: 15),

                  _textField(
                    "Địa chỉ",
                    Icons.location_on_outlined,
                    diaChiController,
                  ),

                  const SizedBox(
                      height: 15),

                  _textField(
                    "Ngày sinh",
                    Icons.calendar_today,
                    ngaySinhController,
                  ),

                  const SizedBox(
                      height: 15),

                  DropdownButtonFormField(
                    value: gioiTinh,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Giới tính",

                      prefixIcon:
                          const Icon(
                        Icons.people,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: "Nam",
                        child:
                            Text("Nam"),
                      ),
                      DropdownMenuItem(
                        value: "Nữ",
                        child:
                            Text("Nữ"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        gioiTinh =
                            value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius:
                          BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "Ghi chú",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller:
                              ghiChuController,
                          maxLines: 4,
                          decoration:
                              const InputDecoration(
                            hintText:
                                "Nhập ghi chú thêm...",
                            border:
                                InputBorder.none,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 30),

            SizedBox(
              width:
                  double.infinity,
              height: 55,

              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                          0xff1A73E8),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                ),

                onPressed: () {
                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Cập nhật thành công"),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const HoSoBenhNhan(),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.save_outlined,
                  color:
                      Colors.white,
                ),

                label: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(
                    color:
                        Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight
                            .bold,
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
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,

      decoration:
          InputDecoration(
        labelText: label,

        prefixIcon:
            Icon(icon),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius
                  .circular(15),
        ),
      ),
    );
  }
}