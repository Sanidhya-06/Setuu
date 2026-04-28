import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/dashboard_provider.dart';
import 'widgets/dashboard_body.dart';
import 'widgets/dashboard_loading_view.dart';
import 'widgets/dashboard_error_view.dart';

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSwitch;

  const DashboardScreen({super.key, this.onTabSwitch});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: switch (provider.status) {
          DashboardStatus.loading ||
          DashboardStatus.initial =>
            const DashboardLoadingView(),

          DashboardStatus.error => DashboardErrorView(
              message: provider.errorMessage ?? 'Something went wrong',
              onRetry: provider.refresh,
            ),

          DashboardStatus.loaded => DashboardBody(
              provider: provider,
              onTabSwitch: widget.onTabSwitch,
            ),
        },
      ),
    );
  }
}