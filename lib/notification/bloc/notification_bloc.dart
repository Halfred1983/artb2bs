import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_service/notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required NotificationService notificationRepository})
      : _notificationService = notificationRepository,
        super(const NotificationState.initial()) {
    on<_NotificationOpened>(_onNotificationOpened);
    on<_NotificationInForegroundReceived>(_onNotificationInForegroundReceived);
    _notificationService.onNotificationOpened.listen((notification) {
      add(_NotificationOpened(notification: notification));
    });
    _notificationService.onForegroundNotification.listen(
          (notification) {
        add(_NotificationOpened(notification: notification));
      },
    );
  }

  final NotificationService _notificationService;

  void _onNotificationOpened(
      _NotificationOpened event,
      Emitter<NotificationState> emit,
      ) {
    emit(
      state.copyWith(
        notification: event.notification,
        appState: AppState.background,
      ),
    );
  }

  void _onNotificationInForegroundReceived(
      _NotificationInForegroundReceived event,
      Emitter<NotificationState> emit,
      ) {
    emit(
      state.copyWith(
        notification: event.notification,
        appState: AppState.foreground,
      ),
    );
  }
}