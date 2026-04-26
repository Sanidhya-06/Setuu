import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../form_controller.dart';
import '../widgets/field_tile.dart';

class FormBuilderScreen extends StatefulWidget {
  const FormBuilderScreen({super.key});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _addField(FormController ctrl, FieldType type) {
    ctrl.addBuilderField(FormFieldModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      label: '',
      options: (type == FieldType.multipleChoice || type == FieldType.checkbox)
          ? ['Option 1']
          : [],
    ));
  }

  void _save(BuildContext context, FormController ctrl) {
    if (!_formKey.currentState!.validate()) return;
    ctrl
      ..builderTitle = _titleCtrl.text
      ..builderDescription = _descCtrl.text
      ..saveBuilderForm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Form saved successfully!'),
        backgroundColor: const Color(0xFF5B4CFF),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormController>(
      builder: (context, ctrl, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F3FF),
          appBar: _buildAppBar(context),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormDetailsCard(
                      titleCtrl: _titleCtrl, descCtrl: _descCtrl),
                  const SizedBox(height: 18),
                  if (ctrl.builderFields.isNotEmpty) ...[
                    _SectionLabel(
                        label: 'Form Fields (${ctrl.builderFields.length})'),
                    const SizedBox(height: 10),
                    ...ctrl.builderFields.map((f) => FieldTile(
                          key: ValueKey(f.id),
                          field: f,
                          onChanged: ctrl.updateBuilderField,
                          onRemove: () => ctrl.removeBuilderField(f.id),
                        )),
                    const SizedBox(height: 6),
                  ] else ...[
                    _EmptyFieldsHint(),
                    const SizedBox(height: 18),
                  ],
                  _AddFieldPanel(onAdd: (type) => _addField(ctrl, type)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _SaveBar(
            onSave: () => _save(context, ctrl),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4F3FF),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 17, color: Color(0xFF1A1A2E)),
        ),
      ),
      title: const Text(
        'Create Form',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      centerTitle: true,
    );
  }
}

// ── Sub-widgets ──────────────────────────────────

class _FormDetailsCard extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  const _FormDetailsCard(
      {required this.titleCtrl, required this.descCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: titleCtrl,
            label: 'Form Title *',
            hint: 'e.g. Community Survey',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Title is required' : null,
          ),
          const SizedBox(height: 12),
          _InputField(
            controller: descCtrl,
            label: 'Description',
            hint: 'Brief description of this form',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: border,
            enabledBorder: border,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF5B4CFF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}

class _EmptyFieldsHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.add_box_outlined, size: 46, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text('No fields added yet',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400)),
          Text('Use the panel below to add fields',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _AddFieldPanel extends StatelessWidget {
  final ValueChanged<FieldType> onAdd;
  const _AddFieldPanel({required this.onAdd});

  static const _types = [
    (FieldType.shortAnswer, Icons.short_text, 'Short Answer'),
    (FieldType.paragraph, Icons.notes_outlined, 'Paragraph'),
    (FieldType.multipleChoice, Icons.radio_button_checked_outlined,
        'Multiple Choice'),
    (FieldType.checkbox, Icons.check_box_outlined, 'Checkbox'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Field',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.map((t) {
              return GestureDetector(
                onTap: () => onAdd(t.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4CFF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF5B4CFF).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.$2, size: 15, color: const Color(0xFF5B4CFF)),
                      const SizedBox(width: 7),
                      Text(
                        t.$3,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B4CFF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final VoidCallback onSave;
  const _SaveBar({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F3FF),
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B4CFF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Text(
            'Save Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}