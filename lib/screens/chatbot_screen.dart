import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [];
  bool _isTyping = false;

  final List<String> _quickReplies = [
    'Hospital resource availability',
    'Admission process',
    'Emergency symptoms',
    'ICU availability near me',
    'How to book appointment?',
  ];

  final Map<String, String> _botResponses = {
    'hospital resource availability':
        'I can help you check hospital resources! Currently, Kokilaben Hospital has 12 ICU beds and full oxygen supply. Hiranandani has 6 ICU beds available. Would you like me to show the complete list?',
    'admission process':
        'The admission process involves:\n1. Submit Emergency Report\n2. Hospital Admin reviews your request\n3. Accept/Reject Appointment\n4. If accepted, Admit/Discharge with date & time\n5. Track in Admission Status tab\n\nWould you like more details?',
    'emergency symptoms':
        'Common emergency symptoms requiring immediate attention:\n• Chest Pain / Heart Attack\n• Breathing Difficulty\n• Severe Injury / Trauma\n• Heavy Bleeding\n• High Fever (>104°F)\n• Unconsciousness\n• Low Oxygen Levels\n\nCall 108 immediately for life-threatening emergencies!',
    'icu availability near me':
        'Based on your location (Andheri West), ICU availability:\n✅ Kokilaben Hospital - 12 ICU beds\n✅ Hiranandani Hospital - 6 ICU beds\n✅ Lilavati Hospital - 3 ICU beds\n❌ Breach Candy - Currently full\n\nWould you like directions to the nearest?',
    'how to book appointment?':
        'To book an appointment:\n1. Go to the Hospitals tab\n2. Select your preferred hospital\n3. Tap "Book Appointment"\n4. Your request goes to Admin\n5. Track status in Admission Status tab\n\nSimple and easy! Anything else?',
  };

  @override
  void initState() {
    super.initState();
    _addBotMessage(
        "Hello! 👋 I'm MedBot, your healthcare assistant. I can help you with:\n\n• Hospital resource availability\n• Admission process questions\n• Emergency guidance\n• General health doubts\n\nHow can I assist you today?");
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(_Message(text: text, isUser: false, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(_Message(text: text, isUser: true, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messageController.clear();
    _addUserMessage(text);

    setState(() => _isTyping = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    String response = _getResponse(text.toLowerCase());
    setState(() => _isTyping = false);
    _addBotMessage(response);
  }

  String _getResponse(String query) {
    for (final key in _botResponses.keys) {
      if (query.contains(key.split(' ').first) ||
          key.contains(query.split(' ').first)) {
        return _botResponses[key]!;
      }
    }
    return "Thank you for your question! For specific medical emergencies, please call 108. For hospital information, visit the Hospitals tab. For admission tracking, check the Admission Status tab.\n\nIs there anything specific I can help you with?";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D9D78),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Color(0xFF2D9D78), size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MedBot',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('Online',
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[i]);
              },
            ),
          ),

          // Quick replies
          if (_messages.length <= 2)
            Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _quickReplies.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => _sendMessage(_quickReplies[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D9D78).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF2D9D78).withOpacity(0.3)),
                    ),
                    child: Text(_quickReplies[i],
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF2D9D78),
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask anything about healthcare...',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                              color: Color(0xFF2D9D78), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onSubmitted: _sendMessage,
                      style:
                          GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_messageController.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D9D78),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_Message msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2D9D78),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isUser
                      ? Colors.white
                      : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppColors.primary, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF2D9D78),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0),
                const SizedBox(width: 4),
                _dot(200),
                const SizedBox(width: 4),
                _dot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF2D9D78),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('About MedBot',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
          'MedBot can assist you with:\n\n• Hospital resource availability\n• Admission process queries\n• Emergency symptom guidance\n• General healthcare questions\n\nFor life-threatening emergencies, always call 108.',
          style: GoogleFonts.poppins(fontSize: 13, height: 1.6),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D9D78),
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final DateTime time;

  _Message({required this.text, required this.isUser, required this.time});
}
