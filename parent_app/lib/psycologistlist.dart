import 'package:flutter/material.dart';
import 'package:parent_app/bookappoinment.dart';
import 'package:parent_app/main.dart';

class Psycolist extends StatefulWidget {
  const Psycolist({super.key, required this.psychologistData});

  final String psychologistData;

  @override
  State<Psycolist> createState() => _PsycolistState();
}

class _PsycolistState extends State<Psycolist> {
  String name = "";
  String contact = "";
  String email = "";
  String qualification = "";
  dynamic image;
  bool isLoading = true;

  Future<void> loadprofile() async {
    try {
      final data = await supabase
          .from('tbl_psycologist')
          .select()
          .eq('psycologist_id', widget.psychologistData)
          .single();
      setState(() {
        name = data['psycologist_name'] ?? 'Not Available';
        contact = data['psycologist_contact'] ?? 'Not Available';
        email = data['psycologist_email'] ?? 'Not Available';
        qualification = data['psycologist_qualification'] ?? 'Not Available';
        image = data['psycologist_photo'];
        isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Off-white elegant background
      appBar: AppBar(
        title: const Text(
          "psycologist Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white,
            backgroundImage: image != null ? NetworkImage(image) : null,
            child: image == null
                ? const Icon(Icons.person, size: 70, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildInfoRow(Icons.email_outlined, "Email Address", email),
              const Divider(height: 30),
              _buildInfoRow(
                Icons.phone_android_outlined,
                "Contact Number",
                contact,
              ),
              const Divider(height: 30),
              _buildInfoRow(Icons.school, "Qualification", qualification),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Appointmentbooking(
                        psychologistData: {
                          'psychologist_id': widget.psychologistData,
                        },
                      ),
                    ),
                  );
                },
                child: Text("book appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF2D3436)),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
