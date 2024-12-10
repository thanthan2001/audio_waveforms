import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_bloc.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_event.dart';
import 'package:audio_example_appv2/features/recording/presentation/bloc/audio_state.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  String _formatDuration(int milliseconds) {
    final seconds = (milliseconds ~/ 1000) % 60;
    final minutes = (milliseconds ~/ 60000) % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ZiiChat"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text("👨‍🎨", style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        "Gửi tin nhắn\nhoặc nhấn để gửi nhãn dán Hi",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                final bloc = BlocProvider.of<AudioBloc>(context);

                // Thanh nhập tin nhắn + icon micro (mặc định)
                Widget bottomBar = Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Aa",
                              hintStyle: TextStyle(color: Colors.white60),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          // Nhấn icon micro để bắt đầu ghi
                          bloc.add(StartRecordingEvent());
                        },
                        icon: const Icon(Icons.mic, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.blue),
                      ),
                    ],
                  ),
                );

                if (state is RecordingState) {
                  final recorderController = state.recorderController;

                  return Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Thanh nhỏ bên trên (gợi ý panel có thể trượt)
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Đang ghi âm",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        // Hiển thị thời gian ghi âm
                        StreamBuilder<Duration>(
                          stream: recorderController.onCurrentDuration,
                          builder: (context, snapshot) {
                            final duration = snapshot.data?.inMilliseconds ?? 0;
                            final timeString = _formatDuration(duration);
                            return Text(
                              timeString,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Sóng âm
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AudioWaveforms(
                            enableGesture: false,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.blue,
                              showMiddleLine: false,
                              extendWaveform: true,
                            ),
                            size: const Size(double.infinity, 50),
                            recorderController: recorderController,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                bloc.add(ResetEvent());
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                bloc.add(StopRecordingEvent());
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_upward,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                            // Nút Stop
                            GestureDetector(
                              onTap: () {
                                bloc.add(StopRecordingEvent());
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    const Icon(Icons.stop, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  );
                } else if (state is StoppedRecordingState) {
                  return bottomBar;
                } else {
                  return bottomBar;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
