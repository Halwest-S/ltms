import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ku.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
    Locale('ku'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LTMS'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kurdistan Import Logistics Management'**
  String get appSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @shipments.
  ///
  /// In en, this message translates to:
  /// **'Imports'**
  String get shipments;

  /// No description provided for @myShipments.
  ///
  /// In en, this message translates to:
  /// **'My Imports'**
  String get myShipments;

  /// No description provided for @assignedShipments.
  ///
  /// In en, this message translates to:
  /// **'Assigned Imports'**
  String get assignedShipments;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @shipmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} imports'**
  String shipmentsCount(int count);

  /// No description provided for @shipmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} import'**
  String shipmentCount(int count);

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @vehicleTypes.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Types'**
  String get vehicleTypes;

  /// No description provided for @vehicleCrudPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Vehicle CRUD UI'**
  String get vehicleCrudPlaceholder;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @sentTab.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sentTab;

  /// No description provided for @customersTab.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTab;

  /// No description provided for @logisticsPortal.
  ///
  /// In en, this message translates to:
  /// **'Logistics Management Portal'**
  String get logisticsPortal;

  /// No description provided for @sendUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send updates to customers'**
  String get sendUpdatesSubtitle;

  /// No description provided for @signOutConfirmStaff.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of the staff portal?'**
  String get signOutConfirmStaff;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account and preferences'**
  String get manageAccount;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// No description provided for @deliverBtn.
  ///
  /// In en, this message translates to:
  /// **'Deliver ✓'**
  String get deliverBtn;

  /// No description provided for @acceptBtn.
  ///
  /// In en, this message translates to:
  /// **'Accept →'**
  String get acceptBtn;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT PASSWORD'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM NEW PASSWORD'**
  String get confirmNewPasswordLabel;

  /// No description provided for @priceBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'PRICE BREAKDOWN'**
  String get priceBreakdownTitle;

  /// No description provided for @baseWeightSurcharge.
  ///
  /// In en, this message translates to:
  /// **'Base + Weight + Surcharge'**
  String get baseWeightSurcharge;

  /// No description provided for @vehicleMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Multiplier'**
  String get vehicleMultiplier;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @markDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get markDelivered;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'LIVE TRACKING'**
  String get liveTracking;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'IMPORT ROUTE'**
  String get route;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// No description provided for @inTransit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get inTransit;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @nowLabel.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowLabel;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @newShipment.
  ///
  /// In en, this message translates to:
  /// **'New Import'**
  String get newShipment;

  /// No description provided for @createShipment.
  ///
  /// In en, this message translates to:
  /// **'Create Import Request'**
  String get createShipment;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Kurdistan Delivery'**
  String get destination;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @shipmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Import Details'**
  String get shipmentDetails;

  /// No description provided for @shipmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Import Status'**
  String get shipmentStatus;

  /// No description provided for @priceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdown;

  /// No description provided for @trackShipment.
  ///
  /// In en, this message translates to:
  /// **'Track Import'**
  String get trackShipment;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @reported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get reported;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search imports...'**
  String get searchPlaceholder;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report Details'**
  String get reportDetails;

  /// No description provided for @yourComment.
  ///
  /// In en, this message translates to:
  /// **'Your Comment'**
  String get yourComment;

  /// No description provided for @staffResponse.
  ///
  /// In en, this message translates to:
  /// **'Staff Response'**
  String get staffResponse;

  /// No description provided for @reportStatus.
  ///
  /// In en, this message translates to:
  /// **'Report Status'**
  String get reportStatus;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @compensationIssued.
  ///
  /// In en, this message translates to:
  /// **'Compensation Issued'**
  String get compensationIssued;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userRole;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @superAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get superAdmin;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @toggleStatus.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get toggleStatus;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @nameEn.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEn;

  /// No description provided for @nameKu.
  ///
  /// In en, this message translates to:
  /// **'Name (Kurdish)'**
  String get nameKu;

  /// No description provided for @surcharge.
  ///
  /// In en, this message translates to:
  /// **'Surcharge'**
  String get surcharge;

  /// No description provided for @multiplier.
  ///
  /// In en, this message translates to:
  /// **'Multiplier'**
  String get multiplier;

  /// No description provided for @deliveryDaysOffset.
  ///
  /// In en, this message translates to:
  /// **'Delivery Days Offset'**
  String get deliveryDaysOffset;

  /// No description provided for @vehicleManagement.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Management'**
  String get vehicleManagement;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// No description provided for @pricingConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Pricing Configuration'**
  String get pricingConfiguration;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @weightRate.
  ///
  /// In en, this message translates to:
  /// **'Weight Rate'**
  String get weightRate;

  /// No description provided for @updatePricing.
  ///
  /// In en, this message translates to:
  /// **'Update Pricing'**
  String get updatePricing;

  /// No description provided for @previewPrice.
  ///
  /// In en, this message translates to:
  /// **'Preview Price'**
  String get previewPrice;

  /// No description provided for @calculatePrice.
  ///
  /// In en, this message translates to:
  /// **'Calculate Price'**
  String get calculatePrice;

  /// No description provided for @faqManagement.
  ///
  /// In en, this message translates to:
  /// **'FAQ Management'**
  String get faqManagement;

  /// No description provided for @addFaq.
  ///
  /// In en, this message translates to:
  /// **'Add FAQ'**
  String get addFaq;

  /// No description provided for @editFaq.
  ///
  /// In en, this message translates to:
  /// **'Edit FAQ'**
  String get editFaq;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrder;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kurdish.
  ///
  /// In en, this message translates to:
  /// **'کوردی'**
  String get kurdish;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmAction;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingCount;

  /// No description provided for @inTransitCount.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get inTransitCount;

  /// No description provided for @deliveredCount.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredCount;

  /// No description provided for @reportedCount.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get reportedCount;

  /// No description provided for @newShipmentBtn.
  ///
  /// In en, this message translates to:
  /// **'+ New Import'**
  String get newShipmentBtn;

  /// No description provided for @noShipmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No import requests yet'**
  String get noShipmentsYet;

  /// No description provided for @createFirstShipment.
  ///
  /// In en, this message translates to:
  /// **'Create your first import request above'**
  String get createFirstShipment;

  /// No description provided for @recentShipments.
  ///
  /// In en, this message translates to:
  /// **'RECENT IMPORTS'**
  String get recentShipments;

  /// No description provided for @helpAndFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndFaq;

  /// No description provided for @findAnswers.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions'**
  String get findAnswers;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @darkModeToggle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeToggle;

  /// No description provided for @switchToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get switchToDark;

  /// No description provided for @receiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts for your imports'**
  String get receiveAlerts;

  /// No description provided for @helpFaqLink.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaqLink;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @updatesFromShipments.
  ///
  /// In en, this message translates to:
  /// **'Updates from your imports'**
  String get updatesFromShipments;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get allCaughtUp;

  /// No description provided for @shipmentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Import Update'**
  String get shipmentUpdate;

  /// No description provided for @reportUpdate.
  ///
  /// In en, this message translates to:
  /// **'Report Update'**
  String get reportUpdate;

  /// No description provided for @newAssignment.
  ///
  /// In en, this message translates to:
  /// **'New Assignment'**
  String get newAssignment;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @readLabel.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readLabel;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @confirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDelivery;

  /// No description provided for @confirmDeliveryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have your imported goods been delivered successfully?'**
  String get confirmDeliveryQuestion;

  /// No description provided for @deliveredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Imported goods delivered successfully.'**
  String get deliveredSuccessfully;

  /// No description provided for @myAssignments.
  ///
  /// In en, this message translates to:
  /// **'MY ASSIGNMENTS'**
  String get myAssignments;

  /// No description provided for @noAssignments.
  ///
  /// In en, this message translates to:
  /// **'No assignments'**
  String get noAssignments;

  /// No description provided for @noDeliveriesYet.
  ///
  /// In en, this message translates to:
  /// **'You have no deliveries assigned yet'**
  String get noDeliveriesYet;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @systemOverview.
  ///
  /// In en, this message translates to:
  /// **'System-wide import overview'**
  String get systemOverview;

  /// No description provided for @signInToManage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage imports'**
  String get signInToManage;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get incorrectCredentials;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @transit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get transit;

  /// No description provided for @tryDifferentFilter.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different filter'**
  String get tryDifferentFilter;

  /// No description provided for @failedToLoadShipments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load imports'**
  String get failedToLoadShipments;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @newBtn.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBtn;

  /// No description provided for @noShipmentsFilter.
  ///
  /// In en, this message translates to:
  /// **'No imports'**
  String get noShipmentsFilter;

  /// No description provided for @catalogLabel.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalogLabel;

  /// No description provided for @usersLabel.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersLabel;

  /// No description provided for @vehiclesLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesLabel;

  /// No description provided for @faqLabel.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqLabel;

  /// No description provided for @pricingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricingLabel;

  /// No description provided for @reportsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsLabel;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nback.'**
  String get welcomeBackTitle;

  /// No description provided for @shipmentMonitor.
  ///
  /// In en, this message translates to:
  /// **'Import Monitor'**
  String get shipmentMonitor;

  /// No description provided for @monitorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor goods imported to Kurdistan'**
  String get monitorSubtitle;

  /// No description provided for @driverLabel.
  ///
  /// In en, this message translates to:
  /// **'DRIVER'**
  String get driverLabel;

  /// No description provided for @actionLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTION'**
  String get actionLabel;

  /// No description provided for @assignBtn.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assignBtn;

  /// No description provided for @assignDriverTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Driver'**
  String get assignDriverTitle;

  /// No description provided for @driverUserIdHint.
  ///
  /// In en, this message translates to:
  /// **'Driver User ID'**
  String get driverUserIdHint;

  /// No description provided for @staffDashboard.
  ///
  /// In en, this message translates to:
  /// **'Staff Dashboard'**
  String get staffDashboard;

  /// No description provided for @shipmentList.
  ///
  /// In en, this message translates to:
  /// **'Import List'**
  String get shipmentList;

  /// No description provided for @incidentReports.
  ///
  /// In en, this message translates to:
  /// **'Incident Reports'**
  String get incidentReports;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// No description provided for @ltmsStaff.
  ///
  /// In en, this message translates to:
  /// **'LTMS Staff'**
  String get ltmsStaff;

  /// No description provided for @reportQueue.
  ///
  /// In en, this message translates to:
  /// **'Report Queue'**
  String get reportQueue;

  /// No description provided for @reportQueueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and respond to customer reports'**
  String get reportQueueSubtitle;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get noReports;

  /// No description provided for @staffResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff Response:'**
  String get staffResponseLabel;

  /// No description provided for @resolveBtn.
  ///
  /// In en, this message translates to:
  /// **'✓ Resolve'**
  String get resolveBtn;

  /// No description provided for @rejectBtn.
  ///
  /// In en, this message translates to:
  /// **'✕ Reject'**
  String get rejectBtn;

  /// No description provided for @noNotificationsSent.
  ///
  /// In en, this message translates to:
  /// **'No notifications sent yet'**
  String get noNotificationsSent;

  /// No description provided for @tapSendToNotify.
  ///
  /// In en, this message translates to:
  /// **'Tap Send to notify a customer'**
  String get tapSendToNotify;

  /// No description provided for @sentBadge.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sentBadge;

  /// No description provided for @notifyBtn.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notifyBtn;

  /// No description provided for @failedToLoadCustomers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load customers'**
  String get failedToLoadCustomers;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @toCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'TO (CUSTOMER)'**
  String get toCustomerLabel;

  /// No description provided for @selectCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Select a customer...'**
  String get selectCustomerHint;

  /// No description provided for @messageEnLabel.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE (ENGLISH)'**
  String get messageEnLabel;

  /// No description provided for @messageEnHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Your imported goods have arrived at Erbil hub and are ready for pickup.'**
  String get messageEnHint;

  /// No description provided for @messageKuLabel.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE (KURDISH)'**
  String get messageKuLabel;

  /// No description provided for @messageKuHint.
  ///
  /// In en, this message translates to:
  /// **'بارەکەت گەیشتە هەولێر و ئامادەی وەرگرتنە.'**
  String get messageKuHint;

  /// No description provided for @photoOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'PHOTO (OPTIONAL)'**
  String get photoOptionalLabel;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a photo'**
  String get tapToAddPhoto;

  /// No description provided for @cameraOrGallery.
  ///
  /// In en, this message translates to:
  /// **'Camera or gallery'**
  String get cameraOrGallery;

  /// No description provided for @updatePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your login password'**
  String get updatePasswordSubtitle;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Available 9am - 5pm'**
  String get supportHours;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notificationsSection;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearanceSection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportSection;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your name and info'**
  String get editProfileSubtitle;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New reports and assignments'**
  String get pushNotificationsSubtitle;

  /// No description provided for @emailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Email Alerts'**
  String get emailAlerts;

  /// No description provided for @emailAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily summary emails'**
  String get emailAlertsSubtitle;

  /// No description provided for @doNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get doNotDisturb;

  /// No description provided for @doNotDisturbSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get doNotDisturbSubtitle;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @compactView.
  ///
  /// In en, this message translates to:
  /// **'Compact View'**
  String get compactView;

  /// No description provided for @compactViewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show more data per row'**
  String get compactViewSubtitle;

  /// No description provided for @aboutLtms.
  ///
  /// In en, this message translates to:
  /// **'About LTMS'**
  String get aboutLtms;

  /// No description provided for @signOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of your staff account'**
  String get signOutSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get nameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get fullNameHint;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @closeBtn.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeBtn;

  /// No description provided for @buildLabel.
  ///
  /// In en, this message translates to:
  /// **'Build: 2026.03'**
  String get buildLabel;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @logisticsSystemName.
  ///
  /// In en, this message translates to:
  /// **'LTMS Logistics\nManagement System'**
  String get logisticsSystemName;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'WEIGHT'**
  String get weightLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'PRICE'**
  String get priceLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusLabel;

  /// No description provided for @changeAdminKey.
  ///
  /// In en, this message translates to:
  /// **'Change Admin Key'**
  String get changeAdminKey;

  /// No description provided for @keyExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your admin key has expired. Please generate a new one to continue.'**
  String get keyExpiredMessage;

  /// No description provided for @generateNewKey.
  ///
  /// In en, this message translates to:
  /// **'Generate New Key'**
  String get generateNewKey;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Import goods to Kurdistan with confidence.'**
  String get splashTagline;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The smarter way to manage import logistics'**
  String get splashSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started →'**
  String get getStarted;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign In to my account'**
  String get signInToAccount;

  /// No description provided for @chooseTransport.
  ///
  /// In en, this message translates to:
  /// **'Choose transport method'**
  String get chooseTransport;

  /// No description provided for @groundTransport.
  ///
  /// In en, this message translates to:
  /// **'Ground Transport'**
  String get groundTransport;

  /// No description provided for @airTransport.
  ///
  /// In en, this message translates to:
  /// **'Air Transport'**
  String get airTransport;

  /// No description provided for @seaTransport.
  ///
  /// In en, this message translates to:
  /// **'Sea Transport'**
  String get seaTransport;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get continueBtn;

  /// No description provided for @backBtn.
  ///
  /// In en, this message translates to:
  /// **'← Back'**
  String get backBtn;

  /// No description provided for @whereIsItGoing.
  ///
  /// In en, this message translates to:
  /// **'Where in Kurdistan is it going?'**
  String get whereIsItGoing;

  /// No description provided for @enterOriginDestination.
  ///
  /// In en, this message translates to:
  /// **'Enter the supplier/source location and the Kurdistan delivery city.'**
  String get enterOriginDestination;

  /// No description provided for @whatAreSending.
  ///
  /// In en, this message translates to:
  /// **'What goods are you importing?'**
  String get whatAreSending;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'WEIGHT (KG)'**
  String get weightKg;

  /// No description provided for @dimensionsCm.
  ///
  /// In en, this message translates to:
  /// **'DIMENSIONS (CM)'**
  String get dimensionsCm;

  /// No description provided for @estimatedTotal.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED TOTAL'**
  String get estimatedTotal;

  /// No description provided for @estimatedDeliveryDays.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery: {days} days'**
  String estimatedDeliveryDays(int days);

  /// No description provided for @shipmentSummary.
  ///
  /// In en, this message translates to:
  /// **'IMPORT SUMMARY'**
  String get shipmentSummary;

  /// No description provided for @confirmShipment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Import Request'**
  String get confirmShipment;

  /// No description provided for @shipmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Import request created! 🎉'**
  String get shipmentCreated;

  /// No description provided for @vehicleStep.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleStep;

  /// No description provided for @routeStep.
  ///
  /// In en, this message translates to:
  /// **'Import Route'**
  String get routeStep;

  /// No description provided for @detailsStep.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsStep;

  /// No description provided for @reviewStep.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewStep;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @categoryFragile.
  ///
  /// In en, this message translates to:
  /// **'Fragile'**
  String get categoryFragile;

  /// No description provided for @categoryElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get categoryElectronics;

  /// No description provided for @transportTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get transportTruck;

  /// No description provided for @transportTruckMeta.
  ///
  /// In en, this message translates to:
  /// **'+2 days · High capacity'**
  String get transportTruckMeta;

  /// No description provided for @transportAirplane.
  ///
  /// In en, this message translates to:
  /// **'Airplane'**
  String get transportAirplane;

  /// No description provided for @transportAirplaneMeta.
  ///
  /// In en, this message translates to:
  /// **'-2 days · Express'**
  String get transportAirplaneMeta;

  /// No description provided for @transportShip.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get transportShip;

  /// No description provided for @transportShipMeta.
  ///
  /// In en, this message translates to:
  /// **'+10 days · Sea freight'**
  String get transportShipMeta;

  /// No description provided for @weightRow.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightRow;

  /// No description provided for @dimensionsRow.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensionsRow;

  /// No description provided for @transportRow.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transportRow;

  /// No description provided for @validWeightError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight.'**
  String get validWeightError;

  /// No description provided for @validDimensionsError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers for L, W, and H.'**
  String get validDimensionsError;

  /// No description provided for @signInToDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage import deliveries'**
  String get signInToDeliveries;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already a member? '**
  String get alreadyMember;

  /// No description provided for @termsAgree.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you agree to our Terms of Service and Privacy Policy.'**
  String get termsAgree;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullNameLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddressLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordMinHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get passwordMinHint;

  /// No description provided for @repeatPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPasswordHint;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create\nyour account.'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import smarter - track your first order in minutes'**
  String get createAccountSubtitle;

  /// No description provided for @signInToStaffPortal.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the staff portal'**
  String get signInToStaffPortal;

  /// No description provided for @signOutDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get signOutDashboard;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted ✓'**
  String get reportSubmitted;

  /// No description provided for @shipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'IMPORT'**
  String get shipmentLabel;

  /// No description provided for @describeProblem.
  ///
  /// In en, this message translates to:
  /// **'DESCRIBE THE PROBLEM'**
  String get describeProblem;

  /// No description provided for @teamWillReview.
  ///
  /// In en, this message translates to:
  /// **'Our team will review your report and respond within 24-48 hours.'**
  String get teamWillReview;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportAnIssue;

  /// No description provided for @problemHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Package arrived damaged — screen is cracked…'**
  String get problemHint;

  /// No description provided for @originCity.
  ///
  /// In en, this message translates to:
  /// **'📍 SOURCE CITY / COUNTRY'**
  String get originCity;

  /// No description provided for @destinationCity.
  ///
  /// In en, this message translates to:
  /// **'🏁 KURDISTAN DELIVERY CITY'**
  String get destinationCity;

  /// No description provided for @originHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Istanbul, Dubai, Guangzhou'**
  String get originHint;

  /// No description provided for @destinationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Erbil, Sulaimani, Duhok'**
  String get destinationHint;

  /// No description provided for @newUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String newUnread(int count);

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your profile information'**
  String get accountSubtitle;

  /// No description provided for @appearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSettings;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode and theme settings'**
  String get appearanceSubtitle;

  /// No description provided for @notificationsSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSettings;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification preferences'**
  String get notificationsSubtitle;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySettings;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password and security settings'**
  String get securitySubtitle;

  /// No description provided for @helpSupportSettings.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportSettings;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and contact support'**
  String get helpSupportSubtitle;

  /// No description provided for @aboutSettings.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSettings;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App version 1.0.0'**
  String get aboutSubtitle;

  /// No description provided for @signOutSettings.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutSettings;

  /// No description provided for @noShipmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No imports found'**
  String get noShipmentsFound;

  /// No description provided for @errorLoadingShipments.
  ///
  /// In en, this message translates to:
  /// **'Error loading imports'**
  String get errorLoadingShipments;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get errorLoading;

  /// No description provided for @errorLoadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// No description provided for @noDriversFound.
  ///
  /// In en, this message translates to:
  /// **'No active drivers found'**
  String get noDriversFound;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreated;

  /// No description provided for @createNewUser.
  ///
  /// In en, this message translates to:
  /// **'Create New User'**
  String get createNewUser;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @generatedPassword.
  ///
  /// In en, this message translates to:
  /// **'Generated Password: {password}'**
  String generatedPassword(String password);

  /// No description provided for @generatePassword.
  ///
  /// In en, this message translates to:
  /// **'Generate Password'**
  String get generatePassword;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get copyPassword;

  /// No description provided for @assignDriver.
  ///
  /// In en, this message translates to:
  /// **'Assign Driver'**
  String get assignDriver;

  /// No description provided for @pricingFormula.
  ///
  /// In en, this message translates to:
  /// **'Total = (Base + Weight × Rate + Surcharge) × Vehicle Multiplier'**
  String get pricingFormula;

  /// No description provided for @reportOverview.
  ///
  /// In en, this message translates to:
  /// **'Report Overview'**
  String get reportOverview;

  /// No description provided for @catalogManagement.
  ///
  /// In en, this message translates to:
  /// **'Catalog Management'**
  String get catalogManagement;

  /// No description provided for @categoryCrudPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Category CRUD UI'**
  String get categoryCrudPlaceholder;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String kgUnit(String value);

  /// No description provided for @priceFormat.
  ///
  /// In en, this message translates to:
  /// **'\${value}'**
  String priceFormat(String value);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @confirmShipmentButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Import Request'**
  String get confirmShipmentButton;

  /// No description provided for @shipmentCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import request created!'**
  String get shipmentCreatedSuccess;

  /// No description provided for @shipmentCreatedError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String shipmentCreatedError(String error);

  /// No description provided for @newShipmentButton.
  ///
  /// In en, this message translates to:
  /// **'+ New Import'**
  String get newShipmentButton;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @searchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Search questions…'**
  String get searchQuestions;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @errorProcessing.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorProcessing(String error);

  /// No description provided for @routeArrow.
  ///
  /// In en, this message translates to:
  /// **'{origin} → {destination}'**
  String routeArrow(String origin, String destination);

  /// No description provided for @staffHint.
  ///
  /// In en, this message translates to:
  /// **'staff@ltms.com'**
  String get staffHint;

  /// No description provided for @driverHint.
  ///
  /// In en, this message translates to:
  /// **'driver@email.com'**
  String get driverHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @ltmsAdmin.
  ///
  /// In en, this message translates to:
  /// **'LTMS Admin'**
  String get ltmsAdmin;

  /// No description provided for @ltmsCustomer.
  ///
  /// In en, this message translates to:
  /// **'LTMS Customer'**
  String get ltmsCustomer;

  /// No description provided for @ltmsDriver.
  ///
  /// In en, this message translates to:
  /// **'LTMS Driver'**
  String get ltmsDriver;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••'**
  String get passwordPlaceholder;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @notificationSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notification sent successfully!'**
  String get notificationSentSuccess;

  /// No description provided for @notificationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Erbil Warehouse, Gate 3'**
  String get notificationHint;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @staffSidebar.
  ///
  /// In en, this message translates to:
  /// **'LTMS Staff'**
  String get staffSidebar;

  /// No description provided for @originOutsideKurdistanRequired.
  ///
  /// In en, this message translates to:
  /// **'Source must be outside Kurdistan for an import request.'**
  String get originOutsideKurdistanRequired;

  /// No description provided for @destinationKurdistanRequired.
  ///
  /// In en, this message translates to:
  /// **'Destination must be a delivery city in Kurdistan.'**
  String get destinationKurdistanRequired;

  /// No description provided for @lengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthLabel;

  /// No description provided for @widthLabel.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get widthLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'0.0'**
  String get weightPlaceholder;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourNameHint;

  /// No description provided for @yourFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get yourFullNameHint;

  /// No description provided for @passwordUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get passwordUpdateHint;

  /// No description provided for @alertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get alerts for new assignments'**
  String get alertsSubtitle;

  /// No description provided for @accountSubtitleUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update your name & info'**
  String get accountSubtitleUpdate;

  /// No description provided for @passwordSubtitleUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get passwordSubtitleUpdate;

  /// No description provided for @faqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and contact us'**
  String get faqSubtitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get feedbackSubtitle;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 · LTMS Driver'**
  String get versionInfo;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version: 1.0.0'**
  String get versionLabel;

  /// No description provided for @logisticsSystemFull.
  ///
  /// In en, this message translates to:
  /// **'Logistics & Transport Management System'**
  String get logisticsSystemFull;

  /// No description provided for @shipmentIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'#{id}'**
  String shipmentIdPrefix(String id);

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}'**
  String statusUpdated(String status);

  /// No description provided for @statusUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String statusUpdateError(String error);

  /// No description provided for @acceptStartTransit.
  ///
  /// In en, this message translates to:
  /// **'Accept & Start Transit'**
  String get acceptStartTransit;

  /// No description provided for @markAsDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markAsDelivered;

  /// No description provided for @noNotificationsFound.
  ///
  /// In en, this message translates to:
  /// **'No notifications found'**
  String get noNotificationsFound;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @ltmsTitle.
  ///
  /// In en, this message translates to:
  /// **'LTMS'**
  String get ltmsTitle;

  /// No description provided for @stillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get stillNeedHelp;

  /// No description provided for @contactSupportLine.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team directly'**
  String get contactSupportLine;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @updateBtn.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateBtn;

  /// No description provided for @statusUpdate.
  ///
  /// In en, this message translates to:
  /// **'Status Update'**
  String get statusUpdate;

  /// No description provided for @assignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get assignment;

  /// No description provided for @sendBtn.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendBtn;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get selectCustomer;

  /// No description provided for @selectCustomerError.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get selectCustomerError;

  /// No description provided for @messageEnRequired.
  ///
  /// In en, this message translates to:
  /// **'English message is required'**
  String get messageEnRequired;

  /// No description provided for @messageKuRequired.
  ///
  /// In en, this message translates to:
  /// **'Kurdish message is required'**
  String get messageKuRequired;

  /// No description provided for @failedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send'**
  String get failedToSend;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Erbil warehouse'**
  String get locationHint;

  /// No description provided for @reportLabel.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportLabel;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @minPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get minPasswordHint;

  /// No description provided for @faqCrudPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'FAQ management content'**
  String get faqCrudPlaceholder;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the application language'**
  String get languageSubtitle;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account is disabled. Please contact support.'**
  String get accountDisabled;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ku'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ku':
      return L10nKu();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
