import 'package:flutter/material.dart';
import 'package:parent_app/homepage.dart';
import 'package:parent_app/main.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


    Future<void> loginUser() async {
    try {
      


      final authResponse = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = authResponse.user;

      if (user == null) {
        throw Exception("Login failed");
      }

      /// CHECK USER STATUS
      final response = await supabase
          .from('tbl_parent')
          .select('parent_status')
          .eq('parent_id', user.id)
          .single();

      String? status = response['parent_status'];

      if (status == "rejected") {
        /// BLOCKED
        await supabase.auth.signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your account has been rejected by admin"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else if (status == "pending") {
        /// ALLOW LOGIN (Active or Pending but not blocked)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your account is pending approval"),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }

      else{
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const homep(),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      print("Login error: $e");
    }

    
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
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           
                            const SizedBox(height: 32),

                            // --- FULL NAME FIELD ---
                            
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
                                loginUser();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: (const Color.fromARGB(255, 46, 136, 38))),

                              child: Text("login",style: TextStyle(color: (Colors.black)),)
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
