// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdsManager {
//   final bool isTestMode;
//   final int maxBanners = 21; // Maximum number of banners to load
//   final int maxInterstitials = 3; // Maximum number of interstitials to preload
//
//   // Ad objects
//   final List<BannerAd> _banners = [];
//   final List<InterstitialAd?> _interstitialAds = [];
//   RewardedAd? _rewardedAd;
//   AppOpenAd? _appOpenAd;
//
//   AdsManager({required this.isTestMode});
//
//   // Ad unit IDs
//   String get bannerAdUnitId => isTestMode
//       ? 'ca-app-pub-3940256099942544/9214589741'
//       : 'ca-app-pub-3453869545957893/9966636346';
//
//   String get interstitialAdUnitId => isTestMode
//       ? 'ca-app-pub-3940256099942544/1033173712'
//       : 'ca-app-pub-3453869545957893/7497780904';
//
//   String get rewardedAdUnitId => isTestMode
//       ? 'ca-app-pub-3940256099942544/5224354917'
//       : 'ca-app-pub-3453869545957893/6452292544';
//
//   String get appOpenAdUnitId => isTestMode
//       ? 'ca-app-pub-3940256099942544/9257395921'
//       : 'ca-app-pub-3453869545957893/6184699231';
//
//   // Load Banner Ads
//   void loadBanners() {
//     for (int i = 0; i < maxBanners; i++) {
//       BannerAd banner = BannerAd(
//         adUnitId: bannerAdUnitId,
//         size: AdSize.banner,
//         request: AdRequest(),
//         listener: BannerAdListener(
//           onAdLoaded: (ad) => print('Banner loaded: $ad'),
//           onAdFailedToLoad: (ad, error) {
//             print('Banner failed to load: $error');
//             ad.dispose();
//           },
//         ),
//       );
//       banner.load();
//       _banners.add(banner);
//     }
//   }
//
//   // Get a specific banner by index
//   BannerAd? getBanner(int index) {
//     if (index < _banners.length) {
//       return _banners[index];
//     }
//     return null;
//   }
//
//   // Load Interstitial Ads
//   Future<void> loadInterstitials() async {
//     if (_interstitialAds.length >= maxInterstitials) return; // Prevent duplicate loading
//
//     try {
//       await InterstitialAd.load(
//         adUnitId: interstitialAdUnitId,
//         request: AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (ad) {
//             print('Interstitial loaded');
//             _interstitialAds.add(ad);
//           },
//           onAdFailedToLoad: (error) {
//             print('Interstitial failed to load: $error');
//           },
//         ),
//       );
//     } catch (e) {
//       print('Error loading Interstitial Ad: $e');
//     }
//   }
//
//   // Show Interstitial Ad (FIFO approach)
//   void showInterstitial() {
//     if (_interstitialAds.isNotEmpty) {
//       InterstitialAd? interstitialAd = _interstitialAds.removeAt(0);
//       interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           print('Interstitial dismissed.');
//           ad.dispose();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('Failed to show interstitial: $error');
//           ad.dispose();
//         },
//       );
//       interstitialAd?.show();
//     } else {
//       print('No interstitial ads preloaded.');
//     }
//
//     // Reload interstitials to maintain the required count
//     if (_interstitialAds.length < maxInterstitials) {
//       loadInterstitials();
//     }
//   }
//
//   // Load Rewarded Ad
//   void loadRewardedAd() {
//     RewardedAd.load(
//       adUnitId: rewardedAdUnitId,
//       request: AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           print('Rewarded Ad loaded');
//           _rewardedAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//           print('Rewarded Ad failed to load: $error');
//         },
//       ),
//     );
//   }
//
//   // Show Rewarded Ad
//   void showRewardedAd(Function onRewardEarned) {
//     if (_rewardedAd != null) {
//       _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           print('Rewarded Ad dismissed.');
//           ad.dispose();
//           _rewardedAd = null;
//           loadRewardedAd(); // Reload for next use
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('Failed to show rewarded ad: $error');
//           ad.dispose();
//           _rewardedAd = null;
//           loadRewardedAd();
//         },
//       );
//       _rewardedAd!.show(
//         onUserEarnedReward: (ad, reward) {
//           print('Reward earned: ${reward.amount} ${reward.type}');
//           onRewardEarned(); // Trigger reward callback
//         },
//       );
//     } else {
//       print('Rewarded Ad not ready.');
//       onRewardEarned(); // Optional: Notify the app even when no ad is shown
//     }
//   }
//
//   // Load App Open Ad
//   bool _isAppOpenAdLoading = false;
//
//   Future<void> loadAppOpenAd() async {
//     if (_isAppOpenAdLoading || _appOpenAd != null) return;
//
//     _isAppOpenAdLoading = true;
//
//     try {
//       await AppOpenAd.load(
//         adUnitId: appOpenAdUnitId,
//         request: AdRequest(),
//         adLoadCallback: AppOpenAdLoadCallback(
//           onAdLoaded: (ad) {
//             print('App Open Ad loaded.');
//             _appOpenAd = ad;
//             _isAppOpenAdLoading = false;
// showAppOpenAd();          },
//           onAdFailedToLoad: (error) {
//             print('App Open Ad failed to load: $error');
//             _isAppOpenAdLoading = false;
//           },
//         ),
//       );
//     } catch (e) {
//       print('Error loading App Open Ad: $e');
//       _isAppOpenAdLoading = false;
//     }
//   }
//   // Show App Open Ad
//   void showAppOpenAd() {
//     if (_appOpenAd != null) {
//       _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           print('App Open Ad dismissed.');
//           ad.dispose();
//           _appOpenAd = null;
//           // Do NOT call loadAppOpenAd() here unless you want to reload immediately after dismissal
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('Failed to show App Open Ad: $error');
//           ad.dispose();
//           _appOpenAd = null;
//         },
//       );
//       _appOpenAd!.show();
//     } else {
//       print('App Open Ad not ready.');
//     }
//   }
//   // Dispose all ads
//   Future<void> disposeAll() async {
//     // Dispose of banner ads
//     for (var banner in _banners) {
//       await banner.dispose();
//     }
//     _banners.clear();
//
//     // Dispose of interstitial ads
//     for (var interstitial in _interstitialAds) {
//       await interstitial?.dispose();
//     }
//     _interstitialAds.clear();
//
//     // Dispose of rewarded ad
//     await _rewardedAd?.dispose();
//     _rewardedAd = null;
//
//     // Dispose of app open ad
//     await _appOpenAd?.dispose();
//     _appOpenAd = null;
//   }
// }