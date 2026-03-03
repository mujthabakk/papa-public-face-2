// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/account_chat_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class AccountChatScreen extends StatefulWidget {
//   const AccountChatScreen({Key? key}) : super(key: key);

//   @override
//   State<AccountChatScreen> createState() => _AccountChatScreenState();
// }

// class _AccountChatScreenState extends State<AccountChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AccountChatController>(
//       builder: (value) {
//         return Scaffold(
//           backgroundColor: ThemeProvider.backgroundColor,
//           appBar: AppBar(
//             backgroundColor: ThemeProvider.appColor,
//             iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//             elevation: 0,
//             centerTitle: true,
//             title: Text(
//               'Inbox'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: value.parser.haveLoggedIn() == false
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset('assets/images/search.png',
//                           width: 60, height: 60),
//                       const SizedBox(height: 30),
//                       TextButton(
//                           onPressed: () {
//                             value.onLoginRoutes();
//                           },
//                           child: Text(
//                             'Opps, Please Login or Register first!'.tr,
//                             style: const TextStyle(
//                                 fontFamily: 'bold',
//                                 color: ThemeProvider.appColor),
//                           )),
//                     ],
//                   ),
//                 )
//               : value.apiCalled == false
//                   ? SkeletonListView(
//                       itemCount: 5,
//                     )
//                   : value.chatList.isEmpty
//                       ? Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const SizedBox(height: 20),
//                               SizedBox(
//                                 height: 80,
//                                 width: 80,
//                                 child: Image.asset(
//                                   "assets/images/no-data.png",
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               ),
//                             ],
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             children:
//                                 List.generate(value.chatList.length, (index) {
//                               return value.chatList[index].senderId
//                                           .toString() ==
//                                       value.uid
//                                   ? GestureDetector(
//                                       onTap: () {
//                                         value.onChat(
//                                             value.chatList[index].receiverId
//                                                 .toString(),
//                                             '${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName}');
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16, vertical: 10),
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 8),
//                                         decoration: BoxDecoration(
//                                           color: ThemeProvider.whiteColor,
//                                           borderRadius: const BorderRadius.all(
//                                             Radius.circular(8),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: ThemeProvider.blackColor
//                                                     .withOpacity(0.2),
//                                                 offset: const Offset(0, 1),
//                                                 blurRadius: 3),
//                                           ],
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             SizedBox(
//                                                 height: 30,
//                                                 width: 30,
//                                                 child: FadeInImage(
//                                                   height: 30,
//                                                   width: 30,
//                                                   image: NetworkImage(
//                                                       '${Environments.imageURL}${value.chatList[index].receiverCover}'),
//                                                   placeholder: const AssetImage(
//                                                       "assets/images/placeholder.jpeg"),
//                                                   imageErrorBuilder: (context,
//                                                       error, stackTrace) {
//                                                     return Image.asset(
//                                                         'assets/images/notfound.png',
//                                                         height: 30,
//                                                         width: 30,
//                                                         fit: BoxFit.fitWidth);
//                                                   },
//                                                   fit: BoxFit.fitWidth,
//                                                 )),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         '${value.chatList[index].receiverName} ${value.chatList[index].receiverLastName}',
//                                                         style: const TextStyle(
//                                                             fontSize: 14,
//                                                             fontFamily:
//                                                                 'medium',
//                                                             color: ThemeProvider
//                                                                 .blackColor),
//                                                       ),
//                                                       Text(
//                                                         value.chatList[index]
//                                                             .updatedAt
//                                                             .toString(),
//                                                         style: const TextStyle(
//                                                             fontSize: 12,
//                                                             color: ThemeProvider
//                                                                 .greyColor),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   : GestureDetector(
//                                       onTap: () {
//                                         value.onChat(
//                                             value.chatList[index].senderId
//                                                 .toString(),
//                                             '${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName}');
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16, vertical: 10),
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 8),
//                                         decoration: BoxDecoration(
//                                           color: ThemeProvider.whiteColor,
//                                           borderRadius: const BorderRadius.all(
//                                             Radius.circular(8),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: ThemeProvider.blackColor
//                                                     .withOpacity(0.2),
//                                                 offset: const Offset(0, 1),
//                                                 blurRadius: 3),
//                                           ],
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                                 clipBehavior: Clip.antiAlias,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                                 height: 30,
//                                                 width: 30,
//                                                 child: FadeInImage(
//                                                   height: 30,
//                                                   width: 30,
//                                                   image: NetworkImage(
//                                                       '${Environments.imageURL}${value.chatList[index].senderCover}'),
//                                                   placeholder: const AssetImage(
//                                                       "assets/images/placeholder.jpeg"),
//                                                   imageErrorBuilder: (context,
//                                                       error, stackTrace) {
//                                                     return Image.asset(
//                                                         'assets/images/notfound.png',
//                                                         height: 30,
//                                                         width: 30,
//                                                         fit: BoxFit.fitWidth);
//                                                   },
//                                                   fit: BoxFit.fitWidth,
//                                                 )),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         '${value.chatList[index].senderFirstName} ${value.chatList[index].senderLastName}',
//                                                         style: const TextStyle(
//                                                             fontSize: 14,
//                                                             fontFamily:
//                                                                 'medium',
//                                                             color: ThemeProvider
//                                                                 .blackColor),
//                                                       ),
//                                                       Text(
//                                                         value.chatList[index]
//                                                             .updatedAt
//                                                             .toString(),
//                                                         style: const TextStyle(
//                                                             fontSize: 12,
//                                                             color: ThemeProvider
//                                                                 .greyColor),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                             }),
//                           ),
//                         ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_chat_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class AccountChatScreen extends StatefulWidget {
  const AccountChatScreen({Key? key}) : super(key: key);

  @override
  State<AccountChatScreen> createState() => _AccountChatScreenState();
}

