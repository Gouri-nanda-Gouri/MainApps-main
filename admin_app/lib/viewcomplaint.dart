import 'package:admin_app/reply.dart';
import 'package:flutter/material.dart';

class vcom extends StatefulWidget {
  const vcom({super.key});

  @override
  State<vcom> createState() => _vcomState();
}

class _vcomState extends State<vcom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("view complaints"),
        backgroundColor: const Color.fromARGB(255, 251, 249, 249),
      ),
      backgroundColor: (const Color.fromARGB(255, 51, 52, 52)),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 300, 20, 0),
              child: Container(
                height: 700,
                width: 1200,
          
                child: Column(
                  children: [
                     DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'SL NO',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Title',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Content',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                           DataColumn(
                            label: Text(
                              'actions',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                           
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Text('1', style: TextStyle(color: Colors.white)),
                              ),
                              DataCell(
                                Text(
                                  'Alan benny',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            
                              DataCell(
                                Text(
                                  'alanbenny@example.com',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                               DataCell(
                                Text(
                                  'fadvvxv',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                               DataCell(
                                Text(
                                  '234564',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                             
                              
                              DataCell(
                                Row(
                                  children: [
                                   TextButton(
                                      onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => rply(),));
                                        // Handle view action
                                      },
                                      child: Text('Reply'),
                                    ),
                                    SizedBox(width: 8),
                                   
                                    
                                   
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}