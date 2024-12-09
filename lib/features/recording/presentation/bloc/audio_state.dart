import 'package:audio_waveforms/audio_waveforms.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class RecordingState extends AudioState {
  final RecorderController recorderController;
  RecordingState(this.recorderController);
}

class StoppedRecordingState extends AudioState {
  final String? recordedFilePath;
  StoppedRecordingState(this.recordedFilePath);
}
