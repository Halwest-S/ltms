// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kurdish (`ku`).
class L10nKu extends L10n {
  L10nKu([String locale = 'ku']) : super(locale);

  @override
  String get appTitle => 'LTMS';

  @override
  String get appSubtitle => 'سیستەمی بەڕێوەبردنی گواستنەوە و ئtransport';

  @override
  String get login => 'چوونەژوورەوە';

  @override
  String get logout => 'دەرچوون';

  @override
  String get register => 'خۆتۆمارکردن';

  @override
  String get email => 'ئیمەیڵ';

  @override
  String get password => 'وشەی نهێنی';

  @override
  String get confirmPassword => 'دڵنیابوونەوەی وشەی نهێنی';

  @override
  String get forgotPassword => 'وشەی نهێنیت لەبیرکردووە؟';

  @override
  String get signIn => 'چوونەژوورەوە';

  @override
  String get signUp => 'خۆتۆمارکردن';

  @override
  String get welcomeBack => 'بەخێرهاتیتەوە';

  @override
  String get createAccount => 'هەژمار دروست بکە';

  @override
  String get home => 'پەڕەی سەرەکی';

  @override
  String get dashboard => 'داشبۆرد';

  @override
  String get shipments => 'بارەکان';

  @override
  String get myShipments => 'بارەکانم';

  @override
  String get assignedShipments => 'بارەکانی ئەسپاردراو';

  @override
  String get reports => 'راپۆرتەکان';

  @override
  String get notifications => 'ئاگانامەکان';

  @override
  String shipmentsCount(int count) {
    return '$count بار';
  }

  @override
  String shipmentCount(int count) {
    return '$count بار';
  }

  @override
  String get users => 'بەکارهێنەران';

  @override
  String get categories => 'پۆلەکان';

  @override
  String get vehicles => 'ئامێرەکان';

  @override
  String get vehicleTypes => 'جۆرەکانی ئامێر';

  @override
  String get vehicleCrudPlaceholder => 'ڕێکخستنی ئامێر';

  @override
  String get sent => 'نێردراو';

  @override
  String get sentTab => 'نێردراو';

  @override
  String get customersTab => 'کڕیاران';

  @override
  String get logisticsPortal => 'دەرگای بەڕێوەبردنی لۆجیستی';

  @override
  String get sendUpdatesSubtitle => 'ناردنی نوێکاری بۆ کڕیاران';

  @override
  String get signOutConfirmStaff =>
      'ئایا دڵنیایت لە چوونە دەرەوە لە پۆرتاڵی کارمەند؟';

  @override
  String get manageAccount => 'بەڕێوەبردنی ئەکاونت و هەڵبژاردنەکان';

  @override
  String get usernameLabel => 'ناوی بەکارهێنەر';

  @override
  String get appSettings => 'ڕێکخستنەکانی ئەپ';

  @override
  String get support => 'پاڵپشتی';

  @override
  String get deliverBtn => 'گەیاندن';

  @override
  String get acceptBtn => 'وەرگرتن';

  @override
  String get goodMorning => 'بەیانیت باش';

  @override
  String get goodAfternoon => 'نیوەڕۆت باش';

  @override
  String get goodEvening => 'ئێوارەت باش';

  @override
  String get viewHistory => 'بینینی مێژوو';

  @override
  String get signOutConfirm => 'دڵنیایت لە دەرچوون؟';

  @override
  String get currentPasswordLabel => 'وشەی نهێنی ئێستا';

  @override
  String get newPasswordLabel => 'وشەی نهێنی نوێ';

  @override
  String get confirmNewPasswordLabel => 'دووبارەکردنەوەی وشەی نهێنی نوێ';

  @override
  String get priceBreakdownTitle => 'پوختەی نرخ';

  @override
  String get baseWeightSurcharge => 'بنەکە + کێش + زیادە';

  @override
  String get vehicleMultiplier => 'زێدەکەری ئامێر';

  @override
  String get totalPaid => 'کۆی پارەدانراو';

  @override
  String get markDelivered => 'وەک گەیاندراو مەزرە';

  @override
  String get liveTracking => 'بەدواداچوونی ڕاستەوخۆ';

  @override
  String get route => 'ڕێگا';

  @override
  String get orderPlaced => 'بارەکە تۆمارکرا';

  @override
  String get inTransit => 'لە ڕێگایە';

  @override
  String get delivered => 'گەیەندرا';

  @override
  String get nowLabel => 'ئێستا';

  @override
  String get help => 'یارمەتی و پشتگیری';

  @override
  String get about => 'دەربارە';

