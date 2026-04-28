import 'package:flutter/material.dart';
import '../campaign_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CreateCampaignScreen extends StatefulWidget {
  final CampaignController controller;

  const CreateCampaignScreen({super.key, required this.controller});

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _maxVolunteersCtrl = TextEditingController(text: '50');

  String _selectedCategory = 'Environment';
  String _selectedStatus = 'Upcoming';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _saving = false;
  double? _latitude;
  double? _longitude;

  final List<String> _categories = [
    'Education',
    'Environment',
    'Health',
    'Community',
    'Disaster Relief',
  ];

  final List<String> _statuses = ['Active', 'Upcoming', 'Completed'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _stateCtrl.dispose();
    _imageUrlCtrl.dispose();
    _maxVolunteersCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  Future<void> _pickCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError("Enable GPS first");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError("Permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError("Enable permission from settings");
        await Geolocator.openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      _latitude = position.latitude;
      _longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _latitude!,
        _longitude!,
      );

      if (placemarks.isEmpty) {
        _showError("Couldn't fetch address");
        return;
      }

      final place = placemarks.first;

      setState(() {
        _locationCtrl.text =
            "${place.locality ?? ''}, ${place.subLocality ?? ''}";
        _stateCtrl.text = place.administrativeArea ?? '';
      });
    } catch (e) {
      _showError("Location error: $e");
    }
  }

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour}:${t.minute.toString().padLeft(2, '0')}";

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedTime == null) {
      _showError("Select date & time");
      return;
    }

    setState(() => _saving = true);

    final campaign = Campaign(
      id: '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      date: _formatDate(_selectedDate!),
      time: _formatTime(_selectedTime!),
      imageUrl: _imageUrlCtrl.text.trim(),
      badge: _selectedStatus,
      badgeColor: Campaign.badgeColorForStatus(_selectedStatus),
      joinedCount: 0,
      maxVolunteers: int.tryParse(_maxVolunteersCtrl.text) ?? 50,
      volunteerAvatars: [],
      category: _selectedCategory,
      organizerId: FirebaseAuth.instance.currentUser!.uid,
    );

    try {
      final success = await widget.controller.createCampaign(campaign);

      setState(() => _saving = false);

      if (!mounted) return;

      // ✅ Capture messenger BEFORE popping so context is still valid
      final messenger = ScaffoldMessenger.of(context);

      if (success) {
        Navigator.pop(context, true);
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Campaign created successfully!"),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      } else {
        _showError("Creation failed. Please try again.");
      }
    } catch (e) {
      setState(() => _saving = false);
      if (!mounted) return;
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Campaign')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field("Title", _titleCtrl),
            _field("Description", _descCtrl, maxLines: 3),
            _field(
              "Location",
              _locationCtrl,
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _pickCurrentLocation,
              ),
            ),
            _field("State", _stateCtrl),
            _field("Image URL", _imageUrlCtrl),
            _field("Max Volunteers", _maxVolunteersCtrl),

            const SizedBox(height: 12),

            // ✅ Category dropdown (was missing from UI)
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),

            const SizedBox(height: 12),

            // ✅ Status dropdown (was missing from UI)
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: _statuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? "Pick Date"
                    : _formatDate(_selectedDate!),
              ),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.access_time),
              label: Text(
                _selectedTime == null
                    ? "Pick Time"
                    : _formatTime(_selectedTime!),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Create Campaign"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        validator: (v) =>
            v == null || v.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}