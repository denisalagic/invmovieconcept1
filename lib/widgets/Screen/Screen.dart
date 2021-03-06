import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/ScreenSettingsModal.dart';

import 'ScreenStateProvider.dart';

class Screen extends StatelessWidget {
  Screen({
    this.init,
    this.child,
    this.drawer,
    this.builder,
    this.debugLabel,
    this.belowBuilder,
    this.renderSettings = true,
    this.scaffoldBackgroundColor,
  });

  final Widget child;
  final Widget drawer;
  final String debugLabel;
  final bool renderSettings;
  final Color scaffoldBackgroundColor;
  final void Function(BuildContext) init;
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext context) belowBuilder;

  @override
  Widget build(BuildContext context) {
    if (this.init != null) {
      this.init(context);
    }
    return ChangeNotifierProvider<ScreenStateProvider>(
      create: (_) => ScreenStateProvider(),
      child: Scaffold(
        drawer: this.drawer,
        backgroundColor: this.scaffoldBackgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            this.belowBuilder != null
                ? this.belowBuilder(context)
                : Container(),
            Positioned.fill(
              child: child ?? builder(context),
            ),
            this.renderSettings
                ? Consumer<ScreenStateProvider>(
                    builder: (ctx, state, child) {
                      return ScreenSettingsModal(
                        isSettingsOpen: state.isSettingsOpen,
                        isSettingsMounted: state.isSettingsMounted,
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