  @override
  String get newShipment => 'بارێکی نوێ';

  @override
  String get createShipment => 'بار دروست بکە';

  @override
  String get origin => 'بنەڕەت';

  @override
  String get destination => 'ئامانج';

  @override
  String get weight => 'کێش (کگ)';

  @override
  String get category => 'پۆل';

  @override
  String get vehicleType => 'جۆری ئامێر';

  @override
  String get totalPrice => 'کۆی نرخ';

  @override
  String get estimatedDelivery => 'دەستپێکردنی خەمڵاندن';

  @override
  String get days => 'ڕۆژ';

  @override
  String get shipmentDetails => 'زانیاری بار';

  @override
  String get shipmentStatus => 'دۆخ';

  @override
  String get priceBreakdown => 'لیستی نرخ';

  @override
  String get trackShipment => 'تەرەکردنی بار';

  @override
  String get pending => 'چاوسێنراو';

  @override
  String get reported => 'راپۆرتکرا';

  @override
  String get all => 'هەموو';

  @override
  String get confirm => 'دڵنیابوونەوە';

  @override
  String get cancel => 'هەڵوەشاندنەوە';

  @override
  String get save => 'پاشەکەوتکردن';

  @override
  String get delete => 'سڕینەوە';

  @override
  String get edit => 'دەستکاری';

  @override
  String get create => 'دروستکردن';

  @override
  String get update => 'نوێکردنەوە';

  @override
  String get search => 'گەڕان';

  @override
  String get searchPlaceholder => 'گەڕان بۆ بارەکان...';

  @override
  String get filter => 'فلتەر';

  @override
  String get refresh => 'نوێکردنەوە';

  @override
  String get submit => 'ناردن';

  @override
  String get markAsRead => 'وەک خوێندراوە مەزرە';

  @override
  String get markAllRead => 'هەمووی وەک خوێندراو مەزرە';

  @override
  String get reportProblem => 'کێشەیەک راپۆرت بکە';

  @override
  String get submitReport => 'راپۆرت بنێرە';

  @override
  String get reportDetails => 'زانیاری راپۆرت';

  @override
  String get yourComment => 'تێبینی تۆ';

  @override
  String get staffResponse => 'وەڵامی کارمەند';

  @override
  String get reportStatus => 'دۆخی راپۆرت';

  @override
  String get open => 'کراوە';

  @override
  String get resolved => 'چارەسەرکرا';

  @override
  String get rejected => 'رەتکرایەوە';

  @override
  String get compensationIssued => 'کۆمپەنسەیشن دەرچووە';

  @override
  String get userManagement => 'بەڕێوەبردنی بەکارهێنەر';

  @override
  String get addUser => 'بەکارهێنەر زیاد بکە';

  @override
  String get editUser => 'دەستکاری بەکارهێنەر';

  @override
  String get userRole => 'ڕۆڵ';

  @override
  String get customer => 'کڕیار';

  @override
  String get driver => 'شوێنکەوتوو';

  @override
  String get staff => 'کارمەند';

  @override
  String get superAdmin => 'سووپەر ئەدمین';

  @override
  String get active => 'چالاک';

  @override
  String get inactive => 'ناچالاک';

  @override
  String get toggleStatus => 'گۆڕینی دۆخ';

  @override
  String get categoryManagement => 'بەڕێوەبردنی پۆل';

  @override
  String get addCategory => 'پۆل زیاد بکە';

  @override
  String get editCategory => 'دەستکاری پۆل';

  @override
  String get nameEn => 'ناو (ئینگلیزی)';

  @override
  String get nameKu => 'ناو (کوردی)';

  @override
  String get surcharge => 'سەرەتای نرخ';

  @override
  String get multiplier => 'لێکدەر';

  @override
  String get deliveryDaysOffset => 'جیاوازی ڕۆژی گەیاندن';

  @override
  String get vehicleManagement => 'بەڕێوەبردنی ئامێر';

  @override
  String get addVehicle => 'ئامێر زیاد بکە';

  @override
  String get editVehicle => 'دەستکاری ئامێر';

  @override
  String get pricingConfiguration => 'ڕێکخستنی نرخ';

  @override
  String get basePrice => 'نرخی بنەڕەت';

  @override
  String get weightRate => 'نرخی کێش';

  @override
  String get updatePricing => 'نرخ نوێکەرەوە';

  @override
  String get previewPrice => 'پێشبینی نرخ';

  @override
  String get calculatePrice => ' حسابات نرخ';

  @override
  String get faqManagement => 'بەڕێوەبردنی پرسیارە باوەکان';

  @override
  String get addFaq => 'پرسیار زیاد بکە';

