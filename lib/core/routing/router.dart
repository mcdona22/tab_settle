// import 'package:canya_mobile/features/group/presentation/group_screen.dart';
// import 'package:canya_mobile/features/landing/landing_screen.dart';
// import 'package:canya_mobile/features/user/presentation/user_detail_screen.dart';
// import 'package:canya_mobile/features/user/presentation/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_page.dart';
import 'package:tab_settle/features/bill_reduce/presentation/bill_presentation_page.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_page.dart';
import 'package:tab_settle/features/home/home_page.dart';
import 'package:tab_settle/features/intro_screens/introductory_page.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/receipt_dashboard_shell.dart';
import 'package:tab_settle/main.dart';

enum AppRoute {
  home,
  addReceipt,
  checkReceipt,
  showReceipt,
  receiptDashboard,
  introScreen,
  introScreenWithParam,
}

final routerConfig = GoRouter(
  initialLocation: '/intro',
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      pageBuilder: (_, state) =>
          MaterialPage(child: HomePage(), key: state.pageKey),
    ),

    GoRoute(
      path: '/intro',
      name: AppRoute.introScreen.name,
      pageBuilder: (_, state) {
        logDebug('router using the /intro path');
        return MaterialPage(
          child: IntroductoryPage(receiptId: ''),
          key: state.pageKey,
        );
      },
      routes: [
        GoRoute(
          path: ':id',
          name: AppRoute.introScreenWithParam.name,
          pageBuilder: (_, state) {
            final id = state.pathParameters['id'] ?? '';
            logDebug('the id found is "$id"');

            return MaterialPage(
              child: IntroductoryPage(receiptId: id),
              key: state.pageKey,
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/submitReceipt',
      name: AppRoute.addReceipt.name,
      pageBuilder: (_, state) {
        return MaterialPage(child: BillSubmissionPage(), key: state.pageKey);
      },
    ),

    GoRoute(
      path: '/checkReceipt',
      name: AppRoute.checkReceipt.name,
      pageBuilder: (_, state) {
        final dto = state.extra as ReceiptDto;
        return MaterialPage(child: ScannedBillPage(dto: dto));
      },
    ),
    GoRoute(
      path: '/showReceipt',
      name: AppRoute.showReceipt.name,
      pageBuilder: (_, state) {
        final receipt = state.extra as Receipt?;
        return MaterialPage(child: BillPresentationPage(receipt: receipt!));
      },
    ),

    GoRoute(
      path: '/receipt/:id',
      name: AppRoute.receiptDashboard.name,
      pageBuilder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        logDebug('navigating to dashboard with id of $id');
        return MaterialPage(child: ReceiptDashboardShell(receiptId: id));
      },
    ),
    // GoRoute(
    //   path: '/group/:id',
    //   name: AppRoute.group.name,
    //   pageBuilder: (_, state) {
    //     final groupId = state.pathParameters['id'] ?? '';
    //     logDebug('going to $groupId');
    //     return MaterialPage(
    //       child: GroupScreen(groupId: groupId),
    //       key: state.pageKey,
    //     );
    //   },
    // ),

    // GoRoute(
    //     path: '/user',
    //     name: AppRoute.user.name,
    //     pageBuilder: (_, state) {
    //       return MaterialPage(
    //         child: UserListScreen(),
    //         key: state.pageKey,
    //       );
    //     },
    //     routes: [
    //       GoRoute(
    //           path: ':id', name: AppRoute.userDetail
    //           .name, pageBuilder: (_, state) {
    //         final groupId = state.pathParameters['id'] ??
    //             '';
    //         logDebug('going to user $groupId');
    //         return MaterialPage(
    //             child: UserDetailScreen(id: groupId,),
    //             key: state.pageKey
    //         );
    //       }),

    //     ]
    // ),
  ],
);
