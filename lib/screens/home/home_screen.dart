import 'dart:io'; // Importing dart:io for file operations.
import 'package:flutter/cupertino.dart'; // Importing Cupertino widgets.
import 'package:flutter/material.dart'; // Importing Material widgets.
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts package.
import 'package:just_audio/just_audio.dart'; // Importing Just Audio package for audio playback.
import 'package:path_provider/path_provider.dart'; // Importing Path Provider for accessing the file system.
import 'package:record/record.dart'; // Importing Record package for audio recording.
import 'package:path/path.dart'
    as p; // Importing Path package with alias 'p' for path operations.

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key}); // Constructor for HomeScreen.

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState(); // Creating state for HomeScreen.
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioRecorder audioRecorder =
      AudioRecorder(); // Creating an instance of AudioRecorder.
  String? recordingPath; // Variable to store the path of the recording.
  bool isRecording = false,
      isPlaying = false; // Variables to manage recording and playing state.
  final AudioPlayer audioPlayer =
      AudioPlayer(); // Creating an instance of AudioPlayer.

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
              // Applying Poppins font to the title text
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
                width: 8), // Adding some space between the text and the icon.
            const Icon(CupertinoIcons.mic_solid), // Adding a microphone icon.
          ],
        ),
      ),
      floatingActionButton:
          _recordingButton(), // Floating action button for recording.
      body: _buildUI(), // Building the main UI of the screen.
    );
  }

  /// UI

  // Building the main UI of the screen.
  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (recordingPath != null) // Checking if there is a recording.
            MaterialButton(
              onPressed: () async {
                if (audioPlayer.playing) {
                  audioPlayer
                      .stop(); // Stop playing the recording if already playing.
                  setState(() {
                    isPlaying = false; // Update the playing state.
                  });
                } else {
                  await audioPlayer.setFilePath(
                      recordingPath!); // Set the file path for the audio player.
                  audioPlayer.play(); // Start playing the recording.
                  setState(() {
                    isPlaying = true; // Update the playing state.
                  });
                }
              },
              child: Text(isPlaying
                  ? "Stop Playing Recording"
                  : "Start Playing Recording"), // Button text changes based on playing state.
            ),
          if (recordingPath == null)
            Text('No recording found'), // Display if no recording is found.
        ],
      ),
    );
  }

  // Widget for the recording button.
  Widget _recordingButton() {
    return FloatingActionButton(
      highlightElevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      elevation: 2,
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop(); // Stop the recording.
          if (filePath != null) {
            setState(() {
              isRecording = false; // Update the recording state.
              recordingPath = filePath; // Set the recording path.
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            // Check for recording permission.
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory(); // Get the directory to save the recording.

            final String filePath = p.join(appDocumentsDir.path,
                "recording.wav"); // Set the file path for the recording.
            await audioRecorder.start(
              RecordConfig(), // Start the recording with the specified configuration.
              path: filePath,
            );
            setState(() {
              isRecording = true; // Update the recording state.
              recordingPath = null; // Reset the recording path.
            });
          }
        }
      },
      child: Icon(
        isRecording
            ? Icons.stop
            : Icons.mic, // Icon changes based on recording state.
      ),
    );
  }
}
