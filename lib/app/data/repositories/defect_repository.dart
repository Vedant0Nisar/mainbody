import '../providers/mock_api_service.dart';
import '../../models/defect_model.dart';
import '../../models/contractor_model.dart';
import '../../models/status_enum.dart';

class DefectRepository {
  final MockApiService _apiService;

  DefectRepository(this._apiService);

  Future<List<DefectModel>> fetchDefects() {
    return _apiService.getDefects();
  }

  Future<List<ContractorModel>> fetchContractors() {
    return _apiService.getContractors();
  }

  Future<bool> assignContractor(String ticketId, ContractorModel contractor) {
    return _apiService.updateTicketStatus(ticketId, TicketStatus.assigned,
        contractor: contractor);
  }

  Future<bool> approveRepair(String ticketId) {
    return _apiService.updateTicketStatus(ticketId, TicketStatus.closed);
  }

  Future<bool> rejectRepair(String ticketId) {
    return _apiService.updateTicketStatus(ticketId, TicketStatus.rework);
  }
}
