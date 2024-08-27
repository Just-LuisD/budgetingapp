import 'package:budgeting_app/data/repositories/budget_repository_impl.dart';
import 'package:budgeting_app/data/repositories/category_repository_impl.dart';
import 'package:budgeting_app/data/repositories/expense_repository_impl.dart';
import 'package:budgeting_app/data/repositories/income_repository_impl.dart';
import 'package:budgeting_app/domain/entities/budget.dart';
import 'package:budgeting_app/presentation/bloc/budget_details_bloc.dart';
import 'package:budgeting_app/presentation/bloc/budget_details_event.dart';
import 'package:budgeting_app/presentation/bloc/budget_details_state.dart';
import 'package:budgeting_app/presentation/widgets/budget_modal.dart';
import 'package:budgeting_app/presentation/widgets/category_section.dart';
import 'package:budgeting_app/presentation/widgets/transaction_section.dart';
import 'package:budgeting_app/presentation/widgets/income_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetDetailsScreen extends StatelessWidget {
  final Budget budget;
  const BudgetDetailsScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetDetailsBloc(
          budgetId: budget.id!,
          budgetRepository: BudgetRepositoryImpl(),
          categoryRepository: CategoryRepositoryImpl(),
          expenseRepository: ExpenseRepositoryImpl(),
          incomeRepository: IncomeRepositoryImpl())
        ..add(const FetchBudgetDetailsEvent()),
      child: const BudgetDetailsView(),
    );
  }
}

class BudgetDetailsView extends StatelessWidget {
  const BudgetDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    void updateBudget(Budget b) {
      context
          .read<BudgetDetailsBloc>()
          .add(UpdateBudgetEvent(updatedBudget: b));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<BudgetDetailsBloc, BudgetDetailsState>(
          buildWhen: (previous, current) => previous.budget != current.budget,
          builder: (context, state) {
            if (state.status == BudgetDetailsStatus.success) {
              return AppBar(
                title: Text(
                  state.budget!.name,
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return BudgetModal(
                            budget: state.budget,
                            onSubmit: updateBudget,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IncomeProgressBar(),
              CategorySection(),
              TransactionSection(),
            ],
          ),
        ),
      ),
    );
  }
}