  @override
  String get editFaq => 'دەستکاری پرسیار';

  @override
  String get question => 'پرسیار';

  @override
  String get answer => 'وەڵام';

  @override
  String get sortOrder => 'ڕیزکردن';

  @override
  String get account => 'هەژمار';

  @override
  String get appearance => 'ڕووی دیمەن';

  @override
  String get darkMode => 'دۆخی تاریک';

  @override
  String get lightMode => 'دۆخی سپی';

  @override
  String get language => 'زمان';

  @override
  String get english => 'ئینگلیزی';

  @override
  String get kurdish => 'کوردی';

  @override
  String get security => 'ئاسایش';

  @override
  String get changePassword => 'وشەی نهێنی بگۆڕە';

  @override
  String get notificationSettings => 'ڕێکخستنەکانی ئاگانامە';

  @override
  String get pushNotifications => 'ئاگانامەی پووش';

  @override
  String get loading => 'بارکردن...';

  @override
  String get noData => 'هیچ داتایەک نییە';

  @override
  String get error => 'هەڵە';

  @override
  String get success => 'سەرکەوتن';

  @override
  String get failed => 'شکستی هێنا';

  @override
  String get retry => 'هەوڵدانەوە';

  @override
  String get confirmAction => 'دڵنیایت؟';

  @override
  String get yes => 'بەڵێ';

  @override
  String get no => 'نەخێر';

  @override
  String get ok => 'باشە';

  @override
  String get required => 'پێویستە';

  @override
  String get invalidEmail => 'ئیمەیڵێکی نادروستە';

  @override
  String get passwordTooShort => 'وشەی نهێنی زۆر کورتە';

  @override
  String get passwordMismatch => ' وشەی نهێنییەکان جیاوازن';

  @override
  String get justNow => 'هەر ئێستا';

  @override
  String minutesAgo(int count) {
    return '$count خولەک پێش ئێستا';
  }

  @override
  String hoursAgo(int count) {
    return '$count کاتژمێر پێش ئێستا';
  }

  @override
  String get yesterday => 'دوێنێ';

  @override
  String get total => 'کۆی';

  @override
  String get pendingCount => 'چاوسێنراو';

  @override
  String get inTransitCount => 'لەڕێگەدا';

  @override
  String get deliveredCount => 'گەیەندرا';

  @override
  String get reportedCount => 'راپۆرتکرا';

  @override
  String get newShipmentBtn => '+ بارێکی نوێ';

  @override
  String get noShipmentsYet => 'هیچ بارێک نییە';

  @override
  String get createFirstShipment => 'یەکەمین بارت لە لای سەرەوە دروست بکە';

  @override
  String get recentShipments => 'بارە نوێیەکان';

  @override
  String get helpAndFaq => 'یارمەتی و پرسیارە دووبارەکان';

  @override
  String get findAnswers => 'وەڵامی پرسیارە باوەکان بدۆزەرەوە';

  @override
  String get preferences => 'ئامادەکاری';

  @override
  String get signOut => 'دەرچوون';

  @override
  String get darkModeToggle => 'دۆخی تاریک';

  @override
  String get switchToDark => 'گۆڕین بۆ دۆخی تاریک';

  @override
  String get receiveAlerts => 'ئاگانامە وەربگرە بۆ بارەکانت';

  @override
  String get helpFaqLink => 'یارمەتی و پرسیارە دووبارەکان';

  @override
  String get contactSupport => 'پەیوەندی بکە بۆ پشتگیری';

  @override
  String get updatesFromShipments => 'نوێکارییەکان لە بارەکانتەوە';

  @override
  String get noNotificationsYet => 'هیچ ئاگانامەیەک نییە';

  @override
  String get allCaughtUp => 'هەمووت خوێندەوە!';

  @override
  String get shipmentUpdate => 'نوێکاری بار';

  @override
  String get reportUpdate => 'نوێکاری راپۆرت';

  @override
  String get newAssignment => 'ئەسپارتنی نوێ';

  @override
  String get imageUnavailable => 'وێنەکە بەردەست نییە';

  @override
  String get readLabel => 'خوێندراوە';

  @override
  String get reportIssue => 'ڕاپۆرتکردنی کێشە';

  @override
  String get confirmDelivery => 'کۆتاییهێنان بە گەیاندن';

  @override
  String get deliveredSuccessfully => 'بارەکە بە سەرکەوتوویی گەیەندرا';

  @override
  String get myAssignments => 'ئەسپارتنەکانم';

  @override
  String get noAssignments => 'هیچ ئەسپارتنێک نییە';

