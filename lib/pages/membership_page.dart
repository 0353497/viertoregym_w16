import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:viertoregym/services/json_reader.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key, required this.user});
  final String user;
  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  bool isLoading = true;
  String subscriptionType = "";
  String expirationDate = "";
  String monthlyPrice = "";
  String _originalFirstName = "";
  String _originalLastName = "";
  String _originalDateOfBirth = "";

  @override
  void initState() {
    super.initState();
    _loadMembershipData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _loadMembershipData() async {
    final membershipData = await JsonReader.getMembershipForUser(widget.user);

    if (!mounted) {
      return;
    }

    if (membershipData == null) {
      setState(() {
        isLoading = false;
        firstNameController.text = widget.user;
        lastNameController.text = "";
        dateOfBirthController.text = "";
        _originalFirstName = widget.user;
        _originalLastName = "";
        _originalDateOfBirth = "";
        subscriptionType = "Unknown subscription";
        expirationDate = "Unknown";
        monthlyPrice = "Unknown";
      });
      return;
    }

    setState(() {
      isLoading = false;
      final initialFirstName =
          membershipData["first_name"]?.toString() ?? widget.user;
      final initialLastName = membershipData["last_name"]?.toString() ?? "";
      final initialDateOfBirth =
          membershipData["date_of_birth"]?.toString() ?? "";

      firstNameController.text = initialFirstName;
      lastNameController.text = initialLastName;
      dateOfBirthController.text = initialDateOfBirth;
      _originalFirstName = initialFirstName.trim();
      _originalLastName = initialLastName.trim();
      _originalDateOfBirth = initialDateOfBirth.trim();
      subscriptionType =
          "${_capitalize(membershipData["subscription_type"]?.toString() ?? "Unknown")} Subscription";
      expirationDate = _formatDate(
        membershipData["expiration_date"]?.toString(),
      );
      monthlyPrice =
          membershipData["monthly_price_eur"]?.toString() ?? "Unknown";
    });
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return "Unknown";
    }

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }

    return DateFormat("MMMM d, y").format(parsed);
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }

  DateTime _sixteenYearsAgo(DateTime referenceDate) {
    return DateTime(
      referenceDate.year - 16,
      referenceDate.month,
      referenceDate.day,
    );
  }

  DateTime _clampDate(
    DateTime value,
    DateTime lowerBound,
    DateTime upperBound,
  ) {
    if (value.isBefore(lowerBound)) {
      return lowerBound;
    }
    if (value.isAfter(upperBound)) {
      return upperBound;
    }
    return value;
  }

  String? _validateName(String? value, String fieldName) {
    final trimmedValue = value?.trim() ?? "";

    if (trimmedValue.isEmpty) {
      return "$fieldName must not be empty.";
    }

    if (trimmedValue.length > 15) {
      return "$fieldName must be at most 15 characters long.";
    }

    return null;
  }

  String? _validateDateOfBirth(String? value) {
    final parsedDate = _parseDate(value ?? "");
    if (parsedDate == null) {
      return "Enter a valid date.";
    }

    final ageLimit = _sixteenYearsAgo(DateTime.now());
    if (parsedDate.isAfter(ageLimit)) {
      return "You must be at least 16 years old.";
    }

    return null;
  }

  void _handleSavePressed() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _originalFirstName = firstNameController.text.trim();
      _originalLastName = lastNameController.text.trim();
      _originalDateOfBirth = dateOfBirthController.text.trim();
    });
  }

  Future<void> _pickDateOfBirth() async {
    final today = DateTime.now();
    final lastSelectableDate = _sixteenYearsAgo(today);
    final currentValue =
        _parseDate(dateOfBirthController.text) ?? lastSelectableDate;
    final initialDate = _clampDate(
      currentValue,
      DateTime(1900),
      lastSelectableDate,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: lastSelectableDate,
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      dateOfBirthController.text = DateFormat(
        "yyyy-MM-dd",
      ).format(selectedDate);
    });
  }

  bool get hasUnsavedChanges {
    return firstNameController.text.trim() != _originalFirstName ||
        lastNameController.text.trim() != _originalLastName ||
        dateOfBirthController.text.trim() != _originalDateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(color: Color(0xff3fa220), width: 3),
    );
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/Icon.png", width: 120),
        ),
        title: Text(
          "Membership",
          style: TextStyle(
            color: Color(0xff3e9f1f),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    elevation: 8,
                    color: Color(0xffe3f0e1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Member Details",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (hasUnsavedChanges)
                                TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : _handleSavePressed,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color(0xff3fa220),
                                    ),
                                    foregroundColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                  ),
                                  child: Text("Save"),
                                ),
                            ],
                          ),
                          TextFormField(
                            controller: firstNameController,
                            enabled: !isLoading,
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              return _validateName(value, "First name");
                            },
                            decoration: InputDecoration(
                              labelText: "First name",
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                            ),
                          ),
                          TextFormField(
                            controller: lastNameController,
                            enabled: !isLoading,
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              return _validateName(value, "Last name");
                            },
                            decoration: InputDecoration(
                              labelText: "Last name",
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                            ),
                          ),
                          TextFormField(
                            controller: dateOfBirthController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.datetime,
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: _validateDateOfBirth,
                            decoration: InputDecoration(
                              labelText: "Date of birth",
                              hintText: "YYYY-MM-DD",
                              prefixIcon: const Icon(Icons.calendar_month),
                              suffixIcon: IconButton(
                                onPressed: isLoading ? null : _pickDateOfBirth,
                                icon: const Icon(Icons.date_range),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: Get.height * .2,
                  child: Card(
                    elevation: 8,
                    color: Color(0xffe3f0e1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subscription Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(isLoading ? "Loading..." : subscriptionType),
                          Text(
                            isLoading
                                ? "Loading..."
                                : "Expires on $expirationDate",
                          ),
                          Text(
                            isLoading ? "Loading..." : "$monthlyPrice€/month",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
