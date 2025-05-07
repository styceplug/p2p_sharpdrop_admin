# Flutter ProGuard rules

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Dart VM
-keep class io.flutter.vm.service.** { *; }

# Firebase (if you use it)
-keep class com.google.firebase.** { *; }

# Crashlytics (if you use it)
-keepattributes SourceFile,LineNumberTable
-keep class com.crashlytics.** { *; }

# For native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep models (if using JSON serialization)
-keep class your.package.name.models.** { *; }

# Multidex
-keep class com.android.support.multidex.** { *; }

# Uncomment if using Retrofit for API calls
# -keepattributes Signature
# -keepattributes *Annotation*
# -keep class retrofit2.** { *; }
# -keep class okhttp3.** { *; }
# -keep class okio.** { *; }

# Uncomment if using GSON
# -keep class com.google.gson.** { *; }
# -keepattributes Signature
# -keepattributes *Annotation*
# -dontwarn sun.misc.**

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }