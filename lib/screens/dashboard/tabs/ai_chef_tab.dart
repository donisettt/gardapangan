import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Tab Chatbot AI (Chef Pintar).
/// Menggunakan Google Generative AI SDK.
class AiChefTab extends StatefulWidget {
  const AiChefTab({super.key});

  @override
  State<AiChefTab> createState() => _AiChefTabState();
}

class _AiChefTabState extends State<AiChefTab> {
  // TODO: Simpan API Key di tempat aman (.env) untuk produksi
  static const String _apiKey = 'GANTI_INI_DENGAN_KUNCI_BARU_DARI_KONSOL_ANDA';
  
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Model Gemini Flash Lite (Cepat & Ringan)
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: _apiKey,
    );
  }

  /// Mengirim pesan user ke Gemini dan mendapatkan balasan.
  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    setState(() {
      _chatHistory.add({"role": "user", "text": message});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final prompt = "Kamu adalah Chef profesional Food Rescue. "
          "Berikan ide masakan singkat, kreatif, dan hemat dari bahan ini: $message";
          
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      setState(() {
        _chatHistory.add({
          "role": "ai", 
          "text": response.text ?? "Maaf, saya tidak bisa menjawab saat ini."
        });
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "role": "ai", 
          "text": "Terjadi kesalahan koneksi. Silakan coba lagi."
        });
      });
      debugPrint("Gemini Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Area Chat List
          Expanded(
            child: _chatHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.soup_kitchen, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Punya bahan sisa di kulkas?\nTanya Chef AI sekarang!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chatHistory.length,
                    itemBuilder: (context, index) {
                      final chat = _chatHistory[index];
                      final isUser = chat['role'] == 'user';
                      
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser ? colorScheme.primary : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
                              bottomRight: isUser ? Radius.zero : const Radius.circular(12),
                            ),
                            boxShadow: isUser ? [] : [
                              const BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                            ],
                          ),
                          child: Text(
                            chat['text']!,
                            style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Loading Indicator Bar
          if (_isLoading) const LinearProgressIndicator(minHeight: 2),

          // Area Input Teks
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Cth: Ada nasi & telur sisa...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(), // Kirim saat Enter ditekan
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  mini: true,
                  elevation: 0,
                  backgroundColor: _isLoading ? Colors.grey : colorScheme.primary,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}