import 'package:flutter_test/flutter_test.dart';
import 'package:datadirr_auth/datadirr_auth.dart';
import 'package:datadirr_auth/datadirr_auth_platform_interface.dart';
import 'package:datadirr_auth/datadirr_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDatadirrAuthPlatform
    with MockPlatformInterfaceMixin
    implements DatadirrAuthPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DatadirrAuthPlatform initialPlatform = DatadirrAuthPlatform.instance;

  test('$MethodChannelDatadirrAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDatadirrAuth>());
  });

  test('getPlatformVersion', () async {
    DatadirrAuth datadirrAuthPlugin = DatadirrAuth();
    MockDatadirrAuthPlatform fakePlatform = MockDatadirrAuthPlatform();
    DatadirrAuthPlatform.instance = fakePlatform;

    expect(await datadirrAuthPlugin.getPlatformVersion(), '42');
  });
}
