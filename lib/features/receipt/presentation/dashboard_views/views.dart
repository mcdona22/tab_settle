import 'package:flutter/material.dart';
import 'package:tab_settle/features/receipt/presentation/dashboard_views/dashboard_claim_view.dart';

import 'dashboard_summary_view.dart';

enum DashboardTab {
  overview(
    label: 'Overview',
    icon: Icons.receipt_long,
    view: DashboardSummaryView(),
  ),
  myClaims(
    label: 'My Claims',
    icon: Icons.checklist,
    view: DashboardClaimView(),
  );

  const DashboardTab({
    required this.label,
    required this.icon,
    required this.view,
  });

  final String label;
  final IconData icon;
  final Widget view;
}
