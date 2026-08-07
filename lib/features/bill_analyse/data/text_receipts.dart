const mockReceipts = [
  {'name': 'Royal Oak', 'receipt': mockReceiptRoyalOak},
  {'name': 'LA TRATTORIA', 'receipt': mockReceiptItalian},
  {'name': 'THE HEAD OF STEAM', 'receipt': mockReceiptPub},
  {'name': 'The Rusty Anchor', 'receipt': mockReceiptCreased},
  {'name': 'Pizza Paradiso', 'receipt': mockReceiptFadedPrices},
  {'name': 'The Mill Cafe', 'receipt': mockReceiptInkBlot},
];

const imageAssetReceipts = [
  {'name': 'Sapore Italiano', 'path': 'sapore.jpeg'},
  {'name': 'Sapore Italiano 2', 'path': 'sapore2.jpg'},
  {'name': 'Toby Carvery', 'path': 'toby.jpeg'},
];

const mockReceiptRoyalOak = '''
THE ROYAL OAK
12 High Street, Huddersfield
25/07/2026 19:42

2x Fish & Chips     £28.00
1x Pint Pale Ale    £5.50
1x Sparkling Water  £2.50

Subtotal:           £36.00
VAT (20%):          £7.20
Service Charge:     £3.60
Total Paid:         £46.80
''';

const String mockReceiptItalian = '''
LA TRATTORIA
24 Church Street, Huddersfield
01/08/2026 20:15

1x Garlic Bread Supreme     £6.50
2x Penne Arrabbiata @ £13.50 £27.00
1x Margherita Pizza         £12.00
2x Peroni Nastro Azzurro    £11.00
1x Tiramisu                 £6.50

Subtotal:                   £63.00
10% Service Charge:         £6.30
Grand Total:                £69.30

Thank you for dining with us!
''';

const String mockReceiptPub = '''
THE HEAD OF STEAM
St George's Square, Huddersfield
01/08/2026 18:30

ORDER #104 - TABLE 12

1x Artisan Burger           £14.50
1x Fish & Chips             £15.00
2x Session IPA @ 5.20       £10.40
1x Diet Coke                £2.80

TOTAL TO PAY:               £42.70
Includes 20% VAT:           £7.12
''';

const String mockReceiptCreased = '''
--- [RECEIPT DAMAGE: HORIZONTAL CREASE] ---
THE Rusty Anchor
12 Pier Road
-------------------------------------------
1x Fish & Chips             £14.50
1x [=== TORN / CREASED - TEXT UNREADABLE ===]
1x Mushy Peas               £2.00
2x Pint Ale                 £9.00
-------------------------------------------
TOTAL:                      £31.00
''';

/// Damaged Test Case 2: Thermal Paper Faded / Smudged Prices
const String mockReceiptFadedPrices = '''
*** [RECEIPT DAMAGE: THERMAL FADE] ***
PIZZA PARADISO
01/08/2026

1x Garlic Bread             £5.50
1x Spicy Pepperoni          £??.??
1x Coke Zero                £2.50
1x Espresso                 £2.00

TOTAL PAID:                 £24.00
-------------------------------------------
(Note: Middle price obscured by heat damage)
''';

/// Damaged Test Case 3: Ink Blot / Thumb Coverage on Quantities & Items
const String mockReceiptInkBlot = '''
### [RECEIPT DAMAGE: HEAVY INK BLOT] ###
THE MILL CAFE
-------------------------------------------
??x Full English Breakfast   £11.00
1x Cappuccino               £3.50
##x [BLOTTED OUT]           £4.50
-------------------------------------------
SUBTOTAL:                   £19.00
CARD PAYMENT:               £19.00
''';
