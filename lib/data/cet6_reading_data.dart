import '../models/study_models.dart';

/// 六级仔细阅读（14.2分/题）双语逐句精读 + 长难句拆解训练营题库
const List<ReadingPassage> cet6ReadingPassages = [
  ReadingPassage(
    id: 'read_01',
    title: 'AI 浪潮下，人类真正不可替代的核心能力是什么？',
    topicTag: '科技与职场 · 仔细阅读',
    examSource: '六级仔细阅读真题风精选（每题 14.2 分必拿）',
    glossary: {
      'automation': ReadingWordHint(
        word: 'automation',
        phonetic: '/ˌɔːtəˈmeɪʃn/',
        meaning: 'n. 自动化',
        tip: 'auto(自动) + mation → 科技类阅读第一高频词',
      ),
      'routine': ReadingWordHint(
        word: 'routine',
        phonetic: '/ruːˈtiːn/',
        meaning: 'adj. 常规的，重复性的；n. 例行公事',
        tip: '六级常考“重复性劳动 routine tasks”',
      ),
      'undermine': ReadingWordHint(
        word: 'undermine',
        phonetic: '/ˌʌndəˈmaɪn/',
        meaning: 'v. 逐渐削弱，暗中破坏',
        tip: 'under(下面) + mine(挖坑) → 暗中削弱',
      ),
      'empathy': ReadingWordHint(
        word: 'empathy',
        phonetic: '/ˈempəθi/',
        meaning: 'n. 共情能力，同理心',
        tip: 'em(进入) + path(情感) → 走进别人内心',
      ),
      'adaptability': ReadingWordHint(
        word: 'adaptability',
        phonetic: '/əˌdæptəˈbɪləti/',
        meaning: 'n. 适应能力',
        tip: 'adapt(适应) + ability(能力)',
      ),
      'indispensable': ReadingWordHint(
        word: 'indispensable',
        phonetic: '/ˌɪndɪˈspensəbl/',
        meaning: 'adj. 不可或缺的',
        tip: '六级阅读与作文双料神词',
      ),
    },
    sentences: [
      ReadingSentence(
        en: 'Although rapid automation has replaced millions of routine tasks, experts argue that it does not necessarily undermine human employment as a whole.',
        zh: '尽管快速自动化已经替代了数百万重复性岗位，但专家指出，这未必会从整体上摧毁人类就业。',
        segments: [
          SentenceSegment('Although rapid automation has replaced millions of routine tasks, ', ClauseRole.adverbial),
          SentenceSegment('experts argue ', ClauseRole.core),
          SentenceSegment('that it does not necessarily undermine human employment ', ClauseRole.core),
          SentenceSegment('as a whole.', ClauseRole.adverbial),
        ],
        structureNote: '主干：experts argue that it does not undermine employment（专家认为它未必削弱就业）。开头 Although 引导让步状语，记住六级铁律：让步后面才是作者真观点！',
      ),
      ReadingSentence(
        en: 'Instead, the workplace of the next decade will reward workers who combine digital fluency with genuine empathy and complex judgment.',
        zh: '相反，未来十年的职场会重奖那些把数字技能、真实共情力和复杂判断力结合起来的打工人。',
        segments: [
          SentenceSegment('Instead, ', ClauseRole.adverbial),
          SentenceSegment('the workplace of the next decade will reward workers ', ClauseRole.core),
          SentenceSegment('who combine digital fluency with genuine empathy and complex judgment.', ClauseRole.modifier),
        ],
        structureNote: '主干：the workplace will reward workers（职场将奖赏员工）。后面 who 引导超长定语从句，专门用来修饰“什么样的员工”。',
      ),
      ReadingSentence(
        en: 'Universities that still rely solely on rote memorization risk leaving their graduates vulnerable to sudden shifts in the labor market.',
        zh: '那些至今还只靠死记硬背教学的高校，正冒着让毕业生在劳动力市场巨变中毫无还手之力的风险。',
        segments: [
          SentenceSegment('Universities ', ClauseRole.core),
          SentenceSegment('that still rely solely on rote memorization ', ClauseRole.modifier),
          SentenceSegment('risk leaving their graduates vulnerable ', ClauseRole.core),
          SentenceSegment('to sudden shifts in the labor market.', ClauseRole.adverbial),
        ],
        structureNote: '先扒掉中间 that 定语从句！骨架秒变：Universities risk leaving graduates vulnerable（高校让毕业生陷入脆弱）。',
      ),
      ReadingSentence(
        en: 'Therefore, lifelong adaptability has become an indispensable safeguard for young professionals striving to thrive alongside intelligent machines.',
        zh: '因此，对于想与智能机器共生并脱颖而出的年轻职场人来说，终身适应力已成为不可或缺的护身符。',
        segments: [
          SentenceSegment('Therefore, ', ClauseRole.adverbial),
          SentenceSegment('lifelong adaptability has become an indispensable safeguard ', ClauseRole.core),
          SentenceSegment('for young professionals striving to thrive alongside intelligent machines.', ClauseRole.modifier),
        ],
        structureNote: '结论句（Therefore 开头必出题！）：lifelong adaptability has become a safeguard（终身适应力成了护身符）。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. According to experts in the passage, what is the overall effect of rapid automation on employment?',
        options: [
          'A. It will completely eliminate all human jobs within a decade.',
          'B. It replaces routine work but does not inevitably destroy overall jobs.',
          'C. It makes digital fluency unnecessary for university graduates.',
          'D. It forces companies to rely solely on rote memorization.',
        ],
        correctIndex: 1,
        explanation: '定位第1句：not necessarily undermine human employment 同义替换为 does not inevitably destroy overall jobs！A选项 completely 太绝对（六级绝对词必排除）。',
      ),
      ReadingQuestion(
        question: '2. What does the author suggest universities should avoid?',
        options: [
          'A. Teaching students complex judgment and empathy.',
          'B. Preparing graduates for shifts in the labor market.',
          'C. Depending exclusively on mechanical memorization.',
          'D. Encouraging lifelong adaptability among youths.',
        ],
        correctIndex: 2,
        explanation: '定位第3句：rely solely on rote memorization 同义替换为 depending exclusively on mechanical memorization（solely = exclusively，rote = mechanical）。',
      ),
    ],
  ),
  ReadingPassage(
    id: 'read_02',
    title: '城市口袋公园：治愈现代人“慢性焦虑”的免费良药',
    topicTag: '城市生态与心理 · 仔细阅读',
    examSource: '六级仔细阅读真题风精选（每题 14.2 分必拿）',
    glossary: {
      'chronic': ReadingWordHint(
        word: 'chronic',
        phonetic: '/ˈkrɒnɪk/',
        meaning: 'adj. 慢性的，长期的',
        tip: '医学/心理类六级阅读高频词',
      ),
      'alleviate': ReadingWordHint(
        word: 'alleviate',
        phonetic: '/əˈliːvieɪt/',
        meaning: 'v. 缓解，减轻',
        tip: '常与 stress / anxiety / poverty 搭配',
      ),
      'substantial': ReadingWordHint(
        word: 'substantial',
        phonetic: '/səbˈstænʃl/',
        meaning: 'adj. 显著的，可观的',
        tip: '用来替掉 low-level 的 big / large',
      ),
      'allocate': ReadingWordHint(
        word: 'allocate',
        phonetic: '/ˈæləkeɪt/',
        meaning: 'v. 分配，拨出（资金/土地）',
        tip: '政府政策类段落高频动词',
      ),
      'neglected': ReadingWordHint(
        word: 'neglected',
        phonetic: '/nɪˈɡlektɪd/',
        meaning: 'adj. 被忽视的，无人打理的',
        tip: 'neglect(忽视) 的过去分词作定语',
      ),
    },
    sentences: [
      ReadingSentence(
        en: 'In densely populated cities where concrete towers dominate the skyline, even tiny green spaces can significantly alleviate chronic mental fatigue.',
        zh: '在钢筋水泥高楼林立的高密度城市里，哪怕巴掌大的绿地也能显著缓解长期精神疲惫。',
        segments: [
          SentenceSegment('In densely populated cities ', ClauseRole.adverbial),
          SentenceSegment('where concrete towers dominate the skyline, ', ClauseRole.modifier),
          SentenceSegment('even tiny green spaces can significantly alleviate chronic mental fatigue.', ClauseRole.core),
        ],
        structureNote: '去掉前面地点状语和 where 定语从句，核心一句秒懂：tiny green spaces can alleviate mental fatigue（小绿地能缓解精神疲劳）。',
      ),
      ReadingSentence(
        en: 'A recent survey involving twelve thousand commuters revealed that spending merely twenty minutes in a pocket park produced a substantial drop in stress hormones.',
        zh: '一项涵盖一万两千名通勤族的最新调查显示，在口袋公园里仅仅待上二十分钟，压力激素水平就会大幅跳水。',
        segments: [
          SentenceSegment('A recent survey ', ClauseRole.core),
          SentenceSegment('involving twelve thousand commuters ', ClauseRole.modifier),
          SentenceSegment('revealed that spending merely twenty minutes in a pocket park produced a substantial drop in stress hormones.', ClauseRole.core),
        ],
        structureNote: 'involving... 是现在分词短语作后置定语修饰 survey。核心：A survey revealed that 20 minutes produced a drop in stress hormones。',
      ),
      ReadingSentence(
        en: 'Rather than building huge suburban parks that require an hour of driving, pragmatic planners now allocate funds to transforming neglected street corners.',
        zh: '务实的城市规划师不再执着于建那种得开车一小时才能到的超大郊野公园，而是把钱花在改造被遗忘的街角空地上。',
        segments: [
          SentenceSegment('Rather than building huge suburban parks ', ClauseRole.adverbial),
          SentenceSegment('that require an hour of driving, ', ClauseRole.modifier),
          SentenceSegment('pragmatic planners now allocate funds to transforming neglected street corners.', ClauseRole.core),
        ],
        structureNote: 'Rather than 对比结构是六级最爱考的！重点看后半句主干：planners allocate funds to transforming street corners。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. What did the survey of twelve thousand commuters find?',
        options: [
          'A. Commuters prefer driving an hour to huge suburban parks.',
          'B. A brief stay in a small urban park notably lowers stress levels.',
          'C. Concrete towers have no impact on residents’ mental health.',
          'D. Pocket parks are too expensive for modern cities to maintain.',
        ],
        correctIndex: 1,
        explanation: '定位第2句：merely twenty minutes = A brief stay；substantial drop in stress hormones = notably lowers stress levels！',
      ),
      ReadingQuestion(
        question: '2. What approach are pragmatic urban planners currently adopting?',
        options: [
          'A. Replacing all downtown streets with large forests.',
          'B. Cutting total public funding for green infrastructure.',
          'C. Investing in turning overlooked corners into small green spots.',
          'D. Banning cars from entering densely populated areas.',
        ],
        correctIndex: 2,
        explanation: '定位第3句：allocate funds to transforming neglected street corners 同义替换为 investing in turning overlooked corners into small green spots。',
      ),
    ],
  ),
  ReadingPassage(
    id: 'read_03',
    title: '注意力经济陷阱：为什么你越刷短视频越觉得空虚？',
    topicTag: '数字生活与心理 · 仔细阅读',
    examSource: '六级仔细阅读真题风精选（每题 14.2 分必拿）',
    glossary: {
      'paradox': ReadingWordHint(
        word: 'paradox',
        phonetic: '/ˈpærədɒks/',
        meaning: 'n. 悖论，自相矛盾的现象',
        tip: '常出现在文章首句引出讨论',
      ),
      'prevalent': ReadingWordHint(
        word: 'prevalent',
        phonetic: '/ˈprevələnt/',
        meaning: 'adj. 普遍存在的，盛行的',
        tip: '社会现象作文开头高频替换词',
      ),
      'diminish': ReadingWordHint(
        word: 'diminish',
        phonetic: '/dɪˈmɪnɪʃ/',
        meaning: 'v. 减弱，削弱，减少',
        tip: '常和 attention / satisfaction 搭配',
      ),
      'detrimental': ReadingWordHint(
        word: 'detrimental',
        phonetic: '/ˌdetrɪˈmentl/',
        meaning: 'adj. 有害的，不利的',
        tip: 'be detrimental to = 对……有害',
      ),
      'curb': ReadingWordHint(
        word: 'curb',
        phonetic: '/kɜːb/',
        meaning: 'v. 遏制，控制',
        tip: '解决问题段落高频动词',
      ),
    },
    sentences: [
      ReadingSentence(
        en: 'It has become a prevalent paradox that endless streams of tailored entertainment often leave viewers feeling more exhausted than refreshed.',
        zh: '一个越来越普遍的悖论是：算法量身定制、刷不完的娱乐信息流，往往让人越刷越累，而不是越刷越放松。',
        segments: [
          SentenceSegment('It has become a prevalent paradox ', ClauseRole.core),
          SentenceSegment('that endless streams of tailored entertainment often leave viewers feeling more exhausted ', ClauseRole.core),
          SentenceSegment('than refreshed.', ClauseRole.adverbial),
        ],
        structureNote: 'It 为形式主语，真正主语是 that 引导的同位语/主语从句：刷不完的娱乐让人更疲惫。',
      ),
      ReadingSentence(
        en: 'Because algorithms are designed to maximize screen time rather than user well-being, passive scrolling gradually diminishes our patience for deep reading.',
        zh: '由于算法天生是为了拉长你的在线时长而不是为了你好，被动刷屏会一点点磨光我们深度阅读的耐心。',
        segments: [
          SentenceSegment('Because algorithms are designed to maximize screen time rather than user well-being, ', ClauseRole.adverbial),
          SentenceSegment('passive scrolling gradually diminishes our patience ', ClauseRole.core),
          SentenceSegment('for deep reading.', ClauseRole.modifier),
        ],
        structureNote: '因果逻辑句（Because 开头）：原因在前半句，核心结果看主干 passive scrolling diminishes our patience。',
      ),
      ReadingSentence(
        en: 'Psychologists warn that this fragmented habit is detrimental to memory consolidation unless individuals deliberately curb impulsive phone checking.',
        zh: '心理学家警告说，这种碎片化习惯对记忆巩固极为有害，除非个人有意识地克制忍不住掏手机的冲动。',
        segments: [
          SentenceSegment('Psychologists warn that this fragmented habit is detrimental to memory consolidation ', ClauseRole.core),
          SentenceSegment('unless individuals deliberately curb impulsive phone checking.', ClauseRole.adverbial),
        ],
        structureNote: 'unless = if not（除非）。核心警告：fragmented habit is detrimental to memory；解法：deliberately curb phone checking。',
      ),
    ],
    questions: [
      ReadingQuestion(
        question: '1. Why does passive scrolling reduce people’s patience for deep reading?',
        options: [
          'A. Algorithms prioritize keeping users hooked over enhancing their well-being.',
          'B. Printed books have completely disappeared from modern campuses.',
          'C. Users prefer feeling exhausted after a long workday.',
          'D. Smartphones cannot display long articles clearly.',
        ],
        correctIndex: 0,
        explanation: '定位第2句：maximize screen time rather than user well-being = prioritize keeping users hooked over enhancing their well-being！',
      ),
      ReadingQuestion(
        question: '2. What do psychologists recommend to protect memory consolidation?',
        options: [
          'A. Deleting all entertainment platforms permanently.',
          'B. Consciously restraining the urge to check phones impulsively.',
          'C. Relying on algorithms to schedule daily study plans.',
          'D. Watching more tailored videos before going to sleep.',
        ],
        correctIndex: 1,
        explanation: '定位第3句：deliberately curb impulsive phone checking = consciously restraining the urge to check phones impulsively。',
      ),
    ],
  ),
];
