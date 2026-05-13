import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';

class dist extends StatefulWidget {
  const dist({super.key});

  @override
  State<dist> createState() => _distPageState();
}

class _distPageState extends State<dist> {
  TextEditingController _district = TextEditingController();
  List<Map<String, dynamic>> _districtlist = [];
  int eid=0;

  Future<void> insert() async {
    try {
      final district = _district.text;
      await supabase.from('tbl_district').insert({'district_name': district});
      print("Inserted Succesfully");
      _district.clear();
      fetchDistrict();
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> fetchDistrict() async {
    try {
      final response = await supabase.from('tbl_district').select();
      setState(() {
        _districtlist = response;
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
  Future<void> delDistrict( int districtId) async {
    try {
      await supabase.from('tbl_district').delete().eq('district_id', districtId);
      print("Deleted Successfully");
      fetchDistrict();
    } catch (e) {
      print("Error $e");
    }
  }
  Future<void> updateDistrict() async {
    try {
      final district=_district.text;
      await supabase.from('tbl_district').update({'district_name': district}).eq('district_id', eid);
      print("Updated Successfully");
      fetchDistrict();
      setState(() {
        eid=0;
        _district.clear();
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
            constraints: const BoxConstraints(maxWidth: 750),
            child: SingleChildScrollView(
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
                          controller: _district,
                          label: "District",
                          hint: "",
                          icon: Icons.file_present_outlined,
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
                             if(eid==0){
                              insert();
                             }
                             else{
                              updateDistrict();
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
                                  'District ',
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
                            rows: _districtlist
                                .asMap()
                                .entries
                                .map(
                                  (entry) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text((entry.key + 1).toString()),
                                      ),
                                      DataCell(
                                        Text(entry.value['district_name']),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                eid=entry.value['district_id'];
                                                _district.text=entry.value['district_name'];

                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                              delDistrict(
                                                entry.value['district_id']
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
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
