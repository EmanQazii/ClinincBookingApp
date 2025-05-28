import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = project.file("key.properties")

if (!keystorePropertiesFile.exists()) {
    throw GradleException("❌ 'key.properties' file is missing at project root: ${keystorePropertiesFile.path}")
}

keystoreProperties.load(FileInputStream(keystorePropertiesFile))

fun getRequiredProperty(name: String): String {
    return keystoreProperties[name] as? String
        ?: throw GradleException("❌ Missing required property '$name' in key.properties")
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}



android {
    ndkVersion = "27.0.12077973"
    namespace = "com.example.clinic_booking_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true 
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.clinic_booking_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    signingConfigs {
        create("release") {
        keyAlias = getRequiredProperty("keyAlias")
        keyPassword = getRequiredProperty("keyPassword")
        storeFile = file(getRequiredProperty("storeFile"))
        storePassword = getRequiredProperty("storePassword")
    }
    }

    buildTypes {
        getByName("release") {
        signingConfig = signingConfigs.getByName("release") // Use release signing config here
        isMinifyEnabled = false
        isShrinkResources = false
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
    }
}

flutter {
    source = "../.."
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}