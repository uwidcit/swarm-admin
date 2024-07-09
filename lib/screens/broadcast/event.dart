abstract class BroadcastEvent {}

class InitEvent extends BroadcastEvent {}

class BroadcastCreateEvent extends BroadcastEvent {
  final String text;
  BroadcastCreateEvent(this.text);
}
