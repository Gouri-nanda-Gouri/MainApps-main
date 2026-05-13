import 'package:flutter/material.dart';
import 'package:psycologist_app/changepassword.dart';
import 'package:psycologist_app/editprofile.dart';
import 'package:psycologist_app/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String contact = "";
  String qualification = "";
  String proof = "";
  String image = "";
  String address = "";
  bool isLoading = true;
  
  get navigator => null;
  Future<void> loadprofile() async {
    try {
      final user = supabase.auth.currentUser;
      final data = await supabase
          .from('tbl_psycologist')
          .select()
          .eq('psycologist_id', user!.id)
          .single();
      setState(() {
        name = data['psycologist_name'];
        email = data['psycologist_email'];
        contact = data['psycologist_contact'];
        qualification = data['psycologist_qualification'];
        proof = data['psycologist_proof'];
        image = data['psycologist_photo'];
        address = data['psycologist_address'];
        isLoading = false;
      });
      print(
        "Profile loaded: $name, $email, $contact,$qualification, $proof, $image, $address",
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
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
                    backgroundColor: const Color(0xFF0129EE),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // If 'image' has a URL, show it. Otherwise, no background image.
                      backgroundImage: (image != null && image!.isNotEmpty)
                          ? NetworkImage(image!)
                          : null,
                      // If 'image' is empty, show the Icon. If it has a URL, show nothing (null).
                      child: (image == null || image!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),

                  SizedBox(height: 16),

                  const Divider(
                    height: 40,
                    thickness: 1,
                    indent: 40,
                    endIndent: 40,
                  ),

                  // Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.perm_identity, "Name ", "$name"),
                        _buildInfoRow(Icons.email_outlined, "Email ", "$email"),
                        _buildInfoRow(
                          Icons.phone_outlined,
                          "Contact",
                          " $contact",
                        ),
                        _buildInfoRow(
                          Icons.school,
                          "Qualification",
                          " $qualification",
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // Background color if image is loading or empty
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: proof.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : Image.network(
                                  proof,
                                  fit: BoxFit
                                      .cover, // Ensures the image fills the container
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if the URL is invalid or fails to load
                                    return const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                        ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const edit()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0129EE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text("Edit Profile"),
                          ),
                        ),
                         SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {

                               Navigator.push(context, MaterialPageRoute(builder: (_) => const Changepass()));
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0129EE)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Password",
                              style: TextStyle(color: Color(0xFF0129EE)),
                            ),
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
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    ),
  );
}
