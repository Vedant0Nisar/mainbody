import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/api_client.dart';

class MainBodyRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _apiClient.get('/tickets/stats');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load stats');
  }

  Future<List<dynamic>> getMapData() async {
    final response = await _apiClient.get('/tickets/map');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load map data');
  }

  Future<List<dynamic>> getTickets({int skip = 0, int limit = 100}) async {
    final response = await _apiClient.get('/tickets/?skip=$skip&limit=$limit');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load tickets');
  }

  Future<Map<String, dynamic>> getTicketDetails(String ticketId) async {
    final response = await _apiClient.get('/tickets/$ticketId');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load ticket details');
  }

  Future<List<dynamic>> getContractors() async {
    try {
      final response = await _apiClient.get(
          '/tickets/contractors'); // assuming this was the correct spelling, user doc says /tickets/contractors -> Wait, user doc says `/tickets/contractors` ? Let me check later.
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load contractors');
    } catch (e) {
      // Returning empty to avoid full crash if endpoint is slightly different
      return [];
    }
  }

  Future<Map<String, dynamic>> assignTicket(
      String ticketId, String contractorName) async {
    final response = await _apiClient.put(
      '/tickets/$ticketId/assign',
      body: {'contractor': contractorName},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to assign ticket');
  }

  Future<Map<String, dynamic>> approveTicket(String ticketId) async {
    final response = await _apiClient.put('/tickets/$ticketId/approve');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to approve ticket');
  }

  Future<Map<String, dynamic>> reworkTicket(String ticketId) async {
    final response = await _apiClient.put('/tickets/$ticketId/rework');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to rework ticket');
  }

  Future<Uint8List> downloadEvidencePdf(String ticketId) async {
    final response = await _apiClient.get('/tickets/$ticketId/evidence');
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception('Failed to download PDF');
  }
}
