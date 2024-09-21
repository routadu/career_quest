import 'package:cloud_functions/cloud_functions.dart';

class GeminiService {
  Future<String> getResponse(String query) async {
    HttpsCallable req = FirebaseFunctions.instance.httpsCallable("geminiRes");
    final response = await req.call(<String, dynamic>{"prompt": query});
    if (response.data != null) {
      final map = Map.from(response.data);
      if (map.containsKey("prompt_response")) {
        return map["prompt_response"];
      } else {
        return "No response";
      }
    } else {
      return "Some error occured";
    }
  }
}
