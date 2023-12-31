package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new com.company.sdk.card_sdk.CardSdkPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin card_sdk, com.company.sdk.card_sdk.CardSdkPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.pauldemarco.flutter_blue.FlutterBluePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_blue, com.pauldemarco.flutter_blue.FlutterBluePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.lib.flutter_blue_plus.FlutterBluePlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_blue_plus, com.lib.flutter_blue_plus.FlutterBluePlusPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin fluttertoast, io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin path_provider_android, io.flutter.plugins.pathprovider.PathProviderPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.baseflow.permissionhandler.PermissionHandlerPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin permission_handler_android, com.baseflow.permissionhandler.PermissionHandlerPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.flutter.stripe.StripeAndroidPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin stripe_android, com.flutter.stripe.StripeAndroidPlugin", e);
    }
  }
}
