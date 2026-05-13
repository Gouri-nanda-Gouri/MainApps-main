import 'package:flutter/material.dart';
import 'package:parent_app/editprofile.dart';
import 'package:parent_app/psycologistlist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PsycologistPage extends StatefulWidget {
  const PsycologistPage({super.key});

  @override
  State<PsycologistPage> createState() => _PsycologistPageState();
}

class _PsycologistPageState extends State<PsycologistPage> {
  final supabase = Supabase.instance.client;

  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPsycologists();
  }

  Future<List<Map<String, dynamic>>> fetchPsycologists() async {
  final response = await supabase
      .from('tbl_psycologist')
      .select()
      .eq('psycologist_status', 'approved');

  return List<Map<String, dynamic>>.from(response);
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Psycologists"),
        
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureData,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text("No psycologists found"),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.50,
            ),

            itemBuilder: (context, index) {
              final psy = data[index];

              return GestureDetector(
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Psycolist(
                        psychologistData: psy['psycologist_id'].toString() ?? '',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                      )
                    ],
                  ),
                
                  padding: const EdgeInsets.all(12),
                
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      
                      Center(
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: psy['psycologist_photo'] != null
                              ? NetworkImage(psy['psycologist_photo'])
                              : null,
                          child: psy['psycologist_photo'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                
                      const SizedBox(height: 10),
                
                      
                      Text(
                        psy['psycologist_name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                
                      const SizedBox(height: 5),
                
                      
                      Text(
                        psy['psycologist_qualification'] ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                
                      SizedBox(height: 30),
                
                      
                      
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone,color:Colors.white70),
                          SizedBox(width: 10),
                          Text(
                            psy['psycologist_contact'] ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ViewPsychologist {
  const ViewPsychologist();
}