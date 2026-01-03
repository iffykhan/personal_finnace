import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1, 
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.deepPurple.withValues(alpha : 0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Transfer'),
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black.withValues(alpha: .65),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Transfer Tab')), 
            Center(child: Text('Expense Tab')),  
            Center(child: Text('Income Tab')),   
          ],
          
        ),
      ),
    );
  }
}
