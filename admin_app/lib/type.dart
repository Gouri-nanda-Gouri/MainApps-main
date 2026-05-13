import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class typ extends StatefulWidget {
  const typ({super.key});

  @override
  State<typ> createState() => _typPageState();
}

class _typPageState extends State<typ> {
  TextEditingController _type = TextEditingController();
  List<Map<String, dynamic>> _typelist = [];
  int eid = 0;

  Future<void> insert() async {
    try {
      final type = _type.text;
      await supabase.from('tbl_type').insert({'type_name': type});
      print("Inserted Succesfully");
      fetchType();
      _type.clear();
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> fetchType() async {
    try {
      final response = await supabase.from('tbl_type').select();
      setState(() {
        _typelist = response;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchType();
  }

  Future<void> deleteType(int id) async {
    try {
      await supabase.from('tbl_type').delete().eq('type_id', id);
      print("Deleted Successfully");
      fetchType();
    } catch (e) {
      print("Error $e");
    }
  }
  Future<void> updateType() async {
    try {
      final type=_type.text;
      await supabase.from('tbl_type').update({'type_name': type}).eq('type_id', eid);
      print("Updated Successfully");
      fetchType();
      setState(() {
        eid=0;
        _type.clear();
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Soft neutral background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Documents Field
                      _buildTextField(
                        controller: _type,
                        label: "Type",
                        hint: "",
                        icon: Icons.type_specimen,
                      ),
                      const SizedBox(height: 40),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[700],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if (eid == 0) {
                              insert();
                            } else {
                              updateType();
                            }
                          },
                          child: const Text(
                            "Submit ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                                'Type ',
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
                            ..._typelist.asMap().entries.map(
                              (entry) => DataRow(
                                cells: [
                                  DataCell(Text((entry.key + 1).toString())),
                                  DataCell(Text(entry.value['type_name'])),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            eid = entry.value['type_id'];
                                            _type.text = entry.value['type_name'];
                                            // Handle edit action
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            deleteType(entry.value['type_id']);
                                            // Handle delete action
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
