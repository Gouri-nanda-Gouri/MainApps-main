

import 'package:flutter/material.dart';

class regs extends StatefulWidget {
  const regs({super.key});

  @override
  State<regs> createState() => _regsState();
}

class _regsState extends State<regs> {
  String? _selectedValue;
   String? _selectedDistrict;
  final List<String> _options1 = [
    'KOTTAYAM',
    'KOLLAM',
    'ERNAKULAM',
    'KANNUR',
    'KOZHIKODE',
  ];
 
  String? _selectedplace;
  final List<String> _options2 = [
    'thiruvambadi',
    'ommasery',
    'mukkam',
    'koodaranji',
    'pullurampara',
  ];
  

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

                            Icon(Icons.perm_identity,),
                            
                           
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


                            // gender
                              Row(
              children: [
                Text("gender",style: TextStyle(color:const Color.fromARGB(255, 200, 198, 193) ),),
                Expanded(
                  child: RadioListTile(
                  
                    value: 'Option1',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    title: Text('male',style: TextStyle(color:const Color.fromARGB(255, 200, 198, 193) ),),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 'Option 2',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    title: Text('female',style: TextStyle(color:const Color.fromARGB(255, 200, 198, 193) ),),
                  ),
                ),
              ],
            ),

            // district 

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                dropdownColor:(const Color.fromARGB(255, 116, 116, 116)), 
                value: _selectedDistrict,
                decoration: InputDecoration(
                  labelText: "District",labelStyle: TextStyle(color:Colors.white),
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() => _selectedDistrict = newValue);
                },
                items: _options1.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // place

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: DropdownButtonFormField<String>(
              dropdownColor:(const Color.fromARGB(255, 116, 116, 116)),
                value: _selectedplace,
                decoration: InputDecoration(
                  labelText: "place",labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() => _selectedplace = newValue);
                },
                items: _options2.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
           ),

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
