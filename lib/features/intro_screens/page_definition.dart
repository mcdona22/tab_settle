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
      'Take a pic of the receipt and let me break it down for you',
      'At the moment you have to have taken the pic already but soon you can '
          'use your camera from your device',
    ],
  ),

  IntroPageData(
    filename: 'check.webp',
    title: 'Check My Conversion',
    text: [
      "I'm usually pretty accurate with this but sometimes its challenging.  "
          "Some receipts are damaged, sometimes its OK but the merchant will  "
          "layout their receipts in an unusual way",
      "When we encounter this you need to be able to edit what I produce",
      "",
      "NOTE",
      "This is currently unavailable but you can edit the name of the "
          "receipt right now",
    ],
  ),

  IntroPageData(
    filename: 'share-bill.webp',
    title: 'Share the bill',
    text: [
      "Assuming you are happy you can now send the receipt to the cloud and "
          "its available for you to share and you will be directed to the "
          "receipt dashboard",
      "From there you will be able to share the link to the dashboard that "
          "using youre preferred app or show the QR code to "
          "your peeps - they will then be able to join you in the dashboard",
      "This dashboard is where you can claim your items and see what others "
          "have claimed,  all in real time",
      "If you havent visited the dashboard before you will be given a user "
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
