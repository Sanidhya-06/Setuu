import 'package:flutter/material.dart';
import '../widgets/report_controller.dart';
import '../widgets/form_field.dart';
import '../widgets/image_picker.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  late final ReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReportController();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E),
              size: 18,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Issue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              'Help us make a better community',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Color(0xFF7C3AED),
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    controller: _controller.titleController,
                    label: 'Issue Title',
                    icon: Icons.edit_outlined,
                    hintText: 'Enter a short title',
                  ),
                  const SizedBox(height: 18),
                  _buildDescriptionField(),
                  const SizedBox(height: 18),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 18),
                  _buildLocationField(),
                  const SizedBox(height: 18),
                  ImagePickerWidget(controller: _controller),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller.descriptionController,
          maxLines: 5,
          maxLength: 250,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: 'Describe the issue in detail...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8, top: 14),
              child: Icon(Icons.menu_rounded,
                  color: Color(0xFF7C3AED), size: 20),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _controller.selectedCategory.isEmpty
              ? null
              : _controller.selectedCategory,
          hint: Text(
            'Select a category',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF7C3AED)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.grid_view_rounded,
                color: Color(0xFF7C3AED), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: _controller.categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A1A2E))),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) _controller.setCategory(newValue);
          },
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller.locationController,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: 'Enter location',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.location_on_outlined,
                color: Color(0xFF7C3AED), size: 20),
            suffixIcon: Icon(Icons.my_location_rounded,
                color: const Color(0xFF7C3AED).withOpacity(0.7), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => _controller.submit(context),
          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          label: const Text(
            'Submit Report',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF7C3AED),
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_rounded),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map_rounded),
            label: 'Heatmap',
          ),
        ],
      ),
    );
  }
}