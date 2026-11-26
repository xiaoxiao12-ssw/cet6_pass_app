import '../models/cet6_models.dart';

/// ==================== ① 选词填空 (Banked Cloze, 15选10) ====================
const List<BankedClozeExercise> cet6BankedClozeExercises = [
  BankedClozeExercise(
    id: 'bc_01',
    title: '选词填空 1 · 数字时代的深度阅读回归',
    subtitle: '15 选 10 · 满分 35.5 分（3.55 分/题）· 建议用时 8 分钟',
    rawPassage:
        'Over the past decade, smartphones and algorithmic news feeds have become virtually {{1}} in modern university life. '
        'While instant connectivity brings undeniable convenience, cognitive scientists warn that constant skimming can quietly {{2}} our capacity for sustained concentration. '
        'When readers jump rapidly from one headline to another, their comprehension tends to remain {{3}}, missing the subtle logical links that bind complex arguments together.\n\n'
        'Encouragingly, a quiet counter-trend is gaining {{4}} across campuses worldwide. '
        'Recognizing the {{5}} effects of fragmented attention, many students are adopting pragmatic habits to reclaim quiet reading hours. '
        'Some campus libraries have even created device-free zones specifically {{6}} to deep study. '
        'At first, putting the phone away may feel uncomfortable, yet researchers emphasize that the {{7}} benefit of reading just twenty uninterrupted pages a day is extraordinary.\n\n'
        'Educators note that deep reading is not an {{8}} luxury reserved for literature majors. '
        'Rather, it serves as an {{9}} foundation for critical thinking across science, law, and engineering. '
        'By deliberately slowing down, learners can {{10}} fragmented facts into coherent, durable wisdom.',
    wordBank: [
      BankedClozeOption(letter: 'A', word: 'arbitrary', posHint: 'adj. 武断的，任意的'),
      BankedClozeOption(letter: 'B', word: 'conducive', posHint: 'adj. 有益于……的，有助于的'),
      BankedClozeOption(letter: 'C', word: 'consolidate', posHint: 'v. 巩固，整合'),
      BankedClozeOption(letter: 'D', word: 'cumulative', posHint: 'adj. 累积的，渐增的'),
      BankedClozeOption(letter: 'E', word: 'detrimental', posHint: 'adj. 有害的，不利的'),
      BankedClozeOption(letter: 'F', word: 'deteriorated', posHint: 'v. 恶化（过去分词）'),
      BankedClozeOption(letter: 'G', word: 'indispensable', posHint: 'adj. 不可或缺的'),
      BankedClozeOption(letter: 'H', word: 'momentum', posHint: 'n. 势头，动力'),
      BankedClozeOption(letter: 'I', word: 'obsolete', posHint: 'adj. 过时的，淘汰的'),
      BankedClozeOption(letter: 'J', word: 'proliferate', posHint: 'v. 激增，扩散'),
      BankedClozeOption(letter: 'K', word: 'skeptical', posHint: 'adj. 怀疑的'),
      BankedClozeOption(letter: 'L', word: 'superficial', posHint: 'adj. 肤浅的，表面的'),
      BankedClozeOption(letter: 'M', word: 'ubiquitous', posHint: 'adj. 无处不在的'),
      BankedClozeOption(letter: 'N', word: 'undermine', posHint: 'v. 逐渐削弱，破坏'),
      BankedClozeOption(letter: 'O', word: 'volatile', posHint: 'adj. 动荡不定的'),
    ],
    answers: ['M', 'N', 'L', 'H', 'E', 'B', 'D', 'I', 'G', 'C'],
    explanations: [
      '1. [M] ubiquitous：系动词 become 后接形容词作表语，“智能手机和算法推送几乎无处不在”。',
      '2. [N] undermine：情态动词 can 后接动词原形，“持续略读会悄悄削弱我们持续专注的能力”。',
      '3. [L] superficial：remain 后接形容词，与后文 missing subtle logical links 呼应，“理解停留在表面/肤浅层”。',
      '4. [H] momentum：固定搭配 gain momentum（获得势头/发展动力），作 gaining 的宾语。',
      '5. [E] detrimental：修饰名词 effects，“碎片化注意力的有害影响”。',
      '6. [B] conducive：固定搭配 conducive to...（有益于……），作后置定语修饰 device-free zones。',
      '7. [D] cumulative：修饰名词 benefit，“每天不间断读20页所产生的累积效益非常惊人”。',
      '8. [I] obsolete：不定冠词 an 后接元音音素开头的形容词，“并非过时的奢侈品”。',
      '9. [G] indispensable：an 后接元音音素开头的形容词，“批判性思维不可或缺的基础”。',
      '10. [C] consolidate：can 后接动词原形，consolidate ... into ...（把零散事实整合巩固为连贯持久的智慧）。',
    ],
    bilingualSentences: [
      BilingualSentence(
        en: 'Over the past decade, smartphones and algorithmic news feeds have become virtually ubiquitous in modern university life.',
        zh: '过去十年间，智能手机和算法信息流在现代大学生活中几乎变得无处不在。',
      ),
      BilingualSentence(
        en: 'While instant connectivity brings undeniable convenience, cognitive scientists warn that constant skimming can quietly undermine our capacity for sustained concentration.',
        zh: '虽然即时互联带来不可否认的便利，但认知科学家警告称，持续略读会悄悄削弱我们持久专注的能力。',
      ),
      BilingualSentence(
        en: 'When readers jump rapidly from one headline to another, their comprehension tends to remain superficial, missing the subtle logical links that bind complex arguments together.',
        zh: '当读者在一个个标题间快速跳转时，他们的理解往往停留在表面，忽略了串联复杂论证的微妙逻辑纽带。',
      ),
      BilingualSentence(
        en: 'Encouragingly, a quiet counter-trend is gaining momentum across campuses worldwide.',
        zh: '令人鼓舞的是，一股静悄悄的反潮流正在全球校园中蔚然成势。',
      ),
      BilingualSentence(
        en: 'Recognizing the detrimental effects of fragmented attention, many students are adopting pragmatic habits to reclaim quiet reading hours.',
        zh: '意识到碎片化注意力的有害影响，许多学生正采取务实习惯来夺回安静阅读时光。',
      ),
      BilingualSentence(
        en: 'Some campus libraries have even created device-free zones specifically conducive to deep study.',
        zh: '一些高校图书馆甚至专门开辟了有利于深度研习的无电子设备区。',
      ),
      BilingualSentence(
        en: 'At first, putting the phone away may feel uncomfortable, yet researchers emphasize that the cumulative benefit of reading just twenty uninterrupted pages a day is extraordinary.',
        zh: '起初放下手机可能会感到不适，但研究人员强调，每天不间断阅读二十页所带来的累积效益是非凡的。',
      ),
      BilingualSentence(
        en: 'Educators note that deep reading is not an obsolete luxury reserved for literature majors.',
        zh: '教育者指出，深度阅读并非专属于文学专业学生的过时奢侈品。',
      ),
      BilingualSentence(
        en: 'Rather, it serves as an indispensable foundation for critical thinking across science, law, and engineering.',
        zh: '相反，它是科学、法律与工程等各领域批判性思维不可或缺的基石。',
      ),
      BilingualSentence(
        en: 'By deliberately slowing down, learners can consolidate fragmented facts into coherent, durable wisdom.',
        zh: '通过刻意放慢节奏，学习者能将零散事实整合巩固为连贯而持久的智慧。',
      ),
    ],
  ),

  BankedClozeExercise(
    id: 'bc_02',
    title: '选词填空 2 · 清洁能源转型的电网韧性挑战',
    subtitle: '15 选 10 · 满分 35.5 分（3.55 分/题）· 建议用时 8 分钟',
    rawPassage:
        'Global investment in wind and solar generation has expanded at an {{1}} speed over the past five years. '
        'In many regions, utility-scale renewables already {{2}} coal-fired stations in cost competitiveness. '
        'Yet engineers point out a critical technical {{3}}: unlike conventional power plants, wind and sunshine are inherently {{4}}, fluctuating sharply with clouds and calm evenings.\n\n'
        'Without modern storage and flexible transmission lines, sudden surges in clean power can {{5}} regional grids rather than strengthen them. '
        'Outdated {{6}} in older industrial belts continues to hamper the seamless delivery of electricity from sunny deserts to coastal factories. '
        'To {{7}} these supply gaps, governments are offering tax {{8}} for grid-scale batteries and smart demand management.\n\n'
        'Energy economists agree that building a truly {{9}} clean grid requires steady coordination between public policy and private ingenuity. '
        'Once large-scale storage becomes commercially {{10}}, green electricity will reliably power both households and heavy industry.',
    wordBank: [
      BankedClozeOption(letter: 'A', word: 'ambiguous', posHint: 'adj. 模棱两可的'),
      BankedClozeOption(letter: 'B', word: 'dilemma', posHint: 'n. 困境，难题'),
      BankedClozeOption(letter: 'C', word: 'disrupt', posHint: 'v. 扰乱，冲击'),
      BankedClozeOption(letter: 'D', word: 'erode', posHint: 'v. 侵蚀'),
      BankedClozeOption(letter: 'E', word: 'incentives', posHint: 'n. 激励措施（复数）'),
      BankedClozeOption(letter: 'F', word: 'infrastructure', posHint: 'n. 基础设施'),
      BankedClozeOption(letter: 'G', word: 'intermittent', posHint: 'adj. 间歇性的'),
      BankedClozeOption(letter: 'H', word: 'mediocre', posHint: 'adj. 平庸的'),
      BankedClozeOption(letter: 'I', word: 'mitigate', posHint: 'v. 缓解，减轻'),
      BankedClozeOption(letter: 'J', word: 'negligible', posHint: 'adj. 微不足道的'),
      BankedClozeOption(letter: 'K', word: 'resilient', posHint: 'adj. 有韧性的'),
      BankedClozeOption(letter: 'L', word: 'surpass', posHint: 'v. 超越，胜过'),
      BankedClozeOption(letter: 'M', word: 'transient', posHint: 'adj. 短暂的'),
      BankedClozeOption(letter: 'N', word: 'unprecedented', posHint: 'adj. 史无前例的'),
      BankedClozeOption(letter: 'O', word: 'viable', posHint: 'adj. 可行的，切实有效的'),
    ],
    answers: ['N', 'L', 'B', 'G', 'C', 'F', 'I', 'E', 'K', 'O'],
    explanations: [
      '1. [N] unprecedented：an 后接元音音素开头形容词，“以前所未有的速度扩张”。',
      '2. [L] surpass：主语 renewables 为复数，此处缺谓语动词原形，“在成本竞争力上已超越燃煤电站”。',
      '3. [B] dilemma：a critical technical 后接可数名词单数，“指出一个关键的技术两难/难题”。',
      '4. [G] intermittent：are inherently 后接形容词，与后文 fluctuating sharply 呼应，“风和日照本质上是间歇性的”。',
      '5. [C] disrupt：can 后接动词原形，与 rather than strengthen 构成对比，“可能会扰乱区域电网”。',
      '6. [F] infrastructure：Outdated 后接不可数名词作主语（配合动词 continues），“老旧基础设施”。',
      '7. [I] mitigate：不定式 To 后接动词原形，“为了缓解这些供应缺口”。',
      '8. [E] incentives：tax incentives（税收激励措施）是六级经济类高频固定搭配。',
      '9. [K] resilient：修饰 clean grid，“建设真正有韧性的清洁电网”。',
      '10. [O] viable：commercially viable（商业上可行的）是六级科技阅读高频搭配。',
    ],
    bilingualSentences: [
      BilingualSentence(
        en: 'Global investment in wind and solar generation has expanded at an unprecedented speed over the past five years.',
        zh: '过去五年间，全球风电和光伏发电投资以前所未有的速度扩张。',
      ),
      BilingualSentence(
        en: 'In many regions, utility-scale renewables already surpass coal-fired stations in cost competitiveness.',
        zh: '在许多地区，大型可再生能源在成本竞争力上已超越燃煤电站。',
      ),
      BilingualSentence(
        en: 'Yet engineers point out a critical technical dilemma: unlike conventional power plants, wind and sunshine are inherently intermittent, fluctuating sharply with clouds and calm evenings.',
        zh: '然而工程师指出了一个关键技术难题：与传统电站不同，风力和日照本质上是间歇性的，会随云层和无风夜晚剧烈波动。',
      ),
      BilingualSentence(
        en: 'Without modern storage and flexible transmission lines, sudden surges in clean power can disrupt regional grids rather than strengthen them.',
        zh: '如果没有现代储能和灵活输电线路，清洁电力的突然激增可能会扰乱而非增强区域电网。',
      ),
      BilingualSentence(
        en: 'Outdated infrastructure in older industrial belts continues to hamper the seamless delivery of electricity from sunny deserts to coastal factories.',
        zh: '老工业带陈旧的基础设施仍在阻碍电力从阳光充沛的沙漠顺畅输送到沿海工厂。',
      ),
      BilingualSentence(
        en: 'To mitigate these supply gaps, governments are offering tax incentives for grid-scale batteries and smart demand management.',
        zh: '为缓解这些供应缺口，各国政府正为电网级电池和智能需求管理提供税收激励。',
      ),
      BilingualSentence(
        en: 'Energy economists agree that building a truly resilient clean grid requires steady coordination between public policy and private ingenuity.',
        zh: '能源经济学家一致认为，建设真正有韧性的清洁电网需要公共政策与民间巧思的稳步协同。',
      ),
      BilingualSentence(
        en: 'Once large-scale storage becomes commercially viable, green electricity will reliably power both households and heavy industry.',
        zh: '一旦大规模储能在商业上切实可行，绿色电力将可靠地为家庭和重工业供电。',
      ),
    ],
  ),
];

