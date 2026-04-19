import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_date_data;
import 'package:intl/intl.dart' as intl;

const _fallbackFormattingLocale = 'en';

Future<String> _ensureFormattingLocale(String localeName) async {
  await intl_date_data.initializeDateFormatting(
    _fallbackFormattingLocale,
    null,
  );
  return _fallbackFormattingLocale;
}

/// A custom [MaterialLocalizations] implementation for Kurdish (Sorani).
class KurdishMaterialLocalizations extends GlobalMaterialLocalizations {
  const KurdishMaterialLocalizations({
    super.localeName = 'ku',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  String get okButtonLabel => 'باشە';

  @override
  String get cancelButtonLabel => 'پاشەکشە';

  @override
  String get closeButtonLabel => 'داخستن';

  @override
  String get searchFieldLabel => 'گەڕان';

  @override
  String get backButtonTooltip => 'گەڕانەوە';

  @override
  String get continueButtonLabel => 'بەردەوام بە';

  @override
  String get copyButtonLabel => 'کۆپی';

  @override
  String get cutButtonLabel => 'بڕین';

  @override
  String get pasteButtonLabel => 'پێوەنوسان';

  @override
  String get selectAllButtonLabel => 'هەمووی هەڵبژێرە';

  @override
  String get deleteButtonTooltip => 'سڕینەوە';

  @override
  String get nextMonthTooltip => 'مانگی داهاتوو';

  @override
  String get previousMonthTooltip => 'مانگی پێشوو';

  String get nextDayTooltip => 'ڕۆژی داهاتوو';

  String get previousDayTooltip => 'ڕۆژی پێشوو';

  @override
  String get showMenuTooltip => 'پیشاندانی مێنۆ';

  @override
  String get drawerLabel => 'مێنۆی لایەنی';

  @override
  String get popupMenuLabel => 'مێنۆی پۆپ ئەپ';

  @override
  String get dialogLabel => 'دیالۆگ';

  @override
  String get alertDialogLabel => 'ئاگادارکردنەوە';

  String get searchLabel => 'گەڕان';

  @override
  String get licensesPageTitle => 'مۆڵەتنامەکان';

  @override
  String get rowsPerPageTitle => 'ڕیزەکان بۆ هەر پەڕەیەک:';

  @override
  String get postMeridiemAbbreviation => 'د.ن';

  @override
  String get anteMeridiemAbbreviation => 'پ.ن';

  @override
  String get modalBarrierDismissLabel => 'داخستن';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.tall;

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      alwaysUse24HourFormat ? TimeOfDayFormat.HH_colon_mm : TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get signedInLabel => 'چوونە ژوورەوە کراوە';

  @override
  String get hideAccountsLabel => 'شاردنەوەی هەژمارەکان';

  @override
  String get showAccountsLabel => 'پیشاندانی هەژمارەکان';

  @override
  String get reorderItemUp => 'جوڵاندن بۆ سەرەوە';

  @override
  String get reorderItemDown => 'جوڵاندن بۆ خوارەوە';

  @override
  String get reorderItemLeft => 'جوڵاندن بۆ چەپ';

  @override
  String get reorderItemRight => 'جوڵاندن بۆ ڕاست';

  @override
  String get reorderItemToEnd => 'جوڵاندن بۆ کۆتایی';

  @override
  String get reorderItemToStart => 'جوڵاندن بۆ سەرەتا';

  @override
  String get expandedIconTapHint => 'بچوککردنەوە';

  @override
  String get collapsedIconTapHint => 'گەورەکردن';

  String get spaceBarButtonLabel => 'بۆشایی';

  @override
  String get refreshIndicatorSemanticLabel => 'نوێکردنەوە';

  String get routeButtonTooltip => 'ڕێگا';

  @override
  String get calendarModeButtonLabel => 'گۆڕین بۆ ڕۆژژمێر';

  @override
  String get dateHelpText => 'سـاپ/مـم/ڕۆژ';

  @override
  String get dateInputLabel => 'بەروار داخڵ بکە';

  @override
  String get dateOutOfRangeLabel => 'بەروارەکە لە دەرەوەی مەودایە.';

  @override
  String get datePickerHelpText => 'هەڵبژاردنی بەروار';

  @override
  String dateRangeEndDateSemanticLabel(String formattedDate) => 'بەرواری کۆتایی $formattedDate';

  @override
  String get dateRangeEndLabel => 'بەرواری کۆتایی';

  @override
  String get dateRangePickerHelpText => 'مەودای بەروار هەڵبژێرە';

  @override
  String dateRangeStartDateSemanticLabel(String formattedDate) => 'بەرواری دەستپێک $formattedDate';

  @override
  String get dateRangeStartLabel => 'بەرواری دەستپێک';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'گۆڕین بۆ هەڵبژاردنی ژمارە';

  @override
  String get inputDateModeButtonLabel => 'گۆڕین بۆ داخڵکردنی بەروار';

  @override
  String get inputTimeModeButtonLabel => 'گۆڕین بۆ داخڵکردنی کات';

  @override
  String get invalidDateFormatLabel => 'فۆرماتی بەروار هەڵەیە.';

  @override
  String get invalidDateRangeLabel => 'مەوداکە هەڵەیە.';

  @override
  String get invalidTimeLabel => 'کاتەکە هەڵەیە.';

  @override
  String licensesPackageDetailText(int licenseCount) {
    if (licenseCount == 0) return 'هیچ مۆڵەتێک نییە';
    if (licenseCount == 1) return '١ مۆڵەت';
    return '$licenseCount مۆڵەت';
  }

  @override
  String get moreButtonTooltip => 'زیاتر';

  @override
  String get saveButtonLabel => 'پاشەکەوتکردن';

  @override
  String get selectYearSemanticsLabel => 'ساڵ هەڵبژێرە';

  @override
  String get timePickerDialHelpText => 'کات هەڵبژێرە';

  @override
  String get timePickerHourLabel => 'کاژێر';

  @override
  String get timePickerInputHelpText => 'کات داخڵ بکە';

  @override
  String get timePickerMinuteLabel => 'خولەک';

  @override
  String get unspecifiedDate => 'بەروار دیاری نەکراوە';

  @override
  String get unspecifiedDateRange => 'مەودای بەروار دیاری نەکراوە';

  @override
  String get viewLicensesButtonLabel => 'پیشاندانی مۆڵەتنامەکان';

  @override
  String get firstPageTooltip => 'یەکەم لاپەڕە';

  @override
  String get lastPageTooltip => 'کۆتا لاپەڕە';

  @override
  String get nextPageTooltip => 'لاپەڕەی دواتر';

  @override
  String get previousPageTooltip => 'لاپەڕەی پێشوو';

  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Del';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'End';

  @override
  String get keyboardKeyEscape => 'Esc';

  @override
  String get keyboardKeyFn => 'Fn';

  @override
  String get keyboardKeyHome => 'Home';

  @override
  String get keyboardKeyInsert => 'Insert';

  @override
  String get keyboardKeyMeta => 'Meta';

  String get keyboardKeyMetaMac => 'Command';

  @override
  String get keyboardKeyMetaWindows => 'Win';

  @override
  String get keyboardKeyNumLock => 'Num Lock';

  @override
  String get keyboardKeyNumpad0 => 'Num 0';

  @override
  String get keyboardKeyNumpad1 => 'Num 1';

  @override
  String get keyboardKeyNumpad2 => 'Num 2';

  @override
  String get keyboardKeyNumpad3 => 'Num 3';

  @override
  String get keyboardKeyNumpad4 => 'Num 4';

  @override
  String get keyboardKeyNumpad5 => 'Num 5';

  @override
  String get keyboardKeyNumpad6 => 'Num 6';

  @override
  String get keyboardKeyNumpad7 => 'Num 7';

  @override
  String get keyboardKeyNumpad8 => 'Num 8';

  @override
  String get keyboardKeyNumpad9 => 'Num 9';

  @override
  String get keyboardKeyNumpadAdd => 'Num +';

  @override
  String get keyboardKeyNumpadComma => 'Num ,';

  @override
  String get keyboardKeyNumpadDecimal => 'Num .';

  @override
  String get keyboardKeyNumpadDivide => 'Num /';

  @override
  String get keyboardKeyNumpadEnter => 'Num Enter';

  @override
  String get keyboardKeyNumpadEqual => 'Num =';

  @override
  String get keyboardKeyNumpadMultiply => 'Num *';

  String get keyboardKeyNumpadParenthesisLeft => 'Num (';

  String get keyboardKeyNumpadParenthesisRight => 'Num )';

  @override
  String get keyboardKeyNumpadSubtract => 'Num -';

  @override
  String get keyboardKeyPageDown => 'PgDown';

  @override
  String get keyboardKeyPageUp => 'PgUp';

  @override
  String get keyboardKeyPower => 'Power';

  @override
  String get keyboardKeyPrintScreen => 'Print Screen';

  @override
  String get keyboardKeyScrollLock => 'Scroll Lock';

  @override
  String get keyboardKeySelect => 'Select';

  @override
  String get keyboardKeySpace => 'Space';

  String get keyboardKeyTab => 'Tab';

  @override
  String get menuBarMenuLabel => 'MenuBar مێنۆی';

  @override
  String get lookUpButtonLabel => 'گەڕان';

  @override
  String get searchWebButtonLabel => 'گەڕان لە وێب';

  @override
  String get shareButtonLabel => 'هاوبەشکردن...';

  String get scrubInstructionBackwards => 'بۆ دواوە بکشێنە';

  String get scrubInstructionForwards => 'بۆ پێشەوە بکشێنە';

  @override
  String get menuDismissLabel => 'لابردنی مێنۆ';

  @override
  int get firstDayOfWeekIndex => 6;

  @override
  List<String> get narrowWeekdays => const <String>['ی', 'د', 'س', 'چ', 'پ', 'ه', 'ش'];

  List<String> get shortWeekdays => const <String>['یەک', 'دوو', 'سێ', 'چوار', 'پێنج', 'هەینی', 'شەم'];

  List<String> get longWeekdays => const <String>['یەکشەممە', 'دووشەممە', 'سێشەممە', 'چوارشەممە', 'پێنجشەممە', 'هەینی', 'شەممە'];

  List<String> get shortMonths => const <String>['ک٢', 'شوب', 'ئاز', 'نیس', 'ئای', 'حوز', 'تەم', 'ئاب', 'ئەی', 'ت١', 'ت٢', 'ک١'];

  List<String> get longMonths => const <String>['کانوونی دووەم', 'شوبات', 'ئازار', 'نیسان', 'ئایار', 'حوزەیران', 'تەممووز', 'ئاب', 'ئەیلوول', 'تشرینی یەکەم', 'تشرینی دووەم', 'کانوونی یەکەم'];

  @override
  String get aboutListTileTitleRaw => r'دەربارەی $applicationName';

  String selectedRowsCountTitle(int selectedRowCount) {
    if (selectedRowCount == 0) return 'هیچ ڕیزێک هەڵنەبژێردراوە';
    if (selectedRowCount == 1) return '١ ڕیز هەڵبژێردراوە';
    return '$selectedRowCount ڕیز هەڵبژێردراوە';
  }

  @override
  String pageRowsInfoTitle(int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    if (rowCountIsApproximate) {
      return '$firstRow–$lastRow لە نزیکەی $rowCount';
    }
    return '$firstRow–$lastRow لە $rowCount';
  }
  @override
  String get openAppDrawerTooltip => 'کردنەوەی مێنوی ڕێنمایی';

  @override
  String get clearButtonTooltip => 'پاککردنەوەی دەق';

  @override
  String get closeButtonTooltip => 'داخستن';

  @override
  String get bottomSheetLabel => 'پەڕەی خوارەوە';

  @override
  String get currentDateLabel => 'ئەمڕۆ';

  @override
  String get selectedDateLabel => 'بەرواری هەڵبژێردراو';

  @override
  String get expandedHint => 'کراوە';

  @override
  String get collapsedHint => 'داخراوە';

  @override
  String get expansionTileExpandedHint => 'دوو جار پەنجە بدە بۆ داخستن';

  @override
  String get expansionTileCollapsedHint => 'دوو جار پەنجە بدە بۆ کردنەوە';

  @override
  String get expansionTileExpandedTapHint => 'داخستن';

  @override
  String get expansionTileCollapsedTapHint => 'کردنەوە بۆ وردەکاری زیاتر';

  @override
  String get scrimLabel => 'پۆشاک';

  @override
  String get scrimOnTapHintRaw => r'داخستنی $modalRouteContentName';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'بەرواری کۆتایی $fullDate';

  @override
  String get dateRangeStartDateSemanticLabelRaw => r'بەرواری دەستپێک $fullDate';

  @override
  String get timePickerHourModeAnnouncement => 'هەڵبژاردنی کاتژمێر';

  @override
  String get timePickerMinuteModeAnnouncement => 'هەڵبژاردنی خولەک';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get keyboardKeyChannelDown => 'کەناڵ بۆ خوارەوە';

  @override
  String get keyboardKeyChannelUp => 'کەناڵ بۆ سەرەوە';

  @override
  String get keyboardKeyMetaMacOs => 'Command';

  @override
  String get keyboardKeyNumpadParenLeft => 'Num (';

  @override
  String get keyboardKeyNumpadParenRight => 'Num )';

  @override
  String get keyboardKeyPowerOff => 'کوژاندنەوە';

  @override
  String get keyboardKeyShift => 'Shift';

  @override
  String get scanTextButtonLabel => 'سکانکردنی دەق';

  @override
  String get tabLabelRaw => r'تابی $tabIndex لە $tabCount';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount دانە هەڵبژێردراوە';

  @override
  String get remainingTextFieldCharacterCountOther => r'$remainingCount پیت ماوە';

  @override
  String get licensesPackageDetailTextOther => r'$licenseCount مۆڵەت';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow-$lastRow لە $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw => r'$firstRow-$lastRow لە نزیکەی $rowCount';
  static Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    final formattingLocale = await _ensureFormattingLocale(localeName);
    intl.Intl.defaultLocale = formattingLocale;

    return KurdishMaterialLocalizations(
      localeName: localeName,
      fullYearFormat: intl.DateFormat.y(formattingLocale),
      compactDateFormat: intl.DateFormat.yMd(formattingLocale),
      shortDateFormat: intl.DateFormat.yMMMd(formattingLocale),
      mediumDateFormat: intl.DateFormat.yMMMEd(formattingLocale),
      longDateFormat: intl.DateFormat.yMMMMEEEEd(formattingLocale),
      yearMonthFormat: intl.DateFormat.yMMMM(formattingLocale),
      shortMonthDayFormat: intl.DateFormat.MMMd(formattingLocale),
      decimalFormat: intl.NumberFormat.decimalPattern(formattingLocale),
      twoDigitZeroPaddedFormat: intl.NumberFormat('00', formattingLocale),
    );
  }

  static const LocalizationsDelegate<MaterialLocalizations> delegate = _KurdishMaterialLocalizationsDelegate();
}

class _KurdishMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) => KurdishMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_KurdishMaterialLocalizationsDelegate old) => false;
}

