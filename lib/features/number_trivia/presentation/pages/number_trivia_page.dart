import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return MessageDisplay(
                    message: "Start searching...",
                  );
                }
                if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else if (state is Loaded) {
                  return TriviaDisplay(
                    numberTrivia: state.trivia,
                  );
                } else if (state is Loading) {
                  return LoadingWidget();
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Placeholder(),
                  );
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TriviaControls(),
          ],
        ),
      ),
    );
  }
}

