import 'package:flutter/material.dart';
import 'package:psycologist_app/main.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class regi extends StatefulWidget {
  const regi({super.key});

  @override
  State<regi> createState() => _regiState();
}

class _regiState extends State<regi> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController qualificationsController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController proofController = TextEditingController();
 PlatformFile? pickedImage; // For profile photo
Uint8List? imageBytes;

PlatformFile? pickedProof; // For proof document
Uint8List? proofBytes;

  /// IMAGE PICKER
  /// IMAGE PICKER
  /// IMAGE PICKER
// Pick Profile Photo
Future<void> handleImagePick() async {
  final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
  if (result != null) {
    setState(() {
      pickedImage = result.files.first;
      imageBytes = pickedImage!.bytes;
    });
  }
}

// Pick Proof Document
Future<void> handleProofPick() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom, 
    allowedExtensions: ['pdf', 'jpg', 'png'], 
    withData: true
  );
  if (result != null) {
    setState(() {
      pickedProof = result.files.first;
      proofBytes = pickedProof!.bytes;
      // Also update the text controller so the filename appears in the UI
      proofController.text = pickedProof!.name;
    });
  }
}

  /// PHOTO UPLOAD
/// PHOTO UPLOAD
  Future<String?> photoUpload(String uid) async {
    try {
      if (imageBytes == null || pickedImage == null) return null;
      final extension = pickedImage!.extension ?? 'jpg';
      final filePath = "profile/$uid.$extension";

      await supabase.storage.from('psycologist').uploadBinary(
            filePath,
            imageBytes!,
            fileOptions: FileOptions(upsert: true, contentType: 'image/$extension'),
          );
      return supabase.storage.from('psycologist').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Photo Upload error: $e");
      return null;
    }
  }

  /// PROOF UPLOAD
  Future<String?> proofUpload(String uid) async {
    try {
      if (proofBytes == null || pickedProof == null) return null;
      final extension = pickedProof!.extension ?? 'pdf';
      final filePath = "proofs/$uid.$extension";

      await supabase.storage.from('psycologist').uploadBinary(
            filePath,
            proofBytes!,
            fileOptions: FileOptions(
              upsert: true, 
              contentType: extension == 'pdf' ? 'application/pdf' : 'image/$extension'
            ),
          );
      return supabase.storage.from('psycologist').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Proof Upload error: $e");
      return null;
    }
  }

 Future<void> insert() async {
    if (pickedImage == null || pickedProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload both Photo and Proof")),
      );
      return;
    }

    try {
      // 1. Create User
      final auth = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (auth.user == null) throw Exception("User creation failed");
      final uid = auth.user!.id;

      // 2. Upload both files and get URLs
      String? profileImageUrl = await photoUpload(uid);
      String? proofFileUrl = await proofUpload(uid);

      // 3. Insert into Table
      await supabase.from('tbl_psycologist').insert({
        "psycologist_id": uid,
        'psycologist_name': nameController.text,
        'psycologist_email': emailController.text,
        'psycologist_contact': contactController.text,
        'psycologist_qualification': qualificationsController.text,
        'psycologist_password': passwordController.text,
        "psycologist_photo": profileImageUrl,
        "psycologist_proof": proofFileUrl, // Now storing the URL, not just text
        'psycologist_status': 'pending',
      });

      // 4. Reset State
      setState(() {
        pickedImage = null;
        imageBytes = null;
        pickedProof = null;
        proofBytes = null;
        nameController.clear();
        emailController.clear();
        contactController.clear();
        qualificationsController.clear();
        passwordController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!")),
      );
    } catch (e) {
      debugPrint("Error: $e");
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
                                      backgroundImage: imageBytes != null
                                          ? MemoryImage(imageBytes!)
                                          : null,
                                      child: imageBytes == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white24,
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.pink,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_a_photo,
                                          size: 18,
                                          color: Colors.white,
                                        ),
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
                                  Icons.phone_in_talk,
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
                                "qualifications",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: qualificationsController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: "Enter qualifications",
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                ),
                                suffixIcon: const Icon(
                                  Icons.school_outlined,
                                  color: Color.fromARGB(137, 255, 255, 255),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Proof",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Trigger your file picker or custom logic here
                                    handleProofPick();
                                  },
                                  child: TextFormField(
                                    controller: proofController,
                                    // Important: disable editing so the tap goes to the GestureDetector
                                    enabled: false,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.black.withOpacity(0.3),
                                      hintText: "Upload Proof",
                                      // Use disabledBorder because enabled: false switches the border state
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white24,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons
                                            .file_present, // Changed to a file icon for clarity
                                        color: Color.fromARGB(
                                          137,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

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
