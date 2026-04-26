import 'package:flutter/material.dart';
import '../form_controller.dart';

class FieldTile extends StatefulWidget {
  final FormFieldModel field;
  final ValueChanged<FormFieldModel> onChanged;
  final VoidCallback onRemove;

  const FieldTile({
    super.key,
    required this.field,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<FieldTile> createState() => _FieldTileState();
}

class _FieldTileState extends State<FieldTile> {
  late final TextEditingController _labelCtrl;
  late final List<TextEditingController> _optionCtrls;

  bool get _hasOptions =>
      widget.field.type == FieldType.multipleChoice ||
      widget.field.type == FieldType.checkbox;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.field.label);
    _optionCtrls = widget.field.options
        .map((o) => TextEditingController(text: o))
        .toList();
    if (_optionCtrls.isEmpty && _hasOptions) {
      _optionCtrls.add(TextEditingController(text: 'Option 1'));
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() {
    widget.onChanged(widget.field.copyWith(
      label: _labelCtrl.text,
      options: _optionCtrls.map((c) => c.text).toList(),
    ));
  }

  void _addOption() {
    setState(() => _optionCtrls.add(TextEditingController()));
    _notify();
  }

  void _removeOption(int i) {
    setState(() {
      _optionCtrls[i].dispose();
      _optionCtrls.removeAt(i);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5B4CFF).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────
          Row(
            children: [
              _TypeBadge(type: widget.field.type),
              const Spacer(),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.close,
                      size: 15, color: Colors.red.shade400),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Label ─────────────────────────────
          _StyledTextField(
            controller: _labelCtrl,
            hint: 'Question label',
            onChanged: (_) => _notify(),
          ),

          // ── Options ───────────────────────────
          if (_hasOptions) ...[
            const SizedBox(height: 12),
            ...List.generate(_optionCtrls.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      widget.field.type == FieldType.multipleChoice
                          ? Icons.radio_button_unchecked
                          : Icons.check_box_outline_blank,
                      size: 18,
                      color: const Color(0xFF5B4CFF),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StyledTextField(
                        controller: _optionCtrls[i],
                        hint: 'Option ${i + 1}',
                        onChanged: (_) => _notify(),
                        fontSize: 13,
                      ),
                    ),
                    if (_optionCtrls.length > 1)
                      GestureDetector(
                        onTap: () => _removeOption(i),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(Icons.remove_circle_outline,
                              size: 17, color: Colors.red.shade300),
                        ),
                      ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addOption,
              icon: const Icon(Icons.add,
                  size: 15, color: Color(0xFF5B4CFF)),
              label: const Text(
                'Add Option',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5B4CFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
            ),
          ],

          // ── Preview hints ─────────────────────
          if (widget.field.type == FieldType.shortAnswer) ...[
            const SizedBox(height: 10),
            _PreviewBox(height: 36, hint: 'Short answer text'),
          ],
          if (widget.field.type == FieldType.paragraph) ...[
            const SizedBox(height: 10),
            _PreviewBox(height: 58, hint: 'Long answer text...'),
          ],
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final FieldType type;
  const _TypeBadge({required this.type});

  static String _label(FieldType t) {
    switch (t) {
      case FieldType.shortAnswer:
        return 'Short Answer';
      case FieldType.paragraph:
        return 'Paragraph';
      case FieldType.multipleChoice:
        return 'Multiple Choice';
      case FieldType.checkbox:
        return 'Checkbox';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF5B4CFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label(type),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B4CFF),
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final double fontSize;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade200),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: fontSize, color: const Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontSize),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFF5B4CFF), width: 1.5),
        ),
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  final double height;
  final String hint;
  const _PreviewBox({required this.height, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      alignment: Alignment.topLeft,
      child: Text(hint,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
    );
  }
}