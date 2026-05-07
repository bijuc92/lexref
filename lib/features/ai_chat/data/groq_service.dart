import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../shared/models/local/local_chat_message.dart';

const _systemPrompt = '''You are LexRef AI, a legal research assistant for Indian advocates.
You help with:
- Explaining Indian law sections (IPC, CrPC, CPC, Evidence Act) in clear language
- Summarizing court judgments
- Citing relevant precedents
- Answering procedural questions

Always:
- Cite the exact section number and act when referencing law (e.g., "Section 302 IPC")
- Mention relevant Supreme Court or High Court judgments when known
- Add a disclaimer that this is for research purposes and not legal advice
- Keep responses concise and structured with bullet points where needed
- Use Indian legal terminology correctly
- Format your responses using markdown for readability''';

class GroqService {
  Future<String> chat(
    List<LocalChatMessage> history,
    String userMessage,
  ) async {
    final messages = [
      {'role': 'system', 'content': _systemPrompt},
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await ApiClient.groq.post(
      '/chat/completions',
      data: {
        'model': ApiConstants.groqModel,
        'messages': messages,
        'max_tokens': ApiConstants.groqMaxTokens,
        'temperature': ApiConstants.groqTemperature,
        'stream': false,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    return response.data['choices'][0]['message']['content'] as String;
  }
}
