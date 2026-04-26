import 'package:flutter/material.dart';

class ReportController extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String _selectedCategory = '';
  bool _isImageSelected = false;

  String get selectedCategory => _selectedCategory;
  bool get isImageSelected => _isImageSelected;

  final List<String> categories = [
    'Environment',
    'Health',
    'Education',
    'Infrastructure',
    'Safety',
    'Other',
  ];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setImageSelected(bool value) {
    _isImageSelected = value;
    notifyListeners();
  }

  bool validate() {
    if (titleController.text.trim().isEmpty) return false;
    if (descriptionController.text.trim().isEmpty) return false;
    if (_selectedCategory.isEmpty) return false;
    if (locationController.text.trim().isEmpty) return false;
    return true;
  }

  void submit(BuildContext context) {
    if (!validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report Submitted Successfully!'),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    clearFields();
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    _selectedCategory = '';
    _isImageSelected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}