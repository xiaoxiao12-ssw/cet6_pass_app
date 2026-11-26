import '../models/study_models.dart';

/// 六级听力（248.5分）盲听 + 逐句精听 + 同义替换防坑题库
const List<ListeningTrack> cet6ListeningTracks = [
  ListeningTrack(
    id: 'lis_01',
    title: '校园学术长对话：论文延期与科研瓶颈',
    sectionType: 'Section A 长对话 (7.1分/题)',
    difficultyTag: '425 必拿热身篇',
    traps: [
      SynonymTrap(
        audioWord: 'running behind schedule',
        answerSynonym: 'delayed / falling behind',
        meaningZh: '进度落后、延期了',
      ),
      SynonymTrap(
        audioWord: 'narrow down the scope',
        answerSynonym: 'focus on a more specific topic',
        meaningZh: '缩小研究范围 → 聚焦更具体的话题',
      ),
      SynonymTrap(
        audioWord: 'overwhelming amount of data',
        answerSynonym: 'too much information to handle',
        meaningZh: '海量数据压得喘不过气 → 信息多到处理不过来',
      ),
    ],
    lines: [
      ListeningLine(
        speaker: 'W',
        en: 'Hey Leo, you look exhausted. Are you still stuck on your graduation paper?',
        zh: '嘿里奥，你看着累坏了，还在毕业论文上卡壳呢？',
      ),
      ListeningLine(
        speaker: 'M',
        en: 'Honestly, I am running behind schedule because I collected an overwhelming amount of data.',
        zh: '说实话我进度全落后了，因为我收集的数据多得根本处理不过来。',
        highlightWords: ['running behind schedule', 'overwhelming amount of data'],
      ),
      ListeningLine(
        speaker: 'W',
        en: 'That sounds familiar. Did you try talking to Professor Lin about cutting some chapters?',
        zh: '太有共鸣了。你试过找林教授商量删掉几章吗？',
      ),
      ListeningLine(
        speaker: 'M',
        en: 'Yes, she advised me to narrow down the scope and analyze only urban commuters.',
        zh: '找过了，她建议我缩小研究范围，只分析城市通勤人群就行。',
        highlightWords: ['narrow down the scope'],
      ),
      ListeningLine(
        speaker: 'W',
        en: 'That is a super pragmatic move. You will definitely finish before Friday’s deadline.',
        zh: '这招太务实了，周五截止前你肯定能搞定。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. Why is the man falling behind with his paper?',
        options: [
          'A. He forgot Friday’s submission deadline.',
          'B. He has gathered too much information to handle smoothly.',
          'C. Professor Lin refused to read his draft.',
          'D. He lost all his commuter survey files.',
        ],
        correctIndex: 1,
        explanation: '六级听力经典同义替换：原文 overwhelming amount of data → 答案 B 的 too much information to handle！',
      ),
      ReadingQuestion(
        question: '2. What did Professor Lin suggest the man do?',
        options: [
          'A. Focus his research on a more specific group.',
          'B. Change his graduation topic completely.',
          'C. Collect more rural commuter questionnaires.',
          'D. Apply for a two-week extension.',
        ],
        correctIndex: 0,
        explanation: '原文 narrow down the scope and analyze only urban commuters → 同义替换为 focus his research on a more specific group！',
      ),
    ],
  ),
  ListeningTrack(
    id: 'lis_02',
    title: '科普短文：为什么“微习惯”比三分钟热度更管用？',
    sectionType: 'Section B 听力篇章 (7.1分/题)',
    difficultyTag: '高频心理行为类',
    traps: [
      SynonymTrap(
        audioWord: 'ambitious resolutions',
        answerSynonym: 'unrealistic big goals',
        meaningZh: '野心勃勃的宏大计划 → 不切实际的大目标',
      ),
      SynonymTrap(
        audioWord: 'triggers resistance',
        answerSynonym: 'causes the brain to push back',
        meaningZh: '引发大脑抗拒',
      ),
      SynonymTrap(
        audioWord: 'tiny daily wins',
        answerSynonym: 'small consistent achievements',
        meaningZh: '微小的日常胜利 → 持续的小成就',
      ),
    ],
    lines: [
      ListeningLine(
        speaker: 'Narrator',
        en: 'Every January, millions of people make ambitious resolutions to master a language or lose weight overnight.',
        zh: '每年一月，都有数百万人立下宏大flag，想一夜之间精通一门外语或者暴瘦。',
        highlightWords: ['ambitious resolutions'],
      ),
      ListeningLine(
        speaker: 'Narrator',
        en: 'Yet behavioral studies show that nearly eighty percent of those plans collapse within six weeks.',
        zh: '然而行为研究表明，将近八成的这类宏大计划在六周内就会彻底崩盘。',
      ),
      ListeningLine(
        speaker: 'Narrator',
        en: 'The main reason is that sudden dramatic change triggers resistance in our brain.',
        zh: '核心原因在于：突然的剧烈改变会触发大脑强烈的本能抗拒。',
        highlightWords: ['triggers resistance'],
      ),
      ListeningLine(
        speaker: 'Narrator',
        en: 'In contrast, breaking a big exam into tiny daily wins builds momentum without draining willpower.',
        zh: '相反，把一场大考拆解成一个个微小的日常胜利，能在不耗干意志力的前提下滚起雪球。',
        highlightWords: ['tiny daily wins'],
      ),
      ListeningLine(
        speaker: 'Narrator',
        en: 'Once an easy routine feels automatic, increasing difficulty becomes remarkably effortless.',
        zh: '一旦简单的日常习惯变成自动化反射，再往上加难度就会出奇地轻松。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. Why do most ambitious New Year plans fail quickly?',
        options: [
          'A. People lack access to online learning tools.',
          'B. Abrupt and huge changes cause the brain to push back.',
          'C. Six weeks is too short to learn any vocabulary.',
          'D. Friends rarely support personal resolutions.',
        ],
        correctIndex: 1,
        explanation: '原文 sudden dramatic change triggers resistance → 同义替换为 abrupt and huge changes cause the brain to push back！',
      ),
      ReadingQuestion(
        question: '2. What is the key advantage of tiny daily wins?',
        options: [
          'A. They build lasting momentum without exhausting willpower.',
          'B. They guarantee an overnight score jump without practice.',
          'C. They eliminate the need to ever increase difficulty.',
          'D. They replace regular sleep schedules.',
        ],
        correctIndex: 0,
        explanation: '原文 builds momentum without draining willpower → 精准对应 without exhausting willpower（draining = exhausting）。',
      ),
    ],
  ),
  ListeningTrack(
    id: 'lis_03',
    title: '高分讲座：共享出行与未来绿色城市交通',
    sectionType: 'Section C 学术讲座 (14.2分/题 · 高分重灾区)',
    difficultyTag: '14.2分必争讲座',
    traps: [
      SynonymTrap(
        audioWord: 'sit idle ninety percent of the time',
        answerSynonym: 'remain unused for most of the day',
        meaningZh: '90%时间都在吃灰停着 → 一天大部分时间闲置',
      ),
      SynonymTrap(
        audioWord: 'curb carbon emissions',
        answerSynonym: 'reduce greenhouse pollution',
        meaningZh: '遏制碳排放 → 减少温室气体污染',
      ),
      SynonymTrap(
        audioWord: 'seamless connection',
        answerSynonym: 'smooth transition between transport modes',
        meaningZh: '无缝衔接 → 各种交通方式丝滑换乘',
      ),
    ],
    lines: [
      ListeningLine(
        speaker: 'Lecturer',
        en: 'Good morning everyone. Today we will examine how shared mobility is reshaping modern urban planning.',
        zh: '大家早上好。今天我们来剖析共享出行是如何重塑现代城市规划的。',
      ),
      ListeningLine(
        speaker: 'Lecturer',
        en: 'Surprisingly, studies reveal that private cars sit idle ninety percent of the time while taking up valuable street space.',
        zh: '令人惊讶的是，研究显示私家车百分之九十的时间都在原地吃灰，却占着寸土寸金的街道空间。',
        highlightWords: ['sit idle ninety percent of the time'],
      ),
      ListeningLine(
        speaker: 'Lecturer',
        en: 'By integrating shared bikes, electric buses, and metro lines, cities can dramatically curb carbon emissions.',
        zh: '通过整合共享单车、电动公交和地铁线路，城市能够大幅度遏制碳排放。',
        highlightWords: ['curb carbon emissions'],
      ),
      ListeningLine(
        speaker: 'Lecturer',
        en: 'However, commuters will only abandon private vehicles when public systems offer a seamless connection for the last kilometer.',
        zh: '但只有当公共交通搞定“最后一公里”的无缝衔接时，通勤族才会心甘情愿放弃私家车。',
        highlightWords: ['seamless connection'],
      ),
      ListeningLine(
        speaker: 'Lecturer',
        en: 'Therefore, smart cities must prioritize convenience and affordability over simply banning cars.',
        zh: '因此，智慧城市必须优先做好便利性和平价体验，而不是一刀切禁车。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. What surprising fact about private cars does the lecturer mention?',
        options: [
          'A. They are cheaper than riding electric buses.',
          'B. They remain unused for the vast majority of the day.',
          'C. They take up very little urban parking space.',
          'D. They produce less pollution than metro systems.',
        ],
        correctIndex: 1,
        explanation: '14.2分大题！原文 sit idle ninety percent of the time → 同义替换为 remain unused for the vast majority of the day！',
      ),
      ReadingQuestion(
        question: '2. Under what condition will commuters give up driving private cars?',
        options: [
          'A. When cities immediately ban all private vehicles.',
          'B. When shared bikes become completely free forever.',
          'C. When public transit provides smooth last-kilometer transitions.',
          'D. When parking lots are built on top of office towers.',
        ],
        correctIndex: 2,
        explanation: '定位 however 转折句（六级讲座转折后必出答案！）：seamless connection for the last kilometer → smooth last-kilometer transitions。',
      ),
    ],
  ),
];
