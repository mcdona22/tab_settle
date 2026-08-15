// import 'package:canya_mobile/features/group/presentation/group_screen.dart';
// import 'package:canya_mobile/features/landing/landing_screen.dart';
// import 'package:canya_mobile/features/user/presentation/user_detail_screen.dart';
// import 'package:canya_mobile/features/user/presentation/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_page.dart';
import 'package:tab_settle/features/bill_reduce/presentation/bill_presentation_page.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_page.dart';
import 'package:tab_settle/features/home/home_page.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

enum AppRoute { home, addReceipt, checkReceipt, showReceipt }

final routerConfig = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      pageBuilder: (_, state) =>
          MaterialPage(child: HomePage(), key: state.pageKey),
    ),

    GoRoute(
      path: '/receipt',
      name: AppRoute.addReceipt.name,
      pageBuilder: (_, state) {
        return MaterialPage(child: BillSubmissionPage(), key: state.pageKey);
      },
    ),

    GoRoute(
      path: '/checkReceipt',
      name: AppRoute.checkReceipt.name,
      pageBuilder: (_, state) {
        final filePath = state.extra as String?;
        return MaterialPage(child: ScannedBillPage(filePath: filePath ?? ''));
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