  @override
  String get noDeliveriesYet => 'هیچ گەیاندنێکت بۆ نەسپێردراوە';

  @override
  String get overview => 'تێڕوانین';

  @override
  String get systemOverview => 'تێڕوانینی گشتی بارەکان';

  @override
  String get signInToManage => 'بچۆ ژوورەوە بۆ بەڕێوەبردنی بارەکانت';

  @override
  String get dontHaveAccount => 'هەژمارت نییە؟';

  @override
  String get createOne => 'دروستی بکە';

  @override
  String get incorrectCredentials => 'ئیمەیڵ یان وشەی نهێنی هەڵەیە';

  @override
  String get assigned => 'ئەسپاردراو';

  @override
  String get history => 'مێژوو';

  @override
  String get alerts => 'ئاگادارکردنەوەکان';

  @override
  String get orders => 'داواکارییەکان';

  @override
  String get transit => 'لەڕێگەدا';

  @override
  String get tryDifferentFilter => 'فلتەرێکی تر هەڵبژێرە';

  @override
  String get failedToLoadShipments => 'بارکردنی بارەکان سەرنەکەوت';

  @override
  String get failedToLoad => 'بارکردن سەرنەکەوت';

  @override
  String get newBtn => 'نوێ';

  @override
  String get noShipmentsFilter => 'هیچ بارێک نییە';

  @override
  String get catalogLabel => 'کەتەلۆگ';

  @override
  String get usersLabel => 'بەکارهێنەران';

  @override
  String get vehiclesLabel => 'ئامێرەکان';

  @override
  String get faqLabel => 'پرسیارە دووبارەکان';

  @override
  String get pricingLabel => 'نرخ';

  @override
  String get reportsLabel => 'راپۆرتەکان';

  @override
  String get welcomeBackTitle => 'بەخێرهاتیتەوە\nدووبارە.';

  @override
  String get shipmentMonitor => 'چاودێری بارەکان';

  @override
  String get monitorSubtitle => 'چاودێری و بەڕێوەبردنی هەموو بارەکان';

  @override
  String get driverLabel => 'شۆفێر';

  @override
  String get actionLabel => 'کار';

  @override
  String get assignBtn => 'ئەسپاردن';

  @override
  String get assignDriverTitle => 'ئەسپاردنی شۆفێر';

  @override
  String get driverUserIdHint => 'ناسنامەی شۆفێر';

  @override
  String get staffDashboard => 'داشبۆردی کارمەند';

  @override
  String get shipmentList => 'لیستی بارەکان';

  @override
  String get incidentReports => 'راپۆرتی رووداوەکان';

  @override
  String get systemSettings => 'رێکخستنی سیستەم';

  @override
  String get ltmsStaff => 'کارمەندی LTMS';

  @override
  String get reportQueue => 'ڕیزبەندی ڕاپۆرتەکان';

  @override
  String get reportQueueSubtitle =>
      'پێداچوونەوە و وەڵامدانەوەی ڕاپۆرتی کڕیاران';

  @override
  String get noReports => 'هیچ ڕاپۆرتێک نییە';

  @override
  String get staffResponseLabel => 'وەڵامی ستاف:';

  @override
  String get resolveBtn => '✓ چارەسەرکردن';

  @override
  String get rejectBtn => '✕ ڕەتکردنەوە';

  @override
  String get noNotificationsSent => 'هێشتا هیچ ئاگادارکردنەوەیەک نەنێردراوە';

  @override
  String get tapSendToNotify => 'کلیک لەسەر ناردن بکە بۆ ئاگادارکردنەوەی کڕیار';

  @override
  String get sentBadge => 'نێردرا';

  @override
  String get notifyBtn => 'ئاگادارکردنەوە';

  @override
  String get failedToLoadCustomers => 'بارکردنی کڕیاران سەرکەوتوو نەبوو';

  @override
  String get addPhoto => 'زیادکردنی وێنە';

  @override
  String get takePhoto => 'وێنەگرتن';

  @override
  String get chooseGallery => 'هەڵبژاردن لە گالەری';

  @override
  String get removePhoto => 'سڕینەوەی وێنە';

  @override
  String get toCustomerLabel => 'بۆ (کڕیار)';

  @override
  String get selectCustomerHint => 'کڕیارێک هەڵبژێرە...';

  @override
  String get messageEnLabel => 'نامە (ئینگلیزی)';

  @override
  String get messageEnHint =>
      'بۆ نموونە: بارەکەت گەیشتە سەنتەری هەولێر و ئامادەیە بۆ وەرگرتن.';

