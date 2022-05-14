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
  late TextEditingController _notesController;
  late TextEditingController _donationDurationController;
  int? donorValidity;
  DateTime _addedOn = DateTime.now();
  final List<String> _roles = List.empty(growable: true);
  final List<String> _servers = List.empty(growable: true);
  final List<DateTime> _pastDonations = List.empty(growable: true);
  bool isDonor = false;
  bool isRecurring = false;
  late UserEntity _user;
  String? role;
  String? documentId;

  @override
  void initState() {
    super.initState();
    if (widget.enitity != null) {
      _servers.addAll(widget.enitity!.servers);
      _roles.addAll(widget.enitity!.roles);
      documentId = widget.enitity!.documentId;
      _discordIdController =
          TextEditingController(text: widget.enitity!.discordId);
      _discordNameController =
          TextEditingController(text: widget.enitity!.discordName);
      _plexEmailController =
          TextEditingController(text: widget.enitity!.plexEmail);
      _plexIdController = TextEditingController(text: widget.enitity!.plexId);
      _plexIdController = TextEditingController(text: widget.enitity!.plexId);
      _notesController = TextEditingController(text: widget.enitity!.note);
      _addedOn = widget.enitity!.dateAdded;
      _roles.addAll(widget.enitity!.roles);
      if (widget.enitity!.pastDonations != null) {
        _pastDonations.addAll(widget.enitity!.pastDonations!);
      }
      if (widget.enitity!.isDonor) {
        isRecurring = widget.enitity!.isRecurring!;
        donorValidity = widget.enitity!.validity;
        isDonor = widget.enitity!.isDonor;
        role = widget.enitity!.donorRole!;
        _donationDurationController = TextEditingController(
            text: widget.enitity!.donationDuration.toString());
      } else {
        _donationDurationController = TextEditingController();
      }
    } else {
      _discordIdController = TextEditingController();
      _discordNameController = TextEditingController();
      _plexEmailController = TextEditingController();
      _plexIdController = TextEditingController();
      _notesController = TextEditingController();
      _donationDurationController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _discordIdController.dispose();
    _discordNameController.dispose();
    _plexEmailController.dispose();
    _plexIdController.dispose();
    _notesController.dispose();
    _donationDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddUserViewModel>(builder: (_, model, __) {
      return Scaffold(
          backgroundColor: AppConstants.bgColor,
          appBar: AppBar(
            title: Text(widget.enitity == null ? 'Add user' : 'Update User'),
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
                          const Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          CustomDateTimePicker(
                              initialDate: _addedOn,
                              style: null,
                              title: 'Added On',
                              onDateSelected: (date) {
                                _addedOn = date;
                              }),
                          const Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Is Donor',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                  activeColor: AppConstants.appBarColor,
                                  value: isDonor,
                                  onChanged: (value) {
                                    setState(() {
                                      isDonor = value;
                                    });
                                  }),
                            ],
                          ),
                          isDonor
                              ? CustomDonationWidget(
                                  donorRole: role,
                                  lastDonated: _pastDonations.isEmpty
                                      ? DateTime.now()
                                      : _pastDonations.last,
                                  onDonationDateSelected: (value) {
                                    _pastDonations.add(value);
                                  },
                                  durationController:
                                      _donationDurationController,
                                  onSelect: (value) {
                                    role = value;
                                  },
                                  onRecurringToggle: (value) {
                                    isRecurring = value;
                                  },
                                  items: state.entity.donorRoles,
                                  isRecurring: isRecurring)
                              : const SizedBox(),
                          const Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          CustomCheckBox(
                              oldNames: _servers,
                              name: state.entity.servers,
                              title: 'Select servers',
                              onTrue: (value) {
                                _servers.add(value);
                              },
                              onFalse: (value) {
                                _servers.remove(value);
                              }),
                          const Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          CustomCheckBox(
                            oldNames: _roles,
                            title: 'Select roles from List below',
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
                          const Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          AddUserFormTextField(
                              isNote: true,
                              controller: _notesController,
                              hintText: 'Additional notes'),
                          const VSpace20(),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppConstants.appBarColor),
                              ),
                              onPressed: () {
                                if (isDonor) {
                                  if (donorValidity != null) {
                                    donorValidity = donorValidity! +
                                        int.parse(
                                            _donationDurationController.text);
                                  } else {
                                    donorValidity = int.parse(
                                        _donationDurationController.text);
                                  }
                                  _user = UserEntity(
                                      isRecurring: isRecurring,
                                      validity: donorValidity,
                                      discordId: _discordIdController.text,
                                      plexId: _plexIdController.text,
                                      servers: _servers,
                                      isDonor: true,
                                      discordName: _discordNameController.text,
                                      plexEmail: _plexEmailController.text,
                                      donationDuration: int.parse(
                                          _donationDurationController.text),
                                      roles: _roles,
                                      donorRole: role,
                                      note: _notesController.text,
                                      dateAdded: _addedOn,
                                      pastDonations: _pastDonations,
                                      documentId: documentId ?? '');
                                } else {
                                  _user = UserEntity(
                                      discordId: _discordIdController.text,
                                      plexId: _plexIdController.text,
                                      servers: _servers,
                                      isDonor: false,
                                      discordName: _discordNameController.text,
                                      plexEmail: _plexEmailController.text,
                                      roles: _roles,
                                      note: _notesController.text,
                                      dateAdded: _addedOn,
                                      documentId: documentId ?? '');
                                }
                                if (widget.enitity == null) {
                                  model.submitUserDetails(_user,
                                      shouldUpdate: false);
                                } else {
                                  model.submitUserDetails(_user,
                                      shouldUpdate: true);
                                }
                              },
                              child: const Text('Save User Details')),
                          const VSpace20(),
                          const VSpace20(),
                          const VSpace20(),
                          const VSpace20(),
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

class CustomDonationWidget extends StatefulWidget {
  final String? donorRole;
  final DateTime lastDonated;
  final void Function(DateTime) onDonationDateSelected;
  final void Function(String) onSelect;
  final void Function(bool) onRecurringToggle;
  final List<String> items;
  final bool isRecurring;
  final TextEditingController durationController;
  const CustomDonationWidget(
      {Key? key,
      required this.durationController,
      required this.donorRole,
      required this.onSelect,
      required this.onRecurringToggle,
      required this.items,
      required this.lastDonated,
      required this.isRecurring,
      required this.onDonationDateSelected})
      : super(key: key);

  @override
  State<CustomDonationWidget> createState() => _CustomDonationWidgetState();
}

class _CustomDonationWidgetState extends State<CustomDonationWidget> {
  late bool isRecurring;
  @override
  void initState() {
    super.initState();
    isRecurring = widget.isRecurring;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
            initialItem: widget.donorRole,
            onSelect: widget.onSelect,
            items: widget.items,
            title: 'Select Donor Role'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Is Recurring',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            Switch(
                activeColor: AppConstants.appBarColor,
                value: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value;
                    widget.onRecurringToggle(isRecurring);
                  });
                }),
          ],
        ),
        CustomDateTimePicker(
          initialDate: widget.lastDonated,
          title: 'Donated on',
          onDateSelected: widget.onDonationDateSelected,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
        Row(
          children: [
            const Text(
              'Donation Duration(Days)',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: widget.durationController,
                cursorColor: AppConstants.appBarColor,
                enabled: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17)),
                  fillColor: AppConstants.textFieldFillColor.withOpacity(0.8),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      width: 2,
                      color: AppConstants.freeUserColor,
                    ),
                  ),
                  hintText: 'Duration',
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CustomDateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final TextStyle? style;
  final String title;
  final void Function(DateTime) onDateSelected;
  const CustomDateTimePicker({
    Key? key,
    required this.initialDate,
    required this.title,
    required this.style,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late DateTime _current;
  @override
  void initState() {
    super.initState();
    _current = widget.initialDate;
  }

  String formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: widget.style ??
              const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
        ),
        Text(
          formatDate(_current),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        IconButton(
          onPressed: () async {
            final dateSelected = (await showDatePicker(
                context: context,
                initialDate: _current,
                firstDate: DateTime(2020),
                lastDate: _current));
            if (dateSelected != null) {
              setState(() {
                _current = dateSelected;
                widget.onDateSelected(_current);
              });
            }
          },
          icon: const Icon(Icons.calendar_month),
          color: Colors.white,
        ),
      ],
    );
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
  final List<String> oldNames;
  final String title;
  final List<String> name;
  final void Function(String) onTrue;
  final void Function(String) onFalse;
  const CustomCheckBox({
    Key? key,
    required this.name,
    required this.title,
    required this.oldNames,
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
        Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        ...widget.name
            .map((name) => SingleCheckBoxWidget(
                  isChecked: widget.oldNames.contains(name),
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
  final bool isChecked;
  final void Function(String) onTrue;
  final void Function(String) onFalse;
  final String name;
  const SingleCheckBoxWidget({
    Key? key,
    required this.onTrue,
    required this.isChecked,
    required this.name,
    required this.onFalse,
  }) : super(key: key);

  @override
  State<SingleCheckBoxWidget> createState() => _SingleCheckBoxWidgetState();
}

class _SingleCheckBoxWidgetState extends State<SingleCheckBoxWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

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
  final String? initialItem;
  final String title;
  final void Function(String) onSelect;
  const CustomDropDown({
    Key? key,
    required this.onSelect,
    required this.items,
    required this.initialItem,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String? selected;
  @override
  void initState() {
    super.initState();
    selected = widget.initialItem;
  }

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
            dropdownColor: AppConstants.appBarColor,
            style: TextStyle(color: Colors.grey[700]),
            iconSize: 28,
            iconEnabledColor: Colors.white,
            hint: const Text(
              'Select Any one',
              style: TextStyle(color: Colors.white),
            ),
            autofocus: true,
            value: selected,
            items: widget.items
                .map((e) => DropdownMenuItem<String>(
                      enabled: true,
                      value: e,
                      child: Text(
                        e,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
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
        cursorColor: AppConstants.appBarColor,
        enabled: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
          fillColor: AppConstants.textFieldFillColor.withOpacity(0.8),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              width: 2,
              color: AppConstants.freeUserColor,
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
