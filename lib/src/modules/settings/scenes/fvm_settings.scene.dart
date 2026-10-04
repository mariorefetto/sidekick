import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../settings.dto.dart';

/// Fvm Settings Scene
class FvmSettingsScene extends StatelessWidget {
  /// Constructor
  const FvmSettingsScene(
    this.settings,
    this.onSave, {
    super.key,
  });

  /// Settings
  final AllSettings settings;

  /// Save handler
  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('FVM', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              context.i18n('modules:settings.scenes.fvmCacheDirectory'),
            ),
            subtitle: Text(
              settings.fvm.cachePath ?? FVMClient.context.cacheDir.path,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.fvm.cachePath != null)
                  TextButton(
                    onPressed: () {
                      settings.fvm.cachePath = null;
                      onSave();
                    },
                    child: Text(
                      context.i18n('modules:settings.scenes.useDefault'),
                    ),
                  ),
                TextButton(
                  onPressed: () async {
                    final path = await getDirectoryPath(
                      initialDirectory: FVMClient.context.cacheDir.path,
                    );
                    if (path != null) {
                      settings.fvm.cachePath = path;
                      onSave();
                    }
                  },
                  child: Text(
                    context.i18n('modules:settings.scenes.chooseFolder'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(context
                .i18n('modules:settings.scenes.skipSetupFlutterOnInstall')),
            subtitle: Text(
              context.i18n(
                      'modules:settings.scenes.thisWillOnlyCloneFlutterAndNotInstall') +
                  context.i18n(
                      'modules:settings.scenes.dependenciesAfterANewVersionIsInstalled'),
            ),
            value: settings.fvm.skipSetup,
            onChanged: (value) {
              settings.fvm.skipSetup = value;
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
