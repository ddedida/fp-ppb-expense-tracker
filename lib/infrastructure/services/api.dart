import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fp_ppb_expense_tracker/model/budget.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'auth.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';

class ApiService {
  final String _baseurl = 'https://ppb-backend-urrztf2ada-as.a.run.app';
  // final String _baseurl = 'http://localhost:8080';
  final dio = Dio();

  Future<void> getLatestExpensesStoredInCloud() async {
    final Response response = await dio.get(
      '$_baseurl/v1/expenses/latest',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get latest expenses');
    }

    return response.data;
  }

  Future<List<dynamic>> getExpensesInCloud() async {
    final token = await AuthMethods().getToken();
    final Response response = await dio.get(
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
    final Response response = await dio.post(
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

  Future<List<dynamic>> getCategoryInCloud() async {
    final token = await AuthMethods().getToken();
    final Response response = await dio.get(
      '$_baseurl/v1/categories',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get categories');
    }

    return response.data['data'];
  }

  Future<void> addCategoryToCloud(List<Category> categories) async {
    final token = await AuthMethods().getToken();
    final Response response = await dio.post(
      '$_baseurl/v1/categories',
      data: jsonEncode(categories.map((e) => e.toJsonBackup()).toList()),
      options: Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add category');
    }

    return response.data;
  }

  Future<List<dynamic>> getBudgetInCloud() async {
    final token = await AuthMethods().getToken();
    final Response response = await dio.get(
      '$_baseurl/v1/budgets',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get budgets');
    }

    return response.data['data'];
  }

  Future<void> addBudgetToCloud(List<Budget> budgets) async {
    final token = await AuthMethods().getToken();
    final Response response = await dio.post(
      '$_baseurl/v1/budgets',
      data: jsonEncode(budgets.map((e) => e.toJsonBackup()).toList()),
      options: Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add budget');
    }

    return response.data;
  }
}
