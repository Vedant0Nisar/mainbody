import '../../models/defect_model.dart';
import '../../models/contractor_model.dart';
import '../../models/status_enum.dart';

class MockApiService {
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == 'admin123';
  }

  Future<List<ContractorModel>> getContractors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ContractorModel(id: 'c1', name: 'Acme Repairs', phone: '+1234567890'),
      ContractorModel(id: 'c2', name: 'BuildIt Fast', phone: '+0987654321'),
      ContractorModel(id: 'c3', name: 'Fixer Upper Co.', phone: '+1122334455'),
    ];
  }

  Future<List<DefectModel>> getDefects() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      DefectModel(
        id: 'TKT-001',
        location: 'Building A, Floor 2, Hallway',
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        status: TicketStatus.newTicket,
        priority: 'High',
        description: 'Large crack in the wall plaster.',
        inspectorName: 'John Doe',
        beforePhotoUrl:
            'https://images.unsplash.com/photo-1518152006812-edab29b069ac?auto=format&fit=crop&q=80&w=400&h=300',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
      DefectModel(
        id: 'TKT-002',
        location: 'Building B, Roof',
        createdDate: DateTime.now().subtract(const Duration(days: 3)),
        status: TicketStatus.assigned,
        priority: 'Medium',
        description: 'Water leaking from the ceiling during rain.',
        inspectorName: 'Jane Smith',
        beforePhotoUrl:
            'https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?auto=format&fit=crop&q=80&w=400&h=300',
        latitude: 12.9725987,
        longitude: 77.5955627,
        contractor: ContractorModel(
            id: 'c1', name: 'Acme Repairs', phone: '+1234567890'),
      ),
      DefectModel(
        id: 'TKT-003',
        location: 'Parking Lot C',
        createdDate: DateTime.now().subtract(const Duration(days: 5)),
        status: TicketStatus.repaired,
        priority: 'Low',
        description: 'Pothole near the entrance.',
        inspectorName: 'Mike Johnson',
        beforePhotoUrl:
            'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&q=80&w=400&h=300',
        latitude: 12.9735987,
        longitude: 77.5965627,
        contractor: ContractorModel(
            id: 'c2', name: 'BuildIt Fast', phone: '+0987654321'),
        afterPhotoUrl:
            'https://images.unsplash.com/photo-1541888086425-d81bb19240f5?auto=format&fit=crop&q=80&w=400&h=300',
      ),
    ];
  }

  Future<bool> updateTicketStatus(String ticketId, TicketStatus newStatus,
      {ContractorModel? contractor}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Simulate success
  }
}
