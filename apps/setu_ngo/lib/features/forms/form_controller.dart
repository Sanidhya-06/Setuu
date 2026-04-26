import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────

enum FormStatus { active, draft }

enum FieldType { shortAnswer, paragraph, multipleChoice, checkbox }

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class FormFieldModel {
  final String id;
  final FieldType type;
  final String label;
  final List<String> options;

  const FormFieldModel({
    required this.id,
    required this.type,
    required this.label,
    this.options = const [],
  });

  FormFieldModel copyWith({
    String? id,
    FieldType? type,
    String? label,
    List<String>? options,
  }) {
    return FormFieldModel(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      options: options ?? List<String>.from(this.options),
    );
  }
}

class FormModel {
  final String id;
  final String title;
  final String description;
  final FormStatus status;
  final int responseCount;
  final DateTime createdAt;
  final List<FormFieldModel> fields;
  final String category; // 'my' | 'shared'

  const FormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.responseCount,
    required this.createdAt,
    required this.fields,
    required this.category,
  });

  FormModel copyWith({
    String? id,
    String? title,
    String? description,
    FormStatus? status,
    int? responseCount,
    DateTime? createdAt,
    List<FormFieldModel>? fields,
    String? category,
  }) {
    return FormModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      responseCount: responseCount ?? this.responseCount,
      createdAt: createdAt ?? this.createdAt,
      fields: fields ?? List<FormFieldModel>.from(this.fields),
      category: category ?? this.category,
    );
  }
}

// ─────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────

class FormController extends ChangeNotifier {
  final List<FormModel> _forms = [];

  String _searchQuery = '';
  String _activeTab = 'all'; // all | my | shared | drafts

  // Builder state
  String builderTitle = '';
  String builderDescription = '';
  final List<FormFieldModel> builderFields = [];

  // ── Getters ───────────────────────────────

  List<FormModel> get filteredForms {
    List<FormModel> base;
    switch (_activeTab) {
      case 'my':
        base = _forms.where((f) => f.category == 'my').toList();
        break;
      case 'shared':
        base = _forms.where((f) => f.category == 'shared').toList();
        break;
      case 'drafts':
        base = _forms.where((f) => f.status == FormStatus.draft).toList();
        break;
      default:
        base = List<FormModel>.from(_forms);
    }

    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base
        .where((f) =>
            f.title.toLowerCase().contains(q) ||
            f.description.toLowerCase().contains(q))
        .toList();
  }

  String get activeTab => _activeTab;
  String get searchQuery => _searchQuery;

  // ── Tab / Search ──────────────────────────

  void setTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  // ── CRUD ──────────────────────────────────

  void addForm(FormModel form) {
    _forms.insert(0, form);
    notifyListeners();
  }

  void updateForm(FormModel updated) {
    final idx = _forms.indexWhere((f) => f.id == updated.id);
    if (idx != -1) {
      _forms[idx] = updated;
      notifyListeners();
    }
  }

  void deleteForm(String id) {
    _forms.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // ── Seed (call once at startup) ───────────

  void seedDemoData() {
    if (_forms.isNotEmpty) return;
    _forms.addAll([
      FormModel(
        id: '1',
        title: 'Community Needs Assessment',
        description:
            'Survey to understand the key needs and challenges in the community.',
        status: FormStatus.active,
        responseCount: 256,
        createdAt: DateTime(2024, 5, 20),
        fields: const [],
        category: 'my',
      ),
      FormModel(
        id: '2',
        title: 'Tree Plantation Drive – Registration',
        description:
            'Registration form for volunteers who want to join the tree plantation drive.',
        status: FormStatus.active,
        responseCount: 142,
        createdAt: DateTime(2024, 5, 15),
        fields: const [],
        category: 'my',
      ),
      FormModel(
        id: '3',
        title: 'Food Donation Collection Form',
        description:
            'Collect donor details and food donation information.',
        status: FormStatus.active,
        responseCount: 89,
        createdAt: DateTime(2024, 5, 10),
        fields: const [],
        category: 'shared',
      ),
      FormModel(
        id: '4',
        title: 'Clean Water Awareness Feedback',
        description:
            'Feedback form for the clean water awareness campaign.',
        status: FormStatus.draft,
        responseCount: 23,
        createdAt: DateTime(2024, 5, 8),
        fields: const [],
        category: 'my',
      ),
      FormModel(
        id: '5',
        title: 'Education Program Feedback',
        description:
            'Feedback from students and parents about the education program.',
        status: FormStatus.active,
        responseCount: 312,
        createdAt: DateTime(2024, 5, 5),
        fields: const [],
        category: 'shared',
      ),
    ]);
    notifyListeners();
  }

  // ── Builder helpers ───────────────────────

  void resetBuilder() {
    builderTitle = '';
    builderDescription = '';
    builderFields.clear();
    notifyListeners();
  }

  void addBuilderField(FormFieldModel field) {
    builderFields.add(field);
    notifyListeners();
  }

  void removeBuilderField(String id) {
    builderFields.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  void updateBuilderField(FormFieldModel updated) {
    final idx = builderFields.indexWhere((f) => f.id == updated.id);
    if (idx != -1) {
      builderFields[idx] = updated;
      notifyListeners();
    }
  }

  void saveBuilderForm() {
    if (builderTitle.trim().isEmpty) return;
    addForm(FormModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: builderTitle.trim(),
      description: builderDescription.trim(),
      status: FormStatus.active,
      responseCount: 0,
      createdAt: DateTime.now(),
      fields: List<FormFieldModel>.from(builderFields),
      category: 'my',
    ));
    resetBuilder();
  }
}