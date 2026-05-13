import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psycologist_app/addavailability.dart';
import 'package:psycologist_app/my_appoinment.dart';
import 'package:psycologist_app/view_parent.dart';
import 'package:psycologist_app/viewavailability.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  get navigator => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'DR.ROBIN',
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 0, 168),
                    letterSpacing: .1,
                    fontSize: 30,
                  ),
                ),
              ),
          
              SizedBox(height: 0),
          
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
                              'Friday  1 May',
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
                            '0',
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 253, 251, 255),
                                letterSpacing: .5,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                ' appointments Today',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 253, 251, 255),
                                    letterSpacing: .5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(width: 200),
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 35,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Calendar",
                style: GoogleFonts.bebasNeue(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 91, 88, 88),
                    letterSpacing: .5,
                    fontSize: 20,
                  ),
                ),
              ),
          
              //---row1-----
              Row(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      height: 300,
                      width: 350,
                      child: Image.asset(
                        'assets/vecteezy_monthly-calendar-of-march-2024-on-transparent-background_18745733.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Quick Actions",
                style: GoogleFonts.bebasNeue(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 91, 88, 88),
                    letterSpacing: .5,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 80, // Increased from 50
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 5, 96),
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners
                      ), // Increased from 50
          
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints:
                                const BoxConstraints(), // Removes extra padding
                            onPressed: () {
                            },
                            icon: const Icon(
                              Icons.supervisor_account,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Parents",
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
          
                    Container(
                      height: 80, // Increased from 50
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 5, 96),
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners
                      ), // Increased from 50
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints:
                                const BoxConstraints(), // Removes extra padding
                            onPressed: () {},
                            icon: const Icon(
                              Icons.message_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Messages",
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    SizedBox(width: 10),
          
                    Container(
                      height: 80, // Increased from 50
                      width: 80, // Increased from 50
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 5, 96),
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints:
                                const BoxConstraints(), // Removes extra padding
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AvailabledateTime(selectedDate: DateTime.now(),)),
                              );
                            },
                            icon: const Icon(
                              Icons.assessment,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Availability",
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 80, // Increased from 50
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 5, 96),
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners
                      ), // Increased from 50
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints:
                                const BoxConstraints(), // Removes extra padding
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppointment()),
                              );
                            },
                            icon: const Icon(Icons.videocam, color: Colors.white),
                          ),
                          Text(
                            "Sessions",
                            style: GoogleFonts.bebasNeue(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}