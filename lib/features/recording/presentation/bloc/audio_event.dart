abstract class AudioEvent {}

class ShowModalEvent extends AudioEvent {} // Sự kiện cho lần nhấn đầu tiên

class StartRecordingEvent extends AudioEvent {}

class StopRecordingEvent extends AudioEvent {}

class ResetEvent extends AudioEvent {}

class ShowRecordPanelEvent extends AudioEvent {}
