class Text {
  final int maxLength;
  final String _string;

  Text(this.maxLength, this._string);
}

class GoalText extends Text {
  GoalText(String str) : super(30, str);
}

class StepText extends Text {
  StepText(String str) : super(20, str);
}

class StepEvaluationText extends Text {
  StepEvaluationText(String str) : super(20, str);
}

class ResultText extends Text {
  ResultText(String str): super(20, str);
}

class ResultEvaluationText extends Text {
  ResultEvaluationText(String str): super(20, str);
}

class ObjectiveText extends Text {
  ObjectiveText(String str) : super(150, str);
}

class ObjectiveEvaluationText extends Text {
  ObjectiveEvaluationText(String str) : super(150, str);
}
