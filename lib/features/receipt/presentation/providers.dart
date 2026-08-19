// import 'package:faker/faker.dart';
// import 'package:loggy/loggy.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'providers.g.dart';
//
// @Riverpod(keepAlive: true)
// class UserHandleController extends _$UserHandleController with UiLoggy {
//   @override
//   build() {
//     ref.onDispose(() => loggy.debug('disposing'));
//
//     final faker = Faker();
//     final adjective = faker.person.firstName();
//     final name = faker.animal.name();
//     return '$adjective the $name';
//   }
//
//   void updateHandle(String handle) {
//     state = handle;
//     loggy.debug('$handle saved to provider scope');
//   }
// }