  @override
  String get messageKuLabel => 'نامە (کوردی)';

  @override
  String get messageKuHint => 'بارەکەت گەیشتە هەولێر و ئامادەی وەرگرتنە.';

  @override
  String get photoOptionalLabel => 'وێنە (ئارەزوومەندانە)';

  @override
  String get tapToChange => 'کلیک بکە بۆ گۆڕین';

  @override
  String get tapToAddPhoto => 'کلیک بکە بۆ زیادکردنی وێنە';

  @override
  String get cameraOrGallery => 'کامێرا یان گالەری';

  @override
  String get updatePasswordSubtitle => 'نوێکردنەوەی تێپەڕەوشەی چوونەژوورەوە';

  @override
  String get supportHours => 'بەردەستە (٩ی بەیانی - ٥ی ئێوارە)';

  @override
  String get accountSection => 'هەژمار';

  @override
  String get notificationsSection => 'ئاگادارکردنەوەکان';

  @override
  String get appearanceSection => 'شێوە';

  @override
  String get supportSection => 'پشتگیری';

  @override
  String get editProfile => 'دەستکاری پرۆفایل';

  @override
  String get editProfileSubtitle => 'ناو و زانیارییەکانت نوێ بکەوە';

  @override
  String get pushNotificationsSubtitle => 'راپۆرت و ئەسپاردە نوێیەکان';

  @override
  String get emailAlerts => 'ئاگادارکردنەوەی ئیمێڵ';

  @override
  String get emailAlertsSubtitle => 'کورتەی ئیمێڵی رۆژانە';

  @override
  String get doNotDisturb => 'بێدەنگکردن';

  @override
  String get doNotDisturbSubtitle => 'بێدەنگکردنی ئاگادارکردنەوەکان';

  @override
  String get darkModeSubtitle => 'گۆڕین بۆ تیمی تاریک';

  @override
  String get compactView => 'نیشاندانی چڕ';

  @override
  String get compactViewSubtitle => 'نیشاندانی زانیاری زیاتر لە هەر دێڕێک';

  @override
  String get aboutLtms => 'دەربارەی LTMS';

  @override
  String get signOutSubtitle => 'چوونە دەرەوە لە هەژماری کارمەند';

  @override
  String get nameLabel => 'ناو';

  @override
  String get fullNameHint => 'ناوی تەواوت';

  @override
  String get selectLanguage => 'هەڵبژاردنی زمان';

  @override
  String get closeBtn => 'داخستن';

  @override
  String get buildLabel => 'بینیات: 2026.03';

  @override
  String get productLabel => 'بەرهەم';

  @override
  String get logisticsSystemName => 'سیستەمی بەڕێوەبردنی\nگواستنەوە و لۆجیستی';

  @override
  String get id => 'ناسنامە';

  @override
  String get weightLabel => 'کێش';

  @override
  String get priceLabel => 'نرخ';

  @override
  String get statusLabel => 'دۆخ';

  @override
  String get changeAdminKey => 'گۆڕینی کلیلی ئەدمین';

  @override
  String get keyExpiredMessage =>
      'کلیلی ئەدمینەکەت بەسەرچووە. تکایە یەکێکی نوێ دروست بکە.';

  @override
  String get generateNewKey => 'دروستکردنی کلیلی نوێ';

  @override
  String get adminRole => 'ئەدمین';

  @override
  String get splashTagline => 'هەر شتێک بنێرە، بۆ هەر کوێێک.';

  @override
  String get splashSubtitle => 'ڕێگای زیرەکتر بۆ بەڕێوەبردنی لۆجیستیکەکەت';

  @override
  String get getStarted => 'دەستپێبکە ←';

  @override
  String get signInToAccount => 'داخلبوون بۆ ئەکاونتم';

  @override
  String get chooseTransport => 'ڕێگای گواستنەوە هەڵبژێرە';

  @override
  String get groundTransport => 'گواستنەوەی بەری';

  @override
  String get airTransport => 'گواستنەوەی ئەسمانی';

  @override
  String get seaTransport => 'گواستنەوەی دەریایی';

  @override
  String get continueBtn => 'بەردەوامبوون ←';

  @override
  String get backBtn => '→ گەڕانەوە';

  @override
  String get whereIsItGoing => 'بۆ کوێ دەچێت؟';

  @override
  String get enterOriginDestination =>
      'شوێنی ئەرەکە و دەستینەی بارەکەت بنووسە.';

  @override
  String get whatAreSending => 'چی دەنێرێت؟';

  @override
  String get weightKg => 'کێش (کیلۆگرام)';

