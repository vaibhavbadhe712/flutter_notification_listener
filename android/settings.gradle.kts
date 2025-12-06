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

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

// Fix for flutter_notification_listener_plus namespace and JVM compatibility issues
gradle.beforeProject {
    if (name == "flutter_notification_listener_plus") {
        afterEvaluate {
            // Set namespace
            extensions.findByType<com.android.build.gradle.LibraryExtension>()?.apply {
                namespace = "im.zoe.labs.flutter_notification_listener"
                compileSdk = 35
                
                // Set compile options to match app configuration
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
            
            // Set Kotlin JVM target and suppress null safety errors
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                    freeCompilerArgs.add("-Xno-call-assertions")
                    freeCompilerArgs.add("-Xno-param-assertions")
                    freeCompilerArgs.add("-Xno-receiver-assertions")
                }
            }
        }
    }
}
