import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'qibla_direction_state.dart';

class QiblaDirectionCubit extends Cubit<QiblaDirectionState> {
  QiblaDirectionCubit() : super(QiblaDirectionState());
  static const double kaabaLat = 21.4225;
  static const double kaabaLon = 39.8262;

  void updateQiblaDirection(double lat, double lng) {
    final qiblaDirection = _calculateQiblaDirection(lat, lng);

    emit(state.copyWith(qiblaDirection: qiblaDirection));
  }

  double _calculateQiblaDirection(double userLat, double userLon) {
    double lat1 = userLat * (math.pi / 180);
    double lon1 = userLon * (math.pi / 180);
    double lat2 = kaabaLat * (math.pi / 180);
    double lon2 = kaabaLon * (math.pi / 180);

    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x);
    bearing = bearing * (180 / math.pi);
    bearing = (bearing + 360) % 360;

    return bearing;
  }
}
