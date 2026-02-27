enum TicketStatus {
  newTicket,
  assigned,
  repaired,
  verified,
  rework,
  closed,
}

extension TicketStatusExtension on TicketStatus {
  String get name {
    switch (this) {
      case TicketStatus.newTicket:
        return 'NEW';
      case TicketStatus.assigned:
        return 'ASSIGNED';
      case TicketStatus.repaired:
        return 'REPAIRED';
      case TicketStatus.verified:
        return 'VERIFIED';
      case TicketStatus.rework:
        return 'REWORK';
      case TicketStatus.closed:
        return 'CLOSED';
    }
  }

  static TicketStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return TicketStatus.newTicket;
      case 'ASSIGNED':
        return TicketStatus.assigned;
      case 'REPAIRED':
        return TicketStatus.repaired;
      case 'VERIFIED':
        return TicketStatus.verified;
      case 'REWORK':
        return TicketStatus.rework;
      case 'CLOSED':
        return TicketStatus.closed;
      default:
        return TicketStatus.newTicket;
    }
  }
}
