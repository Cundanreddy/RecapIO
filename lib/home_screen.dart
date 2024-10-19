import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transcription_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListening = false;
  String _transcription = "Start speaking to see the transcription here...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recapio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the Transcription using Provider
            Expanded(
              child: Container(
                // margin: EdgeInsets.all(50),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _transcription,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Start/Stop Recording Button
            ElevatedButton.icon (
              onPressed: _toggleListening,
              icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
              
              label: Text(_isListening ? "Stop Listening" : "Start Listening"),
            )
            // ElevatedButton.icon(
            //   onPressed: _toggleListening,
            //   icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
            //   label: Text(_isListening ? "Stop Listening" : "Start Listening"),
            // ),
          ],
        ),
      ),
    );
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      _transcription = _isListening ? "Listening..." : "Transcription will appear here.";
    });
    // Start/Stop the speech recognition service here
    // if (_isListening) {
    //   context.read<TranscriptionProvider>().updateTranscription("Listening...");
    // } else {
    //   context.read<TranscriptionProvider>().resetTranscription();
    // }
    // Implement the speech recognition start/stop logic here
  }
}
