class IntroPageData {
  final String filename;
  final String? title;
  final List<String> text;

  const IntroPageData({required this.filename, this.title, required this.text});
}

final pages = [
  IntroPageData(
    filename: 'scan.webp',
    title: 'Scan Receipt',
    text: [
      'Take a pic of the receipt and let me analyse it for you',
      'Coming soon...',
      ''
          'Activate the camera from within the application',
      'Add analysis instructions.  E.g. "filter out line items having a price'
          ' of £0.00"',
    ],
  ),

  IntroPageData(
    filename: 'check.webp',
    title: 'Check My Conversion',
    text: [
      "I'm usually pretty accurate with this but sometimes its a challenge.  "
          "Some receipts are damaged. On occasions the merchant will  "
          "layout their receipts in an unusual way",
      "For a number of reasons you may need to edit the breakdown I "
          "produce",
      "",
      "NOTE",
      "You can edit receipt name (how it will appear in the dashboard) but "
          "you will have to wait for a later release to edit the receipts "
          "line items",
    ],
  ),

  IntroPageData(
    filename: 'share-bill.webp',
    title: 'Share the bill',
    text: [
      "Once you are happy you can now send the receipt to the cloud and "
          "its available for you to share.  You will be directed to the "
          "receipt dashboard",
      "From there you will be able to share this link with your peeps "
          "using your preferred app or show them the QR code"
          " - they will then be able to join you in the dashboard",
      "This dashboard is where you can claim your items and see what others "
          "have claimed,  all in real time",
      "If you haven't visited the dashboard before you will be given a user "
          "handle such as 'Tony the Tiger' you can change this to a handle "
          "you prefer - or not 😉",
    ],
  ),

  // {
  //   'filename': 'share-bill.webp',
  //   'title': 'Share the Items',
  //   'description': [
  //     'Share  it with '
  //         'your friends to claim their items on the bill',
  //   ],
  // },
];
