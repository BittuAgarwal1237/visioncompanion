// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Vision Companion';

  @override
  String get splashLoading => 'Loading';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to pick up where you left off.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'It only takes a minute.';

  @override
  String get nameLabel => 'Full name';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signInButton => 'Sign in';

  @override
  String get registerButton => 'Create account';

  @override
  String get switchToRegister => 'New here? Create an account';

  @override
  String get switchToLogin => 'Already registered? Sign in';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get orDivider => 'or';

  @override
  String get signingIn => 'Signing in, please wait';

  @override
  String get errNameRequired => 'Please enter your name';

  @override
  String get errEmailInvalid => 'Enter a valid email address';

  @override
  String get errPasswordShort => 'Use at least 6 characters';

  @override
  String get authInvalidCredentials => 'Email or password is incorrect';

  @override
  String get authInvalidEmail => 'Please enter a valid email address';

  @override
  String get authEmailInUse => 'An account with this email already exists';

  @override
  String get authWeakPassword => 'Choose a stronger password';

  @override
  String get authNetwork => 'No internet connection. Please try again';

  @override
  String get authTooMany => 'Too many attempts. Wait a little and try again';

  @override
  String get authUnknown => 'Something went wrong. Please try again';

  @override
  String greeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get greetingSub => 'What would you like to try today?';

  @override
  String profileSemantics(String name) {
    return 'Profile: $name, tap to open menu';
  }

  @override
  String get homeSectionTitle => 'Pick a tool';

  @override
  String get detectorTitle => 'Live Object Detector';

  @override
  String get detectorDescription =>
      'Point your camera and watch everyday objects get named in real time.';

  @override
  String get analyzerTitle => 'AI Image Analyzer';

  @override
  String get analyzerDescription =>
      'Take a photo and get a short description with smart tags.';

  @override
  String get startButton => 'Start';

  @override
  String featureCardLabel(String title, String summary) {
    return '$title. $summary. Double tap to start.';
  }

  @override
  String get homeFootnote =>
      'Everything you detect or analyze is saved in History.';

  @override
  String get profileSheetTitle => 'Your profile';

  @override
  String get signOut => 'Sign out';

  @override
  String get historyTitle => 'History';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved results',
      one: '1 saved result',
      zero: 'Nothing saved yet',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptyTitle => 'Nothing here yet';

  @override
  String get historyEmptyBody =>
      'Try a feature and your results will show up here.';

  @override
  String historyFeature(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'detector': 'Object detection',
      'analyzer': 'Image analysis',
      'other': 'Activity',
    });
    return '$_temp0';
  }

  @override
  String get historyRemoved => 'Entry removed';

  @override
  String get historyLoadError => 'Could not load your history.';

  @override
  String get retryButton => 'Try again';

  @override
  String get detectorPageTitle => 'Object detector';

  @override
  String get cameraFeedLabel => 'Live camera feed for object detection';

  @override
  String get pauseDetection => 'Pause detection';

  @override
  String get resumeDetection => 'Resume detection';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resumeButton => 'Resume';

  @override
  String get detectorScanning => 'Looking for objects…';

  @override
  String get detectorPausedHint => 'Detection paused';

  @override
  String detectorFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objects found',
      one: '1 object found',
    );
    return '$_temp0';
  }

  @override
  String detectorTop(String name, int percent) {
    return 'Top match: $name, $percent%';
  }

  @override
  String announceObject(String name, int percent) {
    return '$name, $percent percent';
  }

  @override
  String inferenceTime(int ms) {
    return '$ms ms';
  }

  @override
  String get cameraStarting => 'Starting camera';

  @override
  String get detectorCameraDenied =>
      'Camera permission is needed to detect objects. Please allow it in your phone settings.';

  @override
  String get detectorCameraFailed => 'The camera could not be started.';

  @override
  String get detectorModelFailed =>
      'The detection model could not be loaded. Check that the model file is inside assets/models.';

  @override
  String get detectorStopped => 'Detection stopped unexpectedly.';

  @override
  String get analyzerPageTitle => 'Image analyzer';

  @override
  String get analyzerIdleTitle => 'Ready when you are';

  @override
  String get analyzerIdleBody =>
      'Take a clear photo and the AI will describe what it sees.';

  @override
  String get tipLight => 'Good light gives better results.';

  @override
  String get tipSteady => 'Hold steady and keep the subject in the frame.';

  @override
  String get captureButton => 'Take photo';

  @override
  String get captureAgain => 'Take another photo';

  @override
  String get analyzingStatus => 'Analyzing image, please wait';

  @override
  String get processingLabel => 'Processing';

  @override
  String get analysisDone => 'Analysis complete';

  @override
  String get resultDescriptionTitle => 'What the AI sees';

  @override
  String get resultTagsTitle => 'Tags';

  @override
  String tagSemantics(String name, int percent) {
    return 'Tag: $name, $percent% confidence';
  }

  @override
  String get photoLabel => 'Photo you captured';

  @override
  String get analyzerNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get analyzerTimeout => 'The request took too long. Please try again.';

  @override
  String get analyzerBusy =>
      'The AI service is busy right now. Try again in a moment.';

  @override
  String get analyzerBadKey => 'The API key was rejected. Check the .env file.';

  @override
  String get analyzerMissingKey =>
      'The API key is missing. Add it to the .env file.';

  @override
  String get analyzerParse => 'The answer could not be read. Please try again.';

  @override
  String get analyzerCameraFailed =>
      'The camera could not be opened. Check the permission and try again.';

  @override
  String get analyzerUnknown => 'Something went wrong. Please try again.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get accountTitle => 'Account';

  @override
  String get objPerson => 'Person';

  @override
  String get objBicycle => 'Bicycle';

  @override
  String get objCar => 'Car';

  @override
  String get objMotorcycle => 'Motorcycle';

  @override
  String get objAirplane => 'Airplane';

  @override
  String get objBus => 'Bus';

  @override
  String get objTrain => 'Train';

  @override
  String get objTruck => 'Truck';

  @override
  String get objBoat => 'Boat';

  @override
  String get objTrafficLight => 'Traffic light';

  @override
  String get objFireHydrant => 'Fire hydrant';

  @override
  String get objStopSign => 'Stop sign';

  @override
  String get objParkingMeter => 'Parking meter';

  @override
  String get objBench => 'Bench';

  @override
  String get objBird => 'Bird';

  @override
  String get objCat => 'Cat';

  @override
  String get objDog => 'Dog';

  @override
  String get objHorse => 'Horse';

  @override
  String get objSheep => 'Sheep';

  @override
  String get objCow => 'Cow';

  @override
  String get objElephant => 'Elephant';

  @override
  String get objBear => 'Bear';

  @override
  String get objZebra => 'Zebra';

  @override
  String get objGiraffe => 'Giraffe';

  @override
  String get objBackpack => 'Backpack';

  @override
  String get objUmbrella => 'Umbrella';

  @override
  String get objHandbag => 'Handbag';

  @override
  String get objTie => 'Tie';

  @override
  String get objSuitcase => 'Suitcase';

  @override
  String get objFrisbee => 'Frisbee';

  @override
  String get objSkis => 'Skis';

  @override
  String get objSnowboard => 'Snowboard';

  @override
  String get objSportsBall => 'Sports ball';

  @override
  String get objKite => 'Kite';

  @override
  String get objBaseballBat => 'Baseball bat';

  @override
  String get objBaseballGlove => 'Baseball glove';

  @override
  String get objSkateboard => 'Skateboard';

  @override
  String get objSurfboard => 'Surfboard';

  @override
  String get objTennisRacket => 'Tennis racket';

  @override
  String get objBottle => 'Bottle';

  @override
  String get objWineGlass => 'Wine glass';

  @override
  String get objCup => 'Cup';

  @override
  String get objFork => 'Fork';

  @override
  String get objKnife => 'Knife';

  @override
  String get objSpoon => 'Spoon';

  @override
  String get objBowl => 'Bowl';

  @override
  String get objBanana => 'Banana';

  @override
  String get objApple => 'Apple';

  @override
  String get objSandwich => 'Sandwich';

  @override
  String get objOrange => 'Orange';

  @override
  String get objBroccoli => 'Broccoli';

  @override
  String get objCarrot => 'Carrot';

  @override
  String get objHotDog => 'Hot dog';

  @override
  String get objPizza => 'Pizza';

  @override
  String get objDonut => 'Donut';

  @override
  String get objCake => 'Cake';

  @override
  String get objChair => 'Chair';

  @override
  String get objCouch => 'Couch';

  @override
  String get objPottedPlant => 'Potted plant';

  @override
  String get objBed => 'Bed';

  @override
  String get objDiningTable => 'Dining table';

  @override
  String get objToilet => 'Toilet';

  @override
  String get objTv => 'TV';

  @override
  String get objLaptop => 'Laptop';

  @override
  String get objMouse => 'Mouse';

  @override
  String get objRemote => 'Remote';

  @override
  String get objKeyboard => 'Keyboard';

  @override
  String get objCellPhone => 'Cell phone';

  @override
  String get objMicrowave => 'Microwave';

  @override
  String get objOven => 'Oven';

  @override
  String get objToaster => 'Toaster';

  @override
  String get objSink => 'Sink';

  @override
  String get objRefrigerator => 'Refrigerator';

  @override
  String get objBook => 'Book';

  @override
  String get objClock => 'Clock';

  @override
  String get objVase => 'Vase';

  @override
  String get objScissors => 'Scissors';

  @override
  String get objTeddyBear => 'Teddy bear';

  @override
  String get objHairDrier => 'Hair drier';

  @override
  String get objToothbrush => 'Toothbrush';
}
