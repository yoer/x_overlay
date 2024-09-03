package com.yoer.x_overlay;

import androidx.annotation.NonNull;
import android.util.Log;
import android.app.ActivityManager;
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** XOverlayPlugin */
public class XOverlayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private Context context;
  private ActivityPluginBinding activityBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d("x.overlay plugin", "onAttachedToEngine");

    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "x_overlay");
    methodChannel.setMethodCallHandler(this);

    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d("x.overlay plugin", "onMethodCall: " + call.method);

    if (call.method.equals(Defines.FLUTTER_API_FUNC_BACK_TO_DESKTOP)) {
      Boolean nonRoot = call.argument(Defines.FLUTTER_PARAM_NON_ROOT);

      backToDesktop(nonRoot);

      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d("x.overlay plugin", "onDetachedFromEngine");

    methodChannel.setMethodCallHandler(null);
  }


  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    Log.d("x.overlay plugin", "onAttachedToActivity");

    activityBinding = activityPluginBinding;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
    Log.d("x.overlay plugin", "onReattachedToActivityForConfigChanges");

    activityBinding = activityPluginBinding;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    Log.d("x.overlay plugin", "onDetachedFromActivityForConfigChanges");

    activityBinding = null;
  }

  @Override
  public void onDetachedFromActivity() {
    Log.d("x.overlay plugin", "onDetachedFromActivity");

    activityBinding = null;
  }

  public void backToDesktop(Boolean nonRoot) {
    Log.i("x.overlay plugin", "backToDesktop" + " nonRoot:" + nonRoot);

    try {
      activityBinding.getActivity().moveTaskToBack(nonRoot);
    } catch (Exception e) {
      Log.e("x.overlay plugin, backToDesktop", e.toString());
    }
  }
}