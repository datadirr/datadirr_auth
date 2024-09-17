#include "include/datadirr_auth/datadirr_auth_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "datadirr_auth_plugin.h"

void DatadirrAuthPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  datadirr_auth::DatadirrAuthPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
