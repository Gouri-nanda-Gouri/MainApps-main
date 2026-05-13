import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psycologist_app/addavailability.dart';
import 'package:psycologist_app/homepage.dart';
import 'package:psycologist_app/login.dart';

import 'package:flutter/material.dart';
import 'package:psycologist_app/myprofile.dart';
import 'package:psycologist_app/registration.dart';
import 'package:psycologist_app/viewavailability.dart';
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

    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Logs()
    );
  }
}
