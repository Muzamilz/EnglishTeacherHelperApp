import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/config/api_keys.dart';

class GeminiService {
  late final GenerativeModel _model;
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    _initializeGemini();
  }

  void _initializeGemini() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: ApiKeys.geminiApiKey,
    );
  }

  Future<String> generateLessonPlan({
    required String topic,
    required String level,
    required int duration,
  }) async {
    try {
      final prompt = '''
Create a detailed ESL lesson plan for the following:
Topic: $topic
Level: $level
Duration: $duration minutes

Please structure the response in these stages:
1. Pre-Teaching (Warm-up and Lead-in activities)
- Specific activities
- Time allocation: ${(duration * 0.15).round()} minutes
- Materials needed

2. Presentation (Introduction of new language/content)
- Teaching approach
- Key points to cover
- Time allocation: ${(duration * 0.3).round()} minutes
- Visual aids and materials

3. Practice (Controlled practice activities)
- Activity types
- Time allocation: ${(duration * 0.3).round()} minutes
- Worksheets or materials needed
- Error correction strategies

4. Production (Free practice activities)
- Communication tasks
- Time allocation: ${(duration * 0.25).round()} minutes
- Success criteria
- Assessment methods

For each stage, include:
- Clear step-by-step instructions
- Student interaction patterns (pair work, group work, etc.)
- Potential challenges and solutions
- Differentiation strategies for mixed abilities
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Failed to generate lesson plan';
    } catch (e) {
      return 'Error generating lesson plan: $e';
    }
  }

  Future<String> generateTeachingTips({
    required String challenge,
    required String studentLevel,
  }) async {
    try {
      final prompt = '''
Provide practical teaching tips for the following challenge in an ESL classroom:
Challenge: $challenge
Student Level: $studentLevel

Please include:
1. Immediate solutions
2. Long-term strategies
3. Recommended resources or materials
4. Best practices from experienced teachers
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Failed to generate teaching tips';
    } catch (e) {
      return 'Error generating teaching tips: $e';
    }
  }

  Future<String> generateAssessmentCriteria({
    required String skill,
    required String level,
  }) async {
    try {
      final prompt = '''
Create detailed assessment criteria for evaluating ESL students':
Skill: $skill
Level: $level

Please include:
1. Specific criteria for scoring
2. Performance level descriptions
3. Sample responses or examples
4. Scoring rubric (1-5 scale)
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Failed to generate assessment criteria';
    } catch (e) {
      return 'Error generating assessment criteria: $e';
    }
  }

  Future<String> generateLessonFeedback({
    required String lessonSummary,
    required String studentResponse,
  }) async {
    try {
      final prompt = '''
Analyze this ESL lesson and provide constructive feedback:
Lesson Summary: $lessonSummary
Student Response: $studentResponse

Please provide:
1. Strengths of the lesson
2. Areas for improvement
3. Specific recommendations
4. Alternative activities or approaches
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Failed to generate lesson feedback';
    } catch (e) {
      return 'Error generating lesson feedback: $e';
    }
  }
}
