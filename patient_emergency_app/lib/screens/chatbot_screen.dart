// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _typing = false;

  // ── Simple keyword-based bot responses ──────────────────────────────────
  static const Map<String, String> _responses = {
    'icu': 'ICU (Intensive Care Unit) availability varies by hospital. Use the Hospitals tab to filter hospitals with ICU available near you.',
    'oxygen': 'You can check oxygen availability in the Hospitals tab — it shows a badge for each hospital that has oxygen.',
    'bed': 'Available beds are shown on each hospital card. Tap "Appointment" to reserve a bed.',
    'admission': 'To get admitted: submit an Emergency Report → browse Hospitals → tap "Appointment" → wait for admin approval in the Status tab.',
    'discharge': 'Discharge is managed by the hospital admin. You will see the update in your Admission Status tab once processed.',
    'appointment': 'To book: go to Hospitals tab → select a hospital → tap "Take Appointment". The hospital admin will respond shortly.',
    'emergency': 'For emergencies: fill the Emergency Report form (first tab). Choose the type, describe the condition, auto-detect your location, and submit.',
    'blood': 'Blood group information was set during registration. Visit your Profile tab to review it.',
    'fever': 'High fever (above 103°F / 39.4°C) is a critical symptom. Please submit an Emergency Report immediately and go to the nearest hospital.',
    'chest': 'Chest pain can indicate a heart attack. This is life-threatening — call emergency services immediately or submit an Emergency Report now.',
    'breathing': 'Breathing difficulty is a medical emergency. Submit an Emergency Report immediately. If severe, call 112.',
    'pregnant': 'Pregnancy emergencies should be reported using the Emergency Report form — select "Pregnancy" as the type.',
    'hi': 'Hello! I\'m MediCare\'s support bot. Ask me about ICU availability, hospital admissions, emergency procedures, or any health-related doubts.',
    'hello': 'Hi there! How can I assist you today? You can ask about hospital resources, admissions, or emergency guidance.',
    'help': 'I can help with:\n• Hospital resource availability (ICU, Oxygen, Beds)\n• Admission process\n• Emergency report guidance\n• General doubt based on your emergency type',
  };

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _ctrl.clear();
      _typing = true;
    });
    _scroll.animateTo(_scroll.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 900), () {
      final response = _getResponse(text.toLowerCase());
      setState(() {
        _messages.add(
            ChatMessage(text: response, isUser: false, time: DateTime.now()));
        _typing = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    });
  }

  String _getResponse(String input) {
    for (final key in _responses.keys) {
      if (input.contains(key)) return _responses[key]!;
    }
    return 'I\'m not sure about that. Try asking about: ICU, oxygen, beds, admission, discharge, appointments, emergency types, or specific symptoms like fever, chest pain, or breathing difficulty.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MediBot',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('Support Assistant',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Suggested questions
          if (_messages.isEmpty) _buildSuggestions(),

          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length) return _buildTypingIndicator();
                return _buildBubble(_messages[i]);
              },
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Ask about ICU, admission, emergency...',
                      hintStyle: const TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggested Questions',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    fontSize: 12)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'ICU availability',
                'How to get admitted?',
                'Oxygen available?',
                'Emergency report help',
                'Chest pain',
              ]
                  .map((q) => GestureDetector(
                        onTap: () {
                          _ctrl.text = q;
                          _send();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(q,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _buildBubble(ChatMessage msg) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isUser) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.smart_toy, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 6),
            ],
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                ),
                border: msg.isUser
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                    color: msg.isUser ? Colors.white : AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.5),
              ),
            ),
          ],
        ),
      );

  Widget _buildTypingIndicator() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    3,
                    (i) => _Dot(delay: Duration(milliseconds: i * 200))),
              ),
            ),
          ],
        ),
      );
}

class _Dot extends StatefulWidget {
  final Duration delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _a = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FadeTransition(
          opacity: _a,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
}
