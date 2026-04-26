import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../form_controller.dart';
import '../widgets/form_card.dart';
import 'form_builder.dart';

class FormsListScreen extends StatefulWidget {
  const FormsListScreen({super.key});

  @override
  State<FormsListScreen> createState() => _FormsListScreenState();
}

class _FormsListScreenState extends State<FormsListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToBuilder(BuildContext context) {
    context.read<FormController>().resetBuilder();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const FormBuilderScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormController>(
      builder: (context, ctrl, _) {
        final forms = ctrl.filteredForms;
        return Scaffold(
          backgroundColor: const Color(0xFFF4F3FF),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _goToBuilder(context),
            backgroundColor: const Color(0xFF5B4CFF),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(onAdd: () => _goToBuilder(context)),
                _HeroBanner(onCreate: () => _goToBuilder(context)),
                _TabBar(ctrl: ctrl),
                _SearchBar(ctrl: ctrl, controller: _searchCtrl),
                Expanded(child: _FormList(forms: forms, ctrl: ctrl)),
                _UpgradeBanner(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Sections ──────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onAdd;
  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forms',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Create forms, collect responses and gain insights.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
              ),
            ],
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF5B4CFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onCreate;
  const _HeroBanner({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 14, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDE9FF), Color(0xFFD5CCFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Your First Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Build custom forms to collect data\nfrom your community.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onCreate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B4CFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 15),
                        SizedBox(width: 6),
                        Text(
                          'Create Form',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: const Color(0xFF5B4CFF).withOpacity(0.28),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final FormController ctrl;
  const _TabBar({required this.ctrl});

  static const _tabs = [
    ('all', 'All Forms'),
    ('my', 'My Forms'),
    ('shared', 'Shared with Me'),
    ('drafts', 'Drafts'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        children: _tabs.map((t) {
          final active = ctrl.activeTab == t.$1;
          return GestureDetector(
            onTap: () => ctrl.setTab(t.$1),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF5B4CFF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? const Color(0xFF5B4CFF)
                      : Colors.grey.shade200,
                ),
              ),
              child: Text(
                t.$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final FormController ctrl;
  final TextEditingController controller;
  const _SearchBar({required this.ctrl, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: controller,
                onChanged: ctrl.setSearchQuery,
                style:
                    const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Search forms...',
                  hintStyle: TextStyle(
                      fontSize: 13.5, color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search,
                      size: 20, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.tune, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 5),
                Text('Filter',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormList extends StatelessWidget {
  final List<FormModel> forms;
  final FormController ctrl;
  const _FormList({required this.forms, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (forms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text('No forms found',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400)),
            Text('Create a new form using the + button',
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      itemCount: forms.length,
      itemBuilder: (_, i) => FormCard(
        key: ValueKey(forms[i].id),
        form: forms[i],
        onTap: () {},
        onViewResponses: () {},
        onDelete: () => ctrl.deleteForm(forms[i].id),
      ),
    );
  }
}

class _UpgradeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5B4CFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.bar_chart_outlined,
                color: Color(0xFF5B4CFF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need advanced insights?',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E)),
                ),
                Text(
                  'Upgrade to Pro to get advanced analytics, custom themes and more powerful features.',
                  style:
                      TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xFF5B4CFF).withOpacity(0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Upgrade Now',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B4CFF)),
            ),
          ),
        ],
      ),
    );
  }
}