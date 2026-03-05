//
// import 'package:flutter/material.dart';
//
// class ConnectivityUtils {
//
//   static final ConnectivityUtils _instance = ConnectivityUtils._internal();
//
//   factory ConnectivityUtils() {
//     return _instance;
//   }
//
//   // ConnectivityUtils._internal();
//
//   // Check internet and navigate, or show dialog if no connection
//   Future<bool> checkInternetAndNavigate(BuildContext context,
//       Function(bool) onConnectionChecked) async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     // Check for mobile or wifi connectivity
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       onConnectionChecked(true);  // Callback with true for connected
//       return true;
//     } else {
//       // Show dialog if no connection
//       _showNoInternetDialog(context, onConnectionChecked);
//       onConnectionChecked(false);  // Callback with false for no connection
//       return false;
//     }
//   }
//
//   // Show dialog to notify the user about no internet connection
//   void _showNoInternetDialog(BuildContext context,
//       Function(bool) onConnectionChecked) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('No Internet Connection'),
//           content: const Text('Please check your internet connection and try again.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Retry'),
//               onPressed: () async {
//                 Navigator.of(context).pop();  // Close the dialog
//                 bool isConnected = await checkInternetAndNavigate(context, onConnectionChecked);
//                 if (isConnected) {
//                   // Handle any additional logic if needed after internet is available
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
