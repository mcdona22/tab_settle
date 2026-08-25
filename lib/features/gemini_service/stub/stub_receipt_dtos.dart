import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';

final stubReceiptDtos = <ReceiptDto>[
  // 1. Standard Pub Meal (UK)
  const ReceiptDto(
    merchantName: 'Toby Carvery Castle View',
    currency: '£',
    subtotal: 26.52,
    serviceCharge: 0.0,
    totalAmount: 26.52,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Midweek Carvery',
        quantity: 2,
        price: 22.58,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'ULSD Sugar Free',
        quantity: 1,
        price: 3.94,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 2. Coffee Shop with Service Charge
  const ReceiptDto(
    merchantName: 'Nero Roastery',
    currency: '£',
    subtotal: 12.00,
    serviceCharge: 1.50,
    totalAmount: 13.50,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Flat White',
        quantity: 2,
        price: 7.20,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Almond Croissant',
        quantity: 1,
        price: 4.80,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 3. Tapas Night (Edge case: Item Discrepancy)
  const ReceiptDto(
    merchantName: 'La Casita Tapas Bar',
    currency: '£',
    subtotal: 48.50,
    serviceCharge: 5.00,
    totalAmount: 53.50,
    hasFallbackValues: false,
    hasDiscrepancy: true,
    items: [
      ReceiptItemDto(
        name: 'Patatas Bravas',
        quantity: 1,
        price: 6.50,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Gambas al Ajillo (Blurry Price)',
        quantity: 2,
        price: 18.00,
        hasFallbackValues: false,
        hasDiscrepancy: true,
      ),
      ReceiptItemDto(
        name: 'Chorizo in Red Wine',
        quantity: 3,
        price: 24.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 4. Large Group Dinner
  const ReceiptDto(
    merchantName: 'The Olive Tree Italian',
    currency: '£',
    subtotal: 112.00,
    serviceCharge: 14.00,
    totalAmount: 126.00,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Spaghetti Carbonara',
        quantity: 2,
        price: 28.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Margherita Pizza',
        quantity: 2,
        price: 24.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Ribeye Steak 10oz',
        quantity: 1,
        price: 32.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'House Red Wine Bottle',
        quantity: 1,
        price: 28.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 5. European Travel Expense (EUR Currency)
  const ReceiptDto(
    merchantName: 'Bistro De Paris',
    currency: '€',
    subtotal: 34.00,
    serviceCharge: 0.0,
    totalAmount: 34.00,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Steak Frites',
        quantity: 1,
        price: 22.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Perrier 750ml',
        quantity: 2,
        price: 12.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 6. US Trip Expense (USD Currency)
  const ReceiptDto(
    merchantName: 'Joe\'s Diner NYC',
    currency: '\$',
    subtotal: 28.50,
    serviceCharge: 5.70,
    totalAmount: 34.20,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Pancake Stack Combo',
        quantity: 1,
        price: 16.50,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Bottomless Coffee',
        quantity: 3,
        price: 12.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 7. Single Item Quick Purchase
  const ReceiptDto(
    merchantName: 'Greggs Bakery',
    currency: '£',
    subtotal: 4.10,
    serviceCharge: 0.0,
    totalAmount: 4.10,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Sausage Roll (2 Pack)',
        quantity: 1,
        price: 2.60,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Tea Large',
        quantity: 1,
        price: 1.50,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 8. OCR Parsing Edge Case (Fallback Values Triggered)
  const ReceiptDto(
    merchantName: 'Unknown Merchant',
    currency: 'GBP',
    subtotal: null,
    serviceCharge: 0.0,
    totalAmount: 18.20,
    hasFallbackValues: true,
    hasDiscrepancy: true,
    items: [
      ReceiptItemDto(
        name: 'Unknown Item',
        quantity: 1,
        price: 18.20,
        hasFallbackValues: true,
        hasDiscrepancy: true,
      ),
    ],
  ),

  // 9. Craft Beer Bar
  const ReceiptDto(
    merchantName: 'The Northern Hop Pub',
    currency: '£',
    subtotal: 21.40,
    serviceCharge: 0.0,
    totalAmount: 21.40,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Hazy IPA Pint',
        quantity: 2,
        price: 13.60,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Dry Cider Pint',
        quantity: 1,
        price: 6.20,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Pork Scratchings',
        quantity: 1,
        price: 1.60,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),

  // 10. Asian Cuisine / Dim Sum Shared Lunch
  const ReceiptDto(
    merchantName: 'Lotus Blossom Dim Sum',
    currency: '£',
    subtotal: 62.00,
    serviceCharge: 6.20,
    totalAmount: 68.20,
    hasFallbackValues: false,
    hasDiscrepancy: false,
    items: [
      ReceiptItemDto(
        name: 'Siu Mai (4pcs)',
        quantity: 3,
        price: 19.50,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Har Gow (4pcs)',
        quantity: 3,
        price: 21.00,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
      ReceiptItemDto(
        name: 'Crispy Duck Half',
        quantity: 1,
        price: 21.50,
        hasFallbackValues: false,
        hasDiscrepancy: false,
      ),
    ],
  ),
];
