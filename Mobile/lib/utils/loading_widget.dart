import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qltstc_kiemke/constants/configs.dart';

import 'dialog_utils.dart';

class LoadingWidget extends StatelessWidget {
  final bool showLoading;
  final bool isBlur;
  final bool isLoadingCoverBG;

  LoadingWidget(
    this.showLoading, {
    this.isBlur = Config.IS_DEFAULT_BLUR_LOADING,
    this.isLoadingCoverBG = true,
  });

  @override
  Widget build(BuildContext context) {
    double blurRatio = isBlur ? 8 : 0;
    double whiteCoverOpacity = this.isBlur ? 0.5 : 0;
    if (isLoadingCoverBG) {
      if (showLoading) {
        return Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurRatio, sigmaY: blurRatio),
            child: Container(
              color: Theme.of(
                context,
              ).colorScheme.surface.withOpacity(whiteCoverOpacity),
              child: new Align(
                child: DialogUtils.basicIndicator(showLoading),
                alignment: FractionalOffset.center,
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    } else {
      return Align(
        child: DialogUtils.basicIndicator(showLoading),
        alignment: FractionalOffset.center,
      );
    }
  }
}
