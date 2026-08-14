import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(showBack: true, title: value.name),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView.builder(
                  controller: value.scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    final mine = value.chatList[index].senderId.toString() ==
                        value.uid.toString();
                    final text = value.chatList[index].message.toString();
                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: mine
                              ? ThemeProvider.gold
                              : ThemeProvider.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(mine ? 14 : 4),
                            bottomRight: Radius.circular(mine ? 4 : 14),
                          ),
                        ),
                        child: Text(
                          text,
                          style: ThemeProvider.sans(
                            size: 14,
                            color: mine ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: ThemeProvider.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF2C2C2C)),
                        ),
                        child: TextField(
                          controller: value.message,
                          style: ThemeProvider.sans(size: 14),
                          cursorColor: ThemeProvider.gold,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Message...'.tr,
                            hintStyle: ThemeProvider.sans(
                                size: 14, color: ThemeProvider.greyColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: value.sendMessage,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: ThemeProvider.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
