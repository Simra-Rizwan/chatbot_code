import "package:custfyp/main.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class ToastService {

  static void display(String message, {required BuildContext context}) {
    // final BuildContext? context = MyApp.navigatorKey.currentContext;
    // if(context == null) {
    //   return;
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        elevation: 10,
        content: Text(
          message,
          // style: AppTextStyles.kBodyMedium.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  // static void showNotification({
  //   required String? title,
  //   required String body,
  // }) {
  //   final BuildContext? context = MyApp.navigatorKey.currentContext;
  //   if (context == null) {
  //     return;
  //   }
  //   InAppNotification.show(
  //     child: Padding(
  //       padding: AppUIConstants.kScaffoldBodyPadding,
  //       child: Glassmorphism(
  //         blur: 10,
  //         color: Colors.black,
  //         opacity: 0.2,
  //         borderRadius: BorderRadius.circular(12),
  //         child: Padding(
  //           padding: const EdgeInsets.all(14),
  //           child: Row(
  //             children: <Widget>[
  //               Container(
  //                 height: 40,
  //                 width: 40,
  //                 decoration: const BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.black,
  //                   image: DecorationImage(
  //                     image: AssetImage(
  //                       AssetImages.appLogoTransparent,
  //                     ),
  //                     fit: BoxFit.scaleDown,
  //                   ),
  //                 ),
  //               ),
  //               const Gap(10),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     Text(
  //                       title ?? "Reminder",
  //                       style: AppTextStyles.kBodyMedium.copyWith(
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     const Gap(4),
  //                     Text(
  //                       body,
  //                       style: AppTextStyles.kBodyMedium.copyWith(
  //                         fontSize: 12,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     context: context,
  //   );
  // }
}