  @override
  String get dimensionsCm => 'ئەندازەکان (سانتیمەتر)';

  @override
  String get estimatedTotal => 'کۆی خەمڵێندراو';

  @override
  String estimatedDeliveryDays(int days) {
    return 'خەمڵێندراوی گەیاندن: $days رۆژ';
  }

  @override
  String get shipmentSummary => 'پوختەی بارەکە';

  @override
  String get confirmShipment => 'پشتڕاستکردنەوەی بارەکە';

  @override
  String get shipmentCreated => 'بارەکە دروستکرا! 🎉';

  @override
  String get vehicleStep => 'ئامێر';

  @override
  String get routeStep => 'ڕێگا';

  @override
  String get detailsStep => 'وردەکاری';

  @override
  String get reviewStep => 'پێداچونەوە';

  @override
  String get categoryGeneral => 'گشتی';

  @override
  String get categoryFragile => 'شکّاو';

  @override
  String get categoryElectronics => 'ئەلیکترۆنیات';

  @override
  String get transportTruck => 'تریلە';

  @override
  String get transportTruckMeta => '+٢ رۆژ · ظەرفیەتی بەرز';

  @override
  String get transportAirplane => 'ئاسمانپەیما';

  @override
  String get transportAirplaneMeta => '-٢ رۆژ · پڕ خێرا';

  @override
  String get transportShip => 'کەشتی';

  @override
  String get transportShipMeta => '+١٠ رۆژ · باری دەریا';

  @override
  String get weightRow => 'کێش';

  @override
  String get dimensionsRow => 'ئەندازەکان';

  @override
  String get transportRow => 'ئامێری گواستنەوە';

  @override
  String get validWeightError => 'تکایە کێشێکی دروست بنووسە.';

  @override
  String get validDimensionsError =>
      'تکایە ژمارەی دروست بۆ دراز، پان و بەرزی بنووسە.';

  @override
  String get signInToDeliveries => 'داخلبوون بۆ بەڕێوەبردنی گەیاندنەکانت';

  @override
  String get loginFailed => 'داخلبوون سەرکەوتوو نەبوو';

  @override
  String get enterEmail => 'تکایە ئیمەیلت بنووسە';

  @override
  String get enterValidEmail => 'تکایە ئیمەیلێکی دروست بنووسە';

  @override
  String get enterPassword => 'تکایە وشەی نهێنیت بنووسە';

  @override
  String get enterName => 'تکایە ناوت بنووسە';

  @override
  String get passwordMin8 => 'وشەی نهێنی دەبێت لانیکەم ٨ پیت بێت';

  @override
  String get registrationFailed =>
      'تۆمارکردن سەرکەوتوو نەبوو. تکایە دووبارە هەوڵبدەرەوە.';

  @override
  String get alreadyMember => 'ئەزموونی هەیتە؟ ';

  @override
  String get termsAgree =>
      'بە دروستکردنی ئەکاونت ڕازیت بە مەرجەکانی خزمەتگوزاری و سیاسەتی نهێنیمانە.';

  @override
  String get fullNameLabel => 'ناوی تەواو';

  @override
  String get emailAddressLabel => 'ئینەوانی ئیمەیل';

  @override
  String get confirmPasswordLabel => 'دووبارەکردنەوەی وشەی نهێنی';

  @override
  String get passwordMinHint => 'لانیکەم ٨ پیت';

  @override
  String get repeatPasswordHint => 'وشەی نهێنی دووبارە بنووسە';

  @override
  String get createAccountTitle => 'دروستکردنی\nئەکاونتت.';

  @override
  String get createAccountSubtitle =>
      'زیرەکتر بنێرە — یەکەمین ئۆردەرت لە چەند خولەکدا شوێننیشان بکە';

  @override
  String get signInToStaffPortal => 'داخلبوون بۆ دەرگای ستاف';

  @override
  String get signOutDashboard => 'داشبۆرد';

  @override
  String get reportSubmitted => 'رپۆرتەکە نارا ✓';

  @override
  String get shipmentLabel => 'بارەکە';

  @override
  String get describeProblem => 'کێشەکە وەسف بکە';

  @override
  String get teamWillReview =>
      'تیمەکەمان رپۆرتەکەت پێداچونەوە دەکاتەوە و لە ٢٤–٤٨ کاتژمێردا وەڵامت دەداتەوە.';

  @override
  String get reportAnIssue => 'رپۆرتکردنی کێشە';

  @override
  String get problemHint => 'بۆ نموونە: گورجەکە زیانی پێگەیشت — شووشەکە شکا…';

  @override
  String get originCity => '📍 شارەوانی سەرچاوە';

