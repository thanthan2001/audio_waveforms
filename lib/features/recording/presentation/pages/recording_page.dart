import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_bloc.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_event.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_state.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Audio Recorder"),
        ),
        body: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            final bloc = BlocProvider.of<AudioBloc>(context);

            if (state is RecordingState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => bloc.add(StopRecordingEvent()),
                    child: const Text("Stop Recording"),
                  ),
                  const SizedBox(height: 20),
                  AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 100),
                    recorderController: state.recorderController,
                  ),
                ],
              );
            } else if (state is StoppedRecordingState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Recording Stopped"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => bloc.add(StartRecordingEvent()),
                      child: const Text("Start Recording Again"),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () => bloc.add(StartRecordingEvent()),
                  child: const Text("Start Recording"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
