import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_chat_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class AccountChatScreen extends StatefulWidget {
  const AccountChatScreen({Key? key}) : super(key: key);

  @override
  State<AccountChatScreen> createState() => _AccountChatScreenState();
}

class _AccountChatScreenState extends State<AccountChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(showBack: true, title: 'Messages'),
          body: !value.parser.haveLoggedIn()
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            size: 48, color: ThemeProvider.gold),
                        const SizedBox(height: 16),
                        Text('Login Required'.tr,
                            style: ThemeProvider.serif(size: 20)),
                        const SizedBox(height: 20),
                        EliteGoldButton(
                          label: 'LOGIN / REGISTER',
                          onTap: value.onLoginRoutes,
                        ),
                      ],
                    ),
                  ),
                )
              : value.apiCalled == false
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: ThemeProvider.gold),
                    )
                  : value.chatList.isEmpty
                      ? const EliteApiUnavailable(minHeight: 180)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: value.chatList.length,
                          itemBuilder: (context, index) {
                            final chat = value.chatList[index];
                            final isSender =
                                chat.senderId.toString() == value.uid;
                            final userId = isSender
                                ? chat.receiverId.toString()
                                : chat.senderId.toString();
                            final userName = isSender
                                ? '${chat.receiverName} ${chat.receiverLastName}'
                                : '${chat.senderFirstName} ${chat.senderLastName}';
                            final userImage = isSender
                                ? chat.receiverCover
                                : chat.senderCover;
                            return EliteCard(
                              child: InkWell(
                                onTap: () => value.onChat(userId, userName),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: EliteNetworkImage(
                                          url:
                                              '${Environments.imageURL}$userImage',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(userName,
                                              style: ThemeProvider.serif(
                                                  size: 16)),
                                          const SizedBox(height: 4),
                                          Text(
                                            chat.updatedAt.toString(),
                                            style: ThemeProvider.sans(
                                                size: 11,
                                                color: ThemeProvider.greyColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right,
                                        color: ThemeProvider.gold),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
        );
      },
    );
  }
}
