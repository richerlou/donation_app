import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader {
  BuildContext _context;
  bool shouldPop = false;

  void hide() => Navigator.of(_context).pop();

  void show() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) => const _LoaderWidget(),
    );
  }

  void managePop(bool canPop) => shouldPop = canPop;

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  CustomLoader._create(this._context);

  factory CustomLoader.of(BuildContext context) =>
      CustomLoader._create(context);
}

class _LoaderWidget extends StatelessWidget {
  const _LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: CustomLoader.of(context).shouldPop,
      onPopInvoked: (didPop) {
        // No additional logic needed for now
      },
      child: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: const Center(
          child: SpinKitThreeBounce(color: AppStyle.kColorGreen, size: 30.0),
        ),
      ),
    );
  }
}
