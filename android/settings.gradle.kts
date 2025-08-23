pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    //https://www.sunzhongwei.com/android-studio-settings-gradle-switching-source-in-china
    // 国内源的切换配置就从 build.gradle 文件改到了 settings.gradle 文件。
    repositories {
        maven { url = uri("https://jitpack.io") }
        maven { url = uri("https://maven.aliyun.com/repository/releases") }
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") } // Central 仓库镜像
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") } // Gradle 插件镜像
        maven { url = uri("https://maven.aliyun.com/repository/public") }// 阿里云镜像
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

//dependencyResolutionManagement {
//    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
//    repositories {
//        maven("https://maven.aliyun.com/repository/public")
//        maven("https://maven.aliyun.com/repository/central")
//        google()
//        mavenCentral()
//    }
//}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
