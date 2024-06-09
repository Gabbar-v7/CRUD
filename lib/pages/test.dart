import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPage();
}


class _TestPage extends State<TestPage> {
final TextEditingController controller =TextEditingController();

Widget _body(){
  return Center(child: TextField(autocorrect: true,
  controller: controller,
  ),);
}
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' TestPage'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>0,
        child: const Icon(Icons.add),
      ),
    );
  }
}
