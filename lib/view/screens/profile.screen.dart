import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.model.dart';
import '../../view_model/profile.view.model.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = "profile_screen";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ProfileViewModel viewModel = ProfileViewModel();

    return ChangeNotifierProvider<ProfileViewModel>.value(
        value: viewModel,
        child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {

          viewModel.getSignedInUser();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Grocify account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button press
                  Navigator.pop(context);
                },
              ),
              shadowColor: Colors.black,
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      UserInfo(userData: viewModel.user),
                      const SizedBox(height: 40),
                      UserOptions(option: "Indirizzi di spedizione", logOut: false, onTap: () {_goToScreen(context,"addresses_screen");}),
                      const SizedBox(height: 20),
                      UserOptions(option: "Storico degli ordini", logOut: false, onTap: () {_goToScreen(context,"orders_screen");}),
                    ],
                  ),
                  UserOptions(option: "Esci", logOut: true, onTap: () {viewModel.signOut();}),
                ],
              ),
            ),
          );
        }
        )
    );

  }
}

class UserInfo extends StatelessWidget {
  final UserModel userData;

  const UserInfo({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue, // Replace with your gradient logic
              width: 3,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              userData.profilePic!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${userData.name} ${userData.surname}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (userData.email != null) ...[
          const SizedBox(height: 5),
          Text(
            userData.email!,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}

class UserOptions extends StatelessWidget {
  final String option;
  final bool logOut;
  final VoidCallback onTap;

  const UserOptions({super.key, required this.option, required this.logOut, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color cardColor = logOut ? Colors.lightBlue : Colors.white;
    Color textColor = logOut ? Colors.white : Colors.black;
    IconData icon = logOut ? Icons.exit_to_app : Icons.arrow_forward_ios;
    Color iconColor = logOut ? Colors.white : Colors.black;
    double iconSize = logOut ? 25 : 15;

    return Card(
      color: cardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                option,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _goToScreen(BuildContext context, String screenRoute) {
  Navigator.pushNamed(context, screenRoute);
}