class _AccountChatScreenState extends State<AccountChatScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.pink;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          appBar: _buildAppBar(),
          body: _buildBody(value),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeProvider.appColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Messages',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeProvider.appColor,
              ThemeProvider.appColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AccountChatController value) {
    if (value.parser.haveLoggedIn() == false) {
      return _buildLoginPrompt(value);
    }

    if (value.apiCalled == false) {
      return _buildSkeletonLoader();
    }

    if (value.chatList.isEmpty) {
      return _buildEmptyState();
    }

    return _buildChatList(value);
  }

  Widget _buildLoginPrompt(AccountChatController value) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.login,
                size: 48,
                color: primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Login Required'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login or register to access your messages',
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => value.onLoginRoutes(),
              icon: const Icon(Icons.login, size: 20),
              label: Text('Login / Register'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 24,
              width: 120,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          // Chat list skeleton
          Expanded(
            child: ListView.separated(
              itemCount: 8,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          shape: BoxShape.circle,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 16,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                height: 14,
                                width: 200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12,
                          width: 60,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: info,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Messages Yet'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with service providers to see your messages here',
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(AccountChatController value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Recent Conversations'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${value.chatList.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chat list
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: value.chatList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final chat = value.chatList[index];
                final bool isSender = chat.senderId.toString() == value.uid;

                return _buildChatItem(
                  value: value,
                  chat: chat,
                  isSender: isSender,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required AccountChatController value,
    required dynamic chat,
    required bool isSender,
    required int index,
  }) {
    final String userId =
        isSender ? chat.receiverId.toString() : chat.senderId.toString();
    final String userName = isSender
        ? '${chat.receiverName} ${chat.receiverLastName}'
        : '${chat.senderFirstName} ${chat.senderLastName}';
    final String userImage = isSender ? chat.receiverCover : chat.senderCover;
    final String lastMessageTime = chat.updatedAt.toString();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => value.onChat(userId, userName),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderLight),
            boxShadow: const [
              BoxShadow(
                color: shadowLight,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile picture
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: borderLight, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: FadeInImage(
                        image:
                            NetworkImage('${Environments.imageURL}$userImage'),
                        placeholder:
                            const AssetImage("assets/images/placeholder.jpeg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: surfaceBackground,
                            child: const Icon(
                              Icons.person,
                              color: textLight,
                              size: 24,
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Online indicator (you can add logic to show online status)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: success,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: cardBackground, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Chat details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(lastMessageTime),
                          style: const TextStyle(
                            fontSize: 12,
                            color: textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tap to continue conversation',
                            style: const TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSender
                                ? primary.withOpacity(0.1)
                                : info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isSender ? 'You' : 'Them',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSender ? primary : info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow indicator
              const Icon(
                Icons.chevron_right,
                color: textLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final DateTime dateTime = DateTime.parse(timeString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timeString;
    }
  }
}
