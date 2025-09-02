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
    required this.focusNode,
  });

  final Function(String) search;
  final VoidCallback onTap;
  final Function(String) onChanged;
  final VoidCallback onEditingComplete;
  final VoidCallback back;
  final bool googleSearchListFlag;
  final TextEditingController controller;
  final FocusNode focusNode;

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
            focusNode: focusNode,
            controller: controller,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: search,
            obscureText: false,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Search via Google Maps . . .',
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

    // Split location into main name and address
    final locationParts = _parseLocation(location);

    return InkWell(
      onTap: () => press(location),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            // Location Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                FluentIcons.location_24_filled,
                size: 18,
                color: ColorTheme.primary,
              ),
            ),

            const SizedBox(width: 16),

            // Location Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main location name
                  Text(
                    locationParts['name']!,
                    style: TextStyle(
                      fontFamily: fontTheme.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Address/description (if available)
                  if (locationParts['address']!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      locationParts['address']!,
                      style: TextStyle(
                        fontFamily: fontTheme.fontFamily,
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to parse location string
  Map<String, String> _parseLocation(String location) {
    // Try to split at first comma to separate name from address
    final parts = location.split(',');
    if (parts.length > 1) {
      return {
        'name': parts[0].trim(),
        'address': parts.sublist(1).join(',').trim(),
      };
    } else {
      return {
        'name': location.trim(),
        'address': '',
      };
    }
  }
}

// Alternative version with more visual emphasis
class LocationListTileEnhanced extends StatelessWidget {
  const LocationListTileEnhanced({
    super.key,
    required this.location,
    required this.press,
    this.showDistance = false,
    this.distance,
  });

  final String location;
  final Function(String) press;
  final bool showDistance;
  final String? distance;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    final locationParts = _parseLocation(location);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => press(location),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Location Icon with gradient background
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorTheme.primary,
                      ColorTheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorTheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  FluentIcons.location_24_filled,
                  size: 20,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 16),

              // Location Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main location name
                    Text(
                      locationParts['name']!,
                      style: TextStyle(
                        fontFamily: fontTheme.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Address/description
                    if (locationParts['address']!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        locationParts['address']!,
                        style: TextStyle(
                          fontFamily: fontTheme.fontFamily,
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Distance indicator (optional)
                    if (showDistance && distance != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          distance!,
                          style: TextStyle(
                            fontFamily: fontTheme.fontFamily,
                            fontSize: 11,
                            color: ColorTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow indicator
              Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to parse location string
  Map<String, String> _parseLocation(String location) {
    final parts = location.split(',');
    if (parts.length > 1) {
      return {
        'name': parts[0].trim(),
        'address': parts.sublist(1).join(',').trim(),
      };
    } else {
      return {
        'name': location.trim(),
        'address': '',
      };
    }
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
