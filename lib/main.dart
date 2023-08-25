import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/constants/routes.dart';
// import 'package:my_flutter_app/services/auth/auth_exceptions.dart';
// import 'package:my_flutter_app/services/auth/auth_service.dart';
import 'package:my_flutter_app/views/login_view.dart';
import 'package:my_flutter_app/views/notes/create_update_note_view.dart';
import 'package:my_flutter_app/views/notes/notes_view.dart';
import 'package:my_flutter_app/views/register_view.dart';
import 'package:my_flutter_app/views/verify_email_view.dart';

void main() {
  // Used for native code to interact with the Flutter engine ie. Java/Kotlin for android and swift/obj-c for ios
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

// // ************* Future call should not be inside futureBuilder ??
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//       // Used to create widgets based on latest snapshot of interaction with a Future (Future function call)
//       future: AuthService.firebase().initialize(), //initialize firebase
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Error: ${snapshot.error}"),
//           );
//         } else {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               try {
//                 final user = AuthService.firebase().currentUser;
//                 if (user != null) {
//                   if (user.isEmailVerified) {
//                     return const NotesView();
//                   } else {
//                     return const VerifyEmailView();
//                   }
//                 } else {
//                   return const LoginView();
//                 }
//               } on UserNotFoundAuthException {
//                 return const LoginView();
//               }
//             default:
//               return const CircularProgressIndicator();
//           }
//         }
//       }, //Builder
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Testing bloc"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : " ";

            return Column(
              children: [
                Text("Current value => ${state.value}"),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text("Invalid input : $invalidValue"),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Enter a number here",
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                      },
                      child: const Text("-"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              IncrementEvent(_controller.text),
                            );
                      },
                      child: const Text("+"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
