plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.project.admin.p2psharpdrop.admin_p2p_sharpdrop" // Replace with your actual package name
    compileSdk = 35 // Based on your targetSdkVersion

    defaultConfig {
        applicationId = "com.project.admin.p2psharpdrop.admin_p2p_sharpdrop" // Replace with your actual package name
        minSdk = 24
        multiDexEnabled = true
        targetSdk = 35
        versionCode = 10
        versionName = "1.0"
    }

    buildTypes {
        release {
            // TODO: Add your signing config here if needed
            // signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation("com.android.support:multidex:1.0.3")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // Add other dependencies here
}

// This section should be kept as is from your original build.gradle.kts
// Usually there is a flutter section here