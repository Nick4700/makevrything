import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';

class StyleEditorWidget extends StatefulWidget {
  const StyleEditorWidget({super.key});

  @override
  State<StyleEditorWidget> createState() => _StyleEditorWidgetState();
}

class _StyleEditorWidgetState extends State<StyleEditorWidget> {
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  String _selectedFont = 'Arial';
  double _fontSize = 16.0;

  final List<String> _fonts = [
    'Arial',
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
  ];

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  void _applyStyles() {
    final styles = '''
    <style>
      body {
        background-color: ${_colorToHex(_backgroundColor)};
        color: ${_colorToHex(_textColor)};
        font-family: $_selectedFont;
        font-size: ${_fontSize}px;
      }
    </style>
    ''';

    context.read<ChatProvider>().insertHtmlElement(styles);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Arka Plan Rengi',
              style: Theme.of(context).textTheme.titleMedium),
          BlockPicker(
            pickerColor: _backgroundColor,
            onColorChanged: (color) {
              setState(() => _backgroundColor = color);
              _applyStyles();
            },
          ),
          const SizedBox(height: 16),
          Text('Yazı Rengi', style: Theme.of(context).textTheme.titleMedium),
          BlockPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              setState(() => _textColor = color);
              _applyStyles();
            },
          ),
          const SizedBox(height: 16),
          Text('Font', style: Theme.of(context).textTheme.titleMedium),
          DropdownButton<String>(
            value: _selectedFont,
            items: _fonts.map((font) {
              return DropdownMenuItem(
                value: font,
                child: Text(font, style: GoogleFonts.getFont(font)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedFont = value);
                _applyStyles();
              }
            },
          ),
          const SizedBox(height: 16),
          Text('Font Boyutu', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _fontSize,
            min: 12,
            max: 32,
            divisions: 20,
            label: '${_fontSize.round()}px',
            onChanged: (value) {
              setState(() => _fontSize = value);
              _applyStyles();
            },
          ),
        ],
      ),
    );
  }
}
