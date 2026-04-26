import 'package:flutter/material.dart';
import '../campaign_controller.dart';

/// A reusable form widget that can be embedded in both
/// [CreateCampaignScreen] and an edit flow.
///
/// Usage:
/// ```dart
/// CampaignForm(
///   onSubmit: (campaign) async { ... },
///   initialData: existingCampaign, // null for create
///   submitLabel: 'Save Changes',
/// )
/// ```
class CampaignForm extends StatefulWidget {
  final Future<bool> Function(Campaign campaign) onSubmit;
  final Campaign? initialData;
  final String submitLabel;

  const CampaignForm({
    super.key,
    required this.onSubmit,
    this.initialData,
    this.submitLabel = 'Create Campaign',
  });

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _maxVolunteersCtrl;

  late String _selectedCategory;
  late String _selectedStatus;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _saving = false;

  final List<String> _categories = [
    'Education',
    'Environment',
    'Health',
    'Community',
    'Disaster Relief',
  ];

  final List<String> _statuses = ['Active', 'Upcoming', 'Completed'];

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _titleCtrl = TextEditingController(text: d?.title ?? '');
    _descCtrl = TextEditingController(text: d?.description ?? '');
    _locationCtrl = TextEditingController(text: d?.location ?? '');
    _stateCtrl = TextEditingController(text: d?.state ?? '');
    _imageUrlCtrl = TextEditingController(text: d?.imageUrl ?? '');
    _maxVolunteersCtrl =
        TextEditingController(text: d?.maxVolunteers.toString() ?? '50');
    _selectedCategory =
        (_categories.contains(d?.category) ? d!.category : _categories.first);
    _selectedStatus =
        (_statuses.contains(d?.badge) ? d!.badge : 'Upcoming');
  }

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
    final initial = _selectedDate ??
        DateTime.now().add(const Duration(days: 7));
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: Color(0xFF5A4EFF)),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: Color(0xFF5A4EFF)),
        ),
        child: child!,
      ),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showSnack('Please select a date.', isError: true);
      return;
    }
    if (_selectedTime == null) {
      _showSnack('Please select a time.', isError: true);
      return;
    }

    setState(() => _saving = true);

    final campaign = Campaign(
      id: widget.initialData?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      date: _formatDate(_selectedDate!),
      time: _formatTime(_selectedTime!),
      imageUrl: _imageUrlCtrl.text.trim(),
      badge: _selectedStatus,
      badgeColor: Campaign.badgeColorForStatus(_selectedStatus),
      joinedCount: widget.initialData?.joinedCount ?? 0,
      maxVolunteers: int.tryParse(_maxVolunteersCtrl.text) ?? 50,
      volunteerAvatars: widget.initialData?.volunteerAvatars ?? [],
      category: _selectedCategory,
      organizerId: widget.initialData?.organizerId ?? 'current_user_id',
    );

    final success = await widget.onSubmit(campaign);
    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      _showSnack('Something went wrong. Please try again.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Rubik')),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF22C55E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Image Preview ──────────────────────────────────────────────
          if (_imageUrlCtrl.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    _imageUrlCtrl.text,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEEEBFF),
                      child: const Icon(Icons.broken_image_outlined,
                          color: Color(0xFF5A4EFF), size: 40),
                    ),
                  ),
                ),
              ),
            ),

          _sectionLabel('Campaign Details'),
          _field('Title', _titleCtrl,
              hint: 'e.g. Beach Cleanup Drive',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null),
          const SizedBox(height: 14),
          _field('Description', _descCtrl,
              hint: 'What will volunteers be doing?',
              maxLines: 3,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Description is required'
                  : null),
          const SizedBox(height: 14),
          _field('Location', _locationCtrl,
              hint: 'e.g. Bali, Indonesia',
              prefixIcon: Icons.location_on_outlined,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Location is required'
                  : null),
          const SizedBox(height: 14),
          _field('State', _stateCtrl,
              hint: 'e.g. Maharashtra',
              prefixIcon: Icons.map_outlined),
          const SizedBox(height: 14),
          _field(
            'Campaign Image URL',
            _imageUrlCtrl,
            hint: 'https://...',
            prefixIcon: Icons.image_outlined,
            onChanged: (_) => setState(() {}), // trigger preview rebuild
          ),

          const SizedBox(height: 20),
          _sectionLabel('Schedule'),
          Row(
            children: [
              Expanded(
                child: _dateTile(
                  label: 'Date',
                  value: _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'Select Date',
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dateTile(
                  label: 'Time',
                  value: _selectedTime != null
                      ? _formatTime(_selectedTime!)
                      : 'Select Time',
                  icon: Icons.access_time_outlined,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _sectionLabel('Configuration'),
          _dropdownField(
              'Category',
              _selectedCategory,
              _categories,
              (v) => setState(() => _selectedCategory = v!)),
          const SizedBox(height: 14),
          _dropdownField(
              'Status',
              _selectedStatus,
              _statuses,
              (v) => setState(() => _selectedStatus = v!)),
          const SizedBox(height: 14),
          _field(
            'Max Volunteers',
            _maxVolunteersCtrl,
            hint: '50',
            prefixIcon: Icons.group_outlined,
            keyboardType: TextInputType.number,
            validator: (v) {
              final n = int.tryParse(v ?? '');
              if (n == null || n <= 0) return 'Enter a valid number';
              return null;
            },
          ),

          const SizedBox(height: 32),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _saving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A4EFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : Text(
                      widget.submitLabel,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1C),
            )),
      );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    int maxLines = 1,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B6B6B),
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Color(0xFF1C1C1C)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontFamily: 'Rubik', color: Color(0xFFBBBBBB)),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    color: const Color(0xFF6B6B6B), size: 18)
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF5A4EFF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B6B6B),
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6B6B6B)),
              style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  color: Color(0xFF1C1C1C)),
              items: options
                  .map((o) =>
                      DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF5A4EFF)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  color: value.startsWith('Select')
                      ? const Color(0xFFBBBBBB)
                      : const Color(0xFF1C1C1C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}