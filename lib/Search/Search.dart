import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myClinic/Homepage.dart';
import 'package:myClinic/ListPage/dataoFoonePatient.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

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
        appBar: AppBar(
          title: const Text('ค้นหา'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Homepage())));
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          backgroundColor: Colors.blue, // เปลี่ยนสีแถบเรื่อง
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'ค้นหา',
                  labelStyle: TextStyle(color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.blue,
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('patients')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }

                  final List<DocumentSnapshot> filteredList =
                      snapshot.data!.docs.where((DocumentSnapshot document) {
                    final String title = document.get('Name');
                    final String patientId = document.get('Patient Id');
                    final String searchQuery =
                        searchController.text.toLowerCase();

                    return title.toLowerCase().contains(searchQuery) ||
                        patientId.toLowerCase().contains(searchQuery);
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text('ไม่พบข้อมูล'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = filteredList[index];

                      return ListTile(
                        title: Text(
                          doc['Name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(doc['Location']),
                        trailing: Text(
                          doc['Patient Id'],
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Patientpage(data: doc)),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
