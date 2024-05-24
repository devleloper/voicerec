import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AudioRecorder audioRecorder = AudioRecorder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VoiceRec',
              // Apply Poppins font to the title text
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(CupertinoIcons.mic_solid),
          ],
        ),
      ),
      floatingActionButton: _recordingButton(),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.record_voice_over_rounded),
    );
  }
}
