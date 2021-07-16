
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/bloc/cubit/add_note_cubit.dart';
import 'package:notes_app/shared/bloc/states/add_note_states.dart';
import 'package:notes_app/shared/constants.dart';

class AddNote extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context)=> AddNoteCubit()..clearStack(),
      child: BlocConsumer<AddNoteCubit , AddNoteState>(
        listener: (context ,AddNoteState state){},
        builder: (context,state){
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              ),
              actions: [
                IconButton(
                  tooltip: 'Undo',
                  icon: Icon(Icons.undo),
                  onPressed: cubit.stackController!.state == '' && !(cubit.stackController!.canUndo) ? null :cubit.undoFun,
                ),
                IconButton(tooltip: 'Redo',
                  icon: Icon(Icons.redo),
                  onPressed: !cubit.stackController!.canRedo ? null :cubit.redoFun,
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800
                      ),
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(color: greyColor, fontSize: 28,fontWeight: FontWeight.normal),
                        fillColor: Theme.of(context).primaryColor,
                        border: InputBorder.none,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10,),
                      height: 2,width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white24
                      ),
                    ),
                    TextFormField(
                      controller: cubit.noteTextController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      onChanged:(value){cubit.onNoteTextChanged(value);},
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,

                      decoration: InputDecoration(
                        hintText: 'Start typing your note ...',
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(color: greyColor, fontSize: 20),
                        fillColor: Theme.of(context).primaryColor,
                        border: InputBorder.none,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: (){},
             /* onPressed: (){
                _scaffoldKey.currentState!.showBottomSheet((context) {
                  return Column();
                });
              }, */
              child: Icon(Icons.clear),
            ),

          );

        },
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/constants.dart';
import 'package:notes_app/shared/styles/theme.dart';
import 'package:replay_bloc/replay_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: MaterialApp(
        home: CounterPage(),
        theme: darkTheme,
      ),
    );
  }
}


class CounterPage extends StatefulWidget {

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<CounterBloc, String>(
            builder: (context, state) {
              final bloc = context.read<CounterBloc>();
              return IconButton(
                icon: const Icon(Icons.undo),
                onPressed: bloc.canUndo ? (){
                  bloc.undo();
                setState(() {
                  _textEditingController.text = state ;
                });
                } : null,
              );
            },
          ),
          BlocBuilder<CounterBloc, String>(
            builder: (context, state) {
              final bloc = context.read<CounterBloc>();
              return IconButton(
                icon: const Icon(Icons.redo),
                onPressed: bloc.canRedo ?(){ bloc.redo();

                }: null,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _textEditingController,
                onChanged: (value){
                  context.read<CounterBloc>().add(Increment());
                },
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800
                ),

                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  hintText: 'Title',
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(color: greyColor, fontSize: 28,fontWeight: FontWeight.normal),
                  fillColor: Theme.of(context).primaryColor,
                  border: InputBorder.none,
                ),
              ),
              Container(

                margin: EdgeInsets.only(bottom: 10,),
                height: 2,width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white24
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                onChanged: (value){
                },
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  hintText: 'Start typing your note ...',
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(color: greyColor, fontSize: 20),
                  fillColor: Theme.of(context).primaryColor,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),

      // BlocBuilder<CounterBloc, String>(
      //   builder: (context, state) {
      //     return Center(child: Text('$state', style: textTheme.headline2));
      //   },
      // ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => context.read<CounterBloc>().add(Increment()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => context.read<CounterBloc>().add(Decrement()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: FloatingActionButton(
              child: const Icon(Icons.delete_forever),
              onPressed: () => context.read<CounterBloc>().add(Reset()),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterCubit extends ReplayCubit<String> {
  /// {@macro replay_counter_cubit}
  CounterCubit() : super('');

  /// Increments the [CounterCubit] state by 1.
  void increment() => emit(state);

  /// Decrements the [CounterCubit] state by 1.
  void decrement() => emit(state.split(' ').last);

  /// Resets the [CounterCubit] state to 0.
  void reset() => emit('');
}

class CounterEvent extends ReplayEvent {}

/// Notifies [CounterBloc] to increment its state.
class Increment extends CounterEvent {
  @override
  String toString() => 'Increment';
}

/// Notifies [CounterBloc] to decrement its state.
class Decrement extends CounterEvent {
  @override
  String toString() => 'Decrement';
}

/// Notifies [CounterBloc] to reset its state.
class Reset extends CounterEvent {
  @override
  String toString() => 'Reset';
}

class CounterBloc extends ReplayBloc<CounterEvent, String> {
  CounterBloc() : super('');

  @override
  Stream<String> mapEventToState(CounterEvent event) async* {
    if (event is Increment) {
      yield state ;
    } else if (event is Decrement) {
      yield state.split(' ').last;
    } else if (event is Reset) {
      yield '';
    }
  }
}

*/