/// ==================== ② 长篇阅读匹配 (Matching, 段落信息匹配) ====================
const List<MatchingExercise> cet6MatchingExercises = [
  MatchingExercise(
    id: 'mt_01',
    title: '长篇阅读匹配 · 博物馆的数字化复兴',
    subtitle: '10 题 · 满分 71.0 分（7.1 分/题）· 建议用时 15 分钟',
    paragraphs: [
      MatchingParagraph(
        label: 'A',
        sentences: [
          BilingualSentence(
            en: 'For more than a century, visiting a major museum followed a familiar script: queue for paper tickets, stroll past glass display cases, and squint at tiny printed plaques.',
            zh: '一个多世纪以来，参观大型博物馆都遵循着熟悉的流程：排队买纸质票、走过玻璃展柜、眯着眼睛看微小的印刷铭牌。',
          ),
          BilingualSentence(
            en: 'Today, however, high-resolution scanning, augmented reality, and open digital archives are triggering a profound paradigm shift in how cultural institutions engage the public.',
            zh: '然而如今，高清扫描、增强现实和开放数字档案正在引发文化机构与公众互动方式的深刻范式转变。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'B',
        sentences: [
          BilingualSentence(
            en: 'Perhaps the most urgent catalyst behind digitization is physical preservation.',
            zh: '推动数字化最紧迫的催化剂或许是实体保护。',
          ),
          BilingualSentence(
            en: 'Ancient silk scrolls, bronze vessels, and desert murals are extraordinarily fragile; exposure to humidity, camera flashes, and millions of breathing visitors can cause pigments to deteriorate irreversibly.',
            zh: '古代丝绸卷轴、青铜器和沙漠壁画极其脆弱；暴露在湿度、闪光灯和数百万游客的呼吸中会导致颜料不可逆转地恶化。',
          ),
          BilingualSentence(
            en: 'By creating millimeter-accurate 3D digital twins, curators can safeguard delicate artifacts in climate-controlled vaults while letting global audiences inspect intricate brushwork online.',
            zh: '通过创建毫米级精度的三维数字孪生体，策展人既能将脆弱文物安全保存在恒温恒湿库房中，又能让全球观众在线端详精细笔触。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'C',
        sentences: [
          BilingualSentence(
            en: 'Digital initiatives have also dismantled geographic and financial barriers that once excluded rural learners.',
            zh: '数字化举措还打破了曾经将乡村学习者拒之门外的地理与经济壁垒。',
          ),
          BilingualSentence(
            en: 'A middle-school student in a mountainous county can now tour the Dunhuang grottoes or examine Tang dynasty ceramics through a free classroom tablet without paying for cross-country travel.',
            zh: '山区县城的初中生现在可以通过免费的课堂平板电脑游览敦煌石窟或端详唐代陶瓷，而无需支付跨省旅费。',
          ),
          BilingualSentence(
            en: 'Educators report that such virtual field trips foster genuine historical curiosity among teenagers who previously viewed history as dry textbook dates.',
            zh: '教育者反馈称，这类虚拟实地考察在过去觉得历史只是枯燥课本年代的青少年中培养出了真正的历史好奇心。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'D',
        sentences: [
          BilingualSentence(
            en: 'Yet technology in exhibition halls is not without controversy.',
            zh: '然而，展厅中的科技应用并非没有争议。',
          ),
          BilingualSentence(
            en: 'Several prominent art historians remain skeptical of flashy projection shows that flood darkened rooms with booming music and animated paintings.',
            zh: '几位知名艺术史学家对那些在昏暗房间里充斥轰鸣音乐与动态画作的炫目投影展仍持怀疑态度。',
          ),
          BilingualSentence(
            en: 'They caution that turning quiet galleries into theme-park spectacles risks encouraging superficial consumption rather than patient contemplation of an original masterpiece.',
            zh: '他们警告说，把安静的画廊变成主题公园式的奇观，可能会助长走马观花式的浅层消费，而非对原作的耐心沉思。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'E',
        sentences: [
          BilingualSentence(
            en: 'Meanwhile, smaller municipal museums face a daunting financial dilemma.',
            zh: '与此同时，规模较小的市级博物馆面临着严峻的资金困境。',
          ),
          BilingualSentence(
            en: 'While prestigious national institutions attract substantial government grants and tech sponsorships, regional museums often lack both the budget and specialized staff needed to maintain interactive software.',
            zh: '享有盛誉的国家级机构能吸引可观的政府拨款和科技赞助，而地方博物馆往往既缺预算又缺维护交互软件的专业人员。',
          ),
          BilingualSentence(
            en: 'Without ongoing maintenance funding, expensive touchscreens frequently go dark within two years, becoming embarrassing obsolete fixtures.',
            zh: '如果没有持续的维护资金，昂贵的触摸屏往往在两年内就会黑屏，变成尴尬的过时摆设。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'F',
        sentences: [
          BilingualSentence(
            en: 'To bridge this gap, several provincial heritage bureaus have initiated shared cloud platforms.',
            zh: '为弥合这一差距，多个省级文物局发起了共享云平台。',
          ),
          BilingualSentence(
            en: 'Instead of asking every county museum to hire its own programmers, a central technical team provides standardized scanning equipment, hosting servers, and bilingual audio-guide templates.',
            zh: '不再要求每个县级博物馆各自聘请程序员，而是由中心技术团队提供标准化扫描设备、托管服务器和双语语音导览模板。',
          ),
          BilingualSentence(
            en: 'This pragmatic alliance has slashed operating expenses by nearly half and enabled dozens of lesser-known collections to gain nationwide visibility.',
            zh: '这种务实的联盟将运营支出削减了近一半，并使数十家鲜为人知的馆藏获得了全国知名度。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'G',
        sentences: [
          BilingualSentence(
            en: 'Interestingly, early fears that free online collections would undermine physical ticket sales have proven largely unfounded.',
            zh: '有趣的是，早期认为免费线上馆藏会削弱实体门票销售的担忧已被证明基本毫无根据。',
          ),
          BilingualSentence(
            en: 'Empirical visitor surveys reveal the exact opposite: people who explore a museum’s digital stories online are substantially more likely to book an in-person trip when visiting that city.',
            zh: '实证游客调查揭示了截然相反的结果：在网上浏览过博物馆数字故事的人，到访该城市时预约实地参观的可能性要高得多。',
          ),
          BilingualSentence(
            en: 'Screens whet the appetite, yet standing inches away from a three-thousand-year-old bronze vessel still delivers an irreplaceable emotional resonance.',
            zh: '屏幕能吊起胃口，但近距离站在三千年前的青铜器前依然能带来不可替代的情感共鸣。',
          ),
        ],
      ),
      MatchingParagraph(
        label: 'H',
        sentences: [
          BilingualSentence(
            en: 'Looking ahead, the most admired museums are those that treat digital tools as quiet servants rather than noisy masters.',
            zh: '展望未来，最受推崇的博物馆是那些将数字工具视为安静仆人而非喧宾夺主者的机构。',
          ),
          BilingualSentence(
            en: 'When technology illuminates historical context, protects fragile heritage, and reconciles scholarship with accessibility, it fulfills the timeless mission of every museum: keeping human memory alive.',
            zh: '当科技阐明历史脉络、保护脆弱遗产并将学术性与大众可达性相调和时，它便履行了每座博物馆永恒的使命：让人类记忆鲜活延续。',
          ),
        ],
      ),
    ],
    statements: [
      MatchingStatement(
        number: 1,
        statement: 'Collaborative regional tech platforms have significantly reduced costs for smaller local museums.',
        answerLabel: 'F',
        keyPhrase: 'shared cloud platforms / slashed operating expenses by nearly half',
        explanation: '对应 F 段：省级文物局发起共享云平台，使地方博物馆运营开支削减近一半。',
      ),
      MatchingStatement(
        number: 2,
        statement: 'Creating precise digital replicas enables museums to protect delicate relics from environmental wear.',
        answerLabel: 'B',
        keyPhrase: 'millimeter-accurate 3D digital twins / safeguard delicate artifacts',
        explanation: '对应 B 段：毫米级 3D 数字孪生让脆弱文物得以保存在恒温库房中免受损毁。',
      ),
      MatchingStatement(
        number: 3,
        statement: 'Some scholars worry that overly dramatic multimedia exhibitions distract visitors from deeply appreciating real artworks.',
        answerLabel: 'D',
        keyPhrase: 'prominent art historians remain skeptical / superficial consumption',
        explanation: '对应 D 段：知名艺术史学家批评炫目投影秀会导致浅层消费而非沉思原作。',
      ),
      MatchingStatement(
        number: 4,
        statement: 'Browsing museum collections online actually encourages more people to visit the physical venues.',
        answerLabel: 'G',
        keyPhrase: 'substantially more likely to book an in-person trip',
        explanation: '对应 G 段：实证调查表明线上浏览反而提升线下实地参观意愿。',
      ),
      MatchingStatement(
        number: 5,
        statement: 'Students from remote areas can now study renowned historical treasures without incurring travel expenses.',
        answerLabel: 'C',
        keyPhrase: 'mountainous county / without paying for cross-country travel',
        explanation: '对应 C 段：山区学生通过免费平板即可云游敦煌石窟，省去跨省旅费。',
      ),
      MatchingStatement(
        number: 6,
        statement: 'Shortages of funding and technical talent frequently leave interactive devices broken in regional museums.',
        answerLabel: 'E',
        keyPhrase: 'lack both the budget and specialized staff / touchscreens frequently go dark',
        explanation: '对应 E 段：地方馆缺预算与专人维护，昂贵触摸屏两年内便黑屏报废。',
      ),
      MatchingStatement(
        number: 7,
        statement: 'Seeing an authentic ancient object face to face still produces a unique feeling that digital screens cannot duplicate.',
        answerLabel: 'G',
        keyPhrase: 'irreplaceable emotional resonance',
        explanation: '对应 G 段末句（六级匹配允许段落复用）：近距离面对三千年青铜器的情感共鸣不可替代。',
      ),
      MatchingStatement(
        number: 8,
        statement: 'The ideal role of digital technology in museums is to support cultural understanding quietly rather than overshadowing exhibits.',
        answerLabel: 'H',
        keyPhrase: 'quiet servants rather than noisy masters',
        explanation: '对应 H 段：最受推崇的博物馆将数字工具当作安静的仆人而非喧宾夺主的主人。',
      ),
      MatchingStatement(
        number: 9,
        statement: 'Virtual museum tours have sparked genuine interest in history among students who once found the subject boring.',
        answerLabel: 'C',
        keyPhrase: 'foster genuine historical curiosity / previously viewed history as dry',
        explanation: '对应 C 段末句：虚拟考察让原本觉得历史枯燥的青少年产生了真正好奇心。',
      ),
      MatchingStatement(
        number: 10,
        statement: 'Humidity and large crowds pose severe risks to the colors of ancient paintings and scrolls.',
        answerLabel: 'B',
        keyPhrase: 'exposure to humidity ... cause pigments to deteriorate irreversibly',
        explanation: '对应 B 段：湿度、闪光灯和人流会导致古画卷轴颜料不可逆恶化。',
      ),
    ],
  ),
];

/// ==================== ③ 仔细阅读 (Careful Reading, 深度单选) ====================
const List<CarefulReadingExercise> cet6CarefulReadingExercises = [
  CarefulReadingExercise(
    id: 'cr_01',
    title: '仔细阅读 Passage 1 · 人工智能时代的“技能退化”隐忧',
    subtitle: '5 题 · 满分 71.0 分（14.2 分/题）· 建议用时 10 分钟',
    paragraphs: [
      [
        BilingualSentence(
          en: 'When commercial aviation introduced sophisticated autopilot systems decades ago, passenger safety improved dramatically.',
          zh: '几十年前民航引入精密自动驾驶系统时，乘客安全性大幅提升。',
        ),
        BilingualSentence(
          en: 'Yet aviation psychologists soon uncovered an unexpected paradox: pilots who relied too heavily on automated cockpits gradually lost the sharp manual intuition needed during rare mid-air emergencies.',
          zh: '然而航空心理学家很快发现了一个意想不到的悖论：过度依赖自动化驾驶舱的飞行员，逐渐丧失了应对罕见空中紧急情况所需的敏锐手动直觉。',
        ),
        BilingualSentence(
          en: 'Today, as generative AI tools proliferate across offices and universities, cognitive researchers warn that knowledge workers face a strikingly similar hazard known as "cognitive deskilling."',
          zh: '如今，随着生成式人工智能工具在办公室和高校迅速普及，认知研究人员警告，知识工作者正面临一种极为相似的风险，称为“认知去技能化”。',
        ),
      ],
      [
        BilingualSentence(
          en: 'In a controlled experiment involving 240 junior software engineers and business analysts, participants were divided into two groups.',
          zh: '在一项涉及240名初级软件工程师和商业分析师的对照实验中，参与者被分为两组。',
        ),
        BilingualSentence(
          en: 'The first group used an AI assistant from the outset to draft code and summarize financial reports, completing tasks nearly forty percent faster than peers working independently.',
          zh: '第一组从一开始就使用AI助手编写代码和总结财报，完成任务的速度比独立工作的同行快了近40%。',
        ),
        BilingualSentence(
          en: 'However, when both groups were later tested without digital assistance on a novel troubleshooting scenario, the AI-reliant group performed substantially worse, struggling to spot subtle logical flaws they had previously delegated to software.',
          zh: '然而，当两组人员随后在没有数字辅助的情况下接受新故障排查测试时，依赖AI的一组表现明显更差，难以察觉那些先前交由软件处理的细微逻辑漏洞。',
        ),
      ],
      [
        BilingualSentence(
          en: 'The underlying mechanism is straightforward. Deep expertise does not emerge from passively reviewing polished answers; it is forged through the productive friction of wrestling with ambiguous problems.',
          zh: '背后的机制很简单。深厚专业能力并非源于被动浏览完美答案，而是在与模棱两可的难题搏斗的“有益摩擦”中锻造出来的。',
        ),
        BilingualSentence(
          en: 'When an algorithm instantly smooths away every mental obstacle, novices are deprived of the deliberate practice required to build robust mental models.',
          zh: '当算法瞬间抚平一切思维障碍时，新手就被剥夺了构建稳固心智模型所必需的刻意练习。',
        ),
        BilingualSentence(
          en: 'Ironically, senior specialists rarely suffer this decline, because they already possess the domain judgment needed to scrutinize AI outputs and detect plausible-sounding errors.',
          zh: '颇具讽刺意味的是，资深专家很少遭遇这种退化，因为他们早已具备审查AI输出、识破看似合理之错误的领域判断力。',
        ),
      ],
      [
        BilingualSentence(
          en: 'Does this mean educators and employers should ban AI tools outright? Few serious scholars endorse such a drastic retreat.',
          zh: '这是否意味着教育者和雇主应彻底禁止AI工具？很少有严肃学者赞同如此极端的倒退做法。',
        ),
        BilingualSentence(
          en: 'Instead, forward-thinking institutions are redesigning workflows around a "attempt-first" principle—requiring students and junior staff to outline their own hypotheses and reasoning before consulting machine suggestions.',
          zh: '相反，有远见的机构正围绕“先自主尝试”原则重构流程——要求学生和初级员工在参考机器建议前，先写出自己的假设与推理。',
        ),
        BilingualSentence(
          en: 'Used as a rigorous sparring partner rather than a shortcut, AI can enhance human capability without eroding the foundational skills that make human oversight indispensable.',
          zh: '如果把AI当作严谨的陪练伙伴而非偷懒捷径，它就能增强人类能力，同时不至于侵蚀让人类监督不可或缺的基础技能。',
        ),
      ],
    ],
    questions: [
      CarefulQuestion(
        number: 1,
        question: 'Why does the author mention commercial aviation autopilot systems in Paragraph 1?',
        options: [
          'A) To argue that modern AI software is safer than early flight computers.',
          'B) To illustrate how over-reliance on automation can weaken core human skills.',
          'C) To show that pilots receive more rigorous emergency training than analysts.',
          'D) To suggest that universities should adopt aviation safety standards.',
        ],
        answerIndex: 1,
        locateHint: '定位第1段第2–3句',
        explanation: '作者以飞行员过度依赖自动驾驶导致手动应急直觉退化为例，类比当下知识工作者使用AI面临的“认知去技能化”风险。',
      ),
      CarefulQuestion(
        number: 2,
        question: 'What did the experiment with 240 junior professionals reveal?',
        options: [
          'A) AI assistants failed to improve initial task completion speed.',
          'B) Independent workers made more coding mistakes during daily routines.',
          'C) Heavy AI users showed weaker independent problem-solving later on.',
          'D) Business analysts benefited less from AI tools than software engineers.',
        ],
        answerIndex: 2,
        locateHint: '定位第2段末句 However 转折处',
        explanation: '实验显示依赖AI组初期快40%，但在无辅助的新测试中表现明显更差（performed substantially worse），对应选项 C。',
      ),
      CarefulQuestion(
        number: 3,
        question: 'Why are experienced specialists less vulnerable to "cognitive deskilling"?',
        options: [
          'A) They refuse to delegate routine tasks to generative algorithms.',
          'B) They already have strong judgment to critically verify AI results.',
          'C) They spend more hours memorizing technical documentation.',
          'D) They use custom enterprise models that rarely make subtle errors.',
        ],
        answerIndex: 1,
        locateHint: '定位第3段末句',
        explanation: '第3段指出资深专家早已拥有领域判断力，“needed to scrutinize AI outputs and detect plausible-sounding errors”。',
      ),
      CarefulQuestion(
        number: 4,
        question: 'What is the core idea of the "attempt-first" principle mentioned in Paragraph 4?',
        options: [
          'A) Prohibiting junior staff from accessing AI during their first year.',
          'B) Letting AI generate multiple drafts before humans pick the best one.',
          'C) Forming independent analysis before turning to AI for feedback.',
          'D) Grading students solely on handwritten closed-book examinations.',
        ],
        answerIndex: 2,
        locateHint: '定位第4段第3句破折号解释处',
        explanation: '破折号后明确定义：先列出自己的假设和推理，再咨询机器建议，对应选项 C。',
      ),
      CarefulQuestion(
        number: 5,
        question: 'What is the author’s overall attitude toward using AI in learning and work?',
        options: [
          'A) Cautiously supportive when paired with active human thinking.',
          'B) Strongly opposed due to irrevocable harm to young workers.',
          'C) Indifferent as long as short-term productivity rises.',
          'D) Skeptical that any workplace rule can curb AI dependency.',
        ],
        answerIndex: 0,
        locateHint: '定位第4段全文及末句',
        explanation: '作者反对一刀切禁止（drastic retreat），主张将AI作为严谨陪练（sparring partner）配合人类主动思考，态度是审慎支持。',
      ),
    ],
  ),

  CarefulReadingExercise(
    id: 'cr_02',
    title: '仔细阅读 Passage 2 · 城市“15分钟生活圈”的现实与隐忧',
    subtitle: '5 题 · 满分 71.0 分（14.2 分/题）· 建议用时 10 分钟',
    paragraphs: [
      [
        BilingualSentence(
          en: 'Across Europe and Asia, urban planners are rallying around an appealing vision called the "15-minute city"—neighborhoods where groceries, clinics, schools, and parks lie within a short walk or bike ride of home.',
          zh: '在欧洲和亚洲各地，城市规划者正围绕一个颇具吸引力的愿景——“15分钟城市”——凝聚共识，即菜场、诊所、学校和公园都在离家步行或骑行几分钟之内的社区。',
        ),
        BilingualSentence(
          en: 'Proponents argue that curbing long cross-town commutes not only slashes transport emissions but also revitalizes local street economies and strengthens neighborly trust.',
          zh: '支持者认为，减少漫长的跨城通勤不仅能大幅削减交通排放，还能激活社区街道经济、增强邻里信任。',
        ),
      ],
      [
        BilingualSentence(
          en: 'Empirical results from early pilot districts have indeed been encouraging. In central Paris and parts of Shanghai, converting parking lanes into shaded sidewalks and community micro-markets lifted foot traffic for independent merchants while noticeably lowering local air pollution.',
          zh: '早期试点街区的实证结果确实令人鼓舞。在巴黎市中心和上海部分区域，将路边停车道改造为林荫人行道和社区微市集，既提升了独立商户客流，又显著降低了局部空气污染。',
        ),
        BilingualSentence(
          en: 'Elderly residents, who are often most vulnerable to car-dominated road layouts, report tangible gains in daily autonomy and social connection.',
          zh: '最容易受汽车主导道路布局困扰的老年居民反馈称，日常出行自主性和社交联系都获得了切实改善。',
        ),
      ],
      [
        BilingualSentence(
          en: 'Yet urban sociologists warn that well-intentioned redesigns can inadvertently exacerbate housing inequality if implemented without safeguards.',
          zh: '然而城市社会学家警告，如果缺乏保障措施，善意的改造可能会在无意中加剧住房不平等。',
        ),
        BilingualSentence(
          en: 'As leafy, walkable districts grow ever more desirable, rents and property prices surge rapidly—quietly pricing out the very service workers, nurses, and teachers who keep neighborhood amenities running.',
          zh: '随着绿树成荫、适宜步行的街区越来越抢手，租金和房价迅速飙升——悄悄把支撑社区运转的服务人员、护士和教师挤了出去。',
        ),
        BilingualSentence(
          en: 'A city composed solely of wealthy self-contained enclaves would betray the inclusive spirit the concept originally promised.',
          zh: '一座仅由富裕且封闭的飞地组成的城市，将背离这一理念最初承诺的包容精神。',
        ),
      ],
      [
        BilingualSentence(
          en: 'Equally challenging is the reality of modern specialized labor markets. Few residents can expect a major hospital, aerospace plant, or university campus to sit fifteen minutes from their doorstep.',
          zh: '同样具有挑战性的是现代专业化劳动力市场的现实。很少有居民能指望大型医院、航天工厂或大学校园正好建在离家15分钟的地方。',
        ),
        BilingualSentence(
          en: 'Consequently, leading urbanists stress that the 15-minute model should complement, rather than substitute for, affordable metro networks linking suburban commuters to regional job hubs.',
          zh: '因此，权威城市学者强调，“15分钟模式”应当补充而非替代连接郊区通勤者与区域就业中心的平价地铁网络。',
        ),
        BilingualSentence(
          en: 'Only by pairing neighborhood livability with subsidized affordable housing and rapid transit can cities reconcile convenience with genuine fairness.',
          zh: '只有将社区宜居性与政府补贴的保障房以及快速公交结合起来，城市才能在便利与真正公平之间实现协调。',
        ),
      ],
    ],
    questions: [
      CarefulQuestion(
        number: 1,
        question: 'What is the core objective of the "15-minute city" concept?',
        options: [
          'A) Banning all private cars from entering metropolitan regions.',
          'B) Placing essential daily services within easy walking or cycling reach.',
          'C) Relocating heavy manufacturing plants into suburban neighborhoods.',
          'D) Ensuring every employee works remotely from home.',
        ],
        answerIndex: 1,
        locateHint: '定位第1段第1句',
        explanation: '第1段明确定义：让日常所需的买菜、诊所、学校和公园都在步行或骑行短距离范围内。',
      ),
      CarefulQuestion(
        number: 2,
        question: 'Who gained notable independence from pilot projects in Paris and Shanghai?',
        options: [
          'A) Long-distance freight drivers.',
          'B) Real estate developers in outer suburbs.',
          'C) Senior citizens living in renovated districts.',
          'D) International tourists visiting historic sites.',
        ],
        answerIndex: 2,
        locateHint: '定位第2段末句',
        explanation: '第2段末句指出 “Elderly residents ... report tangible gains in daily autonomy”，autonomy 同义替换 independence。',
      ),
      CarefulQuestion(
        number: 3,
        question: 'What unintended negative consequence do urban sociologists caution against?',
        options: [
          'A) Small local shops losing customers to online grocers.',
          'B) Rising living costs pushing essential workers out of improved neighborhoods.',
          'C) Excessive bike lanes worsening emergency ambulance response times.',
          'D) Neighborhood parks becoming overcrowded on weekends.',
        ],
        answerIndex: 1,
        locateHint: '定位第3段第1–2句',
        explanation: '第3段指出若无保障措施，租金房价飙升会把服务人员、护士和教师挤出社区（pricing out），加剧住房不平等。',
      ),
      CarefulQuestion(
        number: 4,
        question: 'Why can the 15-minute city model NOT replace regional public transit?',
        options: [
          'A) Most citizens dislike cycling during rainy or cold seasons.',
          'B) Specialized workplaces cannot all be distributed into every neighborhood.',
          'C) Metro operators rely on suburban fares to maintain downtown stations.',
          'D) Local governments lack land to build shaded sidewalks.',
        ],
        answerIndex: 1,
        locateHint: '定位第4段第1–2句',
        explanation: '第4段指出专业化就业市场中，大医院、工厂、高校不可能都建在每个居民家门口，仍需平价地铁连接就业中心。',
      ),
      CarefulQuestion(
        number: 5,
        question: 'According to the last sentence, how can cities achieve both livability and fairness?',
        options: [
          'A) By combining walkable neighborhoods with affordable housing and efficient transit.',
          'B) By limiting property ownership exclusively to local district employees.',
          'C) By replacing all street-level parking spaces with public hospitals.',
          'D) By subsidizing electric vehicles for suburban residents.',
        ],
        answerIndex: 0,
        locateHint: '定位第4段末句 Only by...',
        explanation: '末句明确指出：将社区宜居性与补贴保障房、快速公交结合（pairing neighborhood livability with subsidized affordable housing and rapid transit）。',
      ),
    ],
  ),
];
