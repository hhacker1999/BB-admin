import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/presentation/add_user_view/add_user_view_model.dart';
import 'package:bb_admin/src/presentation/helper/value_stream_builder.dart';

class AddUserView extends StatefulWidget {
  final UserEntity? enitity;
  const AddUserView({
    Key? key,
    this.enitity,
  }) : super(key: key);

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  late TextEditingController _discordNameController;
  late TextEditingController _discordIdController;
  late TextEditingController _plexIdController;
  late TextEditingController _plexEmailController;
  late TextEditingController _donorValidity;
  late TextEditingController _notesController;
  final List<String> _roles = List.empty(growable: true);
  final List<DateTime> _pastDonations = List.empty(growable: true);
  bool isDonor = false;

  late UserEntity _user;
  String role = '';

  @override
  void initState() {
    super.initState();
    _discordIdController = TextEditingController();
    _discordNameController = TextEditingController();
    _plexEmailController = TextEditingController();
    _plexIdController = TextEditingController();
    _donorValidity = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _discordIdController.dispose();
    _discordNameController.dispose();
    _plexEmailController.dispose();
    _plexIdController.dispose();
    _donorValidity.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddUserViewModel>(builder: (_, model, __) {
      return Scaffold(
          backgroundColor: AppConstants.bgColor,
          appBar: AppBar(
            title: const Text('Add user'),
            backgroundColor: AppConstants.appBarColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ValueStreamBuilder<AddUserViewState>(
                stream: model.stateStream,
                builder: (_, state) {
                  if (state is AddUserViewLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const VSpace20(),
                          AddUserFormTextField(
                              isNote: false,
                              controller: _discordNameController,
                              hintText: 'Discord Name'),
                          const VSpace20(),
                          AddUserFormTextField(
                              isNote: false,
                              controller: _discordIdController,
                              hintText: 'Discord Id'),
                          const VSpace20(),
                          AddUserFormTextField(
                              isNote: false,
                              controller: _plexIdController,
                              hintText: 'Plex Id'),
                          const VSpace20(),
                          AddUserFormTextField(
                              controller: _plexEmailController,
                              isNote: false,
                              hintText: 'Plex Email'),
                          const VSpace20(),
                          AddUserFormTextField(
                              isNote: true,
                              controller: _notesController,
                              hintText: 'Additional notes'),
                          const VSpace20(),
                          CustomDropDown(
                            title: 'Donor Roles',
                            items: [
                              ...['None'],
                              ...state.entity.donorRoles
                            ],
                            onSelect: (value) {
                              if (value != 'None') {
                                role = value;
                                isDonor = true;
                              }
                            },
                          ),
                          const VSpace20(),
                          CustomCheckBox(
                            name: state.entity.roles,
                            onFalse: (value) {
                              _roles.remove(value);
                            },
                            onTrue: (value) {
                              if (!_roles.contains(value)) {
                                _roles.add(value);
                              }
                            },
                          ),
                          const VSpace20(),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppConstants.appBarColor),
                              ),
                              onPressed: () {
                                _user = UserEntity(
                                  validity: 0,
                                    discordId: _discordIdController.text,
                                    plexId: _plexIdController.text,
                                    server: '',
                                    isDonor: false,
                                    discordName: _discordNameController.text,
                                    plexEmail: _plexEmailController.text,
                                    donationDuration: 0,
                                    otherRoles: _roles,
                                    donorRole: role,
                                    note: _notesController.text,
                                    dateAdded: DateTime.now(),
                                    pastDonations: [],
                                    documentId: '');
                                model.submitUserDetails(_user);
                              },
                              child: const Text('Submit User Details')),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ));
    });
  }
}

class VSpace20 extends StatelessWidget {
  const VSpace20({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  final List<String> name;
  final void Function(String) onTrue;
  final void Function(String) onFalse;
  const CustomCheckBox({
    Key? key,
    required this.name,
    required this.onTrue,
    required this.onFalse,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select roles from List below',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(
          height: 20,
        ),
        ...widget.name
            .map((name) => SingleCheckBoxWidget(
                  name: name,
                  onFalse: widget.onFalse,
                  onTrue: widget.onTrue,
                ))
            .toList(),
      ],
    );
  }
}

class SingleCheckBoxWidget extends StatefulWidget {
  final void Function(String) onTrue;
  final void Function(String) onFalse;
  final String name;
  const SingleCheckBoxWidget({
    Key? key,
    required this.onTrue,
    required this.name,
    required this.onFalse,
  }) : super(key: key);

  @override
  State<SingleCheckBoxWidget> createState() => _SingleCheckBoxWidgetState();
}

class _SingleCheckBoxWidgetState extends State<SingleCheckBoxWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            fillColor: MaterialStateProperty.all(AppConstants.appBarColor),
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
              if (value!) {
                widget.onTrue(widget.name);
              } else {
                widget.onFalse(widget.name);
              }
            }),
        Text(
          widget.name,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final String title;
  final void Function(String) onSelect;
  const CustomDropDown({
    Key? key,
    required this.onSelect,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String selected = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Select Donor Role',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(
          width: 20,
        ),
        DropdownButton(
            // focusColor: AppConstants.fieldCursorColor,
            dropdownColor: AppConstants.appBarColor,
            style: TextStyle(color: Colors.grey[700]),
            iconSize: 28,
            iconEnabledColor: Colors.white,
            hint: const Text(
              'Select Any one',
              style: TextStyle(color: Colors.white),
            ),
            autofocus: true,
            value: selected.isEmpty ? null : selected,
            items: widget.items
                .map((e) => DropdownMenuItem<String>(
                      enabled: true,
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selected = value as String;
                });
                widget.onSelect(value as String);
              }
            }),
      ],
    );
  }
}

class AddUserFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isNote;
  const AddUserFormTextField({
    Key? key,
    required this.controller,
    required this.isNote,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isNote ? 5 * 24 : null,
      child: TextField(
        maxLines: isNote ? 5 : 1,
        controller: controller,
        style: TextStyle(color: Colors.grey[500]),
        cursorColor: AppConstants.paidUserColor,
        enabled: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
          fillColor: Colors.black,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              width: 2,
              color: AppConstants.paidUserColor,
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
