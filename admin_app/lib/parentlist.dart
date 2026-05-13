import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class pare extends StatefulWidget {
  const pare({super.key});

  @override
  State<pare> createState() => _pareState();
}

class _pareState extends State<pare> {
  
  List<Map<String, dynamic>> _parentlist = [];
   Future<void> fetchparent() async {
    try {
      final response = await supabase.from('tbl_parent').select();
      setState(() {
        _parentlist = response;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchparent();
  } 
  dynamic paraId;
 
  
  Future<void> approvepara( dynamic aid) async {
    try {
     
      await supabase.from('tbl_parent').update({'parent_status': 'approved'}).eq('parent_id', aid);
      print("Updated Successfully");
      fetchparent();
      setState(() {
        
      });
    } catch (e) {
      print("Error $e");
      
    }
  }
  
  Future<void> rejectpara( dynamic aid) async {
    try {
     
      await supabase.from('tbl_parent').update({'parent_status': 'rejected'}).eq('parent_id', aid);
      print("Updated Successfully");
      fetchparent();
      setState(() {
        ;
      });
    } catch (e) {
      print("Error $e");
      
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: Icon(Icons.keyboard_backspace,color: Colors.white,),
      ),
      backgroundColor: (const Color.fromARGB(255, 245, 243, 243)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/360_F_1749345583_466310xw05NmIKkNMDw5te9cOMCCUHZR.webp"),fit: BoxFit.cover)
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color:Colors.transparent,
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 300, 20, 0),
                child: Container(
                  height: 700,
                  width: 1500,
            
                  child: Column(
                    children: [
                       DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Parent ID',
                                style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'contact',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'address',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'Photo',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                              
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                          ],
                           rows: _parentlist
                                .asMap()
                                .entries
                                .map(
                                  (entry) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text((entry.key + 1).toString()),
                                      ),
                                DataCell(
                                  Text(
                                    entry.value['parent_name'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                              DataCell(
                                  Text(
                                    entry.value['parent_email'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['parent_contact'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['parent_address'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                               
                                DataCell(
                                  Image.network(
                                    entry.value['parent_photo'] ?? "https://via.placeholder.com/150",
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check, color: const Color.fromARGB(255, 255, 221, 0)),
                                        onPressed: () {
                                          approvepara(
                                            paraId = entry.value['parent_id']
                                          );

                                          // Handle edit action
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.clear, color: const Color.fromARGB(255, 255, 221, 0)),
                                        onPressed: () {
                                          rejectpara(
                                            paraId = entry.value['parent_id']
                                          );
                                          // Handle delete action
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['parent_status'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                        ),
                    
                    ],
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