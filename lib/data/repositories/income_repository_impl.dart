import 'package:budgeting_app/data/local_database.dart';
import 'package:budgeting_app/domain/entities/income.dart';
import 'package:budgeting_app/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<Income>> getBudgetIncome(int budgetId) async {
    final maps = await dbHelper.getCategories(budgetId);
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertBudget(Income income) async {
    return await dbHelper.insertIncome(income.toMap());
  }
}
