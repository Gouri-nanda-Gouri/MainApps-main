import 'package:flutter/material.dart';
import 'package:psycologist_app/main.dart';
import 'package:psycologist_app/myprofile.dart';

class edit extends StatefulWidget {

  const edit({super.key});

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController addressController = TextEditingController();

Future<void> updateData() async {
    try {
     

      await supabase.from("tbl_psycologist").update({
        'psycologist_name': nameController.text,
        'psycologist_contact': contactController.text,
        'psycologist_qualification': qualificationController.text,
        }).eq('psycologist_id', supabase.auth.currentUser!.id);

      nameController.clear();
      contactController.clear();
      qualificationController.clear();
     
      setState(() {
         // Reset edit ID after update
      });

       // Refresh table after update

      if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("Profile updated successfully"),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  });
}
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Future<void> loadprofile() async {
    try {
      final user = supabase.auth.currentUser;
      final data = await supabase
          .from('tbl_psycologist')
          .select()
          .eq('psycologist_id', user!.id)
          .single();
      setState(() {
        nameController.text = data['psycologist_name'];
        contactController.text = data['psycologist_contact'];
        qualificationController.text = data['psycologist_qualification'];
       
      
       
      });
      print(
        "Profile loaded: ${nameController.text}, ${contactController.text}, ${qualificationController.text}",
      );
    } catch (e) {
      if (mounted) {
        setState(() {
         
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("Error loading profile"),
        //     backgroundColor: Colors.redAccent,
        //   ),
        // );
      }
    }
  }

  initState() {
    super.initState();
    loadprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            margin: const EdgeInsets.all(20),
            child: Container(
              // Width and height controlled by content or fixed width
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              // Using ClipRRect to ensure the background image follows the container corners
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    // 1. Full Background Image
                    Positioned.fill(
                      child: Image.asset(
                        "assets/img.png",
                        fit:
                            BoxFit.cover, // Ensures image fills the entire card
                      ),
                    ),
                    // 2. Dark Overlay (to ensure text is readable over the image)
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.6)),
                    ),
                    // 3. Your Login Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "EDIT PROFILE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           
                            const SizedBox(height: 32),

                            // --- FULL NAME FIELD ---
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Full Name",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter Name",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),

                        
                            // --- contact ---
                             const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "contact",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: contactController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter contact",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            //-----qualification------
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Qualification",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: qualificationController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter qualification",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.school,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                             // ----- button-----
                           
                            ElevatedButton(
                              onPressed: () {
                                updateData();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: (const Color.fromARGB(255, 46, 136, 38))),

                              child: Text("update",style: TextStyle(color: (Colors.black)),)
                              ,
                            ),
                          ],
                        ),
                      ),
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
