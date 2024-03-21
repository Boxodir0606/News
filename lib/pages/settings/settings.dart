import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:news/local/shared_preferences.dart';
import 'package:news/pages/home/home.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Column(
                  children: [

                        Row(
                          children: [
                            const Text(
                              "Enable Dark Mode",
                              style: TextStyle(
                                color: Color(0xFFF26B6C),
                                fontSize: 14,
                                fontFamily: 'Uni Neue',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                                activeColor: const Color(0xFFF26B6C),
                                value: MyPreferences.getTheme() ?? false,
                                onChanged: (newValue) {
                                  setState(() {
                                    MyPreferences.setTheme(newValue);
                                    if (MyPreferences.getTheme() == true) {
                                      AdaptiveTheme.of(context).setDark();
                                    } else {
                                      AdaptiveTheme.of(context).setLight();
                                    }
                                  });

                                })
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    )


              ))
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileItem({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF26B6C),
                fontSize: 14,
                fontFamily: 'Uni Neue',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const Spacer(),
            SelectableText(
              value,
              style: const TextStyle(
                color: Color(0xFF787878),
                fontSize: 14,
                fontFamily: 'Uni Neue',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFF2F2F2))
      ],
    );
  }
}
