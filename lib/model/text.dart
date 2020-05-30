class Description {
  final int maxLength;
  final String _string;

  Description(this.maxLength, this._string);
}

class GoalDescription extends Description {
  GoalDescription(String str) : super(30, str);
}

class StepDescription extends Description {
  StepDescription(String str) : super(20, str);
}

class StepEvaluationDescription extends Description {
  StepEvaluationDescription(String str) : super(20, str);
}

class ResultDescription extends Description {
  ResultDescription(String str): super(20, str);
}

class ResultEvaluationDescription extends Description {
  ResultEvaluationDescription(String str): super(20, str);
}

class ObjectiveDescription extends Description {
  ObjectiveDescription(String str) : super(150, str);
}

class ObjectiveEvaluationDescription extends Description {
  ObjectiveEvaluationDescription(String str) : super(150, str);
}
