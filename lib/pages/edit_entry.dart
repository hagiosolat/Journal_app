import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/journal_edit_bloc.dart';
import 'package:journal_app4/classes/format_dates.dart';
import 'package:journal_app4/classes/mood_icons.dart';
import 'package:journal_app4/blocs/journal_edit_bloc_provider.dart';

class EditEntry extends StatefulWidget {
  const EditEntry({super.key});

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  JournalEditBloc? _journalEditBloc;
  FormatDates? _formatDates;
  MoodIcons? _moodIcons;
  TextEditingController? _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = const MoodIcons();
    _noteController = TextEditingController();
    _noteController!.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  @override
  void dispose() {
    _noteController!.dispose();
    _journalEditBloc!.dispose();
    super.dispose();
  }

//Date Picker
  Future<String> _selectDate(String selectedDate) async {
    DateTime initialDate = DateTime.parse(selectedDate);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      selectedDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              initialDate.hour,
              initialDate.minute,
              initialDate.second,
              initialDate.millisecond,
              initialDate.microsecond)
          .toString();
    }

    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc!.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Entry",
          style: TextStyle(
            color: Colors.lightBlue.shade800,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32.0),
          child: Container(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.lightBlue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: _journalEditBloc!.dateEdit,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return TextButton(
                  onPressed: (() async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    String pickerDate =
                        await _selectDate(snapshot.data as String);
                    _journalEditBloc!.dateEditChanged.add(pickerDate);
                  }),
                  child: Row(children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 22.0,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      _formatDates!
                          .dateFormatShortMonthDayYear(snapshot.data as String),
                      style: const TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ]),
                );
              },
            ),
            StreamBuilder(
              stream: _journalEditBloc!.moodEdit,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return DropdownButtonHideUnderline(
                    child: DropdownButton<MoodIcons>(
                  value: _moodIcons!.getMoodIconList()[_moodIcons!
                      .getMoodIconList()
                      .indexWhere((icon) => icon.title == snapshot.data)],
                  onChanged: (selected) {
                    _journalEditBloc!.moodEditChanged
                        .add(selected!.title as String);
                  },
                  items:
                      _moodIcons!.getMoodIconList().map((MoodIcons selected) {
                    return DropdownMenuItem<MoodIcons>(
                      value: selected,
                      child: Row(children: [
                        Transform(
                          transform: Matrix4.identity()
                            ..rotateZ(_moodIcons!
                                .getMoodRotation(selected.title as String)),
                          alignment: Alignment.center,
                          child: Icon(
                            _moodIcons!.getMoodIcon(selected.title as String),
                            color: _moodIcons!
                                .getMoodColor(selected.title as String),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Text(selected.title as String)
                      ]),
                    );
                  }).toList(),
                ));
              },
            ),
            StreamBuilder(
              stream: _journalEditBloc!.noteEdit,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                _noteController!.value = _noteController!.value
                    .copyWith(text: snapshot.data as String);
                return TextField(
                  controller: _noteController,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    icon: Icon(Icons.subject),
                  ),
                  maxLines: null,
                  onChanged: (note) =>
                      _journalEditBloc!.noteEditChanged.add(note),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(color: Colors.lightGreen.shade100),
                    ),
                    onPressed: () {
                      _addOrUpdateJournal();
                    },
                    child: const Text('Save'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
