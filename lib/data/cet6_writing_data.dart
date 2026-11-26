import '../models/study_models.dart';

/// 六级写作（106.5分）四大常考话题万能三段式填空救命模板
const List<WritingTemplate> cet6WritingTemplates = [
  WritingTemplate(
    id: 'w_social',
    topic: '社会现象',
    title: '社会热点现象分析型（如：数字化依赖 / 志愿服务 / 终身学习）',
    scoreStrategy: '425压线稳拿 75+ 策略：第一段点现象+亮观点，第二段两点原因（个人+社会），第三段提呼吁。不求偏难怪词，但求零语法错误 + 高级连接词！',
    blanks: [
      EssayBlank(
        key: 'topic',
        label: '核心现象（英文短语）',
        placeholder: '如：over-reliance on short videos',
        sampleFill: 'over-reliance on short videos',
      ),
      EssayBlank(
        key: 'attitude',
        label: '你的明确立场',
        placeholder: '如：calls for rational balance rather than blind indulgence',
        sampleFill: 'calls for rational balance rather than blind indulgence',
      ),
      EssayBlank(
        key: 'reason1',
        label: '核心论据一（个人层面）',
        placeholder: '如：it gradually erodes our ability to focus on deep reading',
        sampleFill: 'it gradually erodes our ability to focus on deep reading',
      ),
      EssayBlank(
        key: 'reason2',
        label: '核心论据二（社会/长远层面）',
        placeholder: '如：healthy offline interaction is indispensable for mental well-being',
        sampleFill: 'healthy offline interaction is indispensable for mental well-being',
      ),
      EssayBlank(
        key: 'action',
        label: '结尾落地建议',
        placeholder: '如：set clear daily screen limits and cultivate offline hobbies',
        sampleFill: 'set clear daily screen limits and cultivate offline hobbies',
      ),
    ],
    templateBody: '''In recent years, {{topic}} has sparked heated discussion across society. From my perspective, this prevalent trend {{attitude}}.

Two compelling reasons account for my viewpoint. First and foremost, from an individual standpoint, {{reason1}}. What is equally worth noting is that, in the long run, {{reason2}}. Without proper awareness, we may unintentionally pay a heavy price for short-term convenience.

To sum up, it is high time that we took pragmatic steps rather than remaining passive observers. Only when individuals {{action}} can we turn modern tools into true stepping stones toward a fulfilling life.''',
    referenceEssay: '''In recent years, over-reliance on short videos has sparked heated discussion across society. From my perspective, this prevalent trend calls for rational balance rather than blind indulgence.

Two compelling reasons account for my viewpoint. First and foremost, from an individual standpoint, it gradually erodes our ability to focus on deep reading. What is equally worth noting is that, in the long run, healthy offline interaction is indispensable for mental well-being. Without proper awareness, we may unintentionally pay a heavy price for short-term convenience.

To sum up, it is high time that we took pragmatic steps rather than remaining passive observers. Only when individuals set clear daily screen limits and cultivate offline hobbies can we turn modern tools into true stepping stones toward a fulfilling life.''',
    upgradeSentences: [
      '开头神句：It is widely acknowledged that...（公认的是……，零出错且地道）',
      '过渡神句：Two compelling reasons account for my viewpoint.（两个铁打的原因支撑我的观点）',
      '倒装加分句：Only when we take pragmatic action can we...（阅卷老师最爱的高分倒装句！）',
    ],
  ),
  WritingTemplate(
    id: 'w_tech',
    topic: '科技发展',
    title: '科技双刃剑型（如：人工智能 AI / 在线教育 / 智慧生活）',
    scoreStrategy: '科技类作文最稳结构：承认科技红利（让步） + 强调人本与理性驾驭（核心立场），轻松拿捏六级阅卷高分逻辑！',
    blanks: [
      EssayBlank(
        key: 'tech',
        label: '科技主题词',
        placeholder: '如：artificial intelligence',
        sampleFill: 'artificial intelligence',
      ),
      EssayBlank(
        key: 'benefit',
        label: '带来的核心好处',
        placeholder: '如：alleviates repetitive workloads and boosts efficiency',
        sampleFill: 'alleviates repetitive workloads and boosts efficiency',
      ),
      EssayBlank(
        key: 'risk',
        label: '潜在隐忧/挑战',
        placeholder: '如：excessive dependence may weaken independent thinking',
        sampleFill: 'excessive dependence may weaken independent thinking',
      ),
      EssayBlank(
        key: 'solution',
        label: '理性应对方案',
        placeholder: '如：treat technology as a helpful assistant rather than a replacement',
        sampleFill: 'treat technology as a helpful assistant rather than a replacement',
      ),
    ],
    templateBody: '''With the rapid advancement of science, {{tech}} has become an indispensable part of our daily lives. While some worry about its disruption, I firmly believe that its value depends largely on how wisely humans apply it.

On the one hand, there is no denying that {{tech}} {{benefit}}. It empowers ordinary learners and workers to solve complex tasks at unprecedented speed. On the other hand, we should never turn a blind eye to its potential risks, as {{risk}}.

In conclusion, technology itself is neither good nor evil; it is a double-edged sword. Therefore, both educators and young people ought to {{solution}}, ensuring that innovation genuinely serves human progress.''',
    referenceEssay: '''With the rapid advancement of science, artificial intelligence has become an indispensable part of our daily lives. While some worry about its disruption, I firmly believe that its value depends largely on how wisely humans apply it.

On the one hand, there is no denying that artificial intelligence alleviates repetitive workloads and boosts efficiency. It empowers ordinary learners and workers to solve complex tasks at unprecedented speed. On the other hand, we should never turn a blind eye to its potential risks, as excessive dependence may weaken independent thinking.

In conclusion, technology itself is neither good nor evil; it is a double-edged sword. Therefore, both educators and young people ought to treat technology as a helpful assistant rather than a replacement, ensuring that innovation genuinely serves human progress.''',
    upgradeSentences: [
      '双刃剑神句：Technology itself is neither good nor evil; it is a double-edged sword.',
      '不可否认句：There is no denying that... has brought unprecedented convenience.',
      '切勿忽视句：We should never turn a blind eye to its potential challenges.',
    ],
  ),
  WritingTemplate(
    id: 'w_culture',
    topic: '传统文化',
    title: '文化传承与创新型（如：非遗保护 / 国潮文化 / 跨文化交流）',
    scoreStrategy: '文化类既考作文又考翻译！记住核心公式：heritage（遗产）+ modern creativity（现代创意）= 文化自信与传承！',
    blanks: [
      EssayBlank(
        key: 'cultureItem',
        label: '传统文化主题',
        placeholder: '如：traditional Chinese cultural heritage',
        sampleFill: 'traditional Chinese cultural heritage',
      ),
      EssayBlank(
        key: 'value',
        label: '文化的核心价值',
        placeholder: '如：carries centuries of wisdom and strengthens our cultural identity',
        sampleFill: 'carries centuries of wisdom and strengthens our cultural identity',
      ),
      EssayBlank(
        key: 'method',
        label: '创新传承方式',
        placeholder: '如：blend classic craftsmanship with digital media and modern design',
        sampleFill: 'blend classic craftsmanship with digital media and modern design',
      ),
    ],
    templateBody: '''In an increasingly globalized world, preserving and revitalizing {{cultureItem}} has never been more vital. Far from being obsolete, our cultural roots remain a priceless source of strength and inspiration.

To begin with, {{cultureItem}} {{value}}. It bridges generations and reminds young people where they come from. Furthermore, keeping traditions alive does not mean locking them inside museums; rather, we need to {{method}} so that younger audiences can truly fall in love with them.

All in all, passing down our cultural treasures is a shared responsibility. By combining respect for history with bold innovation, we can help timeless traditions thrive on the global stage.''',
    referenceEssay: '''In an increasingly globalized world, preserving and revitalizing traditional Chinese cultural heritage has never been more vital. Far from being obsolete, our cultural roots remain a priceless source of strength and inspiration.

To begin with, traditional Chinese cultural heritage carries centuries of wisdom and strengthens our cultural identity. It bridges generations and reminds young people where they come from. Furthermore, keeping traditions alive does not mean locking them inside museums; rather, we need to blend classic craftsmanship with digital media and modern design so that younger audiences can truly fall in love with them.

All in all, passing down our cultural treasures is a shared responsibility. By combining respect for history with bold innovation, we can help timeless traditions thrive on the global stage.''',
    upgradeSentences: [
      '反驳过时句：Far from being obsolete, traditional culture remains a source of inspiration.',
      '生动比喻句：Keeping traditions alive does not mean locking them inside museums.',
      '升华结尾句：Help timeless traditions thrive on the global stage.',
    ],
  ),
  WritingTemplate(
    id: 'w_youth',
    topic: '青年成长',
    title: '个人品格与青年成长型（如：抗压韧性 / 团队合作 / 脚踏实地）',
    scoreStrategy: '青年成长与名言警句题万能套壳！主打“面对挑战不退缩 + 每日微行动积累”，几乎所有个人品质题都能无缝套入！',
    blanks: [
      EssayBlank(
        key: 'virtue',
        label: '核心品质/能力',
        placeholder: '如：perseverance and self-discipline',
        sampleFill: 'perseverance and self-discipline',
      ),
      EssayBlank(
        key: 'effect1',
        label: '成长作用一',
        placeholder: '如：helps us stay resilient when confronted with inevitable setbacks',
        sampleFill: 'helps us stay resilient when confronted with inevitable setbacks',
      ),
      EssayBlank(
        key: 'effect2',
        label: '成长作用二',
        placeholder: '如：turns ambitious dreams into measurable daily progress',
        sampleFill: 'turns ambitious dreams into measurable daily progress',
      ),
    ],
    templateBody: '''As a well-known saying goes, true success is rarely achieved overnight. Among all the qualities that shape a young person’s future, {{virtue}} undoubtedly plays a decisive role.

The significance of {{virtue}} can be seen in two major aspects. Firstly, it {{effect1}}. Life is full of uncertainties, and only those with inner grit can keep moving forward. Secondly, it {{effect2}}. Just as tiny drops of water wear away stone, consistent effort eventually leads to remarkable breakthroughs.

As college students standing at the threshold of adulthood, we should actively cultivate {{virtue}} in our everyday study and work. With steady steps and a determined heart, every goal is within our reach.''',
    referenceEssay: '''As a well-known saying goes, true success is rarely achieved overnight. Among all the qualities that shape a young person’s future, perseverance and self-discipline undoubtedly plays a decisive role.

The significance of perseverance and self-discipline can be seen in two major aspects. Firstly, it helps us stay resilient when confronted with inevitable setbacks. Life is full of uncertainties, and only those with inner grit can keep moving forward. Secondly, it turns ambitious dreams into measurable daily progress. Just as tiny drops of water wear away stone, consistent effort eventually leads to remarkable breakthroughs.

As college students standing at the threshold of adulthood, we should actively cultivate perseverance and self-discipline in our everyday study and work. With steady steps and a determined heart, every goal is within our reach.''',
    upgradeSentences: [
      '谚语引入句：As a well-known saying goes, true success is rarely achieved overnight.',
      '水滴石穿句：Just as tiny drops of water wear away stone, consistent effort leads to breakthroughs.',
      '大学生落脚句：As college students standing at the threshold of adulthood, we should...',
    ],
  ),
];

