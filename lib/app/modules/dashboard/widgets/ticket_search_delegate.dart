import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/defect_model.dart';
import '../../../routes/app_routes.dart';

class TicketSearchDelegate extends SearchDelegate<DefectModel?> {
  final List<DefectModel> tickets;

  TicketSearchDelegate(this.tickets);

  @override
  String get searchFieldLabel => 'Search ID or Name...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    final filtered = tickets.where((t) {
      final idMatch = t.id.toLowerCase().contains(query.toLowerCase());
      final titleMatch = t.title.toLowerCase().contains(query.toLowerCase());
      return idMatch || titleMatch;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No tickets found.'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final ticket = filtered[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              image: ticket.beforePhotoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(ticket.beforePhotoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: ticket.beforePhotoUrl.isEmpty
                ? const Icon(Icons.image_not_supported, color: Colors.grey)
                : null,
          ),
          title: Text(ticket.title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('ID: ${ticket.id.isEmpty ? "N/A" : ticket.id}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            close(context, ticket);
            Get.toNamed(Routes.DEFECT_DETAIL, arguments: ticket);
          },
        );
      },
    );
  }
}
