import 'package:flutter_test/flutter_test.dart';
import 'package:tab_settle/features/receipt_correct/presentation/form_validators.dart';

void main() {
  final testCases = [
    (
      name: 'null value not permitted',
      input: null,
      result: FormValidators.isRequired,
    ),
    (
      name: 'empty string not permitted',
      input: '',
      result: FormValidators.isRequired,
    ),

    (
      name: 'padded empty string not permitted',
      input: '     ',
      result: FormValidators.isRequired,
    ),
  ];

  group('name validation', () {
    // (value, expected)

    for (final testCase in testCases) {
      test('Name Validation: ${testCase.name}', () {
        final result = FormValidators.requiredName(testCase.input);
        expect(result!.endsWith(FormValidators.isRequired), true);
      });
    }

    final positiveTests = [
      (name: 'alphanumeric string is acceptable', input: 'abc 123'),
      (name: 'padded string is acceptable', input: '   abc 123   '),
    ];

    for (final testCase in positiveTests) {
      test(
        testCase.name,
        () => expect(FormValidators.requiredName(testCase.input), null),
      );
    }
  });

  group('quantity validation', () {
    for (final testCase in testCases) {
      test(testCase.name, () {
        final result = FormValidators.nonNegativeInteger(testCase.input);
        expect(result!.endsWith(FormValidators.isRequired), true);
      });
    }

    final failingCases = [
      (name: 'negative number', input: '-1', result: FormValidators.notAllowed),
      (name: 'not a number', input: 'three', result: FormValidators.notValid),
      (name: 'not an integer', input: '1.5', result: FormValidators.notValid),
    ];

    for (final testCase in failingCases) {
      test('${testCase.name} is not permitted', () {
        final result = FormValidators.nonNegativeInteger(testCase.input);
        expect(result, equals(testCase.result));
      });
    }

    test(
      'good integer is ok',
      () => expect(FormValidators.nonNegativeInteger('5'), null),
    );

    test(
      'padded integer is ok',
      () => expect(FormValidators.nonNegativeInteger(' 5  '), null),
    );
  });

  group('Price Validation', () {
    for (final testCase in testCases) {
      test('Price Validation: ${testCase.name}', () {
        final result = FormValidators.nonNegativePrice(testCase.input);
        expect(result!.endsWith(FormValidators.isRequired), true);
      });
    }

    final priceScenarios = [
      (
        name: 'negative integer not allowed',
        input: '-1',
        result: FormValidators.notAllowed,
      ),
      (
        name: 'negative double not allowed',
        input: '-1.3',
        result: FormValidators.notAllowed,
      ),
      (name: 'integer is good', input: '32', result: null),
      (name: 'double is good', input: '32.0', result: null),
      (name: 'padded integer is good', input: ' 32  ', result: null),
      (name: 'padded double is good', input: ' 32.98  ', result: null),
    ];

    for (final testCase in priceScenarios) {
      test(
        testCase.name,
        () => expect(
          FormValidators.nonNegativePrice(testCase.input),
          testCase.result,
        ),
      );
    }
  });
}
