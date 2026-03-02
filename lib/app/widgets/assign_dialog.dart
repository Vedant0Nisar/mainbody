import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/contractor_model.dart';
import '../models/defect_model.dart';

class AssignDialog extends StatefulWidget {
  final DefectModel ticket;
  final List<ContractorModel> contractors;

  const AssignDialog({
    Key? key,
    required this.ticket,
    required this.contractors,
  }) : super(key: key);

  @override
  State<AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<AssignDialog> {
  ContractorModel? _selectedContractor;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assign Contractor',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ticket: ${widget.ticket.id}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ContractorModel>(
            decoration: InputDecoration(
              labelText: 'Select Contractor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            value: _selectedContractor,
            items: widget.contractors.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c.name),
              );
            }).toList(),
            onChanged: _isLoading
                ? null
                : (val) {
                    setState(() {
                      _selectedContractor = val;
                    });
                  },
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading || _selectedContractor == null
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      // Return the selected contractor to the caller
                      Get.back(result: _selectedContractor);
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirm Assignment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
