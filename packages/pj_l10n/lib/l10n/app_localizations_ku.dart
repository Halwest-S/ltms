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
  String get appSubtitle => 'بەڕێوەبردنی هاوردەکردنی کاڵا بۆ کوردستان';

  @override
  String get login => 'چوونەژوورەوە';

  @override
  String get logout => 'چوونەدەرەوە';

  @override
  String get register => 'خۆتۆمارکردن';

  @override
  String get email => 'ئیمەیڵ';

  @override
  String get password => 'وشەی نهێنی';

  @override
  String get confirmPassword => 'دووبارەکردنەوەی وشەی نهێنی';

  @override
  String get forgotPassword => 'وشەی نهێنیت لەبیرکردووە؟';

  @override
  String get signIn => 'چوونەژوورەوە';

  @override
  String get signUp => 'خۆتۆمارکردن';

  @override
  String get welcomeBack => 'بەخێرهاتیتەوە';

  @override
  String get createAccount => 'دروستکردنی هەژمار';

  @override
  String get home => 'سەرەکی';

  @override
  String get dashboard => 'داشبۆرد';

  @override
  String get shipments => 'هاوردەکان';

  @override
  String get myShipments => 'هاوردەکانم';

  @override
  String get assignedShipments => 'هاوردە سپێردراوەکان';

  @override
  String get reports => 'ڕاپۆرتەکان';

  @override
  String get notifications => 'ئاگادارکردنەوەکان';

  @override
  String shipmentsCount(int count) {
    return '$count هاوردە';
  }

  @override
  String shipmentCount(int count) {
    return '$count هاوردە';
  }

  @override
  String get users => 'بەکارهێنەران';

  @override
  String get categories => 'پۆلەکان';

  @override
  String get vehicles => 'هۆکارەکانی گواستنەوە';

  @override
  String get vehicleTypes => 'جۆرەکانی گواستنەوە';

  @override
  String get vehicleCrudPlaceholder =>
      'ناوەڕۆکی بەڕێوەبردنی هۆکارەکانی گواستنەوە';

  @override
  String get sent => 'نێردراو';

  @override
  String get sentTab => 'نێردراو';

  @override
  String get customersTab => 'کڕیاران';

  @override
  String get logisticsPortal => 'پۆرتاڵی بەڕێوەبردنی لۆجستیک';

  @override
  String get sendUpdatesSubtitle => 'ناردنی نوێکاری بۆ کڕیاران';

  @override
  String get signOutConfirmStaff => 'ئایا دڵنیایت لە چوونەدەرەوە؟';

  @override
  String get manageAccount => 'بەڕێوەبردنی هەژمارەکەت';

  @override
  String get usernameLabel => 'ناوی بەکارهێنەر';

  @override
  String get appSettings => 'ڕێکخستنەکانی ئەپ';

  @override
  String get support => 'پشتگیری';

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
  String get priceBreakdownTitle => 'وردەکاریی نرخ';

  @override
  String get baseWeightSurcharge => 'نرخی بنەڕەت + کێش + زیادەی نرخ';

  @override
  String get vehicleMultiplier => 'جارکەری هۆکاری گواستنەوە';

  @override
  String get totalPaid => 'کۆی پارەی دراو';

  @override
  String get markDelivered => 'دڵنیاکردنەوەی گەیاندن';

  @override
  String get liveTracking => 'بەدواداچوونی ڕاستەوخۆ';

  @override
  String get route => 'ڕێڕەوی هاوردە';

  @override
  String get orderPlaced => 'داواکاری تۆمارکرا';

  @override
  String get inTransit => 'لە ڕێگادایە';

  @override
  String get delivered => 'گەیەندراو';

  @override
  String get nowLabel => 'ئێستا';

  @override
  String get help => 'یارمەتی و پشتگیری';

  @override
  String get about => 'دەربارە';

  @override
  String get newShipment => 'هاوردەی نوێ';

  @override
  String get createShipment => 'دروستکردنی داواکاری هاوردە';

  @override
  String get origin => 'شوێنی دابینکەر';

  @override
  String get destination => 'گەیاندن لە کوردستان';

  @override
  String get weight => 'کێش (کگ)';

  @override
  String get category => 'پۆل';

  @override
  String get vehicleType => 'جۆری هۆکاری گواستنەوە';

  @override
  String get totalPrice => 'کۆی نرخ';

  @override
  String get estimatedDelivery => 'گەیاندنی خەمڵێنراو';

  @override
  String get days => 'ڕۆژ';

  @override
  String get shipmentDetails => 'وردەکارییەکانی هاوردە';

  @override
  String get shipmentStatus => 'دۆخی هاوردە';

  @override
  String get priceBreakdown => 'وردەکاریی نرخ';

  @override
  String get trackShipment => 'بەدواداچوونی هاوردە';

  @override
  String get pending => 'چاوەڕوان';

  @override
  String get reported => 'ڕاپۆرتکراو';

  @override
  String get all => 'هەموو';

  @override
  String get confirm => 'دڵنیاکردنەوە';

  @override
  String get cancel => 'پاشگەزبوونەوە';

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
  String get searchPlaceholder => 'گەڕان بۆ هاوردەکان...';

  @override
  String get filter => 'فلتەر';

  @override
  String get refresh => 'نوێکردنەوە';

  @override
  String get submit => 'ناردن';

  @override
  String get markAsRead => 'وەک خوێندراو دیاری بکە';

  @override
  String get markAllRead => 'هەموویان وەک خوێندراو دیاری بکە';

  @override
  String get reportProblem => 'ڕاپۆرتکردنی کێشە';

  @override
  String get submitReport => 'ڕاپۆرت بنێرە';

  @override
  String get reportDetails => 'وردەکارییەکانی ڕاپۆرت';

  @override
  String get yourComment => 'تێبینی تۆ';

  @override
  String get staffResponse => 'وەڵامی کارمەند';

  @override
  String get reportStatus => 'دۆخی ڕاپۆرت';

  @override
  String get open => 'کراوە';

  @override
  String get resolved => 'چارەسەرکراو';

  @override
  String get rejected => 'ڕەتکراوە';

  @override
  String get compensationIssued => 'قەرەبوو دەرکرا';

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
  String get driver => 'شۆفێر';

  @override
  String get staff => 'کارمەند';

  @override
  String get superAdmin => 'بەڕێوەبەری گشتی';

  @override
  String get active => 'چالاک';

  @override
  String get inactive => 'ناچالاک';

  @override
  String get toggleStatus => 'گۆڕینی دۆخ';

  @override
  String get categoryManagement => 'بەڕێوەبردنی پۆلەکان';

  @override
  String get addCategory => 'پۆل زیاد بکە';

  @override
  String get editCategory => 'دەستکاری پۆل';

  @override
  String get nameEn => 'ناو (ئینگلیزی)';

  @override
  String get nameKu => 'ناو (کوردی)';

  @override
  String get surcharge => 'زیادەی نرخ';

  @override
  String get multiplier => 'لێکدەر';

  @override
  String get deliveryDaysOffset => 'جیاوازی ڕۆژی گەیاندن';

  @override
  String get vehicleManagement => 'بەڕێوەبردنی هۆکارەکانی گواستنەوە';

  @override
  String get addVehicle => 'زیادکردنی هۆکاری گواستنەوە';

  @override
  String get editVehicle => 'دەستکاری هۆکاری گواستنەوە';

  @override
  String get pricingConfiguration => 'ڕێکخستنی نرخدانان';

  @override
  String get basePrice => 'نرخی بنەڕەت';

  @override
  String get weightRate => 'نرخی کێش';

  @override
  String get updatePricing => 'نوێکردنەوەی نرخدانان';

  @override
  String get previewPrice => 'پێشبینی نرخ';

  @override
  String get calculatePrice => 'ژماردنی نرخ';

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
  String get sortOrder => 'ڕیزبەندی';

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
  String get notificationSettings => 'ڕێکخستنەکانی ئاگادارکردنەوە';

  @override
  String get pushNotifications => 'ئاگادارکردنەوەی پۆش';

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
  String get pendingCount => 'چاوەڕوان';

  @override
  String get inTransitCount => 'لە ڕێگادایە';

  @override
  String get deliveredCount => 'گەیەندراو';

  @override
  String get reportedCount => 'ڕاپۆرتکراو';

  @override
  String get newShipmentBtn => '+ هاوردەی نوێ';

  @override
  String get noShipmentsYet => 'هیچ داواکارییەکی هاوردە نییە';

  @override
  String get createFirstShipment => 'یەکەم داواکاری هاوردەکردنت دروست بکە';

  @override
  String get recentShipments => 'هاوردە دواییەکان';

  @override
  String get helpAndFaq => 'یارمەتی و پرسیارە باوەکان';

  @override
  String get findAnswers => 'وەڵامی پرسیارە باوەکان بدۆزەوە';

  @override
  String get preferences => 'هەڵبژاردنەکان';

  @override
  String get signOut => 'چوونەدەرەوە';

  @override
  String get darkModeToggle => 'دۆخی تاریک';

  @override
  String get switchToDark => 'گۆڕین بۆ دۆخی تاریک';

  @override
  String get receiveAlerts => 'ئاگادارکردنەوەی هاوردەکانت وەربگرە';

  @override
  String get helpFaqLink => 'یارمەتی و پرسیارە باوەکان';

  @override
  String get contactSupport => 'پەیوەندی بە پشتگیری بکە';

  @override
  String get updatesFromShipments => 'نوێکارییەکانی هاوردەکانت';

  @override
  String get noNotificationsYet => 'هیچ ئاگادارکردنەوەیەک نییە';

  @override
  String get allCaughtUp => 'هەموویان خوێندراون!';

  @override
  String get shipmentUpdate => 'نوێکاری هاوردە';

  @override
  String get reportUpdate => 'نوێکاری ڕاپۆرت';

  @override
  String get newAssignment => 'ئەسپاردەی نوێ';

  @override
  String get imageUnavailable => 'وێنەکە بەردەست نییە';

  @override
  String get readLabel => 'خوێندراوە';

  @override
  String get reportIssue => 'ڕاپۆرتکردنی کێشە';

  @override
  String get confirmDelivery => 'دڵنیاکردنەوەی گەیاندن';

  @override
  String get confirmDeliveryQuestion =>
      'ئایا کاڵای هاوردەکراوت بە سەرکەوتوویی گەیشتووە؟';

  @override
  String get deliveredSuccessfully =>
      'کاڵای هاوردەکراو بە سەرکەوتوویی گەیەندرا.';

  @override
  String get myAssignments => 'ئەسپاردەکانم';

  @override
  String get noAssignments => 'هیچ ئەسپاردەیەک نییە';

  @override
  String get noDeliveriesYet => 'هێشتا هیچ گەیاندنێکت پێ نەسپێردراوە';

  @override
  String get overview => 'تێڕوانین';

  @override
  String get systemOverview => 'تێڕوانینی گشتی هاوردەکان';

  @override
  String get signInToManage => 'بچۆ ژوورەوە بۆ بەڕێوەبردنی هاوردەکانت';

  @override
  String get dontHaveAccount => 'هەژمارت نییە؟';

  @override
  String get createOne => 'دروستی بکە';

  @override
  String get incorrectCredentials => 'ئیمەیڵ یان وشەی نهێنی هەڵەیە';

  @override
  String get assigned => 'سپێردراو';

  @override
  String get history => 'مێژوو';

  @override
  String get alerts => 'ئاگادارکردنەوەکان';

  @override
  String get orders => 'داواکارییەکان';

  @override
  String get transit => 'لە ڕێگا';

  @override
  String get tryDifferentFilter => 'فلتەرێکی تر هەڵبژێرە';

  @override
  String get failedToLoadShipments => 'بارکردنی هاوردەکان سەرنەکەوت';

  @override
  String get failedToLoad => 'بارکردن سەرنەکەوت';

  @override
  String get newBtn => 'نوێ';

  @override
  String get noShipmentsFilter => 'هیچ هاوردەیەک نییە';

  @override
  String get catalogLabel => 'کاتەلۆگ';

  @override
  String get usersLabel => 'بەکارهێنەران';

  @override
  String get vehiclesLabel => 'هۆکارەکان';

  @override
  String get faqLabel => 'پرسیارە باوەکان';

  @override
  String get pricingLabel => 'نرخ';

  @override
  String get reportsLabel => 'ڕاپۆرتەکان';

  @override
  String get welcomeBackTitle => 'بەخێرهاتیتەوە\nدووبارە.';

  @override
  String get shipmentMonitor => 'چاودێری هاوردەکان';

  @override
  String get monitorSubtitle =>
      'چاودێری و بەڕێوەبردنی کاڵای هاوردە بۆ کوردستان';

  @override
  String get driverLabel => 'شۆفێر';

  @override
  String get actionLabel => 'کار';

  @override
  String get assignBtn => 'سپاردن';

  @override
  String get assignDriverTitle => 'سپاردنی شۆفێر';

  @override
  String get driverUserIdHint => 'ناسنامەی شۆفێر';

  @override
  String get staffDashboard => 'داشبۆردی کارمەند';

  @override
  String get shipmentList => 'لیستی هاوردەکان';

  @override
  String get incidentReports => 'ڕاپۆرتی ڕووداوەکان';

  @override
  String get systemSettings => 'ڕێکخستنی سیستەم';

  @override
  String get ltmsStaff => 'کارمەندی LTMS';

  @override
  String get reportQueue => 'ڕیزی ڕاپۆرتەکان';

  @override
  String get reportQueueSubtitle =>
      'پێداچوونەوە و وەڵامدانەوەی ڕاپۆرتی کڕیاران';

  @override
  String get noReports => 'هیچ ڕاپۆرتێک نییە';

  @override
  String get staffResponseLabel => 'وەڵامی کارمەند';

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
      'بۆ نموونە: کاڵای هاوردەکراوت گەیشتە سەنتەری هەولێر و ئامادەیە بۆ وەرگرتن.';

  @override
  String get messageKuLabel => 'نامە (کوردی)';

  @override
  String get messageKuHint =>
      'کاڵای هاوردەکراوت گەیشتە هەولێر و ئامادەی وەرگرتنە.';

  @override
  String get photoOptionalLabel => 'وێنە (ئارەزوومەندانە)';

  @override
  String get tapToChange => 'کلیک بکە بۆ گۆڕین';

  @override
  String get tapToAddPhoto => 'کلیک بکە بۆ زیادکردنی وێنە';

  @override
  String get cameraOrGallery => 'کامێرا یان گالەری';

  @override
  String get updatePasswordSubtitle => 'نوێکردنەوەی وشەی نهێنی چوونەژوورەوە';

  @override
  String get supportHours => 'بەردەستە (٩ی بەیانی - ٥ی ئێوارە)';

  @override
  String get accountSection => 'هەژمار';

  @override
  String get notificationsSection => 'ئاگادارکردنەوەکان';

  @override
  String get appearanceSection => 'ڕووکار';

  @override
  String get supportSection => 'پشتگیری';

  @override
  String get editProfile => 'دەستکاری پرۆفایل';

  @override
  String get editProfileSubtitle => 'ناو و زانیارییەکانت نوێ بکەوە';

  @override
  String get pushNotificationsSubtitle => 'ڕاپۆرت و ئەسپاردە نوێیەکان';

  @override
  String get emailAlerts => 'ئاگادارکردنەوەی ئیمەیڵ';

  @override
  String get emailAlertsSubtitle => 'کورتەی ئیمێڵی رۆژانە';

  @override
  String get doNotDisturb => 'بێدەنگکردن';

  @override
  String get doNotDisturbSubtitle => 'بێدەنگکردنی ئاگادارکردنەوەکان';

  @override
  String get darkModeSubtitle => 'گۆڕین بۆ دۆخی تاریک';

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
  String get buildLabel => 'بنیاتنان: 2026.03';

  @override
  String get productLabel => 'بەرهەم';

  @override
  String get logisticsSystemName => 'سیستەمی بەڕێوەبردنی\nگواستنەوە و لۆجستیک';

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
  String get adminRole => 'بەڕێوەبەر';

  @override
  String get splashTagline => 'کاڵا بە دڵنیاییەوە بۆ کوردستان هاوردە بکە.';

  @override
  String get splashSubtitle => 'ڕێگای زیرەکتر بۆ بەڕێوەبردنی هاوردەکردن';

  @override
  String get getStarted => 'دەستپێبکە ←';

  @override
  String get signInToAccount => 'چوونەژوورەوە بۆ هەژمارەکەم';

  @override
  String get chooseTransport => 'هۆکاری گواستنەوە هەڵبژێرە';

  @override
  String get groundTransport => 'گواستنەوەی وشکانی';

  @override
  String get airTransport => 'گواستنەوەی ئاسمانی';

  @override
  String get seaTransport => 'گواستنەوەی دەریایی';

  @override
  String get continueBtn => 'بەردەوامبوون ←';

  @override
  String get backBtn => '→ گەڕانەوە';

  @override
  String get whereIsItGoing => 'بۆ کام شار لە کوردستان دەچێت؟';

  @override
  String get enterOriginDestination =>
      'شوێنی دابینکەر/سەرچاوە و شاری گەیاندن لە کوردستان بنووسە.';

  @override
  String get whatAreSending => 'چی هاوردە دەکەیت؟';

  @override
  String get weightKg => 'کێش (کیلۆگرام)';

  @override
  String get dimensionsCm => 'ئەندازەکان (سانتیمەتر)';

  @override
  String get estimatedTotal => 'کۆی خەمڵێنراو';

  @override
  String estimatedDeliveryDays(int days) {
    return 'گەیاندنی خەمڵێنراو: $days ڕۆژ';
  }

  @override
  String get shipmentSummary => 'پوختەی هاوردە';

  @override
  String get confirmShipment => 'دڵنیاکردنەوەی داواکاری هاوردە';

  @override
  String get shipmentCreated => 'داواکاری هاوردەکە بە سەرکەوتوویی دروستکرا!';

  @override
  String get vehicleStep => 'هۆکاری گواستنەوە';

  @override
  String get routeStep => 'ڕێڕەوی هاوردە';

  @override
  String get detailsStep => 'وردەکاری';

  @override
  String get reviewStep => 'پێداچوونەوە';

  @override
  String get categoryGeneral => 'گشتی';

  @override
  String get categoryFragile => 'ناسک';

  @override
  String get categoryElectronics => 'ئەلیکترۆنی';

  @override
  String get transportTruck => 'بارەهەڵگر';

  @override
  String get transportTruckMeta => '+٢ ڕۆژ · توانای بارکردنی بەرز';

  @override
  String get transportAirplane => 'فڕۆکە';

  @override
  String get transportAirplaneMeta => '-٢ ڕۆژ · گەیاندنی خێرا';

  @override
  String get transportShip => 'کەشتی';

  @override
  String get transportShipMeta => '+١٠ ڕۆژ · باری دەریایی';

  @override
  String get weightRow => 'کێش';

  @override
  String get dimensionsRow => 'ئەندازەکان';

  @override
  String get transportRow => 'هۆکاری گواستنەوە';

  @override
  String get validWeightError => 'تکایە کێشێکی دروست بنووسە.';

  @override
  String get validDimensionsError =>
      'تکایە ژمارەی دروست بۆ درێژی، پانی و بەرزی بنووسە.';

  @override
  String get signInToDeliveries =>
      'چوونەژوورەوە بۆ بەڕێوەبردنی گەیاندنی هاوردەکانت';

  @override
  String get loginFailed => 'چوونەژوورەوە سەرکەوتوو نەبوو';

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
  String get alreadyMember => 'پێشتر هەژمارت هەیە؟ ';

  @override
  String get termsAgree =>
      'بە دروستکردنی هەژمار، ڕازیت بە مەرجەکانی خزمەتگوزاری و سیاسەتی نهێنیمان.';

  @override
  String get fullNameLabel => 'ناوی تەواو';

  @override
  String get emailAddressLabel => 'ناونیشانی ئیمەیڵ';

  @override
  String get confirmPasswordLabel => 'دووبارەکردنەوەی وشەی نهێنی';

  @override
  String get passwordMinHint => 'لانیکەم ٨ پیت';

  @override
  String get repeatPasswordHint => 'وشەی نهێنی دووبارە بنووسە';

  @override
  String get createAccountTitle => 'دروستکردنی\nهەژمارەکەت.';

  @override
  String get createAccountSubtitle =>
      'هاوردەکردن زیرەکتر بکە — یەکەم داواکارییەکەت لە چەند خولەکدا بەدوادا بکە';

  @override
  String get signInToStaffPortal => 'چوونەژوورەوە بۆ پۆرتاڵی کارمەند';

  @override
  String get signOutDashboard => 'داشبۆرد';

  @override
  String get reportSubmitted => 'ڕاپۆرتەکە نێردرا ✓';

  @override
  String get shipmentLabel => 'هاوردەکە';

  @override
  String get describeProblem => 'کێشەکە وەسف بکە';

  @override
  String get teamWillReview =>
      'تیمەکەمان ڕاپۆرتەکەت پێداچوونەوە دەکات و لە ماوەی ٢٤–٤٨ کاتژمێردا وەڵامت دەداتەوە.';

  @override
  String get reportAnIssue => 'ڕاپۆرتکردنی کێشە';

  @override
  String get problemHint =>
      'بۆ نموونە: پاکێجەکە زیانی پێگەیشتووە — شاشەکە شکاوە…';

  @override
  String get originCity => '📍 شاری/وڵاتی دابینکەر';

  @override
  String get destinationCity => '🏁 شاری گەیاندن لە کوردستان';

  @override
  String get originHint => 'بۆ نموونە: ئیستانبوول، دوبەی، گوانگژۆ';

  @override
  String get destinationHint => 'بۆ نموونە: هەولێر، سلێمانی، دهۆک';

  @override
  String newUnread(int count) {
    return '$count نوێ';
  }

  @override
  String get accountSettings => 'هەژمار';

  @override
  String get accountSubtitle => 'زانیاری پرۆفایلەکەت نوێ بکەوە';

  @override
  String get appearanceSettings => 'ڕووکار';

  @override
  String get appearanceSubtitle => 'دۆخی تاریک و ڕێکخستنەکانی ڕووکار';

  @override
  String get notificationsSettings => 'ئاگادارکردنەوەکان';

  @override
  String get notificationsSubtitle => 'ڕێکخستنەکانی ئاگادارکردنەوەی پۆش';

  @override
  String get securitySettings => 'ئاسایش';

  @override
  String get securitySubtitle => 'وشەی نهێنی و ڕێکخستنەکانی ئاسایش';

  @override
  String get helpSupportSettings => 'یارمەتی و پشتگیری';

  @override
  String get helpSupportSubtitle => 'پرسیارە باوەکان و پەیوەندی بە پشتگیری';

  @override
  String get aboutSettings => 'دەربارە';

  @override
  String get aboutSubtitle => 'ڤێرژنی ئەپەکە 1.0.0';

  @override
  String get signOutSettings => 'چوونەدەرەوە';

  @override
  String get noShipmentsFound => 'هیچ هاوردەیەک نەدۆزرایەوە';

  @override
  String get errorLoadingShipments => 'هەڵە لە بارکردنی هاوردەکان';

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
  String get assignDriver => 'سپاردنی شۆفێر';

  @override
  String get pricingFormula =>
      'کۆی گشتی = (نرخی بنەڕەت + کێش × نرخ + زیادەی نرخ) × جارکەری هۆکاری گواستنەوە';

  @override
  String get reportOverview => 'کورتەی ڕاپۆرتەکان';

  @override
  String get catalogManagement => 'بەڕێوەبردنی کاتالۆگ';

  @override
  String get categoryCrudPlaceholder => 'ناوەڕۆکی بەڕێوەبردنی پۆلەکان';

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
  String get confirmShipmentButton => 'دڵنیاکردنەوەی داواکاری هاوردە';

  @override
  String get shipmentCreatedSuccess =>
      'داواکاری هاوردەکە بە سەرکەوتوویی دروستکرا!';

  @override
  String shipmentCreatedError(String error) {
    return 'هەڵە: $error';
  }

  @override
  String get newShipmentButton => '+ هاوردەی نوێ';

  @override
  String get helpFaq => 'یارمەتی و پرسیارە باوەکان';

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
    return '$destination ← $origin';
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
  String get ltmsDriver => 'شۆفێری LTMS';

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
  String get notificationSentSuccess => 'ئاگادارکردنەوە بە سەرکەوتوویی نێردرا';

  @override
  String get notificationHint => 'بۆ نموونە: کۆگای هەولێر، دەرگای ٣';

  @override
  String get sendNotification => 'ناردنی ئاگادارکردنەوە';

  @override
  String get staffSidebar => 'کارمەندی LTMS';

  @override
  String get originOutsideKurdistanRequired =>
      'شوێنی سەرچاوە دەبێت لە دەرەوەی کوردستان بێت بۆ داواکاری هاوردە.';

  @override
  String get destinationKurdistanRequired =>
      'شوێنی گەیاندن دەبێت شارێک لە کوردستان بێت.';

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
  String get alertsSubtitle => 'ئاگادارکردنەوە بۆ ئەسپاردە نوێیەکان وەربگرە';

  @override
  String get accountSubtitleUpdate => 'ناو و زانیارییەکانت نوێ بکەوە';

  @override
  String get passwordSubtitleUpdate => 'وشەی نهێنیت نوێ بکەوە';

  @override
  String get faqSubtitle => 'پرسیارە باوەکان و پەیوەندی';

  @override
  String get feedbackSubtitle => 'پێداچونەوەکانت بنێرە';

  @override
  String get versionInfo => 'ڤێرژن 1.0.0 · شۆفێری LTMS';

  @override
  String get versionLabel => 'ڤێرژن: 1.0.0';

  @override
  String get logisticsSystemFull => 'سیستەمی بەڕێوەبردنی گواستنەوە و لۆجستیک';

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
  String get acceptStartTransit => 'وەرگرتن و دەستپێکردنی گواستنەوە';

  @override
  String get markAsDelivered => 'وەک گەیەندراو دیاری بکە';

  @override
  String get noNotificationsFound => 'هیچ ئاگادارکردنەوەیەک نەدۆزرایەوە';

  @override
  String get noNotifications => 'هیچ ئاگادارکردنەوەیەک نییە';

  @override
  String get ltmsTitle => 'LTMS';

  @override
  String get stillNeedHelp => 'هێشتا پێویستت بە یارمەتییە؟';

  @override
  String get contactSupportLine => 'ڕاستەوخۆ پەیوەندی بە تیمی پشتگیریمان بکە';

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
  String get languageSubtitle => 'گۆڕینی زمانی ئەپ';

  @override
  String get accountDisabled =>
      'هەژمارەکەت ناچالاککراوە. تکایە پەیوەندی بە پشتگیری بکە.';
}
