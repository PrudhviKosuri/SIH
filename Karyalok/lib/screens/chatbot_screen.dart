import 'package:flutter/material.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/report_form_widget.dart';
import '../models/chat_message.dart';
import '../styles/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addBotWelcomeMessage();
  }

  void _addBotWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          text:
              'Hello! I\'m your civic assistant. How can I help you today?\n\n'
              'You can:\n'
              '• Report a civic issue\n'
              '• Check status of previous reports\n'
              '• Get information about civic services',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _handleSubmitted(String text, List<String> attachments) {
    if (text.trim().isEmpty && attachments.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
          attachments: attachments,
        ),
      );

      // Simulate bot response
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            if (text.toLowerCase().contains('report') ||
                text.toLowerCase().contains('issue')) {
              _messages.add(
                ChatMessage(
                  text:
                      'Would you like to submit a formal report? Tap the button below:',
                  isUser: false,
                  timestamp: DateTime.now(),
                  action: ChatAction.showReportForm,
                ),
              );
            } else {
              _messages.add(
                ChatMessage(
                  text: 'I understand you\'re trying to say: $text\n\n'
                      'How else can I assist you?',
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              );
            }
          });
          _scrollToBottom();
        }
      });
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleActionTap(ChatAction action) {
    switch (action) {
      case ChatAction.showReportForm:
        _showReportForm();
        break;
      default:
        break;
    }
  }

  void _showReportForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ReportFormWidget(
                  onSubmitted: (report) {
                    Navigator.pop(context);
                    setState(() {
                      _messages.add(
                        ChatMessage(
                          text:
                              'Thank you for submitting your report about: ${report.title}',
                          isUser: false,
                          timestamp: DateTime.now(),
                        ),
                      );
                    });
                    _scrollToBottom();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Civic Assistant',
                  style: TextStyle(
                    color: AppTheme.neutral800,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppTheme.neutral600,
            ),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(
                  message: _messages[index],
                  onActionTap: _handleActionTap,
                );
              },
            ),
          ),
          ChatInputWidget(
            onSubmitted: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
