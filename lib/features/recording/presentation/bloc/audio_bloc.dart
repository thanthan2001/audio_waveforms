import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_event.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_state.dart';
import 'package:bloc/bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final RecorderController recorderController = RecorderController();

  AudioBloc() : super(AudioInitial()) {
    on<ShowModalEvent>((event, emit) {
      // Lần nhấn mic đầu tiên: Hiển thị modal, chưa ghi âm
      emit(ShowModalState());
    });

    on<StartRecordingEvent>((event, emit) async {
      // Nhấn mic lần 2 (khi đang ở ShowModalState) để bắt đầu ghi âm
      await recorderController.checkPermission();
      if (recorderController.hasPermission) {
        await recorderController.record();
        emit(RecordingState(recorderController));
      }
    });

    on<ShowRecordPanelEvent>((event, emit) {
      emit(PanelOpenedState());
    });

    on<StopRecordingEvent>((event, emit) async {
      final recordedFilePath = await recorderController.stop();
      recorderController.reset();
      emit(StoppedRecordingState(recordedFilePath));
    });

    on<ResetEvent>((event, emit) {
      recorderController.reset();
      emit(AudioInitial());
    });
  }
}
