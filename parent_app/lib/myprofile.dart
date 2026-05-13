import 'package:flutter/material.dart';
import 'package:parent_app/changepassword.dart';
import 'package:parent_app/editprofile.dart';
import 'package:parent_app/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String name="";
  String email="";
  String contact="";
  String image="";
  String address="";
  Future<void> loadprofile() async {
    try {
      final user = supabase.auth.currentUser;
      final data=await supabase.from('tbl_parent').select().eq('parent_id', user!.id).single();
      setState(() {
        name=data['parent_name'];
        email=data['parent_email'];
        contact=data['parent_contact'];
        image=data['parent_photo'];
        address=data['parent_address'];
      });
      print("Profile loaded: $name, $email, $contact, $image, $address");
      
    } catch (e) {
      print("Error loading profile: $e");
      
    }

  }
  @override
  void initState() {
    super.initState();
    loadprofile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A subtle gradient background looks more modern than flat grey
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  
                  // Profile Picture
                   CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFF0129EE),
                    child: CircleAvatar(
                      radius: 50,
                       backgroundImage:NetworkImage(image) ,    // Placeholder image 
                       // Fallback icon
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Text(
                    " $name",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  
                  
                  const Divider(height: 40, thickness: 1, indent: 40, endIndent: 40),

                  // Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.email_outlined, "Email  $email", ""),
                        _buildInfoRow(Icons.phone_outlined, "Contact  $contact", ""),
                        _buildInfoRow(Icons.location_on_outlined, "Address $address", ""),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Buttons Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Edit Profile page
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const edit()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0129EE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text("Edit Profile"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to Change Password page
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const Changepass()));
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0129EE)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Password", style: TextStyle(color: Color(0xFF0129EE))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0129EE)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}