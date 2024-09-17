#ifndef FLUTTER_PLUGIN_DATADIRR_AUTH_PLUGIN_H_
#define FLUTTER_PLUGIN_DATADIRR_AUTH_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace datadirr_auth {

class DatadirrAuthPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DatadirrAuthPlugin();

  virtual ~DatadirrAuthPlugin();

  // Disallow copy and assign.
  DatadirrAuthPlugin(const DatadirrAuthPlugin&) = delete;
  DatadirrAuthPlugin& operator=(const DatadirrAuthPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace datadirr_auth

#endif  // FLUTTER_PLUGIN_DATADIRR_AUTH_PLUGIN_H_
