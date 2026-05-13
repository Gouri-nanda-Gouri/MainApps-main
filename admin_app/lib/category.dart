import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class cate extends StatefulWidget {
  const cate({super.key});

  @override
  State<cate> createState() => _catePageState();
}

class _catePageState extends State<cate> {
   TextEditingController _category = TextEditingController();
  List<Map<String, dynamic>> Category = [];
  int eid=0;

  Future<void> insert() async {
    try {
      final category=_category.text;
      await supabase.from('tbl_category').insert({'category_name':category});
      print("Inserted Succesfully");
      fetchCategory();
      _category.clear();
      
    } catch (e) {
      print("Error $e");
      
    }

  }
  
  Future<void> fetchCategory() async {
    try {
      final response = await supabase.from('tbl_category').select();
      setState(() {
        Category = response;
      });
    } catch (e) {
      print("Error $e");

    }    
  }

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }
  Future<void> deleteCategory( int id) async {
    try {
      await supabase.from('tbl_category').delete().eq('category_id', id);
      print("Deleted Successfully");
      fetchCategory();
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> updateCategory() async {
    try {
      final category=_category.text;
      await supabase.from('tbl_category').update({'category_name': category}).eq('category_id', eid);
      print("Updated Successfully");
      fetchCategory();
      setState(() {
        eid=0;
        _category.clear();
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
                          controller: _category,
                          label: "category",
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
                              updateCategory();
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
                              'category ',
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
                                              rows:
                                              Category
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (entry) => DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Text((entry.key + 1).toString()),
                                                        ),
                                                        DataCell(
                                                          Text(entry.value['category_name']),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                                onPressed: () {
                                                                  eid=entry.value['category_id'];
                                                                  _category.text=entry.value['category_name'];

                                                                  // Handle edit action
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                                onPressed: () { 
                                                                  deleteCategory(entry.value['category_id']);
                                                                  // Handle delete action
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
