class PromptGenerator {
  static String generateCareerPathPrompt(
    String educationLevel,
    List<String> interests,
  ) {
    final String query = """
          Determine a career path for an Indian student of $educationLevel
          and the following interests ${interests.toString()}.
          Give only the top career path as single string
          """;
    return query;
  }

  static String generateQuizPrompt(
    String educationLevel,
    List<String> interests,
  ) {
    final String query = """
    Create a MCQ based quiz of 10 questions for an Indian student of
    $educationLevel and with following interests ${interests.toString()}, to
    assess the perfect career path for the student.
    Keep the quiz relevant to the above scenario and provide short options.
    Also give the quiz a title, short description and summary and don't add any
    formatting, just plain string.
    Return the quiz in the form of JSON which should have the following format

    {
      title: String,
      description: String,
      summary: String,
      questions: [
        {
          "question": String
          "options": List<String>
          "correctOptionIndex": int,
        },
        ...
      ]
    }

    Don't add any comments or incorrect values such as negative index value for correctOptionIndex.
    Adhere strictly to the format given above.
    """;
    return query;
  }
}
