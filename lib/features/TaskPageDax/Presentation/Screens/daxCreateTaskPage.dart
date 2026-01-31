// dax_create_task_screen.dart
import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../Api/dax_task_repository.dart';
import '../../Model/dax_service_item_model.dart';

class DaxCreateTaskScreen extends StatefulWidget {
  const DaxCreateTaskScreen({super.key});

  @override
  State<DaxCreateTaskScreen> createState() => _DaxCreateTaskScreenState();
}

class _DaxCreateTaskScreenState extends State<DaxCreateTaskScreen> {
  final List<DaxServiceItem> services = [DaxServiceItem()];

  final chassisController = TextEditingController();
  final modelController = TextEditingController();
  final remarkController = TextEditingController();

  final otherSiteController = TextEditingController();
  bool isOtherSite = false;

  String detailingSite = "mq_dubai_showroom";
  String proofInvoice = "yes";

  final serviceTypes = [
    "tinting",
    "exterior detailing",
    "interior detailing",
    "ceramic coating",
    "ppf",
  ];

  final Map<String, String> siteMap = {
    "mq_dubai_showroom": "MG Dubai Showroom (SZR)",
    "mq_deira_service_center": "MG Deira Service Center",
    "mq_al_quoz_service_center": "MG Al Quoz Service Center",
    "mq_sharjah_showroom": "MG Sharjah Showroom",
    "mq_abu_dhabi_showroom": "MG Abu Dhabi Showroom",
    "mq_abu_dhabi_service_center": "MG Abu Dhabi Service Center",
    "mq_al_ain_showroom": "MG Al Ain Showroom",
    "mq_al_ain_service_center": "MG Al Ain Service Center",
    "mq_fujairah_showroom": "MG Fujairah Showroom",
    "mq_fujairah_service_center": "MG Fujairah Service Center",
    "premier_car_care_elite_motors": "Premier Car Care (Elite Motors)",
    "carnab_al_quoz": "Carnab (Al Quoz)",
    "emperor_garage": "Emperor Garage",
    "five_star_garage": "Five Star Garage",
    "golden_palace": "Golden Palace",
    "fos_automotive": "FOS Automotive",
    "office": "Office",
  };

  final repo = DaxTaskRepository();
  bool isLoading = false;

  void addService() => setState(() => services.add(DaxServiceItem()));

  void removeService(int i) => setState(() => services.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Create Task",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Detailing Site", true),
            _siteDropdown(),

            const SizedBox(height: 18),

            /// SERVICES
            ...services.asMap().entries.map((e) {
              return _serviceCard(e.value, e.key);
            }),

            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: addService,
              icon: const Icon(Icons.add, color: primaryColor),
              label: const Text(
                "Add Another Service",
                style: TextStyle(color: primaryColor),
              ),
            ),

            const SizedBox(height: 20),

            _label("Remarks"),
            _textArea(remarkController, "Please mention any additional notes"),

            const SizedBox(height: 22),
            const Text(
              "VEHICLE INFORMATION",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 14),

            _label("Chassis Number", true),
            _textField(chassisController, "Enter your vehicle chassis number"),

            _label("Vehicle Model / Type", true),
            _textField(modelController, "Enter your vehicle model"),

            const SizedBox(height: 14),

            _label("Proof of Invoice/Purchase Request PR", true),
            Row(children: [_radio("Yes", "yes"), _radio("No", "no")]),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Create Task",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SERVICE CARD =================

  Widget _serviceCard(DaxServiceItem s, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Service Type", true),
          _dropdown(serviceTypes, s.type, (v) {
            setState(() {
              s.type = v!;
              s.subType = null;
              s.level = null;
              s.layer = null;
              s.rollMeter = null;
            });
          }),

          if (s.type == "tinting") ...[
            _label("Select Tinting Type", true),
            _dropdown(
              ["standard tinting", "premium tinting"],
              s.subType,
              (v) => setState(() => s.subType = v!),
            ),

            _label("Enter Level of Tinting", true),
            _dropdown(
              ["0%", "30%", "50%", "70%"],
              s.level,
              (v) => setState(() => s.level = v!),
            ),

            _label("Roll Meter", true),
            _textField(
              null,
              "Enter roll meter",
              onChanged: (v) => s.rollMeter = v,
            ),
          ],

          if (s.type == "ceramic coating") ...[
            _label("Service Layer", true),
            _dropdown(
              ["1layer", "2layer", "3layer"],
              s.layer,
              (v) => setState(() => s.layer = v!),
            ),
          ],

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => removeService(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Remove",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= COMMON UI =================

  Widget _label(String t, [bool req = false]) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        text: t,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        children: req
            ? const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ]
            : [],
      ),
    ),
  );

  Widget _dropdown(List<String> items, String? value, Function(String?) onC) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: (value == null || value.isEmpty) ? null : value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onC,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController? c,
    String hint, {
    Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: c,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _textArea(TextEditingController c, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: c,
        maxLines: 4,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hint,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _radio(String label, String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: proofInvoice,
          onChanged: (v) => setState(() => proofInvoice = v!),
        ),
        Text(label),
      ],
    );
  }

  Widget _siteDropdown() {
    final items = [...siteMap.values, "Others"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown(items, isOtherSite ? "Others" : siteMap[detailingSite], (v) {
          setState(() {
            if (v == "Others") {
              isOtherSite = true;
            } else {
              isOtherSite = false;
              detailingSite = siteMap.entries
                  .firstWhere((e) => e.value == v)
                  .key;
            }
          });
        }),

        if (isOtherSite) ...[
          const SizedBox(height: 10),
          _textField(otherSiteController, "Enter detailing site manually"),
        ],
      ],
    );
  }

  Future<void> _submit() async {
    final payload = {
      "detailing_site": isOtherSite ? otherSiteController.text : detailingSite,
      "service_types": services.map((e) => e.toJson()).toList(),
      "remark": remarkController.text,
      "chassis_number": chassisController.text,
      "vehicle_model": modelController.text,
      "proof_of_invoice": proofInvoice,
    };

    try {
      setState(() => isLoading = true);

      await repo.createDaxTask(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // go back to task list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
