import 'package:expenses/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expensesList/expenses_list.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Mashed Potatoes',
        amount: 12.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Berlin',
        amount: 12.99,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: 'Cinema',
        amount: 12.99,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

   void _addNewExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} removed'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(_addNewExpense);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text('No expenses added yet!'),);

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('G Expenses'),
        actions: [
          IconButton(
            onPressed:_openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ] ,
      ),
      body: Column(children: [
        Chart(expenses: _registeredExpenses),
        Expanded(
          child: mainContent,
        ),
      ]),
    );
  }
}
