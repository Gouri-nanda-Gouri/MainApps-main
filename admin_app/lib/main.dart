import 'package:admin_app/admin_registration.dart';
import 'package:admin_app/category.dart';
import 'package:admin_app/district.dart';
import 'package:admin_app/homepage.dart';
import 'package:admin_app/login.dart';
import 'package:admin_app/place.dart';
import 'package:admin_app/registeration.dart';
import 'package:admin_app/subcategory.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://kuxoafiiabsdpwwfjuqc.supabase.co',
    anonKey: 'sb_publishable_KqFa6-a0NiJ1U6k8qH4BYQ_dKj-foAw',
  );
  runApp(MainApp());
}
final supabase=Supabase.instance.client;
class MainApp extends StatelessWidget {  
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:homp()
    );
  }
}
