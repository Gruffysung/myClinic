import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:myClinic/ListPage/HomeList.dart';
import 'package:myClinic/Newcase/HomenewCase.dart';
import 'package:myClinic/Search/Search.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Widget searchButton() {
    return SizedBox.fromSize(
        size: const Size(280, 85), // button width and height
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 80, 82, 82), // button color
          child: Center(
            child: SizedBox.fromSize(
              size: const Size(270, 75), // button width and height
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white, // button color
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.lightBlueAccent, // splash color
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SearchPage())));
                  }, // button pressed
                  child: const Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        size: 40,
                        color: Color.fromARGB(255, 52, 90, 90),
                      ),
                      title: Text(
                        'ค้นหา',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 52, 90, 90),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget adddataButton() {
    return SizedBox.fromSize(
        size: const Size(280, 85), // button width and height
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 144, 150, 150), // button color
          child: Center(
            child: SizedBox.fromSize(
              size: const Size(270, 75), // button width and height
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white, // button color
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.lightGreen, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => Newcase())),
                    );
                  }, // button pressed
                  child: const Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.add,
                        size: 40,
                        color: Color.fromARGB(255, 52, 90, 90),
                      ),
                      title: Text(
                        'ผู้ป่วยใหม่',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 52, 90, 90),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget listdataButton() {
    return SizedBox.fromSize(
        size: const Size(280, 85), // button width and height
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 52, 90, 90), // button color
          child: Center(
            child: SizedBox.fromSize(
              size: const Size(270, 75), // button width and height
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white, // button color
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.amberAccent, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => HomeList())),
                    );
                  }, // button pressed
                  child: const Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.list,
                        size: 40,
                        color: Color.fromARGB(255, 52, 90, 90),
                      ),
                      title: Text(
                        'รายชื่อผู้ป่วย',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 52, 90, 90),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget showButton() {
    return Column(
      children: [
        searchButton(),
        const SizedBox(
          height: 25,
        ),
        adddataButton(),
        const SizedBox(
          height: 25,
        ),
        listdataButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;

        if (isPortrait) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
        }

        return WillPopScope(
          onWillPop: () async {
            // แสดงข้อความเตือนเมื่อกดปุ่มย้อนกลับอีกครั้ง
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ปิดแอปพลิเคชัน'),
                  content: Text('กดย้อนกลับอีกครั้งเพื่อปิดแอปพลิเคชัน'),
                  actions: [
                    TextButton(
                      child: Text('ยกเลิก'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('ปิดแอป'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pop(); // ปิดหน้าจอกลับไปยังหน้าแรก
                      },
                    ),
                  ],
                );
              },
            );

            return false;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xFF75C095),
              body: SingleChildScrollView(
                physics:
                    isPortrait ? null : const NeverScrollableScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: Image.asset(
                          'assets/pharmacy (3).png',
                          scale: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox.fromSize(
                        size: const Size(370, 90), // button width and height
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white, // button color
                          child: Center(
                            child: SizedBox.fromSize(
                              size: const Size(
                                  350, 75), // button width and height
                              child: Material(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF97C5D8),
                                child: const Text(
                                  ' บ้านเกาะคลินิก\nการพยาบาลและการผดุงครรภ์',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      showButton(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
