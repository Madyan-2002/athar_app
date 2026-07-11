import 'package:alkher/services/feedback_service.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FeedbackUserScreen extends StatefulWidget {
  const FeedbackUserScreen({super.key});

  @override
  State<FeedbackUserScreen> createState() => _FeedbackUserScreenState();
}

class _FeedbackUserScreenState extends State<FeedbackUserScreen> {
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;
  int _rating = 5;

  Future<void> _sendFeedback() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى كتابة ملاحظتك"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await FeedbackService().sendFeedback(
      message: message,
      rating: _rating,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("شكراً لك، تم إرسال ملاحظتك."),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حدث خطأ أثناء الإرسال"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      splashRadius: 20,
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
      icon: Icon(
        index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
        color: Colors.amber,
        size: 34,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          "إرسال ملاحظة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Center(
              child: Icon(
                Icons.feedback_rounded,
                color: AppColors.primary,
                size: 80,
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Text(
                "يسعدنا سماع رأيك",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                "شاركنا اقتراحاتك أو أخبرنا بأي مشكلة واجهتك داخل التطبيق.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "التقييم",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, _buildStar),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "اكتب ملاحظتك",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "اكتب رسالتك هنا...",
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "إرسال",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
