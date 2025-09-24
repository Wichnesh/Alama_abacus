# Ignore warnings for missing ProGuard annotations
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

# Razorpay specific rules
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Ignore all warnings (use cautiously)
-ignorewarnings
