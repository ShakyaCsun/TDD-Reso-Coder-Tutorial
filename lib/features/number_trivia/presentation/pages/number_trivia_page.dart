import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:clean_architecture/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => getIt<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Container(
              height: MediaQuery.of(context).size.height / 5 * 3,
              child: Center(
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is NumberTriviaInitial) {
                      return MessageDisplay(
                        message: 'Start Searching!',
                      );
                    } else if (state is NumberTriviaLoadInProgress) {
                      return LoadingWidget();
                    } else if (state is NumberTriviaLoadSuccess) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is NumberTriviaLoadFailure) {
                      return MessageDisplay(message: state.message);
                    }
                    return LoadingWidget();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TriviaControls(),
          ],
        ),
      ),
    );
  }
}
