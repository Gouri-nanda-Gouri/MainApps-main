
import 'package:flutter/material.dart';
import 'package:parent_app/main.dart';

class chil extends StatefulWidget {
  const chil({super.key});

  @override
  State<chil> createState() => _chilState();
}

class _chilState extends State<chil> {
  
  List<Map<String, dynamic>> _childlist = [];
   Future<void> fetchchild() async {
    try {
      final response = await supabase.from('tbl_child').select();
      setState(() {
        _childlist = response;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchchild();
  } 
  Future<void> delchild( int childId) async {
    try {
      await supabase.from('tbl_child').delete().eq('child_id', childId);
      print("Deleted Successfully");
      fetchchild();
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
          image: DecorationImage(image: AssetImage("assets/img.png"),fit: BoxFit.cover)
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              color:Colors.transparent,
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 300, 20, 0),
                child: Container(
                  height: 700,
                  
            
                  child: Column(
                    children: [
                       DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'SL NO',
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
                                'DOB',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'GENDER',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'NOTES',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                             DataColumn(
                              label: Text(
                                'DOCUMENT',
                                style: TextStyle(color:  const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                              
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                              ),
                            ),
                            
                          ],
                           rows: _childlist
                                .asMap()
                                .entries
                                .map(
                                  (entry) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text((entry.key + 1).toString(),style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),),
                                      ),
                                DataCell(
                                  Text(
                                    entry.value['child_name'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                              DataCell(
                                  Text(
                                    entry.value['child_dob'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['child_gender'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['child_notes'] ?? 'N/A',
                                    style: TextStyle(color: const Color.fromARGB(255, 255, 221, 0)),
                                  ),
                                ),
                               
                                DataCell(
                                  Image.network(
                                    entry.value['child_docs'] ?? "https://via.placeholder.com/150",
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 221, 0)),
                                        onPressed: () {
                                           delchild(
                                                entry.value['child_id']
                                              );
                                         
                                        },
                                      ),
                                     
                                    ],
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