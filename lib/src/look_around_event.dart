class LookAroundEvent<T> {
  /// The ID of the look around this event is associated to.
  final int viewId;

  /// The value wrapped by this event
  final T value;

  /// Build a look around Event, that relates a viewId with a given value.
  ///
  /// The `viewId` is the id of the look around that triggered the event.
  /// `value` may be `null` in events that don't transport any meaningful data.
  LookAroundEvent(this.viewId, this.value);
}

/// Event that is triggered when the look around is available.
class LookAroundIsAvailableEvent extends LookAroundEvent<bool> {
  final bool isAvailable;
  final String message;

  LookAroundIsAvailableEvent(int viewId, this.isAvailable, this.message)
      : super(viewId, isAvailable);
}
