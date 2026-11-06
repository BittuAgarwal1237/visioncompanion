// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'विज़न कम्पैनियन';

  @override
  String get splashLoading => 'लोड हो रहा है';

  @override
  String get navHome => 'होम';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get loginTitle => 'वापसी पर स्वागत है';

  @override
  String get loginSubtitle =>
      'जहाँ छोड़ा था वहीं से शुरू करने के लिए साइन इन करें।';

  @override
  String get registerTitle => 'अपना खाता बनाएँ';

  @override
  String get registerSubtitle => 'बस एक मिनट लगेगा।';

  @override
  String get nameLabel => 'पूरा नाम';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get signInButton => 'साइन इन करें';

  @override
  String get registerButton => 'खाता बनाएँ';

  @override
  String get switchToRegister => 'नए हैं? खाता बनाएँ';

  @override
  String get switchToLogin => 'पहले से खाता है? साइन इन करें';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get orDivider => 'या';

  @override
  String get signingIn => 'साइन इन हो रहा है, कृपया प्रतीक्षा करें';

  @override
  String get errNameRequired => 'कृपया अपना नाम दर्ज करें';

  @override
  String get errEmailInvalid => 'सही ईमेल पता दर्ज करें';

  @override
  String get errPasswordShort => 'कम से कम 6 अक्षर रखें';

  @override
  String get authInvalidCredentials => 'ईमेल या पासवर्ड गलत है';

  @override
  String get authInvalidEmail => 'कृपया सही ईमेल पता दर्ज करें';

  @override
  String get authEmailInUse => 'इस ईमेल से खाता पहले से मौजूद है';

  @override
  String get authWeakPassword => 'कोई मज़बूत पासवर्ड चुनें';

  @override
  String get authNetwork => 'इंटरनेट कनेक्शन नहीं है। कृपया फिर कोशिश करें';

  @override
  String get authTooMany =>
      'बहुत ज़्यादा कोशिशें हुईं। थोड़ा रुककर फिर प्रयास करें';

  @override
  String get authUnknown => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें';

  @override
  String greeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get greetingSub => 'आज आप क्या आज़माना चाहेंगे?';

  @override
  String profileSemantics(String name) {
    return 'प्रोफ़ाइल: $name, मेनू खोलने के लिए टैप करें';
  }

  @override
  String get homeSectionTitle => 'कोई टूल चुनें';

  @override
  String get detectorTitle => 'लाइव ऑब्जेक्ट डिटेक्टर';

  @override
  String get detectorDescription =>
      'कैमरा घुमाइए और रोज़मर्रा की चीज़ों के नाम तुरंत देखिए।';

  @override
  String get analyzerTitle => 'AI इमेज एनालाइज़र';

  @override
  String get analyzerDescription =>
      'फ़ोटो खींचिए और छोटा विवरण व स्मार्ट टैग पाइए।';

  @override
  String get startButton => 'शुरू करें';

  @override
  String featureCardLabel(String title, String summary) {
    return '$title। $summary। शुरू करने के लिए दो बार टैप करें।';
  }

  @override
  String get homeFootnote =>
      'आप जो भी पहचानते या एनालाइज़ करते हैं, वह इतिहास में सेव हो जाता है।';

  @override
  String get profileSheetTitle => 'आपकी प्रोफ़ाइल';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेव किए गए परिणाम',
      one: '1 सेव किया गया परिणाम',
      zero: 'अभी कुछ सेव नहीं है',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptyTitle => 'यहाँ अभी कुछ नहीं है';

  @override
  String get historyEmptyBody => 'कोई फ़ीचर आज़माइए, आपके परिणाम यहाँ दिखेंगे।';

  @override
  String historyFeature(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'detector': 'ऑब्जेक्ट डिटेक्शन',
      'analyzer': 'इमेज विश्लेषण',
      'other': 'गतिविधि',
    });
    return '$_temp0';
  }

  @override
  String get historyRemoved => 'प्रविष्टि हटा दी गई';

  @override
  String get historyLoadError => 'आपका इतिहास लोड नहीं हो सका।';

  @override
  String get retryButton => 'फिर कोशिश करें';

  @override
  String get detectorPageTitle => 'ऑब्जेक्ट डिटेक्टर';

  @override
  String get cameraFeedLabel => 'ऑब्जेक्ट डिटेक्शन के लिए लाइव कैमरा फ़ीड';

  @override
  String get pauseDetection => 'डिटेक्शन रोकें';

  @override
  String get resumeDetection => 'डिटेक्शन फिर शुरू करें';

  @override
  String get pauseButton => 'रोकें';

  @override
  String get resumeButton => 'चालू करें';

  @override
  String get detectorScanning => 'चीज़ें खोजी जा रही हैं…';

  @override
  String get detectorPausedHint => 'डिटेक्शन रुका हुआ है';

  @override
  String detectorFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चीज़ें मिलीं',
      one: '1 चीज़ मिली',
    );
    return '$_temp0';
  }

  @override
  String detectorTop(String name, int percent) {
    return 'सबसे संभावित: $name, $percent%';
  }

  @override
  String announceObject(String name, int percent) {
    return '$name, $percent प्रतिशत';
  }

  @override
  String inferenceTime(int ms) {
    return '$ms मि.से.';
  }

  @override
  String get cameraStarting => 'कैमरा शुरू हो रहा है';

  @override
  String get detectorCameraDenied =>
      'ऑब्जेक्ट पहचानने के लिए कैमरे की अनुमति चाहिए। कृपया फ़ोन की सेटिंग्स में अनुमति दें।';

  @override
  String get detectorCameraFailed => 'कैमरा शुरू नहीं हो सका।';

  @override
  String get detectorModelFailed =>
      'डिटेक्शन मॉडल लोड नहीं हो सका। जाँचें कि मॉडल फ़ाइल assets/models में रखी है।';

  @override
  String get detectorStopped => 'डिटेक्शन अचानक रुक गया।';

  @override
  String get analyzerPageTitle => 'इमेज एनालाइज़र';

  @override
  String get analyzerIdleTitle => 'जब आप तैयार हों';

  @override
  String get analyzerIdleBody =>
      'साफ़ फ़ोटो खींचिए, AI बताएगा कि उसमें क्या दिख रहा है।';

  @override
  String get tipLight => 'अच्छी रोशनी से बेहतर नतीजे मिलते हैं।';

  @override
  String get tipSteady => 'कैमरा स्थिर रखें और चीज़ को फ़्रेम में रखें।';

  @override
  String get captureButton => 'फ़ोटो खींचें';

  @override
  String get captureAgain => 'दूसरी फ़ोटो खींचें';

  @override
  String get analyzingStatus =>
      'इमेज का विश्लेषण हो रहा है, कृपया प्रतीक्षा करें';

  @override
  String get processingLabel => 'प्रोसेस हो रहा है';

  @override
  String get analysisDone => 'विश्लेषण पूरा हुआ';

  @override
  String get resultDescriptionTitle => 'AI को क्या दिख रहा है';

  @override
  String get resultTagsTitle => 'टैग';

  @override
  String tagSemantics(String name, int percent) {
    return 'टैग: $name, $percent% विश्वसनीयता';
  }

  @override
  String get photoLabel => 'आपकी खींची हुई फ़ोटो';

  @override
  String get analyzerNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। नेटवर्क जाँचकर फिर कोशिश करें।';

  @override
  String get analyzerTimeout =>
      'अनुरोध में बहुत समय लगा। कृपया फिर कोशिश करें।';

  @override
  String get analyzerBusy =>
      'AI सेवा अभी व्यस्त है। थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get analyzerBadKey => 'API कुंजी स्वीकार नहीं हुई। .env फ़ाइल जाँचें।';

  @override
  String get analyzerMissingKey =>
      'API कुंजी नहीं मिली। उसे .env फ़ाइल में जोड़ें।';

  @override
  String get analyzerParse => 'जवाब पढ़ा नहीं जा सका। कृपया फिर कोशिश करें।';

  @override
  String get analyzerCameraFailed =>
      'कैमरा नहीं खुल सका। अनुमति जाँचकर फिर कोशिश करें।';

  @override
  String get analyzerUnknown => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String languageChanged(String language) {
    return 'भाषा $language में बदल गई है';
  }

  @override
  String get accountTitle => 'खाता';

  @override
  String get objPerson => 'व्यक्ति';

  @override
  String get objBicycle => 'साइकिल';

  @override
  String get objCar => 'कार';

  @override
  String get objMotorcycle => 'मोटरसाइकिल';

  @override
  String get objAirplane => 'हवाई जहाज़';

  @override
  String get objBus => 'बस';

  @override
  String get objTrain => 'ट्रेन';

  @override
  String get objTruck => 'ट्रक';

  @override
  String get objBoat => 'नाव';

  @override
  String get objTrafficLight => 'ट्रैफ़िक लाइट';

  @override
  String get objFireHydrant => 'फ़ायर हाइड्रेंट';

  @override
  String get objStopSign => 'स्टॉप साइन';

  @override
  String get objParkingMeter => 'पार्किंग मीटर';

  @override
  String get objBench => 'बेंच';

  @override
  String get objBird => 'पक्षी';

  @override
  String get objCat => 'बिल्ली';

  @override
  String get objDog => 'कुत्ता';

  @override
  String get objHorse => 'घोड़ा';

  @override
  String get objSheep => 'भेड़';

  @override
  String get objCow => 'गाय';

  @override
  String get objElephant => 'हाथी';

  @override
  String get objBear => 'भालू';

  @override
  String get objZebra => 'ज़ेबरा';

  @override
  String get objGiraffe => 'जिराफ़';

  @override
  String get objBackpack => 'बैकपैक';

  @override
  String get objUmbrella => 'छाता';

  @override
  String get objHandbag => 'हैंडबैग';

  @override
  String get objTie => 'टाई';

  @override
  String get objSuitcase => 'सूटकेस';

  @override
  String get objFrisbee => 'फ्रिस्बी';

  @override
  String get objSkis => 'स्की';

  @override
  String get objSnowboard => 'स्नोबोर्ड';

  @override
  String get objSportsBall => 'गेंद';

  @override
  String get objKite => 'पतंग';

  @override
  String get objBaseballBat => 'बेसबॉल बैट';

  @override
  String get objBaseballGlove => 'बेसबॉल दस्ताना';

  @override
  String get objSkateboard => 'स्केटबोर्ड';

  @override
  String get objSurfboard => 'सर्फ़बोर्ड';

  @override
  String get objTennisRacket => 'टेनिस रैकेट';

  @override
  String get objBottle => 'बोतल';

  @override
  String get objWineGlass => 'वाइन ग्लास';

  @override
  String get objCup => 'कप';

  @override
  String get objFork => 'काँटा';

  @override
  String get objKnife => 'चाकू';

  @override
  String get objSpoon => 'चम्मच';

  @override
  String get objBowl => 'कटोरा';

  @override
  String get objBanana => 'केला';

  @override
  String get objApple => 'सेब';

  @override
  String get objSandwich => 'सैंडविच';

  @override
  String get objOrange => 'संतरा';

  @override
  String get objBroccoli => 'ब्रोकली';

  @override
  String get objCarrot => 'गाजर';

  @override
  String get objHotDog => 'हॉट डॉग';

  @override
  String get objPizza => 'पिज़्ज़ा';

  @override
  String get objDonut => 'डोनट';

  @override
  String get objCake => 'केक';

  @override
  String get objChair => 'कुर्सी';

  @override
  String get objCouch => 'सोफ़ा';

  @override
  String get objPottedPlant => 'गमले का पौधा';

  @override
  String get objBed => 'बिस्तर';

  @override
  String get objDiningTable => 'डाइनिंग टेबल';

  @override
  String get objToilet => 'शौचालय';

  @override
  String get objTv => 'टीवी';

  @override
  String get objLaptop => 'लैपटॉप';

  @override
  String get objMouse => 'माउस';

  @override
  String get objRemote => 'रिमोट';

  @override
  String get objKeyboard => 'कीबोर्ड';

  @override
  String get objCellPhone => 'मोबाइल फ़ोन';

  @override
  String get objMicrowave => 'माइक्रोवेव';

  @override
  String get objOven => 'ओवन';

  @override
  String get objToaster => 'टोस्टर';

  @override
  String get objSink => 'सिंक';

  @override
  String get objRefrigerator => 'फ्रिज';

  @override
  String get objBook => 'किताब';

  @override
  String get objClock => 'घड़ी';

  @override
  String get objVase => 'फूलदान';

  @override
  String get objScissors => 'कैंची';

  @override
  String get objTeddyBear => 'टेडी बियर';

  @override
  String get objHairDrier => 'हेयर ड्रायर';

  @override
  String get objToothbrush => 'टूथब्रश';
}
