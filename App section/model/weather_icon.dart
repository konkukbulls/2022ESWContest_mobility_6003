import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';


class WeatherIcon {
  Widget? getWeatherIcon(condition) {
    if (condition < 300) {
      return SvgPicture.asset(
        'svg/cloud_lightning.svg',
        color: Colors.black87,
        fit: BoxFit.contain,
      );
    } else if (condition < 600) {
      return SvgPicture.asset(
        'svg/cloud_rain.svg',
        color: Colors.black87,
        fit: BoxFit.contain,
      );
    } else if (condition == 800) {
      return SvgPicture.asset(
        'svg/sun.svg',
        color: Colors.black87,
        fit: BoxFit.contain,
      );
    } else if (condition <= 804) {
      return SvgPicture.asset(
        'svg/cloud_sun.svg',
        color: Colors.black87,
        fit: BoxFit.contain,
      );
    }
    return null;
  }
}