/// A custom [CupertinoLocalizations] implementation for Kurdish (Sorani).
class KurdishCupertinoLocalizations extends GlobalCupertinoLocalizations {
  const KurdishCupertinoLocalizations({
    required super.localeName,
    required super.fullYearFormat,
    required super.dayFormat,

    required super.weekdayFormat,
    required super.mediumDateFormat,
    required super.singleDigitHourFormat,
    required super.singleDigitMinuteFormat,
    required super.doubleDigitMinuteFormat,
    required super.singleDigitSecondFormat,
    required super.decimalFormat,
  });

  @override
  String get alertDialogLabel => 'ئاگادارکردنەوە';

  @override
  String get anteMeridiemAbbreviation => 'پ.ن';

  @override
  String get postMeridiemAbbreviation => 'د.ن';

  @override
  String get copyButtonLabel => 'کۆپی';

  @override
  String get cutButtonLabel => 'بڕین';

  @override
  String get pasteButtonLabel => 'پێوەنوسان';

  @override
  String get selectAllButtonLabel => 'هەمووی هەڵبژێرە';

  @override
  String datePickerHourSemanticsLabel(int hour) => '$hour کاژێر';

  @override
  String datePickerMinuteSemanticsLabel(int minute) => '$minute خولەک';

  @override
  String get datePickerDateOrderString => 'mdy';