  @override
  String get destinationCity => '🏁 شارەوانی دەستینە';

  @override
  String get originHint => 'بۆ نموونە: هەولێر';

  @override
  String get destinationHint => 'بۆ نموونە: ئیستانبوول';

  @override
  String newUnread(int count) {
    return '$count نوێ';
  }

  @override
  String get accountSettings => 'هەژمار';

  @override
  String get accountSubtitle => 'زانیاری پرۆفایلەکەت نوێ بکەوە';

  @override
  String get appearanceSettings => 'ڕووی دیمەن';

  @override
  String get appearanceSubtitle => 'دۆخی تاریک و ڕێکخستنەکانی تەمەن';

  @override
  String get notificationsSettings => 'ئاگانامەکان';

  @override
  String get notificationsSubtitle => 'ڕێکخستنەکانی ئاگانامەی پووش';

  @override
  String get securitySettings => 'ئاسایش';

  @override
  String get securitySubtitle => 'وشەی نهێنی و ڕێکخستنەکانی ئاسایش';

  @override
  String get helpSupportSettings => 'یارمەتی و پشتگیری';

  @override
  String get helpSupportSubtitle => 'پرسیارە دووبارەکان و پەیوەندی';

  @override
  String get aboutSettings => 'دەربارە';

  @override
  String get aboutSubtitle => 'ڤێرژنی ئاپەکە 1.0.0';

  @override
  String get signOutSettings => 'دەرچوون';

  @override
  String get noShipmentsFound => 'هیچ بارێک نەدۆزرایەوە';

  @override
  String get errorLoadingShipments => 'هەڵە لە بارکردنی بارەکان';

  @override
  String get errorLoading => 'هەڵە لە بارکردن';

  @override
  String get errorLoadingUsers => 'هەڵە لە بارکردنی بەکارهێنەران';

  @override
  String get noDriversFound => 'هیچ شۆفێرێکی چالاک نەدۆزرایەوە';

  @override
  String get userCreated => 'بەکارهێنەر بە سەرکەوتوویی دروستکرا';

  @override
  String get createNewUser => 'بەکارهێنەری نوێ دروست بکە';

  @override
  String get selectRole => 'ڕۆڵ هەڵبژێرە';

  @override
  String generatedPassword(String password) {
    return 'وشەی نهێنی دروستکرا: $password';
  }

  @override
  String get generatePassword => 'دروستکردنی وشەی نهێنی';

  @override
  String get copyPassword => 'کۆپیکردنی وشەی نهێنی';

  @override
  String get assignDriver => 'شوێنکەوتوو ئەسپاردن';

  @override
  String get pricingFormula => 'کۆی = (بن + کێش × نرخ + خەرێک) × لێکدەری ئامێر';

  @override
  String get reportOverview => 'سەرنجی راپۆرت';

  @override
  String get catalogManagement => 'بەڕێوەبردنی کاتالۆگ';

  @override
  String get categoryCrudPlaceholder => 'ڕێکخستنی پۆل';

  @override
  String kgUnit(String value) {
    return '$value کگ';
  }

  @override
  String priceFormat(String value) {
    return '\$$value';
  }

  @override
  String get continueButton => 'بەردەوامبوون';

  @override
  String get backButton => 'گەڕانەوە';

  @override
  String get confirmShipmentButton => 'دڵنیابوونەوەی بار';

  @override
  String get shipmentCreatedSuccess => 'بارەکە بە سەرکەوتوویی دروستکرا!';

  @override
  String shipmentCreatedError(String error) {
    return 'هەڵە: $error';
  }

  @override
  String get newShipmentButton => '+ بارێکی نوێ';

  @override
  String get helpFaq => 'یارمەتی و پرسیارە دووبارەکان';

  @override
  String get searchQuestions => 'گەڕان لە پرسیارەکان…';

  @override
  String get resolve => 'چارەسەرکردن';

  @override
  String get reject => 'رەتکردنەوە';

  @override
  String errorProcessing(String error) {
    return 'هەڵە: $error';
  }

  @override
  String routeArrow(String origin, String destination) {
    return '$origin ← $destination';
  }

  @override
  String get staffHint => 'staff@ltms.com';

  @override
  String get driverHint => 'driver@email.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get ltmsAdmin => 'ئەدمینی LTMS';

  @override
  String get ltmsCustomer => 'کڕیاری LTMS';

  @override
  String get ltmsDriver => 'شوێنکەوتووی LTMS';

  @override
  String get emailPlaceholder => 'email@example.com';

  @override
  String get passwordPlaceholder => '••••••';

