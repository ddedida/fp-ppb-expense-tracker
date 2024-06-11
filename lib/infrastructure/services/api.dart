import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'auth.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';

class ApiService {
  final String _baseurl = 'https://ppb-backend-urrztf2ada-as.a.run.app';
  final Dio _dio = Dio();

  Future<void> getLatestExpensesStoredInCloud() async {
    final Response response = await _dio.get(
      '$_baseurl/v1/expenses/latest',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get latest expenses');
    }

    return response.data;
  }

  Future<List<dynamic>> getExpensesInCloud() async {
    final token = await AuthMethods().getToken();
    final Response response = await _dio.get(
      '$_baseurl/v1/expenses',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get expenses');
    }

    return response.data['data'];
  }

  Future<void> addExpenseToCloud(List<Expense> expenses) async {
    final token = await AuthMethods().getToken();
    final Response response = await _dio.post(
      '$_baseurl/v1/expenses',
      data: jsonEncode(expenses.map((e) => e.toJsonBackup()).toList()),
      options: Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add expense');
    }

    return response.data;
  }
}