  @override
  String get datePickerDateTimeOrderString => 'date_time_dayPeriod';

  @override
  String get searchTextFieldPlaceholderLabel => 'گەڕان';

  @override
  String tabSemanticsLabel({required int tabIndex, required int tabCount}) => 'تاب $tabIndex لە $tabCount';

  @override
  String get timerPickerHourLabelOne => 'کاژێر';

  @override
  String get timerPickerHourLabelOther => 'کاژێر';

  @override
  String get timerPickerMinuteLabelOne => 'خولەک';

  @override
  String get timerPickerMinuteLabelOther => 'خولەک';

  @override
  String get timerPickerSecondLabelOne => 'چرکە';

  @override
  String get timerPickerSecondLabelOther => 'چرکە';

  @override
  String get todayLabel => 'ئەمڕۆ';

  @override
  String get noSpellCheckReplacementsLabel => 'هیچ جێگرەوەیەک نییە';

  @override
  String get lookUpButtonLabel => 'گەڕان';

  @override
  String get searchWebButtonLabel => 'گەڕان لە وێب';

  @override
  String get shareButtonLabel => 'هاوبەشکردن...';

  @override
  String get menuDismissLabel => 'لابردنی مێنۆ';

  @override
  String timerPickerHourLabel(int hour) => 'کاژێر';

