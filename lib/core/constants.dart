class AppConstants {
  // App Information
  static const String appName = 'نظام إدارة المصنع';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'factory_management.db';
  static const int databaseVersion = 1;
  
  // Shared Preferences Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstRunKey = 'first_run';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

class AppColors {
  static const int primaryColorValue = 0xFF1976D2;
  static const int secondaryColorValue = 0xFF424242;
  static const int accentColorValue = 0xFFFF5722;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;
  static const int infoColorValue = 0xFF2196F3;
}

class AppStrings {
  // Common
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String add = 'إضافة';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String refresh = 'تحديث';
  static const String loading = 'جاري التحميل...';
  static const String error = 'خطأ';
  static const String success = 'نجح';
  static const String warning = 'تحذير';
  static const String info = 'معلومات';
  static const String confirm = 'تأكيد';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String ok = 'موافق';
  static const String close = 'إغلاق';
  static const String back = 'رجوع';
  static const String next = 'التالي';
  static const String previous = 'السابق';
  static const String submit = 'إرسال';
  static const String reset = 'إعادة تعيين';
  static const String clear = 'مسح';
  static const String select = 'اختيار';
  static const String all = 'الكل';
  static const String none = 'لا شيء';
  static const String unknown = 'غير معروف';
  static const String notAvailable = 'غير متوفر';
  static const String required = 'مطلوب';
  static const String optional = 'اختياري';
  
  // Navigation
  static const String dashboard = 'لوحة التحكم';
  static const String inventory = 'المخزون';
  static const String production = 'الإنتاج';
  static const String sales = 'المبيعات';
  static const String accounting = 'المحاسبة';
  static const String workers = 'العمال';
  static const String reports = 'التقارير';
  static const String settings = 'الإعدادات';
  
  // Validation Messages
  static const String fieldRequired = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String invalidPhone = 'رقم الهاتف غير صحيح';
  static const String invalidNumber = 'الرقم غير صحيح';
  static const String invalidDate = 'التاريخ غير صحيح';
  static const String invalidTime = 'الوقت غير صحيح';
  static const String invalidQuantity = 'الكمية غير صحيحة';
  static const String invalidPrice = 'السعر غير صحيح';
  static const String invalidPercentage = 'النسبة المئوية غير صحيحة';
  
  // Success Messages
  static const String savedSuccessfully = 'تم الحفظ بنجاح';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String updatedSuccessfully = 'تم التحديث بنجاح';
  static const String addedSuccessfully = 'تم الإضافة بنجاح';
  
  // Error Messages
  static const String saveError = 'حدث خطأ أثناء الحفظ';
  static const String deleteError = 'حدث خطأ أثناء الحذف';
  static const String updateError = 'حدث خطأ أثناء التحديث';
  static const String addError = 'حدث خطأ أثناء الإضافة';
  static const String networkError = 'خطأ في الاتصال بالشبكة';
  static const String databaseError = 'خطأ في قاعدة البيانات';
  static const String permissionError = 'خطأ في الصلاحيات';
  static const String unknownError = 'خطأ غير معروف';
}
