

import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'ImageUtils.dart';
import 'constant.dart';
import 'network_image.dart';

class BeautifulAlertDialog extends StatelessWidget {
  BeautifulAlertDialog({super.key});
  late SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  bottomLeft: Radius.circular(75),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20.0),
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                child: const PNetworkImage(
                  infoIcon,
                  width: 60,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Alert!",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10.0),
                    const Flexible(
                      child: Text("Do you want to log-out?"),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: const Text("Yes"),
                            onPressed: () async {
                              await Prefs.setString(TOKEN, "");
                              await Prefs.setString(USERNAME, "");
                              await Prefs.setString(FRANCHISESTATE,"");
                              await Prefs.setBoolen(SHARED_ADMIN, false);
                              await Prefs.setBoolen('isLoggedIn', false);
                              if (kDebugMode) {
                                print(
                                    '${Prefs.getString(TOKEN)} -- ${Prefs.getBoolen(SHARED_ADMIN)} -- ${Prefs.getString('isLoggedIn')}');
                              }
                              Get.offAllNamed(ROUTE_LOGIN);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
