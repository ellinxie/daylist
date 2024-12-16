import 'package:flutter/material.dart';

class StudyInput extends StatefulWidget {
  const StudyInput({super.key});

  @override
  _StudyInputState createState() => _StudyInputState();
}

class _StudyInputState extends State<StudyInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isEditable = false;
  String _studyText = '';

  void _toggleEdit() {
    setState(() {
      if (_isEditable) {
        _studyText = _controller.text;
      }
      _isEditable = !_isEditable;
      _controller.text = _studyText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          // Display the study text
          _isEditable
              ? TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'What do you want to study today?',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                )
              : Container(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    _studyText.isEmpty ? 'What do you want to study today?' : _studyText,
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          SizedBox(height: 5), 
          SizedBox(
            width: 50,
            child: ElevatedButton(
              onPressed: _toggleEdit,
              child: Text(_isEditable ? 'Save' : 'Edit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                textStyle: TextStyle(fontSize: 10), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
