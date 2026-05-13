import 'dart:ui';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class Subcategory1 extends StatefulWidget {
  const Subcategory1({super.key});

  @override
  State<Subcategory1> createState() => _Subcategory1State();
}

class _Subcategory1State extends State<Subcategory1> {
  // State variable moved here
  List<Map<String, dynamic>> categorylist = [];
  dynamic? _selectedValue;
  Future<void> fetchcategory() async {
    try {
      final response = await supabase.from('tbl_category').select();
      setState(() {
        categorylist = response;
      });
    } catch (e) {
      print("Error $e");
      
    }

  }
  @override
  void initState() {
    super.initState();
    fetchcategory();
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
              Color(0xFFF3E5F5), // Soft Lavender
              Colors.white,
              Color(0xFFEDE7F6), // Very light Purple
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 750,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter the category details below",
                        style: TextStyle(
                          color: Colors.purple.shade900.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- Category Field (Dropdown) ---
                      _buildFieldLabel("Category"),
                      DropdownButtonFormField<dynamic>(
                        dropdownColor: Colors.white,
                        iconEnabledColor: const Color(0xFF4A148C),
                        style: const TextStyle(color: Colors.black87),
                        value: _selectedValue,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          prefixIcon: const Icon(Icons.category_outlined,
                              color: Color(0xFF9C27B0)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xFF9C27B0), width: 1.5),
                          ),
                        ),
                        onChanged: (dynamic? newValue) {
                          setState(() {
                            _selectedValue = newValue;
                          });
                        },
                         items: categorylist.map<DropdownMenuItem<dynamic>>((Map<String, dynamic> value) {
                            return DropdownMenuItem<dynamic>(
                              value: value['category_id'],
                              child: Text(value['category_name'] as String),
                            );
                          }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // --- Sub Category Field ---
                      _buildFieldLabel("Sub Category"),
                      _buildGlassTextField(
                        hint: "Enter Sub Category",
                        icon: Icons.layers_outlined,
                      ),

                      const SizedBox(height: 32),

                      // --- Gradient Submit Button ---
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: DataTable(
                                              columns: [
                          DataColumn(
                            label: Text(
                              ' SL NO',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                           DataColumn(
                            label: Text(
                              '  CATEGORY',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'SUB CATEGORY ',
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
                                  'junior',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                               
                              DataCell(
                                Text(
                                  'sub junior',
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
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6A1B9A),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({required String hint, required IconData icon}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.purple.shade200, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF9C27B0), size: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
        ),
      ),
    );
  }
}