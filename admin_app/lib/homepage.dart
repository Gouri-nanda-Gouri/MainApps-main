import 'package:admin_app/admin_registration.dart';
import 'package:admin_app/category.dart';
import 'package:admin_app/district.dart';
import 'package:admin_app/parentlist.dart';
import 'package:admin_app/place.dart';
import 'package:admin_app/psycologistlist.dart';
import 'package:admin_app/subcategory.dart';
import 'package:admin_app/type.dart';
import 'package:admin_app/viewcomplaint.dart';
import 'package:flutter/material.dart';

class homp extends StatefulWidget {
  const homp({super.key});

  @override
  State<homp> createState() => _hompState();
}

class _hompState extends State<homp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:(const Color.fromARGB(255, 250, 247, 247)),
        leading:Icon(Icons.arrow_back),
        title:Text("Dasher"),
      
        actions: [
          Icon(Icons.notifications),
          Icon(Icons.account_circle)
        ],
      ),
      
      body:
       Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 200,
            height: double.infinity,
            color: (const Color.fromARGB(255, 255, 254, 251)),
            child:SingleChildScrollView(
              child: Column(
                
              children: [
              
                Align(
                  alignment: Alignment.topLeft,
                  
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("MENU",style: TextStyle(fontSize:20,color:Colors.purple[800],fontWeight:FontWeight.bold),),
                  )),
                
                 TextButton(onPressed: () {
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [ Icon(Icons.home),
                      Text("Dashboard",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, 
                      ),),
                    ],
                  ),
                )),
                 TextButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => dist() ,));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.apartment),
                      Text("District",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,) ),
                    ],
                  ),
                )),
                 TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => cate(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.category),
                      Text("Category",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,) ),
                    ],
                  ),
                )),
                
                TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage(),));
                  
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.place),
                      Text("Place",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Subcategory1(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.category),
                      Text("Subcategory",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                 TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => reg(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.person_add),
                      Text(" Add Account",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                 TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => typ(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.type_specimen),
                      Text("Type",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                TextButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => reg() ,));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.app_registration),
                      Text("admin registratoin ",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,) ),
                    ],
                  ),
                )),
                TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => pare(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.person_add),
                      Text(" parent list ",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                  TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => psyco(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.storage),
                      Text("  psycologist list ",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
                 TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => vcom(),));
                  
                }, child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [Icon(Icons.list_alt),
                      Text("Complaints ",style: TextStyle(
                        color:Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18, )),
                    ],
                  ),
                )),
              
              
              ],
              
              ),
            ) ,
          ),
        ),
        Expanded(
          flex: 4,
          child: Container( 
            width: 400,
            height:800,
            color:Color.fromARGB(255, 216, 216, 224),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height:150 ,
                        width: 800,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-28 123801.png"),fit: BoxFit.fill)
                        ),
                        )),
                      
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height: 250,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-28 124050.png"),fit: BoxFit.fill)
                        ),
                        )),
                        
                    
                   
              
                    ] 
                  ),
                  Row(
                    children: [
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height:150 ,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-29 140328.png"),fit: BoxFit.fill)
                        ),
                        )),
                      
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height: 150,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-29 140341.png"),fit: BoxFit.fill)
                        ),
                        )),
                         
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height: 150,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-29 140359.png"),fit: BoxFit.fill)
                        ),
                        )),
                        
                    
                   
              
                    ] 
                  ),
                  Row(
                    children: [
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height:600 ,
                        width: 800,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-29 141959.png"),fit: BoxFit.fill)
                        ),
                        )),
                      
                    Card(elevation:10,
                    margin:EdgeInsets.all(10),
                    color: (const Color.fromARGB(255, 66, 66, 66)),
                      child: Container(
                        height: 550,
                        width: 370,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage("assets/Screenshot 2026-04-29 142034.png"),fit: BoxFit.fill)
                        ),
                        )),
                        
                    
                   
              
                    ] 
                  ),
              
              
                ],
              
              
              
              
              
              
              
              ),
            ),
              
            ),
          
          ),
      ]
        )

      
    
    );
  }
}