import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parent_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ChildInformationPage extends StatefulWidget {
  const ChildInformationPage({super.key});

  @override
  State<ChildInformationPage> createState() => _ChildInformationPageState();
}

class _ChildInformationPageState extends State<ChildInformationPage> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController docPathController = TextEditingController();

  String? _selectedGender;
  Uint8List? _fileBytes;
  PlatformFile? _pickedFile;
  bool _isLoading = false;

  /// Function to pick an image/document
  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedFile = result.files.first;
          _fileBytes = _pickedFile!.bytes;
          docPathController.text = _pickedFile!.name;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  /// Upload image to Supabase Storage and return Public URL
  Future<String?> uploadDocument(String userId) async {
    if (_fileBytes == null || _pickedFile == null) return null;

    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}";
      final filePath = "$userId/$fileName";

      await supabase.storage.from('child').uploadBinary(
            filePath,
            _fileBytes!,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/${_pickedFile!.extension}',
            ),
          );

      return supabase.storage.from('child').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  /// Insert record into Supabase
  Future<void> insertChildData() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. Upload the file first to get the URL
      String? publicUrl = await uploadDocument(user.id);

      // 2. Insert into Table
      await supabase.from('tbl_child').insert({
        'child_name': nameController.text,
        'child_dob': dobController.text,
        'child_notes': notesController.text,
        'child_gender': _selectedGender,
        'parent_id': user.id,
        'child_docs': publicUrl, // Ensure this column exists in your DB
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Child information saved successfully!")),
        );
        _clearForm();
      }
    } catch (e) {
      debugPrint("Insert error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    nameController.clear();
    dobController.clear();
    notesController.clear();
    docPathController.clear();
    setState(() {
      _selectedGender = null;
      _fileBytes = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Dark theme for better contrast with white text
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Child Information", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Name Field
              _buildTextField(nameController, "Name", Icons.person),
              const SizedBox(height: 16),

              // Gender Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Gender", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  _buildRadio("Male", "male"),
                  _buildRadio("Female", "female"),
                ],
              ),

              // DOB Field
              _buildTextField(dobController, "Date of Birth", Icons.calendar_month, keyboardType: TextInputType.datetime),
              const SizedBox(height: 16),

              // Notes Field
              _buildTextField(notesController, "Notes", Icons.note_add_outlined),
              const SizedBox(height: 16),

              // File Picker Field
              TextFormField(
                controller: docPathController,
                readOnly: true,
                onTap: pickDocument,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Upload Document",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.library_books_outlined, color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Colors.blue)),
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      ),
                      onPressed: insertChildData,
                      child: const Text("Save"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Colors.blue)),
      ),
    );
  }

  Widget _buildRadio(String title, String value) {
    return Expanded(
      child: RadioListTile(
        value: value,
        groupValue: _selectedGender,
        onChanged: (val) => setState(() => _selectedGender = val as String?),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}