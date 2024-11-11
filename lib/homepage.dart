import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        // color: Colors.red,
        // constraints: BoxConstraints(maxHeight: 200),
        child: MyBannerAdWidget(
          adSize: AdSize(width: Get.width.toInt(), height: 200),
        ),
      ),
    );
  }
}

class MyBannerAdWidget extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;

  /// The AdMob ad unit to show.
  ///

  final String adUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test banner ad unit ID

  //   final String adUnitId = Platform.isAndroid
  // // Use this test ad unit ID for development
  // ? 'ca-app-pub-3940256099942544/6300978111'
  // // Use test ad unit ID for iOS
  // : 'ca-app-pub-3940256099942544/2934735716';
  MyBannerAdWidget({
    super.key,
    required this.adSize,
  });

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: Get.width,
        height: 300,
        child: _bannerAd == null
            // Nothing to render yet.
            ? const SizedBox()
            // The actual ad.
            : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Ad loaded successfully!');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: ${error.message}');
          print('Error code: ${error.code}');
          print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    );

    print('Loading banner ad...');
    bannerAd.load();
  }
}
