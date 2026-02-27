import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../models/status_enum.dart';
import '../../models/defect_model.dart';
import '../../widgets/main_layout.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: LayoutBuilder(builder: (context, constraints) {
                  final cardWidth =
                      (constraints.maxWidth - 12) / 2; // 2 columns
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Total Tickets',
                          controller.defects.length.toString(),
                          Colors.blue[700]!,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'New Tickets',
                          controller
                              .getCount(TicketStatus.newTicket)
                              .toString(),
                          Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Assigned',
                          controller.getCount(TicketStatus.assigned).toString(),
                          Colors.purple,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Repaired',
                          controller.getCount(TicketStatus.repaired).toString(),
                          Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Rework',
                          controller.getCount(TicketStatus.rework).toString(),
                          Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSummaryCard(
                          'Closed',
                          controller.getCount(TicketStatus.closed).toString(),
                          Colors.green,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              // List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Records',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '${controller.defects.length} records',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // List View
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: controller.defects.length,
                  itemBuilder: (context, index) {
                    return _buildInspectionCard(
                        context, controller.defects[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color countColor) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: countColor.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: countColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInspectionCard(BuildContext context, DefectModel defect) {
    final aiConfidence = 85.0; // placeholder
    return BlinkingBorderCard(
      isBlinking: defect.isNewlyAdded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(defect.beforePhotoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            defect.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(defect.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.memory,
                            size: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                        const SizedBox(width: 4),
                        Text(
                          'AI: ${aiConfidence.toStringAsFixed(1)}% confident',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                        const SizedBox(width: 4),
                        Text(
                          '${defect.createdDate.day}/${defect.createdDate.month}/${defect.createdDate.year}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed('/defect-detail', arguments: defect);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: const Color(0xFF555555),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Details',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Get.toNamed('/defect-detail', arguments: defect);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF0D6EFD), // Bright Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Update Status',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TicketStatus status) {
    Color badgeColor;
    switch (status) {
      case TicketStatus.newTicket:
        badgeColor = Colors.blue;
        break;
      case TicketStatus.assigned:
        badgeColor = Colors.purple;
        break;
      case TicketStatus.repaired:
        badgeColor = Colors.orange;
        break;
      case TicketStatus.verified:
        badgeColor = Colors.teal;
        break;
      case TicketStatus.rework:
        badgeColor = Colors.red;
        break;
      case TicketStatus.closed:
        badgeColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isSelected,
      {VoidCallback? onTap}) {
    return Builder(builder: (context) {
      final color = isSelected
          ? const Color(0xFF0D6EFD)
          : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[500];
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class BlinkingBorderCard extends StatefulWidget {
  final Widget child;
  final bool isBlinking;

  const BlinkingBorderCard(
      {Key? key, required this.child, this.isBlinking = false})
      : super(key: key);

  @override
  _BlinkingBorderCardState createState() => _BlinkingBorderCardState();
}

class _BlinkingBorderCardState extends State<BlinkingBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Colors.red.withOpacity(0.1),
      end: Colors.red.withOpacity(1.0), // Pulses to strong red
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isBlinking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BlinkingBorderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && !oldWidget.isBlinking) {
      _controller.repeat(reverse: true);
    } else if (!widget.isBlinking && oldWidget.isBlinking) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isBlinking
                  ? (_colorAnimation.value ?? Colors.transparent)
                  : Colors.red
                      .withOpacity(0.4), // Default highlight when not blinking
              width:
                  widget.isBlinking ? 3.0 : 2.0, // Make blinking border broader
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
