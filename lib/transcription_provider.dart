import 'package:flutter/foundation.dart';

class TranscriptionProvider with ChangeNotifier {
  String _transcription = "Start speaking to see the transcription here...";

  String get transcription => _transcription;

  void updateTranscription(String newTranscription) {
    _transcription = newTranscription;
    notifyListeners();
  }

  void resetTranscription() {
    _transcription = "Start speaking to see the transcription here...";
    notifyListeners();
  }
}
