import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Homepage.dart';

class Newcase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Newcase();
  }
}

class _Newcase extends State<Newcase> {
  final dateInput = TextEditingController();
  final tcName = TextEditingController();
  final tcNum = TextEditingController();
  final tcLo = TextEditingController();
  final tcCase = TextEditingController();
  final tcPresh = TextEditingController();
  var patienId = TextEditingController();
  final idCard = TextEditingController();
  DateTime? selectedDate;
  // final patient =
  //     FirebaseFirestore.instance.collection(patienId.toString()).snapshots();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  Future showAleart(String title, String message) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          );
        }));
  }

  Future addfirstCollection() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );

    Map<String, dynamic> map = Map();

    map['Name'] = tcName.text;
    map['Phone number'] = tcNum.text;
    map['Patient Id'] = patienId.text;
    map['Id card'] = idCard.text;
    map['Date'] = currentDate;
    map['Location'] = tcLo.text;

    map['Timestamp'] = FieldValue.serverTimestamp();
    await firestore.collection('patients').doc(patienId.text).set(map);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  Future addsecCollection() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> map = Map();

    map['Case history'] = tcCase.text;
    map['Appoiment date'] = dateInput.text;
    map['Date'] = currentDate;
    map['Date by Timestamp'] = Timestamp.now();
    map['Timestamp'] = FieldValue.serverTimestamp();
    await firestore
        .collection('patients')
        .doc(patienId.text)
        .collection(tcName.text)
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    });
  }

  Future conditionCaseaddsecCollection() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) =>
            const Center(child: CircularProgressIndicator())));
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> map = Map();

    map['Case history'] = tcCase.text;
    map['Appoiment date'] = dateInput.text;
    map['Date'] = currentDate;
    map['Date by Timestamp'] = selectedDate!;
    map['Timestamp'] = FieldValue.serverTimestamp();
    await firestore
        .collection('patients')
        .doc(patienId.text)
        .collection(tcName.text)
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const Homepage())));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ป้องกันการปิดแอปพลิเคชันเมื่อกดปุ่ม Back บนอุปกรณ์ Android
        // เพื่อให้แอปพลิเคชันกลับไปยังหน้าหลักแทน
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: const Text(
              "บันทึกประวัติผู้ป่วย",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            //background color of app bar
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Name ======================================================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: TextField(
                                controller: tcName,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  labelText: '  ชื่อ - นามสกุล',

                                  // hintStyle: TextStyle(color: Colors.brown),
                                  border: InputBorder.none,
                                )),
                          ))),
                  //patient num ==========================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                              controller: patienId,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person_pin_circle_outlined),
                                labelText: '  เลขประจำตัวผู้ป่วย',

                                // hintStyle: TextStyle(color: Colors.brown),
                                border: InputBorder.none,
                              )))),
                  //Phone Num =====================================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: tcNum,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.call),
                            labelText: 'เบอร์โทร',
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเบอร์โทรศัพท์';
                            }
                            if (value.length != 10) {
                              return 'กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก';
                            }
                            return null; // ไม่มีข้อผิดพลาด
                          },
                        ),
                      )),
                  // IdCard ==================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                              controller: idCard,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: '  รหัสบัตรประจำตัวประชาชน',

                                // hintStyle: TextStyle(color: Colors.brown),
                                border: InputBorder.none,
                              )))),
                  //Location ===================================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                              controller: tcLo,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.location_on),
                                labelText: '  ที่อยู่',

                                // hintStyle: TextStyle(color: Colors.brown),
                                border: InputBorder.none,
                              )))),
                  // Case ====================================================================
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                              controller: tcCase,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.sick),
                                labelText: '  ประวัติการรักษาพยาบาล',

                                // hintStyle: TextStyle(color: Colors.brown),
                                border: InputBorder.none,
                              )))),

                  // Appointment Date
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: dateInput,

                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: '  ทำการนัดหมาย' //label text of field
                              ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                      )),
                  //Save data ===================================

                  Padding(
                    padding: const EdgeInsets.only(top: 45, bottom: 30),
                    child: SizedBox.fromSize(
                      size: const Size(200, 60), // button width and height
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent, // button color
                        child: Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: Colors.white, // splash color
                            onTap: () {
                              if (tcName.text.isEmpty) {
                                showAleart(
                                    'ไม่พบชื่อผู้ป่วย', 'เพิ่มชื่อผู้ป่วย');
                              }

                              if (patienId.text.isEmpty) {
                                showAleart('ไม่พบเลขประจำตัวผู้ป่วย',
                                    'เพิ่มเลขประจำตัวผู้ป่วย');
                              }
                              if (tcCase.text.isEmpty &&
                                  dateInput.text.isEmpty) {
                                if (tcName.text.isNotEmpty &&
                                    tcNum.text.isNotEmpty) {
                                  addfirstCollection();
                                }
                              } else {
                                addfirstCollection();
                                addsecCollection();
                              }
                            }, // button pressed
                            child: const ListTile(
                              leading: Icon(
                                Icons.data_saver_on,
                                size: 30,
                                color: Colors.white,
                              ),
                              title: Text(
                                ' Save',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
