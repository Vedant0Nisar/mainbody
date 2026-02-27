import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_ticket_controller.dart';

class CreateTicketView extends GetView<CreateTicketController> {
  const CreateTicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      appBar: AppBar(
        title: const Text('Create New Ticket',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Defect Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2022),
                    ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: controller.titleController,
                label: 'Title',
                icon: Icons.title,
                hint: 'Short description of the defect',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                hint: 'Detailed explanation of the problem...',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              const Text('Photo Evidence',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 12),
              InkWell(
                onTap: controller.pickPhoto,
                borderRadius: BorderRadius.circular(16),
                child: Obx(() => Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.grey[300]!, style: BorderStyle.solid),
                      ),
                      child: controller.photoPath.value.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Tap to add photo',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: const Icon(Icons.check_circle,
                                  color: Colors.green, size: 60),
                            ),
                    )),
              ),
              const SizedBox(height: 24),
              const Text('Location (GPS)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            controller.gpsLocation.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0D6EFD)),
                          ),
                        )),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: controller.getLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Fetch'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Obx(() => FilledButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitTicket,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF0D6EFD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Submit Ticket',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey[400]) : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D6EFD), width: 1.5)),
      ),
    );
  }
}