  @override
  String timerPickerMinuteLabel(int minute) => 'خولەک';

  @override
  String timerPickerSecondLabel(int second) => 'چرکە';
  @override
  String get backButtonLabel => 'گەڕانەوە';

  @override
  String get cancelButtonLabel => 'هەڵوەشاندنەوە';

  @override
  String get clearButtonLabel => 'پاککردنەوە';

  @override
  String get modalBarrierDismissLabel => 'لابردن';

  @override
  String get expandedHint => 'کراوە';

  @override
  String get collapsedHint => 'داخراوە';

  @override
  String get expansionTileExpandedHint => 'دوو جار پەنجە بدە بۆ داخستن';

  @override
  String get expansionTileCollapsedHint => 'دوو جار پەنجە بدە بۆ کردنەوە';

  @override
  String get expansionTileExpandedTapHint => 'داخستن';

  @override
  String get expansionTileCollapsedTapHint => 'کردنەوە بۆ وردەکاری زیاتر';

  @override
  String? get datePickerHourSemanticsLabelOther => r'$hour کاتژمێر';

  @override
  String? get datePickerMinuteSemanticsLabelOther => r'$minute خولەک';

  @override
  String get tabSemanticsLabelRaw => r'تابی $tabIndex لە $tabCount';

  static Future<CupertinoLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    final formattingLocale = await _ensureFormattingLocale(localeName);
    intl.Intl.defaultLocale = formattingLocale;

    return KurdishCupertinoLocalizations(
      localeName: localeName,
      fullYearFormat: intl.DateFormat.y(formattingLocale),
      dayFormat: intl.DateFormat.d(formattingLocale),
      weekdayFormat: intl.DateFormat.E(formattingLocale),
      mediumDateFormat: intl.DateFormat.MMMEd(formattingLocale),
      singleDigitHourFormat: intl.DateFormat('h', formattingLocale),
      singleDigitMinuteFormat: intl.DateFormat('m', formattingLocale),
      doubleDigitMinuteFormat: intl.DateFormat('mm', formattingLocale),
      singleDigitSecondFormat: intl.DateFormat('s', formattingLocale),
      decimalFormat: intl.NumberFormat.decimalPattern(formattingLocale),
    );
  }

  static const LocalizationsDelegate<CupertinoLocalizations> delegate = _KurdishCupertinoLocalizationsDelegate();
}

class _KurdishCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _KurdishCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) => KurdishCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_KurdishCupertinoLocalizationsDelegate old) => false;
}
