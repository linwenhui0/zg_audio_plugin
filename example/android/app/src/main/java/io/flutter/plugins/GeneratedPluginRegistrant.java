package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.flutter.zg.zgaudioplugin.ZgAudioPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ZgAudioPlugin.registerWith(registry.registrarFor("com.flutter.zg.zgaudioplugin.ZgAudioPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}