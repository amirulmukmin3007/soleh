part of 'qibla_direction_cubit.dart';

class QiblaDirectionState extends Equatable {
  final double qiblaDirection;
  const QiblaDirectionState({this.qiblaDirection = 0.0});

  QiblaDirectionState copyWith({double? qiblaDirection}) {
    return QiblaDirectionState(
        qiblaDirection: qiblaDirection ?? this.qiblaDirection);
  }

  @override
  List<Object> get props => [qiblaDirection];
}
