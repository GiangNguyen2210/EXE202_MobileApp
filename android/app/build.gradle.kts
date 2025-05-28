plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Bắt buộc để dùng Firebase
}

android {
    namespace = "com.example.EXE202.exe202_mobile_app"
    compileSdk = flutter.compileSdkVersion

    // ✅ Cập nhật NDK version như Firebase yêu cầu
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.EXE202.exe202_mobile_app"

        // ✅ Cập nhật minSdkVersion từ 21 → 23 do Firebase Auth yêu cầu
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Dùng Firebase BoM để đồng bộ tất cả phiên bản Firebase
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // ✅ Thư viện Firebase bạn cần
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics") // (tuỳ chọn)
}
