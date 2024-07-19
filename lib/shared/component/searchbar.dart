import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class SearchBarMap extends StatelessWidget {
  const SearchBarMap({
    super.key,
    required this.search,
    required this.onTap,
    required this.onChanged,
    required this.onEditingComplete,
    required this.back,
    required this.googleSearchListFlag,
    required this.controller,
  });

  final Function(String) search;
  final VoidCallback onTap;
  final Function(String) onChanged;
  final VoidCallback onEditingComplete;
  final VoidCallback back;
  final bool googleSearchListFlag;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return Material(
      elevation: googleSearchListFlag ? 0 : 8,
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          child: TextFormField(
            controller: controller,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: search,
            obscureText: false,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Search...',
              labelStyle: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 195, 195, 195),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  // color: ColorTheme.primary,
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  // color: ColorTheme.primary,
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 248, 248, 248),
              prefixIcon: googleSearchListFlag
                  ? IconButton(
                      onPressed: back,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: ColorTheme.primary,
                      ),
                    )
                  : IconButton(
                      onPressed: back,
                      icon: const Icon(
                        Icons.search_outlined,
                        color: ColorTheme.primary,
                      ),
                    ),
            ),
            style: TextStyle(
              fontFamily: fontTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final Function(String) press;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();

    return Column(
      children: [
        ListTile(
          onTap: () => press(location),
          horizontalTitleGap: 0,
          leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 215, 215, 215),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                FluentIcons.location_24_filled,
                size: 15,
              )),
          title: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              location,
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 236, 236, 236),
        ),
      ],
    );
  }
}

class SearchBarMasjid extends StatelessWidget {
  const SearchBarMasjid({
    super.key,
    required this.search,
    required this.onTap,
    required this.onChanged,
    required this.onEditingComplete,
    required this.back,
    required this.masjidSearchListFlag,
    required this.controller,
  });

  final Function(String) search;
  final VoidCallback onTap;
  final Function(String) onChanged;
  final VoidCallback onEditingComplete;
  final VoidCallback back;
  final bool masjidSearchListFlag;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return Material(
      // elevation: googleSearchListFlag ? 0 : 8,
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          child: TextFormField(
            controller: controller,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: search,
            obscureText: false,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Search Masjid ...',
              labelStyle: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 195, 195, 195),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorTheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorTheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 248, 248, 248),
              prefixIcon: masjidSearchListFlag
                  ? IconButton(
                      onPressed: back,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: ColorTheme.primary,
                      ),
                    )
                  : IconButton(
                      onPressed: back,
                      icon: const Icon(
                        Icons.search_outlined,
                        color: ColorTheme.primary,
                      ),
                    ),
            ),
            style: TextStyle(
              fontFamily: fontTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class MasjidListTile extends StatelessWidget {
  const MasjidListTile({
    super.key,
    required this.location,
    required this.serviceType,
    required this.masjid,
    required this.press,
  });

  final String location;
  final String serviceType;
  final Map<String, dynamic> masjid;
  final Function(Map<String, dynamic>) press;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();

    return Column(
      children: [
        ListTile(
          onTap: () => press(masjid),
          horizontalTitleGap: 0,
          leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 215, 215, 215),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                FluentIcons.location_24_filled,
                size: 15,
              )),
          title: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Text(
                  location,
                  style: TextStyle(
                    fontFamily: fontTheme.fontFamily,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    serviceType,
                    style: TextStyle(
                      fontFamily: fontTheme.fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 236, 236, 236),
        ),
      ],
    );
  }
}
