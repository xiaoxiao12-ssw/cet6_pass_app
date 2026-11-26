import 'package:flutter_test/flutter_test.dart';
import 'package:cet6_pass_app/data/cet6_listening_data.dart';
import 'package:cet6_pass_app/data/cet6_reading_data.dart';
import 'package:cet6_pass_app/data/cet6_writing_data.dart';
import 'package:cet6_pass_app/models/cet6_models.dart';

void main() {
  test('CET-6 datasets cover all required real exam sections', () {
    // 听力三大题型全覆盖
    final listeningTypes =
        cet6ListeningExercises.map((e) => e.sectionType).toSet();
    expect(listeningTypes, containsAll(ListeningSectionType.values));

    // 阅读三大题型全覆盖 + 分值权重正确
    expect(cet6BankedClozeExercises.length, greaterThanOrEqualTo(2));
    expect(cet6MatchingExercises.length, greaterThanOrEqualTo(1));
    expect(cet6CarefulReadingExercises.length, greaterThanOrEqualTo(2));
    expect(ReadingSectionType.bankedCloze.scorePerQuestion, 3.55);
    expect(ReadingSectionType.matching.scorePerQuestion, 7.1);
    expect(ReadingSectionType.carefulReading.scorePerQuestion, 14.2);

    // 写译三大作文体裁 + 三大翻译主题全覆盖
    expect(
      cet6WritingTopics.map((e) => e.genre).toSet(),
      containsAll(WritingGenre.values),
    );
    expect(
      cet6TranslationTopics.map((e) => e.theme).toSet(),
      containsAll(TranslationTheme.values),
    );
  });
}
