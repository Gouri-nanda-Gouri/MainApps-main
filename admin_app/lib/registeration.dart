import 'package:flutter/material.dart';

class regs extends StatelessWidget {
  const regs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                        "assets/img.webp",
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: (const Color.fromARGB(255, 46, 136, 38))),

                              child: Text("submit",style: TextStyle(color: (Colors.black)),)
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
