import 'package:flutter/material.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/dashboard_views/dashboard_share_view.dart';

import 'dashboard_claim_view.dart';
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
  ),
  shareDetails(
    label: 'Share Details',
    icon: Icons.qr_code,
    view: DashboardShareView(),
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
