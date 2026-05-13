
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class reg extends StatefulWidget {
  const reg({super.key});

  @override
  State<reg> createState() => _regState();
}

class _regState extends State<reg> {
   TextEditingController adminController = TextEditingController();
    TextEditingController emailController = TextEditingController();
     TextEditingController passwordController = TextEditingController();
  Future<void> insert() async {
    try {
      final admin = adminController.text;
      await supabase.from('tbl_admin').insert({'admin_name': admin, 'admin_email': emailController.text, 'admin_password': passwordController.text}); //insertQry
      print("admin inserted successfully");
      adminController.clear();
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      print("Error inserting admin: $e");
    }
  }
 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.keyboard_backspace,color: Colors.white,),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(20, 0,20,0),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 0,20,0),
              child: Container(
                height: 700,
                width: 400,
                
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 150,
                        color: Colors.black,
                        child: Image.asset("assets/user-icon-on-transparent-background-free-png (1).webp"),
                        
                      ),
                      Container(
                        width: 400,
                        height: 100,
                        child: Center(child: Column(
                          children: [
                            Text("Register?",style: TextStyle(color:Colors.white,fontSize: 30),),
                            Text("Register your account to expolre.",style: TextStyle(color:Colors.white),),
                          ],
                        ),
                        ),
                      ),
                      Form(child: Column(
                  children: [
                     Row(
                      children: [
                        Text("Name",style: TextStyle(color: Colors.white),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: adminController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: Text("Name",style: TextStyle(color: Colors.white),),
                            hintText: "Enter your Name",
                            prefixIcon: Icon(Icons.person,color:Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                      ],
                    ),
                   
                  
                    Row(
                      children: [
                        Text("Email",style: TextStyle(color: Colors.white),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text("Email",style: TextStyle(color: Colors.white),),
                            hintText: "Enter your Email",
                            prefixIcon: Icon(Icons.mail,color:Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Password",style: TextStyle(color: Colors.white),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            label: Text("Password",style: TextStyle(color: Colors.white),),
                            hintText: "Enter your Password",
                            prefixIcon: Icon(Icons.lock,color: Colors.white,),
                            suffixIcon: Icon(Icons.visibility_off,color:Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                      ],
                    ),
                  ],
                        )),
                        ElevatedButton(onPressed: () { 
                          insert();
                          
                        },style: ElevatedButton.styleFrom(
                          fixedSize: Size(400, 50)
                        ), child: Text("Register")),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("------or continue with------",style: TextStyle(color: Colors.white))),
                    
                  ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/google.png'),
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                                 width: 75,
                                 height: 75,
                                 child: Image.asset('assets/apple_logo_PNG19673.png'),
                          ),
                     ),
                  ],
                        ),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("Already have an account?",style: TextStyle(color: Colors.white),)),
              
                    TextButton(onPressed: () {
                      
                      
                      
                    }, child: Text("Sign in"))
                  ],
                        )
                     
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}