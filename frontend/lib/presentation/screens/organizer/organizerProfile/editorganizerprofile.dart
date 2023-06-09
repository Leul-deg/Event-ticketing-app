import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/organizer/organizer_update/organizer_update_bloc.dart';
import 'package:frontend/infrastructure/organizer/data_sources/organizer_data_sources.dart';
import 'package:frontend/infrastructure/organizer/repositories/organizer_repository_imp.dart';
import 'package:frontend/presentation/screens/routes/appRouteConstants.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorganizerProfile extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditorganizerProfile> {
  bool _passwordVisible = false;

  var organizerData;

  @override
  void initState() {
    super.initState();

    getOrganizer();
  }

  getOrganizer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      organizerData = json.decode(prefs.getString('userData')!);
      print('here is userdata up there');
      print(organizerData);
    });
  }

  @override
  Widget build(BuildContext context) {
    var organizerData = this.organizerData;

    print('and in the builder');
    print(organizerData);
    return BlocProvider(
      create: (context) => OrganizerUpdateBloc(
        OrganizerRepositoryImp(organizerDataSource: OrganizerDataSource()),
      ),
      child: BlocConsumer<OrganizerUpdateBloc, OrganizerUpdateState>(
        listener: (context, state) {
          // show snackbar based on folding state.updateFailureOrSuccessOption
          state.updateFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failure.map(
                        insufficientPermission: () => 'Insufficient Permission',
                        invalidOrganizer: () => 'Invalid Organizer',
                        serverError: () => 'Server Error',
                        unableToDelete: () => 'Unable To Delete',
                        unableToUpdate: () => 'Unable To Update',
                        unexpectedError: () => 'Unexpected Error',
                      ),
                    ),
                  ),
                );
              },
              (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Update Success'),
                  ),
                );

                GoRouter.of(context)
                    .pushNamed(MyAppRouteConstants.organizerScreenRouteName);
              },
            ),
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              backgroundColor: Colors.blue,
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 15), // Add padding to the top
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight, // Align at bottom-right
                      children: [
                        CircleAvatar(
                          radius: 70,
                        ),
                        Positioned(
                          bottom: 2, // Adjust the value as needed
                          right: 3, // Adjust the value as needed
                          child: Padding(
                            padding: EdgeInsets.all(
                                4), // Add padding to the IconButton
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 23,
                              child: IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              context.read<OrganizerUpdateBloc>().add(
                                    OrganizerUpdateEvent.organizationNameChanged(
                                        value),
                                  );
                            },
                            initialValue: json.decode(
                                organizerData ?? '{}')['organizationName'],
                            decoration: InputDecoration(
                              labelText: 'Organization Name',
                              prefixIcon: Icon(Icons.business),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onChanged: (value) {
                              context.read<OrganizerUpdateBloc>().add(
                                    OrganizerUpdateEvent.emailChanged(value),
                                  );
                            },
                            initialValue:
                                json.decode(organizerData ?? '{}' )['email'],
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onChanged: (value) {
                              context.read<OrganizerUpdateBloc>().add(
                                    OrganizerUpdateEvent.passwordChanged(value),
                                  );
                            },
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<OrganizerUpdateBloc>().add(
                                      OrganizerUpdateEvent
                                          .updateOrganizerPressed(),
                                    );
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
