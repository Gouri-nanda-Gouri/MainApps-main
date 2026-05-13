import 'package:flutter/material.dart';

class addc extends StatefulWidget {
  const addc({super.key});

  @override
  State<addc> createState() => _addcState();
}

class _addcState extends State<addc> {
  TextEditingController replyController = TextEditingController();
  
  
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Complaint"),
        backgroundColor: const Color.fromARGB(255, 252, 251, 251),
      ),
      backgroundColor: (const Color.fromARGB(255, 51, 52, 52)),
      body: Container(
        
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Colors.transparent,
                child: Container(
                
                  width: 350,
                            
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                         Row(
                          children: [
                            Text("Title", style: TextStyle(color: Colors.white)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: replyController,
                              
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Content", style: TextStyle(color: Colors.white)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: replyController,
                              
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Content.......",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                              
                              },
                              child: Text("Submit"),
                            ),
                          ],
                        ),
                              
                       
                      
                      ]
                                    ),
                  ),
                              ),
                        ),
            ),
        ),
      ),
    ),
    );
  }
}