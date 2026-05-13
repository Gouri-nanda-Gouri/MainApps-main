import 'dart:ui';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  // Move the state variable inside the State class
  List<Map<String, dynamic>> districtlist = [];
  dynamic? _selectedValue;
  Future<void> fetchDistrict() async {
    try {
      final response = await supabase.from('tbl_district').select();
      setState(() {
        districtlist = response;
      });
    } catch (e) {
      print("Error $e");
      
    }

  }
  @override
  void initState() {
    super.initState();
    fetchDistrict();
  } 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3E5F5), // Very light purple
              Colors.white,
              Color(0xFFEDE7F6), // Soft lavender
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 750,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Location Details",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter the specific area and district",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 32),

                        // --- District Field ---
                        _buildLabel("District"),
                        DropdownButtonFormField<dynamic>(
                          dropdownColor: Colors.white, // Menu background
                          iconEnabledColor: const Color(0xFF6A1B9A),
                          style: const TextStyle(color: Colors.black87),
                          value: _selectedValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.6),
                            prefixIcon: const Icon(Icons.map, color: Color(0xFF7E57C2)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
                            ),
                          ),
                          onChanged: (dynamic newValue) {
                            // setState now works because this is a StatefulWidget
                            setState(() {
                              _selectedValue = newValue;
                            });
                          },
                          items: districtlist.map<DropdownMenuItem<dynamic>>((Map<String, dynamic> value) {
                            return DropdownMenuItem<dynamic>(
                              value: value['district_id'],
                              child: Text(value['district_name'] as String),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // --- Place Field ---
                        _buildLabel("Place"),
                        _buildGlassInput(
                          hint: "e.g. Thiruvambady",
                          icon: Icons.location_on_outlined,
                        ),

                        const SizedBox(height: 40),

                        // --- Submit Button ---
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "SUBMIT",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                          Center(
                          child: DataTable(
                                              columns: [
                          DataColumn(
                            label: Text(
                              'SL NO',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'District ',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Place',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                                              ],
                                              rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Text('1', style: TextStyle(color: Colors.black)),
                              ),
                              DataCell(
                                Text(
                                  'Ernakulam',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                               DataCell(
                                Text(
                                  'Ernakulam',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.black),
                                      onPressed: () {
                                        // Handle edit action
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.black),
                                      onPressed: () {
                                        // Handle delete action
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                                              ],
                                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6A1B9A),
        ),
      ),
    );
  }

  Widget _buildGlassInput({required String hint, required IconData icon}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        prefixIcon: Icon(icon, color: const Color(0xFF7E57C2)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
        ),
      ),
    );
  }
}