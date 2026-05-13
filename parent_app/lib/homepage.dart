import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parent_app/add_child.dart';
import 'package:parent_app/bookappoinment.dart';
import 'package:parent_app/my_appoinments.dart';
import 'package:parent_app/my_child.dart';
import 'package:parent_app/myprofile.dart';
import 'package:parent_app/psycologistlist.dart';
import 'package:parent_app/viewpsycologist.dart';

class homep extends StatefulWidget {
  const homep({super.key});

  @override
  State<homep> createState() => _homepState();
}

class _homepState extends State<homep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: (Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "good morning ",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(
                'MARTIN',
                style: GoogleFonts.archivoBlack(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 0, 168),
                    letterSpacing: .1,
                    fontSize: 30,
                  ),
                ),
              ),
              Text(
                "friday 1 MAY  ",
                style: GoogleFonts.amarna(
                  textStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 50),
          
              Card(
                elevation: 5,
                color: const Color.fromARGB(255, 29, 5, 96),
                child: Container(
                  height: 120,
                  width: 350,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
          
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              'Weekly progress',
                              style: GoogleFonts.bebasNeue(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  backgroundColor: ((Colors.blue)),
                                  letterSpacing: .5,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
          
                          Text(
                            '85%',
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 253, 251, 255),
                                letterSpacing: .5,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200, // Or any width that fits your design
                            child: LinearProgressIndicator(
                              value: 0.85,
                              backgroundColor: Colors.white,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
              //---row1-----
              Row(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 150,
                      width: 175,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
          
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.directions_run_outlined,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Text(
                                ' Activities',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
          
                                    letterSpacing: .5,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                'Daily tracking',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 84, 136),
                                    letterSpacing: .5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 150,
                      width: 175,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
          
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.question_answer,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Text(
                                ' Community',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
          
                                    letterSpacing: .5,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                'connect ',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 84, 136),
                                    letterSpacing: .5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          
              ///---row2-----
              Row(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 150,
                      width: 175,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
          
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Text(
                                ' Messages',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
          
                                    letterSpacing: .5,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                'chat history ',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 84, 136),
                                    letterSpacing: .5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 150,
                      width: 175,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
          
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PsycologistPage()),
                                  );
                                },
                                icon: Icon(
                                  Icons.question_answer,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                              Text(
                                ' Psycologist',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
          
                                    letterSpacing: .5,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                'library ',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 0, 84, 136),
                                    letterSpacing: .5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 29, 5, 96),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
          
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChildInformationPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.person_add_alt_1_rounded,
                                        color: Color.fromARGB(255, 255, 251, 251),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Add child",
                                      style: TextStyle(
                                        color:Color.fromARGB(255, 255, 251, 251),
                                        // letterSpacing: .10,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 29, 5, 96),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
          
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                chil(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.format_list_bulleted,
                                        color:Color.fromARGB(255, 255, 251, 251),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "My child",
                                      style: TextStyle(
                                        color:Color.fromARGB(255, 255, 251, 251),
                                        letterSpacing: .10,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 29, 5, 96),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
          
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyAppointmentParents(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.calendar_view_day,
                                        color:Color.fromARGB(255, 255, 251, 251),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "appoinments",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 251, 251),
                                        letterSpacing: .10,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 7,
                        color:  const Color.fromARGB(255, 29, 5, 96),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
          
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.video_call_outlined,
                                        color: Color.fromARGB(255, 255, 251, 251),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sessions",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 251, 251),
                                        letterSpacing: .10,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }
}
