import 'package:flutter/material.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/screens/auth/login_screen.dart';
import 'package:task_manager/screens/profile/update_profile_screen.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showLogout;
  final bool enableProfileTap;

  const TmAppBar({
    super.key,
    this.showBackButton = false,
    this.showLogout = false,
    this.enableProfileTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthController.userData;

    return AppBar(
      backgroundColor: Colors.green,

      // Back button appears on the left
      automaticallyImplyLeading: showBackButton,

      title: InkWell(
        onTap: enableProfileTap
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateProfileScreen(),
                  ),
                );
              }
            : null,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('asset/profile.jpg'),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),

      // Logout appears only when showLogout = true
      actions: showLogout
          ? [
              IconButton(
                onPressed: () async {
                  await AuthController.cleanUserData();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Logout',
              ),
              const SizedBox(width: 8),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
