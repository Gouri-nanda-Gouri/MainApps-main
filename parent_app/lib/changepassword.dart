import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Changepass extends StatefulWidget {
  const Changepass({super.key});

  @override
  State<Changepass> createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {


final oldpassController = TextEditingController();
  final newpassController = TextEditingController();
  final confpassController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool isLoading = false;

  Future<void> changePassword() async {
  final oldPass = oldpassController.text.trim();
  final newPass = newpassController.text.trim();
  final confPass = confpassController.text.trim();

  if (oldPass.isNotEmpty && newPass.isNotEmpty && confPass.isNotEmpty) {
    setState(() => isLoading = true);

    try {
      final user = supabase.auth.currentUser;

      if (user != null) {
        final data = await supabase
            .from('tbl_parent')
            .select()
            .eq('parent_id', user.id)
            .single();

        final currentPassword = data['parent_password'] ?? '';

        if (oldPass == currentPassword) {
          if (newPass == confPass) {
            
            await supabase.auth.updateUser(
              UserAttributes(password: newPass),
            );
            await supabase.from('tbl_parent').update({'parent_password': newPass}).eq('parent_id', user.id);

            showMessage("Password updated successfully");

            Navigator.pop(context);
          } else {
            showMessage("New passwords do not match");
          }
        } else {
          showMessage("Current password is incorrect");
        }
      } else {
        showMessage("User not logged in");
      }
    } catch (e) {
      showMessage("Error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }

  } else {
    showMessage("All fields are required");
  }
}

  void showMessage(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  void dispose() {
    oldpassController.dispose();
    newpassController.dispose();
    confpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 204, 204),
      appBar: AppBar(
      
        backgroundColor: const Color.fromARGB(255, 255, 252, 252),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            color: (Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  buildTextField(
                    controller: oldpassController,
                    label: "Current Password",
                  ),

                  const SizedBox(height: 15),

                  buildTextField(
                    controller: newpassController,
                    label: "New Password",
                  ),

                  const SizedBox(height: 15),

                  buildTextField(
                    controller: confpassController,
                    label: "Confirm Password",
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (Colors.purple[800]),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Change Password",
                              style: TextStyle(color: Colors.white),
                            ),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}