/// 六级翻译（106.5分）中国传统文化/科技/生态高频词 + 425救命平替库
const List<TranslationTerm> cet6TranslationTerms = [
  TranslationTerm(
    zh: '非物质文化遗产',
    advancedEn: 'intangible cultural heritage',
    rescueEn: 'valuable traditional culture',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '悠久的历史',
    advancedEn: 'a time-honored history',
    rescueEn: 'a very long history',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '代代相传',
    advancedEn: 'be passed down from generation to generation',
    rescueEn: 'be handed down by generations',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '精湛的工艺',
    advancedEn: 'exquisite craftsmanship',
    rescueEn: 'amazing hand-making skills',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '象征着吉祥与团圆',
    advancedEn: 'symbolize good fortune and family reunion',
    rescueEn: 'stand for good luck and getting together',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '深受海内外喜爱',
    advancedEn: 'enjoy immense popularity both at home and abroad',
    rescueEn: 'be widely loved in China and overseas',
    category: '传统文化',
  ),
  TranslationTerm(
    zh: '高速铁路网络',
    advancedEn: 'high-speed railway network',
    rescueEn: 'fast train system',
    category: '科技基建',
  ),
  TranslationTerm(
    zh: '取得了举世瞩目的成就',
    advancedEn: 'achieve remarkable breakthroughs',
    rescueEn: 'make great progress',
    category: '科技基建',
  ),
  TranslationTerm(
    zh: '大大便利了人们的出行',
    advancedEn: 'bring unprecedented convenience to travel',
    rescueEn: 'make traveling much easier',
    category: '科技基建',
  ),
  TranslationTerm(
    zh: '数字化转型',
    advancedEn: 'digital transformation',
    rescueEn: 'turning to digital technology',
    category: '科技基建',
  ),
  TranslationTerm(
    zh: '可持续发展',
    advancedEn: 'sustainable development',
    rescueEn: 'long-term green growth',
    category: '生态环保',
  ),
  TranslationTerm(
    zh: '绿水青山就是金山银山',
    advancedEn: 'lucid waters and lush mountains are invaluable assets',
    rescueEn: 'clean water and green mountains are as valuable as gold',
    category: '生态环保',
  ),
  TranslationTerm(
    zh: '大幅降低碳排放',
    advancedEn: 'dramatically curb carbon emissions',
    rescueEn: 'greatly cut air pollution',
    category: '生态环保',
  ),
  TranslationTerm(
    zh: '改善生态环境',
    advancedEn: 'restore and enhance the ecological environment',
    rescueEn: 'make nature cleaner and healthier',
    category: '生态环保',
  ),
  TranslationTerm(
    zh: '脱贫攻坚 / 乡村振兴',
    advancedEn: 'poverty alleviation / rural revitalization',
    rescueEn: 'helping poor villages grow richer',
    category: '经济民生',
  ),
  TranslationTerm(
    zh: '提升居民幸福感',
    advancedEn: 'enhance citizens’ sense of well-being',
    rescueEn: 'make people feel happier in daily life',
    category: '经济民生',
  ),
];

