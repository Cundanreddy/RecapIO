import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transcription_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListening = false;
  String _transcription = "Start speaking to see the transcription here...";
  late stt.SpeechToText _speech; // Speech-to-Text instance
  double _confidence = 1.0; // Confidence score for transcription

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recapio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current confidence score
            Text(
              "Confidence: $_confidence",
              style: const TextStyle(fontSize: 18),
            ),
            // Display the Transcription using Provider
            Expanded(
              child: Container(
                width: double
                    .infinity, // Make the container take all the available width
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
            ElevatedButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
              label: Text(_isListening ? "Stop Listening" : "Start Listening"),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => _onSpeechStatus(val), //print('onStatus:$val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        listenFor: Duration(seconds: 500), // Adjust as needed
        pauseFor: Duration(seconds: 50), // Adjust as needed
        onResult: (val) => setState(() {
          _transcription += val.recognizedWords;
          _confidence = val.confidence;
          context
              .read<TranscriptionProvider>()
              .updateTranscription(_transcription);
        }),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechStatus(String status) {
    if ((status == "notListening" || status == "done") && _isListening) {
      // Restart listening if it stops due to silence
      _startListening();
    }
  }
}
