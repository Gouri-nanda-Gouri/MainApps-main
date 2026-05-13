import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class psyco extends StatefulWidget {
  const psyco({super.key});

  @override
  State<psyco> createState() => _psycoState();
}

class _psycoState extends State<psyco> {
  List<Map<String, dynamic>> _psycologistlist = [];
   Future<void> fetchpsycologist() async {
    try {
      final response = await supabase.from('tbl_psycologist').select();
      setState(() {
        _psycologistlist = response;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchpsycologist();
  }
   dynamic psyId;
 
  
  Future<void> approvePsy( dynamic aid) async {
    try {
     
      await supabase.from('tbl_psycologist').update({'psycologist_status': 'approved'}).eq('psycologist_id', aid);
      print("Updated Successfully");
      fetchpsycologist();
      setState(() {
        
      });
    } catch (e) {
      print("Error $e");
      
    }
  }
  
  Future<void> rejectPsy( dynamic aid) async {
    try {
     
      await supabase.from('tbl_psycologist').update({'psycologist_status': 'rejected'}).eq('psycologist_id', aid);
      print("Updated Successfully");
      fetchpsycologist();
      setState(() {
        ;
      });
    } catch (e) {
      print("Error $e");
      
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Psycologist List"),
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
                              ' ID',
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
                              'Email',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Contact',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Qualification',
                              style: TextStyle(color: Colors.white),
                             ),
                          ),
                           DataColumn(
                            label: Text(
                              'Photo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                           
                           DataColumn(
                            label: Text(
                              'Proof',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(color: Colors.white),
                             ),
                            
                          ),
                           DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(color: Colors.white),
                            ),
                           ),
                        ],
                        rows: _psycologistlist
                                .asMap()
                                .entries
                                .map(
                                  (entry) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text((entry.key + 1).toString(),
                                            style: TextStyle(color: Colors.white)),
                                      ),
                              DataCell(
                                Text(
                                  entry.value['psycologist_name'] ?? 'N/A',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            
                              DataCell(
                                Text(
                                  entry.value['psycologist_email'] ?? 'N/A',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                               DataCell(
                                Text(
                                  entry.value['psycologist_contact'] ?? 'N/A',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                                DataCell(
                                Text(
                                  entry.value['psycologist_qualification'] ?? 'N/A',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Image.network(
                                  entry.value['psycologist_photo'] ?? '',
                                  width: 30,
                                  height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: Colors.red);
                                  },
                                ),
                              ),
                              
                              DataCell(
                                Image.network(
                                  entry.value['psycologist_proof'] ?? '',
                                  width: 30,
                                  height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: Colors.red);
                                  },
                                ),
                              ),
                              
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check, color: Colors.white),
                                      onPressed: () {
                                        approvePsy(
                                           psyId = entry.value['psycologist_id']);
                                        
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.clear, color: Colors.white),
                                      onPressed: () {
                                        rejectPsy(
                                            psyId = entry.value['psycologist_id']);
                                        // Handle delete action
                                      },
                                    ),
                                    
                                  ],
                                ),
                              ),
                               DataCell(
                                Text(
                                  entry.value['psycologist_status'] ?? 'N/A',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ).toList(),
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
