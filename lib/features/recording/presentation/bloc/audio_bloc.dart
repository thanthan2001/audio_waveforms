import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_event.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_state.dart';
import 'package:bloc/bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final RecorderController recorderController = RecorderController();

  AudioBloc() : super(AudioInitial()) {
    on<StartRecordingEvent>((event, emit) async {
      await recorderController.checkPermission();
      if (recorderController.hasPermission) {
        final dataRecord = recorderController.record();
        emit(RecordingState(recorderController));
      }
    });

    on<StopRecordingEvent>((event, emit) async {
      final recordedFilePath = await recorderController.stop();
      recorderController.reset();
      emit(StoppedRecordingState(recordedFilePath));
    });
  }
}