/// 六级翻译段落实战演练（含 425 救命拆句技巧）
const List<TranslationDrill> cet6TranslationDrills = [
  TranslationDrill(
    id: 'tr_01',
    title: '中国茶文化与待客之道',
    category: '传统文化',
    chinesePrompt: '中国有着数千年的饮茶历史。如今，茶不仅是一种日常饮品，更象征着和谐与尊重。每当客人来访，奉上一杯热茶已成为代代相传的待客之道。',
    referenceEn: 'China boasts a history of tea drinking spanning thousands of years. Today, tea is not only a daily beverage, but also symbolizes harmony and respect. Whenever guests visit, serving a cup of hot tea has become a hospitable custom passed down from generation to generation.',
    keyTips: [
      '“有着……历史”直接套用 China has/boasts a history of...',
      '“不仅……更……”用最稳的 not only... but also...',
      '不会写 hospitable custom？直接救命平替为 a polite tradition 照样拿高分！',
    ],
  ),
  TranslationDrill(
    id: 'tr_02',
    title: '中国新能源汽车与绿色出行',
    category: '科技环保',
    chinesePrompt: '近年来，中国新能源汽车产业蓬勃发展，取得了举世瞩目的成就。越来越多年轻人选择绿色出行，这不仅节省了开销，还大幅降低了城市碳排放。',
    referenceEn: 'In recent years, China’s new energy vehicle industry has thrived and achieved remarkable breakthroughs. More and more young people choose green travel, which not only saves money, but also dramatically curbs urban carbon emissions.',
    keyTips: [
      '“近年来”送分开头：In recent years,',
      '“蓬勃发展”用高频词 thrive 或 develop rapidly',
      '“这不仅……”用非限制性定语从句 , which not only..., but also... 瞬间提档！',
    ],
  ),
];
