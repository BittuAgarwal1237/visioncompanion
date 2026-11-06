import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Vision Companion'**
  String get appName;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get splashLoading;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to pick up where you left off.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It only takes a minute.'**
  String get registerSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @switchToRegister.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get switchToRegister;

  /// No description provided for @switchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already registered? Sign in'**
  String get switchToLogin;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in, please wait'**
  String get signingIn;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errNameRequired;

  /// No description provided for @errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get errPasswordShort;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get authInvalidCredentials;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authInvalidEmail;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password'**
  String get authWeakPassword;

  /// No description provided for @authNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again'**
  String get authNetwork;

  /// No description provided for @authTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a little and try again'**
  String get authTooMany;

  /// No description provided for @authUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again'**
  String get authUnknown;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String greeting(String name);

  /// No description provided for @greetingSub.
  ///
  /// In en, this message translates to:
  /// **'What would you like to try today?'**
  String get greetingSub;

  /// No description provided for @profileSemantics.
  ///
  /// In en, this message translates to:
  /// **'Profile: {name}, tap to open menu'**
  String profileSemantics(String name);

  /// No description provided for @homeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a tool'**
  String get homeSectionTitle;

  /// No description provided for @detectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Object Detector'**
  String get detectorTitle;

  /// No description provided for @detectorDescription.
  ///
  /// In en, this message translates to:
  /// **'Point your camera and watch everyday objects get named in real time.'**
  String get detectorDescription;

  /// No description provided for @analyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Image Analyzer'**
  String get analyzerTitle;

  /// No description provided for @analyzerDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a photo and get a short description with smart tags.'**
  String get analyzerDescription;

  /// No description provided for @startButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// No description provided for @featureCardLabel.
  ///
  /// In en, this message translates to:
  /// **'{title}. {summary}. Double tap to start.'**
  String featureCardLabel(String title, String summary);

  /// No description provided for @homeFootnote.
  ///
  /// In en, this message translates to:
  /// **'Everything you detect or analyze is saved in History.'**
  String get homeFootnote;

  /// No description provided for @profileSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileSheetTitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing saved yet} =1{1 saved result} other{{count} saved results}}'**
  String historyCount(int count);

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try a feature and your results will show up here.'**
  String get historyEmptyBody;

  /// No description provided for @historyFeature.
  ///
  /// In en, this message translates to:
  /// **'{type, select, detector{Object detection} analyzer{Image analysis} other{Activity}}'**
  String historyFeature(String type);

  /// No description provided for @historyRemoved.
  ///
  /// In en, this message translates to:
  /// **'Entry removed'**
  String get historyRemoved;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your history.'**
  String get historyLoadError;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryButton;

  /// No description provided for @detectorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Object detector'**
  String get detectorPageTitle;

  /// No description provided for @cameraFeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Live camera feed for object detection'**
  String get cameraFeedLabel;

  /// No description provided for @pauseDetection.
  ///
  /// In en, this message translates to:
  /// **'Pause detection'**
  String get pauseDetection;

  /// No description provided for @resumeDetection.
  ///
  /// In en, this message translates to:
  /// **'Resume detection'**
  String get resumeDetection;

  /// No description provided for @pauseButton.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButton;

  /// No description provided for @resumeButton.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeButton;

  /// No description provided for @detectorScanning.
  ///
  /// In en, this message translates to:
  /// **'Looking for objects…'**
  String get detectorScanning;

  /// No description provided for @detectorPausedHint.
  ///
  /// In en, this message translates to:
  /// **'Detection paused'**
  String get detectorPausedHint;

  /// No description provided for @detectorFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 object found} other{{count} objects found}}'**
  String detectorFound(int count);

  /// No description provided for @detectorTop.
  ///
  /// In en, this message translates to:
  /// **'Top match: {name}, {percent}%'**
  String detectorTop(String name, int percent);

  /// No description provided for @announceObject.
  ///
  /// In en, this message translates to:
  /// **'{name}, {percent} percent'**
  String announceObject(String name, int percent);

  /// No description provided for @inferenceTime.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String inferenceTime(int ms);

  /// No description provided for @cameraStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting camera'**
  String get cameraStarting;

  /// No description provided for @detectorCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is needed to detect objects. Please allow it in your phone settings.'**
  String get detectorCameraDenied;

  /// No description provided for @detectorCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started.'**
  String get detectorCameraFailed;

  /// No description provided for @detectorModelFailed.
  ///
  /// In en, this message translates to:
  /// **'The detection model could not be loaded. Check that the model file is inside assets/models.'**
  String get detectorModelFailed;

  /// No description provided for @detectorStopped.
  ///
  /// In en, this message translates to:
  /// **'Detection stopped unexpectedly.'**
  String get detectorStopped;

  /// No description provided for @analyzerPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Image analyzer'**
  String get analyzerPageTitle;

  /// No description provided for @analyzerIdleTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready when you are'**
  String get analyzerIdleTitle;

  /// No description provided for @analyzerIdleBody.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo and the AI will describe what it sees.'**
  String get analyzerIdleBody;

  /// No description provided for @tipLight.
  ///
  /// In en, this message translates to:
  /// **'Good light gives better results.'**
  String get tipLight;

  /// No description provided for @tipSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold steady and keep the subject in the frame.'**
  String get tipSteady;

  /// No description provided for @captureButton.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get captureButton;

  /// No description provided for @captureAgain.
  ///
  /// In en, this message translates to:
  /// **'Take another photo'**
  String get captureAgain;

  /// No description provided for @analyzingStatus.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image, please wait'**
  String get analyzingStatus;

  /// No description provided for @processingLabel.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processingLabel;

  /// No description provided for @analysisDone.
  ///
  /// In en, this message translates to:
  /// **'Analysis complete'**
  String get analysisDone;

  /// No description provided for @resultDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'What the AI sees'**
  String get resultDescriptionTitle;

  /// No description provided for @resultTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get resultTagsTitle;

  /// No description provided for @tagSemantics.
  ///
  /// In en, this message translates to:
  /// **'Tag: {name}, {percent}% confidence'**
  String tagSemantics(String name, int percent);

  /// No description provided for @photoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo you captured'**
  String get photoLabel;

  /// No description provided for @analyzerNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get analyzerNoInternet;

  /// No description provided for @analyzerTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get analyzerTimeout;

  /// No description provided for @analyzerBusy.
  ///
  /// In en, this message translates to:
  /// **'The AI service is busy right now. Try again in a moment.'**
  String get analyzerBusy;

  /// No description provided for @analyzerBadKey.
  ///
  /// In en, this message translates to:
  /// **'The API key was rejected. Check the .env file.'**
  String get analyzerBadKey;

  /// No description provided for @analyzerMissingKey.
  ///
  /// In en, this message translates to:
  /// **'The API key is missing. Add it to the .env file.'**
  String get analyzerMissingKey;

  /// No description provided for @analyzerParse.
  ///
  /// In en, this message translates to:
  /// **'The answer could not be read. Please try again.'**
  String get analyzerParse;

  /// No description provided for @analyzerCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be opened. Check the permission and try again.'**
  String get analyzerCameraFailed;

  /// No description provided for @analyzerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get analyzerUnknown;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @objPerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get objPerson;

  /// No description provided for @objBicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get objBicycle;

  /// No description provided for @objCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get objCar;

  /// No description provided for @objMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get objMotorcycle;

  /// No description provided for @objAirplane.
  ///
  /// In en, this message translates to:
  /// **'Airplane'**
  String get objAirplane;

  /// No description provided for @objBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get objBus;

  /// No description provided for @objTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get objTrain;

  /// No description provided for @objTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get objTruck;

  /// No description provided for @objBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get objBoat;

  /// No description provided for @objTrafficLight.
  ///
  /// In en, this message translates to:
  /// **'Traffic light'**
  String get objTrafficLight;

  /// No description provided for @objFireHydrant.
  ///
  /// In en, this message translates to:
  /// **'Fire hydrant'**
  String get objFireHydrant;

  /// No description provided for @objStopSign.
  ///
  /// In en, this message translates to:
  /// **'Stop sign'**
  String get objStopSign;

  /// No description provided for @objParkingMeter.
  ///
  /// In en, this message translates to:
  /// **'Parking meter'**
  String get objParkingMeter;

  /// No description provided for @objBench.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get objBench;

  /// No description provided for @objBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get objBird;

  /// No description provided for @objCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get objCat;

  /// No description provided for @objDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get objDog;

  /// No description provided for @objHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get objHorse;

  /// No description provided for @objSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get objSheep;

  /// No description provided for @objCow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get objCow;

  /// No description provided for @objElephant.
  ///
  /// In en, this message translates to:
  /// **'Elephant'**
  String get objElephant;

  /// No description provided for @objBear.
  ///
  /// In en, this message translates to:
  /// **'Bear'**
  String get objBear;

  /// No description provided for @objZebra.
  ///
  /// In en, this message translates to:
  /// **'Zebra'**
  String get objZebra;

  /// No description provided for @objGiraffe.
  ///
  /// In en, this message translates to:
  /// **'Giraffe'**
  String get objGiraffe;

  /// No description provided for @objBackpack.
  ///
  /// In en, this message translates to:
  /// **'Backpack'**
  String get objBackpack;

  /// No description provided for @objUmbrella.
  ///
  /// In en, this message translates to:
  /// **'Umbrella'**
  String get objUmbrella;

  /// No description provided for @objHandbag.
  ///
  /// In en, this message translates to:
  /// **'Handbag'**
  String get objHandbag;

  /// No description provided for @objTie.
  ///
  /// In en, this message translates to:
  /// **'Tie'**
  String get objTie;

  /// No description provided for @objSuitcase.
  ///
  /// In en, this message translates to:
  /// **'Suitcase'**
  String get objSuitcase;

  /// No description provided for @objFrisbee.
  ///
  /// In en, this message translates to:
  /// **'Frisbee'**
  String get objFrisbee;

  /// No description provided for @objSkis.
  ///
  /// In en, this message translates to:
  /// **'Skis'**
  String get objSkis;

  /// No description provided for @objSnowboard.
  ///
  /// In en, this message translates to:
  /// **'Snowboard'**
  String get objSnowboard;

  /// No description provided for @objSportsBall.
  ///
  /// In en, this message translates to:
  /// **'Sports ball'**
  String get objSportsBall;

  /// No description provided for @objKite.
  ///
  /// In en, this message translates to:
  /// **'Kite'**
  String get objKite;

  /// No description provided for @objBaseballBat.
  ///
  /// In en, this message translates to:
  /// **'Baseball bat'**
  String get objBaseballBat;

  /// No description provided for @objBaseballGlove.
  ///
  /// In en, this message translates to:
  /// **'Baseball glove'**
  String get objBaseballGlove;

  /// No description provided for @objSkateboard.
  ///
  /// In en, this message translates to:
  /// **'Skateboard'**
  String get objSkateboard;

  /// No description provided for @objSurfboard.
  ///
  /// In en, this message translates to:
  /// **'Surfboard'**
  String get objSurfboard;

  /// No description provided for @objTennisRacket.
  ///
  /// In en, this message translates to:
  /// **'Tennis racket'**
  String get objTennisRacket;

  /// No description provided for @objBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get objBottle;

  /// No description provided for @objWineGlass.
  ///
  /// In en, this message translates to:
  /// **'Wine glass'**
  String get objWineGlass;

  /// No description provided for @objCup.
  ///
  /// In en, this message translates to:
  /// **'Cup'**
  String get objCup;

  /// No description provided for @objFork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get objFork;

  /// No description provided for @objKnife.
  ///
  /// In en, this message translates to:
  /// **'Knife'**
  String get objKnife;

  /// No description provided for @objSpoon.
  ///
  /// In en, this message translates to:
  /// **'Spoon'**
  String get objSpoon;

  /// No description provided for @objBowl.
  ///
  /// In en, this message translates to:
  /// **'Bowl'**
  String get objBowl;

  /// No description provided for @objBanana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get objBanana;

  /// No description provided for @objApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get objApple;

  /// No description provided for @objSandwich.
  ///
  /// In en, this message translates to:
  /// **'Sandwich'**
  String get objSandwich;

  /// No description provided for @objOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get objOrange;

  /// No description provided for @objBroccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get objBroccoli;

  /// No description provided for @objCarrot.
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get objCarrot;

  /// No description provided for @objHotDog.
  ///
  /// In en, this message translates to:
  /// **'Hot dog'**
  String get objHotDog;

  /// No description provided for @objPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get objPizza;

  /// No description provided for @objDonut.
  ///
  /// In en, this message translates to:
  /// **'Donut'**
  String get objDonut;

  /// No description provided for @objCake.
  ///
  /// In en, this message translates to:
  /// **'Cake'**
  String get objCake;

  /// No description provided for @objChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get objChair;

  /// No description provided for @objCouch.
  ///
  /// In en, this message translates to:
  /// **'Couch'**
  String get objCouch;

  /// No description provided for @objPottedPlant.
  ///
  /// In en, this message translates to:
  /// **'Potted plant'**
  String get objPottedPlant;

  /// No description provided for @objBed.
  ///
  /// In en, this message translates to:
  /// **'Bed'**
  String get objBed;

  /// No description provided for @objDiningTable.
  ///
  /// In en, this message translates to:
  /// **'Dining table'**
  String get objDiningTable;

  /// No description provided for @objToilet.
  ///
  /// In en, this message translates to:
  /// **'Toilet'**
  String get objToilet;

  /// No description provided for @objTv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get objTv;

  /// No description provided for @objLaptop.
  ///
  /// In en, this message translates to:
  /// **'Laptop'**
  String get objLaptop;

  /// No description provided for @objMouse.
  ///
  /// In en, this message translates to:
  /// **'Mouse'**
  String get objMouse;

  /// No description provided for @objRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get objRemote;

  /// No description provided for @objKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get objKeyboard;

  /// No description provided for @objCellPhone.
  ///
  /// In en, this message translates to:
  /// **'Cell phone'**
  String get objCellPhone;

  /// No description provided for @objMicrowave.
  ///
  /// In en, this message translates to:
  /// **'Microwave'**
  String get objMicrowave;

  /// No description provided for @objOven.
  ///
  /// In en, this message translates to:
  /// **'Oven'**
  String get objOven;

  /// No description provided for @objToaster.
  ///
  /// In en, this message translates to:
  /// **'Toaster'**
  String get objToaster;

  /// No description provided for @objSink.
  ///
  /// In en, this message translates to:
  /// **'Sink'**
  String get objSink;

  /// No description provided for @objRefrigerator.
  ///
  /// In en, this message translates to:
  /// **'Refrigerator'**
  String get objRefrigerator;

  /// No description provided for @objBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get objBook;

  /// No description provided for @objClock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get objClock;

  /// No description provided for @objVase.
  ///
  /// In en, this message translates to:
  /// **'Vase'**
  String get objVase;

  /// No description provided for @objScissors.
  ///
  /// In en, this message translates to:
  /// **'Scissors'**
  String get objScissors;

  /// No description provided for @objTeddyBear.
  ///
  /// In en, this message translates to:
  /// **'Teddy bear'**
  String get objTeddyBear;

  /// No description provided for @objHairDrier.
  ///
  /// In en, this message translates to:
  /// **'Hair drier'**
  String get objHairDrier;

  /// No description provided for @objToothbrush.
  ///
  /// In en, this message translates to:
  /// **'Toothbrush'**
  String get objToothbrush;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
