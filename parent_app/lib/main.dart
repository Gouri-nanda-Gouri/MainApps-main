import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parent_app/add_child.dart';
import 'package:parent_app/add_complaint.dart';
import 'package:parent_app/changepassword.dart';
import 'package:parent_app/editprofile.dart';
import 'package:parent_app/homepage.dart';
import 'package:parent_app/login.dart';
import 'package:parent_app/my_child.dart';
import 'package:parent_app/myprofile.dart';
import 'package:parent_app/newreg.dart';
import 'package:parent_app/registration.dart';

import 'package:flutter/material.dart';
import 'package:parent_app/viewpsycologist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://kuxoafiiabsdpwwfjuqc.supabase.co',
    anonKey: 'sb_publishable_KqFa6-a0NiJ1U6k8qH4BYQ_dKj-foAw',
  );
  runApp(MainApp());
}
final supabase = Supabase.instance.client;
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final session =
        Supabase.instance.client.auth.currentSession;
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
       home: session != null
          ?  homep()
          :  Logs(),
    );
  }
}
