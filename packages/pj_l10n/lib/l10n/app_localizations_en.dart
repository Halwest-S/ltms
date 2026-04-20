// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LTMS';

  @override
  String get appSubtitle => 'Logistics & Transportation Management';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get shipments => 'Shipments';

  @override
  String get myShipments => 'My Shipments';

  @override
  String get assignedShipments => 'Assigned Shipments';

  @override
  String get reports => 'Reports';

  @override
  String get notifications => 'Notifications';

  @override
  String shipmentsCount(int count) {
    return '$count shipments';
  }

  @override
  String shipmentCount(int count) {
    return '$count shipment';
  }

  @override
  String get users => 'Users';

  @override
  String get categories => 'Categories';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get vehicleTypes => 'Vehicle Types';

  @override
  String get vehicleCrudPlaceholder => 'Vehicle CRUD UI';

  @override
  String get sent => 'Sent';

  @override
  String get sentTab => 'Sent';

  @override
  String get customersTab => 'Customers';

  @override
  String get logisticsPortal => 'Logistics Management Portal';

  @override
  String get sendUpdatesSubtitle => 'Send updates to customers';

  @override
  String get signOutConfirmStaff =>
      'Are you sure you want to sign out of the staff portal?';

  @override
  String get manageAccount => 'Manage your account and preferences';

  @override
  String get usernameLabel => 'Username';

  @override
  String get appSettings => 'App Settings';

  @override
  String get support => 'SUPPORT';

  @override
  String get deliverBtn => 'Deliver ✓';

  @override
  String get acceptBtn => 'Accept →';

  @override
  String get goodMorning => 'Good morning,';

  @override
  String get goodAfternoon => 'Good afternoon,';

  @override
  String get goodEvening => 'Good evening,';

  @override
  String get viewHistory => 'View History';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get currentPasswordLabel => 'CURRENT PASSWORD';

  @override
  String get newPasswordLabel => 'NEW PASSWORD';

  @override
  String get confirmNewPasswordLabel => 'CONFIRM NEW PASSWORD';

  @override
  String get priceBreakdownTitle => 'PRICE BREAKDOWN';

  @override
  String get baseWeightSurcharge => 'Base + Weight + Surcharge';

  @override
  String get vehicleMultiplier => 'Vehicle Multiplier';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get markDelivered => 'Mark Delivered';

  @override
  String get liveTracking => 'LIVE TRACKING';

  @override
  String get route => 'ROUTE';

  @override
  String get orderPlaced => 'Order Placed';

  @override
  String get inTransit => 'In Transit';

  @override
  String get delivered => 'Delivered';

  @override
  String get nowLabel => 'Now';

  @override
  String get help => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get newShipment => 'New Shipment';

  @override
  String get createShipment => 'Create Shipment';

  @override
  String get origin => 'Origin';

  @override
  String get destination => 'Destination';

  @override
  String get weight => 'Weight (kg)';

  @override
  String get category => 'Category';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get estimatedDelivery => 'Estimated Delivery';

  @override
  String get days => 'days';

  @override
  String get shipmentDetails => 'Shipment Details';

  @override
  String get shipmentStatus => 'Status';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String get trackShipment => 'Track Shipment';

  @override
  String get pending => 'Pending';

  @override
  String get reported => 'Reported';

  @override
  String get all => 'All';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search shipments...';

  @override
  String get filter => 'Filter';

  @override
  String get refresh => 'Refresh';

  @override
  String get submit => 'Submit';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get reportProblem => 'Report a Problem';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get reportDetails => 'Report Details';

  @override
  String get yourComment => 'Your Comment';

  @override
  String get staffResponse => 'Staff Response';

  @override
  String get reportStatus => 'Report Status';

  @override
  String get open => 'Open';

  @override
  String get resolved => 'Resolved';

  @override
  String get rejected => 'Rejected';

  @override
  String get compensationIssued => 'Compensation Issued';

  @override
  String get userManagement => 'User Management';

  @override
  String get addUser => 'Add User';

  @override
  String get editUser => 'Edit User';

  @override
  String get userRole => 'Role';

  @override
  String get customer => 'Customer';

  @override
  String get driver => 'Driver';

  @override
  String get staff => 'Staff';

  @override
  String get superAdmin => 'Super Admin';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get toggleStatus => 'Toggle Status';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get nameEn => 'Name (English)';

  @override
  String get nameKu => 'Name (Kurdish)';

  @override
  String get surcharge => 'Surcharge';

  @override
  String get multiplier => 'Multiplier';

  @override
  String get deliveryDaysOffset => 'Delivery Days Offset';

  @override
  String get vehicleManagement => 'Vehicle Management';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get pricingConfiguration => 'Pricing Configuration';

  @override
  String get basePrice => 'Base Price';

  @override
  String get weightRate => 'Weight Rate';

  @override
  String get updatePricing => 'Update Pricing';

  @override
  String get previewPrice => 'Preview Price';

  @override
  String get calculatePrice => 'Calculate Price';

  @override
  String get faqManagement => 'FAQ Management';

  @override
  String get addFaq => 'Add FAQ';

  @override
  String get editFaq => 'Edit FAQ';

  @override
  String get question => 'Question';

  @override
  String get answer => 'Answer';

  @override
  String get sortOrder => 'Sort Order';

  @override
  String get account => 'Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get kurdish => 'کوردی';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change Password';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get retry => 'Retry';

  @override
  String get confirmAction => 'Are you sure?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get required => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get total => 'Total';

  @override
  String get pendingCount => 'Pending';

  @override
  String get inTransitCount => 'In Transit';

  @override
  String get deliveredCount => 'Delivered';

  @override
  String get reportedCount => 'Reported';

  @override
  String get newShipmentBtn => '+ New Shipment';

  @override
  String get noShipmentsYet => 'No shipments yet';

  @override
  String get createFirstShipment => 'Create your first shipment above';

  @override
  String get recentShipments => 'RECENT SHIPMENTS';

  @override
  String get helpAndFaq => 'Help & FAQ';

  @override
  String get findAnswers => 'Find answers to common questions';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get signOut => 'Sign Out';

  @override
  String get darkModeToggle => 'Dark Mode';

  @override
  String get switchToDark => 'Switch to dark theme';

  @override
  String get receiveAlerts => 'Receive alerts for your shipments';

  @override
  String get helpFaqLink => 'Help & FAQ';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get updatesFromShipments => 'Updates from your shipments';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get allCaughtUp => 'You\'re all caught up!';

  @override
  String get shipmentUpdate => 'Shipment Update';

  @override
  String get reportUpdate => 'Report Update';

  @override
  String get newAssignment => 'New Assignment';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get readLabel => 'Read';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get confirmDelivery => 'Confirm Delivery';

  @override
  String get confirmDeliveryQuestion =>
      'Has your shipment been delivered successfully?';

  @override
  String get deliveredSuccessfully => 'Shipment delivered successfully.';

  @override
  String get myAssignments => 'MY ASSIGNMENTS';

  @override
  String get noAssignments => 'No assignments';

  @override
  String get noDeliveriesYet => 'You have no deliveries assigned yet';

  @override
  String get overview => 'Overview';

  @override
  String get systemOverview => 'System-wide shipment overview';

  @override
  String get signInToManage => 'Sign in to manage your shipments';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createOne => 'Create one';

  @override
  String get incorrectCredentials => 'Incorrect email or password';

  @override
  String get assigned => 'Assigned';

  @override
  String get history => 'History';

  @override
  String get alerts => 'Alerts';

  @override
  String get orders => 'Orders';

  @override
  String get transit => 'Transit';

  @override
  String get tryDifferentFilter => 'Try selecting a different filter';

  @override
  String get failedToLoadShipments => 'Failed to load shipments';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get newBtn => 'New';

  @override
  String get noShipmentsFilter => 'No shipments';

  @override
  String get catalogLabel => 'Catalog';

  @override
  String get usersLabel => 'Users';

  @override
  String get vehiclesLabel => 'Vehicles';

  @override
  String get faqLabel => 'FAQ';

  @override
  String get pricingLabel => 'Pricing';

  @override
  String get reportsLabel => 'Reports';

  @override
  String get welcomeBackTitle => 'Welcome\nback.';

  @override
  String get shipmentMonitor => 'Shipment Monitor';

  @override
  String get monitorSubtitle => 'Monitor and manage all shipments';

  @override
  String get driverLabel => 'DRIVER';

  @override
  String get actionLabel => 'ACTION';

  @override
  String get assignBtn => 'Assign';

  @override
  String get assignDriverTitle => 'Assign Driver';

  @override
  String get driverUserIdHint => 'Driver User ID';

  @override
  String get staffDashboard => 'Staff Dashboard';

  @override
  String get shipmentList => 'Shipment List';

  @override
  String get incidentReports => 'Incident Reports';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get ltmsStaff => 'LTMS Staff';

  @override
  String get reportQueue => 'Report Queue';

  @override
  String get reportQueueSubtitle => 'Review and respond to customer reports';

  @override
  String get noReports => 'No reports';

  @override
  String get staffResponseLabel => 'Staff Response:';

  @override
  String get resolveBtn => '✓ Resolve';

  @override
  String get rejectBtn => '✕ Reject';

  @override
  String get noNotificationsSent => 'No notifications sent yet';

  @override
  String get tapSendToNotify => 'Tap Send to notify a customer';

  @override
  String get sentBadge => 'Sent';

  @override
  String get notifyBtn => 'Notify';

  @override
  String get failedToLoadCustomers => 'Failed to load customers';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get chooseGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get toCustomerLabel => 'TO (CUSTOMER)';

  @override
  String get selectCustomerHint => 'Select a customer...';

  @override
  String get messageEnLabel => 'MESSAGE (ENGLISH)';

  @override
  String get messageEnHint =>
      'e.g. Your shipment has arrived at Erbil hub and is ready for pickup.';

  @override
  String get messageKuLabel => 'MESSAGE (KURDISH)';

  @override
  String get messageKuHint => 'بارەکەت گەیشتە هەولێر و ئامادەی وەرگرتنە.';

  @override
  String get photoOptionalLabel => 'PHOTO (OPTIONAL)';

  @override
  String get tapToChange => 'Tap to change';

  @override
  String get tapToAddPhoto => 'Tap to add a photo';

  @override
  String get cameraOrGallery => 'Camera or gallery';

  @override
  String get updatePasswordSubtitle => 'Update your login password';

  @override
  String get supportHours => 'Available 9am - 5pm';

  @override
  String get accountSection => 'ACCOUNT';

  @override
  String get notificationsSection => 'NOTIFICATIONS';

  @override
  String get appearanceSection => 'APPEARANCE';

  @override
  String get supportSection => 'SUPPORT';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Update your name and info';

  @override
  String get pushNotificationsSubtitle => 'New reports and assignments';

  @override
  String get emailAlerts => 'Email Alerts';

  @override
  String get emailAlertsSubtitle => 'Daily summary emails';

  @override
  String get doNotDisturb => 'Do Not Disturb';

  @override
  String get doNotDisturbSubtitle => 'Mute notifications';

  @override
  String get darkModeSubtitle => 'Switch to dark theme';

  @override
  String get compactView => 'Compact View';

  @override
  String get compactViewSubtitle => 'Show more data per row';

  @override
  String get aboutLtms => 'About LTMS';

  @override
  String get signOutSubtitle => 'Log out of your staff account';

  @override
  String get nameLabel => 'NAME';

  @override
  String get fullNameHint => 'Your full name';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get closeBtn => 'Close';

  @override
  String get buildLabel => 'Build: 2026.03';

  @override
  String get productLabel => 'Product';

  @override
  String get logisticsSystemName => 'LTMS Logistics\nManagement System';

  @override
  String get id => 'ID';

  @override
  String get weightLabel => 'WEIGHT';

  @override
  String get priceLabel => 'PRICE';

  @override
  String get statusLabel => 'STATUS';

  @override
  String get changeAdminKey => 'Change Admin Key';

  @override
  String get keyExpiredMessage =>
      'Your admin key has expired. Please generate a new one to continue.';

  @override
  String get generateNewKey => 'Generate New Key';

  @override
  String get adminRole => 'Admin';

  @override
  String get splashTagline => 'Ship anything, anywhere.';

  @override
  String get splashSubtitle => 'The smarter way to manage your logistics';

  @override
  String get getStarted => 'Get Started →';

  @override
  String get signInToAccount => 'Sign In to my account';

  @override
  String get chooseTransport => 'Choose transport method';

  @override
  String get groundTransport => 'Ground Transport';

  @override
  String get airTransport => 'Air Transport';

  @override
  String get seaTransport => 'Sea Transport';

  @override
  String get continueBtn => 'Continue →';

  @override
  String get backBtn => '← Back';

  @override
  String get whereIsItGoing => 'Where is it going?';

  @override
  String get enterOriginDestination =>
      'Enter origin and destination for your shipment.';

  @override
  String get whatAreSending => 'What are you sending?';

  @override
  String get weightKg => 'WEIGHT (KG)';

  @override
  String get dimensionsCm => 'DIMENSIONS (CM)';

  @override
  String get estimatedTotal => 'ESTIMATED TOTAL';

  @override
  String estimatedDeliveryDays(int days) {
    return 'Estimated delivery: $days days';
  }

  @override
  String get shipmentSummary => 'SHIPMENT SUMMARY';

  @override
  String get confirmShipment => 'Confirm Shipment';

  @override
  String get shipmentCreated => 'Shipment created! 🎉';

  @override
  String get vehicleStep => 'Vehicle';

  @override
  String get routeStep => 'Route';

  @override
  String get detailsStep => 'Details';

  @override
  String get reviewStep => 'Review';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryFragile => 'Fragile';

  @override
  String get categoryElectronics => 'Electronics';

  @override
  String get transportTruck => 'Truck';

  @override
  String get transportTruckMeta => '+2 days · High capacity';

  @override
  String get transportAirplane => 'Airplane';

  @override
  String get transportAirplaneMeta => '-2 days · Express';

  @override
  String get transportShip => 'Ship';

  @override
  String get transportShipMeta => '+10 days · Sea freight';

  @override
  String get weightRow => 'Weight';

  @override
  String get dimensionsRow => 'Dimensions';

  @override
  String get transportRow => 'Transport';

  @override
  String get validWeightError => 'Please enter a valid weight.';

  @override
  String get validDimensionsError =>
      'Please enter valid numbers for L, W, and H.';

  @override
  String get signInToDeliveries => 'Sign in to manage your deliveries';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get enterEmail => 'Please enter an email';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get enterName => 'Please enter your name';

  @override
  String get passwordMin8 => 'Password must be at least 8 characters';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get alreadyMember => 'Already a member? ';

  @override
  String get termsAgree =>
      'By creating an account you agree to our Terms of Service and Privacy Policy.';

  @override
  String get fullNameLabel => 'FULL NAME';

  @override
  String get emailAddressLabel => 'EMAIL ADDRESS';

  @override
  String get confirmPasswordLabel => 'CONFIRM PASSWORD';

  @override
  String get passwordMinHint => 'Min. 8 characters';

  @override
  String get repeatPasswordHint => 'Repeat password';

  @override
  String get createAccountTitle => 'Create\nyour account.';

  @override
  String get createAccountSubtitle =>
      'Ship smarter — track your first order in minutes';

  @override
  String get signInToStaffPortal => 'Sign in to the staff portal';

  @override
  String get signOutDashboard => 'Dashboard';

  @override
  String get reportSubmitted => 'Report submitted ✓';

  @override
  String get shipmentLabel => 'SHIPMENT';

  @override
  String get describeProblem => 'DESCRIBE THE PROBLEM';

  @override
  String get teamWillReview =>
      'Our team will review your report and respond within 24–48 hours.';

  @override
  String get reportAnIssue => 'Report an Issue';

  @override
  String get problemHint => 'e.g. Package arrived damaged — screen is cracked…';

  @override
  String get originCity => '📍 ORIGIN CITY';

  @override
  String get destinationCity => '🏁 DESTINATION CITY';

  @override
  String get originHint => 'e.g. Erbil';

  @override
  String get destinationHint => 'e.g. Istanbul';

  @override
  String newUnread(int count) {
    return '$count new';
  }

  @override
  String get accountSettings => 'Account';

  @override
  String get accountSubtitle => 'Update your profile information';

  @override
  String get appearanceSettings => 'Appearance';

  @override
  String get appearanceSubtitle => 'Dark mode and theme settings';

  @override
  String get notificationsSettings => 'Notifications';

  @override
  String get notificationsSubtitle => 'Push notification preferences';

  @override
  String get securitySettings => 'Security';

  @override
  String get securitySubtitle => 'Password and security settings';

  @override
  String get helpSupportSettings => 'Help & Support';

  @override
  String get helpSupportSubtitle => 'FAQs and contact support';

  @override
  String get aboutSettings => 'About';

  @override
  String get aboutSubtitle => 'App version 1.0.0';

  @override
  String get signOutSettings => 'Sign Out';

  @override
  String get noShipmentsFound => 'No shipments found';

  @override
  String get errorLoadingShipments => 'Error loading shipments';

  @override
  String get errorLoading => 'Error loading';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get noDriversFound => 'No active drivers found';

  @override
  String get userCreated => 'User created successfully';

  @override
  String get createNewUser => 'Create New User';

  @override
  String get selectRole => 'Select Role';

  @override
  String generatedPassword(String password) {
    return 'Generated Password: $password';
  }

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get copyPassword => 'Copy Password';

  @override
  String get assignDriver => 'Assign Driver';

  @override
  String get pricingFormula =>
      'Total = (Base + Weight × Rate + Surcharge) × Vehicle Multiplier';

  @override
  String get reportOverview => 'Report Overview';

  @override
  String get catalogManagement => 'Catalog Management';

  @override
  String get categoryCrudPlaceholder => 'Category CRUD UI';

  @override
  String kgUnit(String value) {
    return '$value kg';
  }

  @override
  String priceFormat(String value) {
    return '\$$value';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get backButton => 'Back';

  @override
  String get confirmShipmentButton => 'Confirm Shipment';

  @override
  String get shipmentCreatedSuccess => 'Shipment created!';

  @override
  String shipmentCreatedError(String error) {
    return 'Error: $error';
  }

  @override
  String get newShipmentButton => '+ New Shipment';

  @override
  String get helpFaq => 'Help & FAQ';

  @override
  String get searchQuestions => 'Search questions…';

  @override
  String get resolve => 'Resolve';

  @override
  String get reject => 'Reject';

  @override
  String errorProcessing(String error) {
    return 'Error: $error';
  }

  @override
  String routeArrow(String origin, String destination) {
    return '$origin → $destination';
  }

  @override
  String get staffHint => 'staff@ltms.com';

  @override
  String get driverHint => 'driver@email.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get ltmsAdmin => 'LTMS Admin';

  @override
  String get ltmsCustomer => 'LTMS Customer';

  @override
  String get ltmsDriver => 'LTMS Driver';

  @override
  String get emailPlaceholder => 'email@example.com';

  @override
  String get passwordPlaceholder => '••••••';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get noCustomersFound => 'No customers found';

  @override
  String get notificationSentSuccess => 'Notification sent successfully!';

  @override
  String get notificationHint => 'e.g. Erbil Warehouse, Gate 3';

  @override
  String get sendNotification => 'Send Notification';

  @override
  String get staffSidebar => 'LTMS Staff';

  @override
  String get lengthLabel => 'Length';

  @override
  String get widthLabel => 'Width';

  @override
  String get heightLabel => 'Height';

  @override
  String get weightPlaceholder => '0.0';

  @override
  String get yourNameHint => 'Your name';

  @override
  String get yourFullNameHint => 'Your full name';

  @override
  String get passwordUpdateHint => 'Update your password';

  @override
  String get alertsSubtitle => 'Get alerts for new assignments';

  @override
  String get accountSubtitleUpdate => 'Update your name & info';

  @override
  String get passwordSubtitleUpdate => 'Update your password';

  @override
  String get faqSubtitle => 'FAQs and contact us';

  @override
  String get feedbackSubtitle => 'Share your feedback';

  @override
  String get versionInfo => 'Version 1.0.0 · LTMS Driver';

  @override
  String get versionLabel => 'Version: 1.0.0';

  @override
  String get logisticsSystemFull => 'Logistics & Transport Management System';

  @override
  String shipmentIdPrefix(String id) {
    return '#$id';
  }

  @override
  String statusUpdated(String status) {
    return 'Status updated to $status';
  }

  @override
  String statusUpdateError(String error) {
    return 'Error: $error';
  }

  @override
  String get acceptStartTransit => 'Accept & Start Transit';

  @override
  String get markAsDelivered => 'Mark as Delivered';

  @override
  String get noNotificationsFound => 'No notifications found';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get ltmsTitle => 'LTMS';

  @override
  String get stillNeedHelp => 'Still need help?';

  @override
  String get contactSupportLine => 'Contact our support team directly';

  @override
  String get settings => 'Settings';

  @override
  String get updateBtn => 'Update';

  @override
  String get statusUpdate => 'Status Update';

  @override
  String get assignment => 'Assignment';

  @override
  String get sendBtn => 'Send';

  @override
  String get selectCustomer => 'Select Customer';

  @override
  String get selectCustomerError => 'Please select a customer';

  @override
  String get messageEnRequired => 'English message is required';

  @override
  String get messageKuRequired => 'Kurdish message is required';

  @override
  String get failedToSend => 'Failed to send';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'For example: Erbil warehouse';

  @override
  String get reportLabel => 'Report';

  @override
  String get customerLabel => 'Customer';

  @override
  String get minPasswordHint => 'Min. 8 characters';

  @override
  String get faqCrudPlaceholder => 'FAQ management content';

  @override
  String get languageSubtitle => 'Change the application language';

  @override
  String get accountDisabled =>
      'Your account is disabled. Please contact support.';
}
