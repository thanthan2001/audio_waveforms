import 'package:audio_waveforms/audio_waveforms.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class ShowModalState extends AudioState {
  // Trạng thái hiển thị modal nhưng chưa ghi âm
}

class RecordingState extends AudioState {
  final RecorderController recorderController;
  RecordingState(this.recorderController);
}

class StoppedRecordingState extends AudioState {
  final String? recordedFilePath;
  StoppedRecordingState(this.recordedFilePath);
}

class PanelOpenedState extends AudioState {}
