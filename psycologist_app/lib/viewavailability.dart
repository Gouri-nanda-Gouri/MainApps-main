import 'package:flutter/material.dart';

import 'package:psycologist_app/main.dart';


class vavai extends StatefulWidget {
  const vavai({super.key});

  @override
  State<vavai> createState() => _vavaiState();
}

class _vavaiState extends State<vavai> {
   
   List<Map<String, dynamic>> availability = [];
   Future<void> fetchavailability()

  async {
    try{
      final responce = await supabase.from('tbl_availability').select();
      setState(() {
        availability = responce;
      });
    } catch (e) {
      print("Error fetching availability: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    fetchavailability();
  }
  void deleteavailability(int id) async {
    try {
      await supabase.from('tbl_availability').delete().eq('availability_id', id);
      print("availability deleted successfully");
      fetchavailability();
    } catch (e) {
      print("Error deleting availability: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Availability's"),
        backgroundColor: const Color.fromARGB(255, 250, 248, 248),
      ),
      backgroundColor: (const Color.fromARGB(255, 51, 52, 52)),
      body: Container(
         decoration: BoxDecoration(
               
                image: DecorationImage(
                  image: AssetImage("assets/psychology-in-art-exploring-the-intersection-of-mind-and-creativity.webp"),
                  fit: BoxFit.cover,
                ),
              ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              color: Colors.transparent,
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
                                ' ID',
                                
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
                                'Start-time',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'End-time',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                           
                            
                             DataColumn(
                              label: Text(
                                'Type',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            
                          ],
                          rows: availability
                            .asMap()
                            .entries
                            .map(
                              (entry) => DataRow(
                                cells: [
                                DataCell(
                                  Text((entry.key + 1).toString(), style: TextStyle(color: Colors.white)),
                                ),
                                DataCell(
                                  Text(
                                    entry.value['available_date'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              
                                DataCell(
                                  Text(
                                    entry.value['start_time'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                 DataCell(
                                  Text(
                                    entry.value['end_time'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                 
                                DataCell(
                                  Text(
                                    entry.value['appointment_type'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                               
                                
                                
                                DataCell(
                                  Row(
                                    children: [
                                     
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.white),
                                        onPressed: () {
                                             deleteavailability
                                            (entry.value['availability_id']);
                                         
                                          // Handle delete action
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                
                                ],
                              )
                              
                            ).toList(),
                          
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