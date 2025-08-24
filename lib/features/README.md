# Features Structure

هذا المجلد يحتوي على جميع وحدات التطبيق منظمة حسب Clean Architecture.

## البنية الحالية

### 📁 **dashboard/**
- **presentation/pages/dashboard_home_page.dart** - الصفحة الرئيسية للوحة التحكم

### 📁 **inventory/** ✅
- **data/** - مصادر البيانات والمستودعات
- **domain/** - الكيانات والواجهات
- **presentation/** - الواجهات والـ BLoC

### 📁 **production/** 🔄
- **presentation/pages/production_page.dart** - صفحة الإنتاج (قيد التطوير)

### 📁 **sales/** 🔄
- **presentation/pages/sales_page.dart** - صفحة المبيعات (قيد التطوير)

### 📁 **accounting/** 🔄
- **presentation/pages/accounting_page.dart** - صفحة المحاسبة (قيد التطوير)

### 📁 **workers/** 🔄
- **presentation/pages/workers_page.dart** - صفحة العمال (قيد التطوير)

## الحالة
- ✅ **مكتمل**: inventory
- 🔄 **قيد التطوير**: production, sales, accounting, workers
- 📋 **مخطط**: dashboard (إضافة BLoC و data layers)

## ملاحظات
- كل مجلد يتبع Clean Architecture مع data, domain, presentation
- تم إنشاء ملفات index.dart لتسهيل الاستيراد
- جميع الصفحات تدعم RTL واللغة العربية

