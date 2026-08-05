import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_schema_provider.g.dart';

@Riverpod(keepAlive: true)
Schema receiptSchema(Ref ref) {
  return Schema.object(
    properties: {
      'merchantName': Schema.string(
        description: 'Name of the restaurant or business.',
      ),
      'currency': Schema.string(
        description: 'ISO currency symbol or code (e.g. GBP, £, USD, EUR).',
      ),
      'subtotal': Schema.number(
        description: 'Total before service charge or taxes, if printed.',
      ),
      'serviceCharge': Schema.number(
        description: 'Explicit service charge or gratuity amount, if printed.',
      ),
      'totalAmount': Schema.number(description: 'Total final bill amount.'),
      'items': Schema.array(
        description: 'Line items on the receipt.',
        items: Schema.object(
          properties: {
            'name': Schema.string(description: 'Description of item.'),
            'quantity': Schema.integer(description: 'Quantity ordered.'),
            'price': Schema.number(
              description: 'Total price for this line item.',
            ),
          },
          requiredProperties: ['name', 'price', 'quantity'],
        ),
      ),
    },
    requiredProperties: [
      'merchantName',
      'totalAmount',
      'items',
      'serviceCharge',
    ],
  );
}
