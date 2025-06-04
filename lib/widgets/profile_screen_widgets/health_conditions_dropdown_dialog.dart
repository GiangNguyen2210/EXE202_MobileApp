import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/api/profile_api.dart';

class HealthConditionsDropdownDialog extends StatefulWidget {
  final String typeName;
  final List<Map<String, dynamic>> initialSelectedHealthConditions;

  const HealthConditionsDropdownDialog({
    required this.typeName,
    required this.initialSelectedHealthConditions,
    super.key,
  });

  @override
  State<HealthConditionsDropdownDialog> createState() => _HealthConditionsDropdownDialogState();
}

class _HealthConditionsDropdownDialogState extends State<HealthConditionsDropdownDialog> {
  late List<Map<String, dynamic>> _selectedHealthConditions;

  @override
  void initState() {
    super.initState();
    _selectedHealthConditions = List.from(widget.initialSelectedHealthConditions);
    print('Initial selected health conditions: $_selectedHealthConditions');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                'Select ${widget.typeName} Conditions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: ProfileApi().fetchHealthConditionsByType(widget.typeName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final conditions = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: conditions.length,
                    itemBuilder: (context, index) {
                      final condition = conditions[index];
                      final conditionName = condition['healthConditionName'] as String;
                      final isSelected = _selectedHealthConditions.any(
                            (selected) => selected['condition'] == conditionName,
                      );
                      return CheckboxListTile(
                        title: Text(conditionName),
                        subtitle: Text(condition['briefDescription'] as String),
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedHealthConditions.add({
                                'condition': conditionName,
                                'status': null, // Reverted to null
                              });
                            } else {
                              _selectedHealthConditions.removeWhere(
                                    (selected) => selected['condition'] == conditionName,
                              );
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No conditions available'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    print('Confirming health conditions: $_selectedHealthConditions');
                    Navigator.of(context).pop(_selectedHealthConditions);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}