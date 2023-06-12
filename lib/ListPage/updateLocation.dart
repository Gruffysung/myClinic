import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myClinic/ListPage/dataoFoonePatient.dart';

class UpdateLocation extends StatefulWidget {
  UpdateLocation({super.key, required this.data});
  var data;
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  final tcLocation = TextEditingController();
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

    map['Location'] = tcLocation.text;

    await firestore
        .collection('patients')
        .doc(widget.data['Patient Id'])
        .update({'Location': tcLocation.text});

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
            "แก้ไขที่อยู่",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          //background color of app bar
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Location ======================================================================================
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
                            controller: tcLocation,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.sick),
                              labelText: '  ที่อยู่',

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
                            if (tcLocation.text.isEmpty) {
                              showAleart('ไม่พบที่อยู่', 'เพิ่มที่อยู่');
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
