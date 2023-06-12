import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myClinic/ListPage/AddPatientPage.dart';
import 'package:myClinic/ListPage/HomeList.dart';
import 'package:myClinic/ListPage/updateLocation.dart';
import 'package:myClinic/ListPage/updateName.dart';
import 'package:myClinic/ListPage/updatePhonenum.dart';

class Patientpage extends StatefulWidget {
  Patientpage({super.key, required this.data});
  var data;

  @override
  State<Patientpage> createState() => _PatientpageState();
}

class _PatientpageState extends State<Patientpage> {
  // final dRef = FirebaseFirestore.instance.collection('patients').snapshots();
  Future deleteDocument() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference docRef = firestore
        .collection('patients')
        .doc(widget.data['Patient Id'])
        .collection(widget.data['Name'])
        .doc();

    await docRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ป้องกันการปิดแอปพลิเคชันเมื่อกดปุ่ม Back บนอุปกรณ์ Android
        // เพื่อให้แอปพลิเคชันกลับไปยังหน้าหลักแทน
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeList()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const HomeList())));
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text('Listview'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('patients')
                .doc(widget.data['Patient Id'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Connection error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.purple,
                ));
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                Map<String, dynamic> docs =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                        child: ListTile(
                          title: Text(
                            'No.\n${docs['Patient Id']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: const Icon(Icons.numbers),
                          trailing: const Icon(Icons.numbers),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            docs['Name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          leading: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            UpdateName(data: widget.data))));
                              },
                              icon: const Icon(Icons.person)),
                          trailing: Icon(
                            Icons.person,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            docs['Location'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          leading: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => UpdateLocation(
                                            data: widget.data))));
                              },
                              icon: const Icon(Icons.location_history_rounded)),
                          trailing: Icon(
                            Icons.location_history_rounded,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            '${docs['Phone number'] == '' ? 'ไม่พบเบอร์โทร' : '${docs['Phone number']}'}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          leading: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => UpdatePhoneNum(
                                            data: widget.data))));
                              },
                              icon: const Icon(Icons.phone_android)),
                          trailing: Icon(
                            Icons.phone_android,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('patients')
                                .snapshots(),
                            builder: (context, snapshot) {
                              // Connection error
                              if (snapshot.hasError) {
                                return const Text('Connection error');
                              }

                              // Connecting...
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              // Data is ready
                              // convert snapshot to List

                              return StreamBuilder<QuerySnapshot<Object?>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('patients')
                                      .doc(widget.data['Patient Id'].toString())
                                      .collection(widget.data['Name'])
                                      .orderBy("Date by Timestamp",
                                          descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Connection error');
                                    }

                                    // Connecting...
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Text('ไม่มีข้อมูล');
                                    }
                                    var docs = snapshot.data!.docs;

                                    return ListView.builder(
                                        itemCount: docs.length,
                                        itemBuilder: ((context, index) {
                                          var docs = snapshot.data!.docs;
                                          final doc = docs[index];

                                          if (doc['Case history'] == '' ||
                                              !doc.exists) {
                                            return const Text('');
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 7, left: 7, right: 7),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                color: Colors.grey[200],
                                              ),
                                              child: ListTile(
                                                title: Center(
                                                    child: Text(
                                                  doc['Case history'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                leading: Text(
                                                  'Date\n${doc['Date']}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    // fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'นัดหมายครั้งถัดไป: ${doc['Appoiment date'] == '' ? '-' : doc['Appoiment date']}',
                                                  textAlign: TextAlign.center,
                                                ),
                                                trailing: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'ยืนยันการลบข้อมูลผู้ป่วย'),
                                                          content: const Text(
                                                              'คุณต้องการที่จะลบข้อมูลไหม'),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                  'Delete'),
                                                              onPressed:
                                                                  () async {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'patients')
                                                                    .doc(widget
                                                                            .data[
                                                                        'Patient Id'])
                                                                    .collection(
                                                                        widget.data[
                                                                            'Name'])
                                                                    .doc(doc.id)
                                                                    .delete();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.delete_rounded,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }));
                                  });
                            }))
                  ],
                );
              } else {
                throw '';
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) => FormPage(
                          data: widget.data,
                        ))));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
