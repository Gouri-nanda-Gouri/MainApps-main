import 'package:flutter/material.dart';
import 'package:parent_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class regi extends StatefulWidget {
  const regi({super.key});

  @override
  State<regi> createState() => _regiState();
}

class _regiState extends State<regi> {
  TextEditingController parentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List? imageBytes;
  PlatformFile? pickedImage;

  /// IMAGE PICKER
  /// IMAGE PICKER
 /// IMAGE PICKER
  Future<void> handleImagePick() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true, // Required to get bytes for web/mobile upload
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          pickedImage = result.files.first;
          imageBytes = pickedImage!.bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  /// PHOTO UPLOAD
 Future<String?> photoUpload(String uid) async {
    try {
      if (imageBytes == null || pickedImage == null) return null;

      final extension = pickedImage!.extension ?? 'jpg';
      final filePath = "profile/$uid.$extension";

      await supabase.storage.from('Parent').uploadBinary(
            filePath,
            imageBytes!,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/$extension', // Dynamic content type
            ),
          );

      return supabase.storage.from('Parent').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  Future<void> insert() async {
    if (pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload profile image")),
      );
      return;
    }
    try {
      final parent = parentController.text;
      final auth = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (auth.user == null) {
        throw Exception("User creation failed");
      }

      final uid = auth.user!.id;

      // Upload photo
      String? profileImageUrl = await photoUpload(uid);
      await supabase.from('tbl_parent').insert({
        "parent_id": uid,
        'parent_name': parent,
        'parent_email': emailController.text,
        'parent_contact': contactController.text,
        'parent_address': addressController.text,
        'parent_password': passwordController.text,
        "parent_photo": profileImageUrl,
        'parent_status': 'pending',
      }); //insertQry
      print("parent inserted successfully");
      parentController.clear();
      emailController.clear();
      contactController.clear();
      addressController.clear();
      passwordController.clear();
      imageBytes = null;
      pickedImage = null;
    } catch (e) {
      print("Error inserting parent: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 43, 43),
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
                          GestureDetector(
  onTap: handleImagePick,
  child: Center(
    child: Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white10,
          // If imageBytes is not null, show the selected image
          backgroundImage: imageBytes != null ? MemoryImage(imageBytes!) : null,
          child: imageBytes == null
              ? const Icon(Icons.person, size: 50, color: Colors.white24)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
            child: const Icon(Icons.add_a_photo, size: 18, color: Colors.white),
          ),
        ),
      ],
    ),
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
                              controller: parentController,

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

                            // --- EMAIL FIELD ---
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter Email",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            //contact
                            const SizedBox(height: 20),
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
                                  Icons.mail_outline,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            //adress
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "address",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: addressController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter address",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // --- PASSWORD FIELD ---
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter Password",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.white54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                insert();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (const Color.fromARGB(
                                  255,
                                  46,
                                  136,
                                  38,
                                )),
                              ),

                              child: Text(
                                "submit",
                                style: TextStyle(color: (Colors.black)),
                              ),
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
