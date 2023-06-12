import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myClinic/ListPage/dataoFoonePatient.dart';

class UpdatePhoneNum extends StatefulWidget {
  UpdatePhoneNum({super.key, required this.data});
  var data;
  @override
  _UpdatePhoneNumState createState() => _UpdatePhoneNumState();
}

class _UpdatePhoneNumState extends State<UpdatePhoneNum> {
  final phoneNum = TextEditingController();
  // final dateInput = TextEditingController();
  // final tcCase = TextEditingController();
  // String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  // @override
  // void initState() {
  //   dateInput.text = ""; //set the initial value of text field
  //   super.initState();
  // }

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

    map['Phone number'] = phoneNum.text;

    await firestore
        .collection('patients')
        .doc(widget.data['Patient Id'])
        .update({'Phone number': phoneNum.text});

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
            "แก้ไขเบอร์โทรศัพท์",
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
                            controller: phoneNum,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.sick),
                              labelText: '  เบอร์โทร',

                              // hintStyle: TextStyle(color: Colors.brown),
                              border: InputBorder.none,
                            )))),

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
                            if (phoneNum.text.isEmpty) {
                              showAleart(
                                  'ไม่พบเบอร์โทรติดต่อ', 'เพิ่มเบอร์โทรติดต่อ');
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
