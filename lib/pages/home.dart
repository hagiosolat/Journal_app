import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/authentication_bloc.dart';
import 'package:journal_app4/blocs/authentication_bloc_provider.dart';
import 'package:journal_app4/blocs/home_bloc.dart';
import 'package:journal_app4/blocs/home_bloc_provider.dart';
import 'package:journal_app4/blocs/journal_edit_bloc.dart';
import 'package:journal_app4/blocs/journal_edit_bloc_provider.dart';
import 'package:journal_app4/classes/format_dates.dart';
import 'package:journal_app4/classes/mood_icons.dart';
import 'package:journal_app4/models/journal.dart';
import 'package:journal_app4/pages/edit_entry.dart';
import 'package:journal_app4/services/db_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationBloc? _authenticationBloc;
  HomeBloc? _homeBloc;
  String? _uid;
  final MoodIcons _moodIcons = const MoodIcons();
  final FormatDates _formatDates = FormatDates();




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    _homeBloc!.dispose();
    super.dispose();
  }

  //Add or Edit Journal Entry and call the Show Entry Dialog
  void _addOrEditJournal ({bool? add, Journal? journal}) {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (BuildContext context) => JournalEditBlocProvider(
          journalEditBloc: JournalEditBloc(add!, journal!, DbFirestoreService()),
          child: const EditEntry(),
         ),
         fullscreenDialog: true
        )
      );
  }
 
//Confirm Deleting a Journal Entry 
Future<bool> _confirmDeleteJournal() async {
  return await showDialog(
     context: context, 
     barrierDismissible: false,
     builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Journal"),
        content: const Text("Are you sure you would like to Delete"),
        actions: [
          TextButton(

          child: const Text('CANCEL'),
          onPressed: (){
            Navigator.pop(context, false);
          },
          ),
             
        TextButton(
          child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context, true);
          }
        )

        ],

      );
     }
     
     );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Journal',
          style: TextStyle(
            color: Colors.lightBlue.shade800,
          ),
        ),
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
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _authenticationBloc!.logoutUser.add(true);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.lightBlue.shade800,
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addOrEditJournal(add: true, journal: Journal(uid: _uid));
        },
        tooltip: 'Add Journal Entry',
        backgroundColor: Colors.lightBlue.shade300,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: _homeBloc!.listJournal,
        builder: ((context, snapshot) {
         if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),
          
          );
         }  else if (snapshot.hasData){
          return _buildListViewSeparated(snapshot);
         } else {
          return Center(
            child: 
            Container(
              child:
          const Text('Add Journals.')
          )
        
        );
         }
        }),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot){
    return ListView.separated(
     itemCount: snapshot.data.length,
     itemBuilder: (context, index) {
        String titleDate = _formatDates.dateFormatShortMonthDayYear(snapshot.data[index].date);
        String subtitle = snapshot.data[index].mood + "\n" + snapshot.data[index].note;
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(Icons.delete,
            color: Colors.white,
            ),
          ),


          child: ListTile(
            leading: Column(children: [
              Text(_formatDates.dateFormatDayNumber(snapshot.data[index].date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: Colors.lightGreen),

              ),

              Text(_formatDates.dateFormatShortDayName(snapshot.data[index].date)),
            ]),
            trailing: Transform(
              transform: Matrix4.identity()..rotateZ(_moodIcons.getMoodRotation(snapshot.data[index].mood)),
              alignment: Alignment.center,
              child: Icon(_moodIcons.getMoodIcon(snapshot.data[index].mood),
              color: _moodIcons.getMoodColor(snapshot.data[index].mood),
              size: 42.0),
            ),

            title: Text(titleDate, 
            style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            subtitle: Text(subtitle),
            onTap: () {
              _addOrEditJournal(
                add: false,
                journal: snapshot.data[index],
              );
            },
              ),
          confirmDismiss: (direction) async {
                bool confirmDelete = await _confirmDeleteJournal();
                if(confirmDelete){
                  _homeBloc!.deleteJournal.add(snapshot.data[index]);
                }
              }
        );
     },
     separatorBuilder: (context, snapshot){
      return const Divider(color: Colors.grey,);
     },

     );
  }


}
