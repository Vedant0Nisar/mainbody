import '../../models/defect_model.dart';
import '../../models/contractor_model.dart';
import '../../models/status_enum.dart';
import 'main_body_repository.dart';

class DefectRepository {
  final MainBodyRepository _apiService;

  DefectRepository(this._apiService);

  Future<List<DefectModel>> fetchDefects() async {
    final tickets = await _apiService.getTickets();
    return tickets.map((e) => DefectModel.fromJson(e)).toList();
  }

  Future<bool> createTicket(
      String title, String desc, double lat, double lng, String photo) async {
    // Note: The provided Main Body API docs do not include an endpoint for creating a ticket,
    // because Authority typically only manages/assigns them.
    // If we need to support it, we'll return false for now to prevent crashes.
    return false;
  }

  Future<List<ContractorModel>> fetchContractors() async {
    final contractors = await _apiService.getContractors();
    return contractors.map((e) => ContractorModel.fromJson(e)).toList();
  }

  Future<bool> assignContractor(
      String ticketId, ContractorModel contractor) async {
    try {
      await _apiService.assignTicket(ticketId, contractor.name);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyRepair(String ticketId) async {
    try {
      await _apiService.approveTicket(ticketId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> closeTicket(String ticketId) async {
    // According to docs, approveTicket sets it down the path to CLOSED
    try {
      await _apiService.approveTicket(ticketId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> rejectRepair(String ticketId) async {
    try {
      await _apiService.reworkTicket(ticketId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
