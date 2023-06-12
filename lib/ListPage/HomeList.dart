import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myClinic/Homepage.dart';
import 'package:myClinic/ListPage/dataoFoonePatient.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final listPatient = FirebaseFirestore.instance
      .collection('patients')
      .orderBy("Patient Id", descending: true)
      .snapshots();

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
      child: StreamBuilder<QuerySnapshot>(
        stream: listPatient,
        builder: (context, snapshot) {
          // Connection error
          if (snapshot.hasError) {
            return const Text('Connection error');
          }

          // Connecting...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Data is ready
          // convert snapshot to List
          var docs = snapshot.data!.docs;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Homepage())));
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text('รายชื่อผู้ป่วย'),
            ),
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: ((context, index) {
                final doc = docs[index];
                void deleteCollectionAndData() async {
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;
                  final CollectionReference collectionRef =
                      firestore.collection(doc['Name']);

                  final QuerySnapshot snapshot = await collectionRef.get();
                  final List<QueryDocumentSnapshot> docs = snapshot.docs;

                  for (QueryDocumentSnapshot doc in docs) {
                    await doc.reference.delete();
                  }
                }

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                    child: Container(
                      color: Colors.grey[200],
                      child: ListTile(
                        title: Text(doc['Name']),
                        leading: Text(
                          'No.\n${doc['Patient Id']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(doc['Location']),
                        trailing: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('ยืนยันการลบข้อมูลผู้ป่วย'),
                                  content:
                                      const Text('คุณต้องการที่จะลบข้อมูลไหม'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        deleteCollectionAndData();
                                        FirebaseFirestore.instance
                                            .collection('patients')
                                            .doc(doc.id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.delete_rounded),
                        ),
                        onTap: () {
                          setState(() {
                            print(doc);
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => Patientpage(data: doc)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
