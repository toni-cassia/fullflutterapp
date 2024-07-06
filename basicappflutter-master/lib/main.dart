import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.orangeAccent,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: HomePage(),
    );

  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'Sign In'),
                Tab(icon: Icon(Icons.person_add), text: 'Sign Up'),
                Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
              ],
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
              indicatorColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SignInScreen(),
                SignUpScreen(),
                CalculatorScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(Icons.person, 'Sign In', 0),
          _buildDrawerItem(Icons.person_add, 'Sign Up', 1),
          _buildDrawerItem(Icons.calculate, 'Calculator', 2),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _tabController.animateTo(index);
      },
    );
  }
}


class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Sign In',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildTextField('Email', Icons.email),
            SizedBox(height: 16),
            _buildTextField('Password', Icons.lock, isPassword: true),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Sign In', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildTextField('Full Name', Icons.person),
            SizedBox(height: 16),
            _buildTextField('Email', Icons.email),
            SizedBox(height: 16),
            _buildTextField('Password', Icons.lock, isPassword: true),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Sign In', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


Widget _buildTextField(String label, IconData icon, {bool isPassword = false}) {
  return TextField(
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _history = '';
  String _expression = '';

  void numClick(String text) {
    setState(() {
      _expression += text;
    });
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '';
    });
  }

  void clear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void evaluate(String text) {
    Parser p = Parser();
    try {
      String parsableExpression = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      if (!_areParenthesesBalanced(parsableExpression)) {
        throw FormatException('Unbalanced parentheses');
      }
      parsableExpression = parsableExpression.replaceAllMapped(
          RegExp(r'(\d)(\()'),
              (match) => '${match.group(1)}*${match.group(2)}'
      );
      parsableExpression = parsableExpression.replaceAllMapped(
          RegExp(r'(\))(\d)'),
              (match) => '${match.group(1)}*${match.group(2)}'
      );
      Expression exp = p.parse(parsableExpression);
      ContextModel cm = ContextModel();
      setState(() {
        _history = _expression;
        _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      setState(() {
        _history = _expression;
        _expression = 'Error';
      });
    }
  }

  bool _areParenthesesBalanced(String expression) {
    int count = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') {
        count++;
      } else if (expression[i] == ')') {
        count--;
      }
      if (count < 0) return false;
    }
    return count == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _history,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildButtonRow(["C", "(", ")", "÷"]),
                _buildButtonRow(["7", "8", "9", "×"]),
                _buildButtonRow(["4", "5", "6", "-"]),
                _buildButtonRow(["1", "2", "3", "+"]),
                _buildButtonRow(["0", ".", "⌫", "="]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => _buildButton(button)).toList(),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(text),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
        ),
        onPressed: () {
          if (text == "C") {
            allClear(text);
          } else if (text == "⌫") {
            setState(() {
              if (_expression.isNotEmpty) {
                _expression = _expression.substring(0, _expression.length - 1);
              }
            });
          } else if (text == "=") {
            evaluate(text);
          } else {
            numClick(text);
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: _getTextColor(text),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == "C" || text == "(" || text == ")" || text == "⌫") {
      return Colors.grey[300]!;
    } else if (text == "÷" || text == "×" || text == "-" || text == "+" || text == "=") {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Colors.white;
    }
  }

  Color _getTextColor(String text) {
    if (text == "÷" || text == "×" || text == "-" || text == "+" || text == "=") {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
