import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myClinic/ListPage/dataoFoonePatient.dart';

class FormPage extends StatefulWidget {
  FormPage({super.key, required this.data});
  var data;
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final dateInput = TextEditingController();
  final date = TextEditingController();
  final tcCase = TextEditingController();
  DateTime? selectedDate;
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    date.text = ""; //set the initial value of text field
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

  Future addCaseToSubCollection() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) =>
            const Center(child: CircularProgressIndicator())));
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> map = Map();

    map['Case history'] = tcCase.text;
    map['Appoiment date'] = dateInput.text;
    map['Date'] = date.text;
    map['Date by Timestamp'] = selectedDate!;
    map['Timestamp'] = FieldValue.serverTimestamp();
    await firestore
        .collection('patients')
        .doc(widget.data['Patient Id'])
        .collection(widget.data['Name'])
        .doc()
        .set(map);
    print('Insert Success');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) => Patientpage(data: widget.data))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            Patientpage(data: widget.data))));
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
                      child: TextField(
                        controller: date,

                        //editing controller of this TextField
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText:
                                '  วันที่เข้ารับบริการ' //label text of field
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
                              selectedDate = pickedDate;
                              date.text = DateFormat('dd-MM-yyyy').format(
                                  pickedDate); //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                    )),

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
                  height: 20,
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
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
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
                            if (tcCase.text.isEmpty) {
                              showAleart(
                                  'ไม่พบประวัติผู้ป่วย', 'เพิ่มประวัติผู้ป่วย');
                            } else {
                              addCaseToSubCollection();
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
        ));
  }
}
