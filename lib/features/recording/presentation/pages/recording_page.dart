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
        body: Column(
          children: [
            // Giả lập danh sách tin nhắn
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: 10, // Số lượng tin nhắn mẫu
                itemBuilder: (context, index) {
                  return Align(
                    alignment: index.isEven
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.grey.shade300
                            : Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Message ${index + 1}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Ô ghi âm ở cuối màn hình
            BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                final bloc = BlocProvider.of<AudioBloc>(context);
                if (state is RecordingState) {
                  return Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AudioWaveforms(
                            enableGesture:
                                true, // Enable/disable scrolling of the waveforms.
                            waveStyle: const WaveStyle(
                              extendWaveform: true, // Mở rộng sóng âm
                              waveColor: Colors.blue, // Màu sóng âm
                              showMiddleLine: false, // Ẩn đường line đỏ
                            ),
                            size: const Size(double.infinity, 50),
                            recorderController: state.recorderController,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: () => bloc.add(StopRecordingEvent()),
                          icon: const Icon(Icons.stop, color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                } else if (state is StoppedRecordingState) {
                  return Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Recording stopped.",
                          style: TextStyle(color: Colors.black),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => bloc.add(StartRecordingEvent()),
                          icon: const Icon(Icons.mic, color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Press the mic to start recording.",
                          style: TextStyle(color: Colors.black),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => bloc.add(StartRecordingEvent()),
                          icon: const Icon(Icons.mic, color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