  @override
  String get updateProfile => 'نوێکردنەوەی پرۆفایل';

  @override
  String get saveChanges => 'پاشەکەوتکردنی گۆڕانکارییەکان';

  @override
  String get updatePassword => 'نوێکردنەوەی وشەی نهێنی';

  @override
  String get noCustomersFound => 'هیچ کڕیارێک نەدۆزرایەوە';

  @override
  String get notificationSentSuccess => 'ئاگانامە بە سەرکەوتوویی نرا!';

  @override
  String get notificationHint => 'بۆ نموونە: ئامادەکاری هەولێر، دەرگا ٣';

  @override
  String get sendNotification => 'ناردنی ئاگانامە';

  @override
  String get staffSidebar => 'کارمەندی LTMS';

  @override
  String get lengthLabel => 'درێژی';

  @override
  String get widthLabel => 'پانی';

  @override
  String get heightLabel => 'بەرزی';

  @override
  String get weightPlaceholder => '0.0';

  @override
  String get yourNameHint => 'ناوت';

  @override
  String get yourFullNameHint => 'ناوی تەواوت';

  @override
  String get passwordUpdateHint => 'وشەی نهێنیت نوێ بکەوە';

  @override
  String get alertsSubtitle => 'ئاگادارکردنەوە بۆ ئەسپارتنی نوێ وەربگرە';

  @override
  String get accountSubtitleUpdate => 'ناو و زانیارییەکانت نوێ بکەوە';

  @override
  String get passwordSubtitleUpdate => 'وشەی نهێنیت نوێ بکەوە';

  @override
  String get faqSubtitle => 'پرسیارە دووبارەکان و پەیوەندی';

  @override
  String get feedbackSubtitle => 'پێداچونەوەکانت بنێرە';

  @override
  String get versionInfo => 'ڤێرژن 1.0.0 · LTMS شوێنکەوتوو';

  @override
  String get versionLabel => 'ڤێرژن: 1.0.0';

  @override
  String get logisticsSystemFull => 'سیستەمی بەڕێوەبردنی گواستنەوە و لۆجیستیک';

  @override
  String shipmentIdPrefix(String id) {
    return '#$id';
  }

  @override
  String statusUpdated(String status) {
    return 'دۆخ نوێکرایەوە بۆ $status';
  }

  @override
  String statusUpdateError(String error) {
    return 'هەڵە: $error';
  }

  @override
  String get acceptStartTransit => 'قبووڵکردن و دەستپێکردنی گواستنەوە';

  @override
  String get markAsDelivered => 'وەک گەیاندراو مەزرە';

  @override
  String get noNotificationsFound => 'هیچ ئاگانامەیەک نەدۆزرایەوە';

  @override
  String get noNotifications => 'هیچ ئاگانامەیەک نییە';

  @override
  String get ltmsTitle => 'LTMS';

  @override
  String get stillNeedHelp => 'هێشتا پێویستت بە یارمەتییە؟';

  @override
  String get contactSupportLine =>
      'ڕاستەوخۆ پەیوەندی بە تیمی پاڵپشتی ئێمەوە بکە';

  @override
  String get settings => 'ڕێکخستنەکان';

  @override
  String get updateBtn => 'نوێکردنەوە';

  @override
  String get statusUpdate => 'نوێکردنەوەی دۆخ';

  @override
  String get assignment => 'ئەسپاردن';

  @override
  String get sendBtn => 'ناردن';

  @override
  String get selectCustomer => 'کڕیار هەڵبژێرە';

  @override
  String get selectCustomerError => 'تکایە کڕیارێک هەڵبژێرە';

  @override
  String get messageEnRequired => 'نامەی ئینگلیزی پێویستە';

  @override
  String get messageKuRequired => 'نامەی کوردی پێویستە';

  @override
  String get failedToSend => 'ناردن سەرکەوتوو نەبوو';

  @override
  String get locationLabel => 'شوێن';

  @override
  String get locationHint => 'بۆ نموونە: کۆگای هەولێر';

  @override
  String get reportLabel => 'ڕاپۆرت';

  @override
  String get customerLabel => 'کڕیار';

  @override
  String get minPasswordHint => 'لانیکەم ٨ پیت';

  @override
  String get faqCrudPlaceholder => 'ناوەڕۆکی بەڕێوەبردنی پرسیارە باوەکان';

  @override
  String get languageSubtitle => 'گۆڕینی زمانی ئەپڵیکەیشن';

  @override
  String get accountDisabled =>
      'هەژمارەکەت ناچالاک کراوە. تکایە پەیوەندی بکە بە پشتگیری.';
}
