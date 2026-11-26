import '../models/cet6_models.dart';

/// ==================== 六级写作实战题库（三大常考体裁全覆盖） ====================
const List<WritingTopic> cet6WritingTopics = [
  // 1. 议论文 / 现象解释
  WritingTopic(
    id: 'wt_arg_01',
    genre: WritingGenre.argumentative,
    genreLabel: '议论文 / 现象解释',
    title: '理性看待人工智能辅助大学学习',
    directions:
        'Directions: For this part, you are allowed 30 minutes to write an essay on the rational use of AI tools in university study. You should write at least 150 words but no more than 200 words.',
    templates: [
      WritingTemplateBlock(
        stage: '第一段 · 引入现象 + 亮明立场',
        pattern:
            'In recent years, [核心现象] has become increasingly prevalent on university campuses. While some embrace it with unreserved enthusiasm, a pragmatic perspective suggests that [核心论点].',
        usageNote: '用 prevalent + pragmatic perspective 直接拉高六级词汇档次，避免 Nowadays every student uses... 的四级模板感。',
      ),
      WritingTemplateBlock(
        stage: '第二段 · 辩证剖析（利弊/原因）',
        pattern:
            'Admittedly, [事物] yields substantial benefits, notably [优势一] and [优势二]. Nevertheless, uncritical reliance may quietly undermine [核心能力], leaving students vulnerable to [负面后果].',
        usageNote: '用 Admittedly... Nevertheless... 形成经典让步转折结构，精准契合六级高分评分标准。',
      ),
      WritingTemplateBlock(
        stage: '第三段 · 对策与升华收尾',
        pattern:
            'To reconcile efficiency with genuine intellectual growth, it is imperative that students [具体举措一] and universities [具体举措二]. Only in this way can [事物] serve as a catalyst rather than a crutch.',
        usageNote: '用 it is imperative that（虚拟语气）+ Only in this way can...（部分倒装）双杀阅卷老师！',
      ),
    ],
    modelEssayEn:
        'In recent years, generative AI tools have become increasingly prevalent on university campuses, reshaping how undergraduates conduct research and draft assignments. While some hail this trend as an educational revolution, a pragmatic perspective suggests that AI should augment rather than replace independent thinking.\n\n'
        'Admittedly, intelligent assistants yield substantial benefits. They help students clarify intricate concepts, polish academic phrasing, and organize preliminary reading notes in minutes. Nevertheless, uncritical reliance carries an inherent hazard. When learners delegate every analytical step to algorithms, they are deprived of the deliberate practice required to build rigorous reasoning, quietly undermining their long-term competence.\n\n'
        'To reconcile technological efficiency with genuine intellectual growth, it is imperative that students adopt an "attempt-first" habit—forming their own arguments before consulting machine feedback. Meanwhile, universities should design explicit guidelines emphasizing academic integrity and oral defense. Only in this way can AI serve as a powerful catalyst for learning rather than a substitute for human wisdom.',
    modelEssayZh:
        '近年来，生成式人工智能工具在大学校园日益普及，重塑了本科生开展研究和撰写作业的方式。尽管有人将这一趋势誉为教育革命，但务实的视角表明，人工智能应当增强而非取代独立思考。\n\n'
        '诚然，智能助手带来了可观益处。它们帮助学生在几分钟内厘清复杂概念、润色学术表达并整理初步阅读笔记。然而，不加甄别的依赖潜藏着固有风险。当学习者把每个分析步骤都交给算法时，他们便被剥夺了建立严谨推理所必需的刻意练习，从而悄悄削弱长期能力。\n\n'
        '为了在技术效率与真正心智成长之间取得协调，学生势在必行地应养成“先自主尝试”的习惯——在参考机器反馈前先形成自己的论点。与此同时，高校应制定强调学术诚信与口头答辩的明确规范。唯有如此，人工智能才能成为学习的强大催化剂，而非人类智慧的替代品。',
    keyExpressions: [
      'augment rather than replace（增强而非取代）',
      'yield substantial benefits（带来可观益处）',
      'uncritical reliance（不加甄别的依赖）',
      'reconcile A with B（在A与B之间取得协调）',
      'a catalyst rather than a crutch（催化剂而非拐杖）',
    ],
  ),

  // 2. 名言哲理
  WritingTopic(
    id: 'wt_prov_01',
    genre: WritingGenre.proverb,
    genreLabel: '名言哲理',
    title: '逆境显才华，顺境藏锋芒',
    directions:
        'Directions: For this part, you are allowed 30 minutes to write an essay commenting on the saying "Adversity reveals genius; prosperity conceals it." You can cite examples to illustrate your views. You should write at least 150 words but no more than 200 words.',
    templates: [
      WritingTemplateBlock(
        stage: '第一段 · 引出名言 + 阐释内涵',
        pattern:
            'The timeless maxim "[名言]" illuminates a profound truth about human growth: genuine resilience and ingenuity are rarely forged in comfort, but rather refined through demanding trials.',
        usageNote: '用 timeless maxim / illuminates a profound truth 优雅破题，切忌逐字机械翻译。',
      ),
      WritingTemplateBlock(
        stage: '第二段 · 对比论证 + 经典例证',
        pattern:
            'On the one hand, prolonged prosperity can subtly breed complacency, diminishing our incentive to innovate. On the other hand, adversity acts as a crucible that compels individuals to confront weaknesses. A compelling case in point is [典型事例].',
        usageNote: '正反对比（prosperity → complacency vs. adversity → breakthrough）逻辑极其扎实。',
      ),
      WritingTemplateBlock(
        stage: '第三段 · 联系青年实践收尾',
        pattern:
            'For contemporary college students navigating an uncertain job market, embracing setbacks with prudent determination is indispensable. Rather than fearing obstacles, we should treat every challenge as a stepping stone toward lasting excellence.',
        usageNote: '将哲理自然落脚到当代大学生自身成长，符合六级命题隐性偏好。',
      ),
    ],
    modelEssayEn:
        'The timeless maxim "Adversity reveals genius; prosperity conceals it" illuminates a profound truth about human potential. Genuine ingenuity and inner resilience are seldom cultivated in effortless comfort; instead, they are forged when individuals confront unexpected trials.\n\n'
        'On the one hand, uninterrupted prosperity can quietly foster complacency. When every path appears smooth, people have little incentive to scrutinize their assumptions or push beyond mediocre routines. On the other hand, adversity strips away illusions and compels relentless innovation. A compelling case in point is Tu Youyou’s research team: facing scarce laboratory funding and hundreds of failed extractions in the 1970s, they turned back to classical medical texts and ultimately discovered artemisinin, saving millions of lives worldwide.\n\n'
        'For contemporary college students preparing for a competitive and volatile future, this wisdom remains indispensable. Rather than viewing academic setbacks or career obstacles as permanent defeats, we should approach them with calm resolve. It is precisely through weathering storms that latent talent transforms into tangible achievement.',
    modelEssayZh:
        '“逆境显才华，顺境藏锋芒”这句永恒箴言阐明了关于人类潜能的深刻真理。真正的独创力与内在韧性很少在安逸舒适中养成，而是在个体直面意外考验时锻造出来的。\n\n'
        '一方面，一帆风顺的境遇会悄悄助长自满。当每条路都显得平坦时，人们便缺乏审视既有假设或突破平庸惯性的动力。另一方面，逆境撕去幻象，倒逼不懈创新。一个极具说服力的例证便是屠呦呦团队：面对上世纪七十年代匮乏的实验经费与数百次提取失败，他们回溯古典医籍，最终发现青蒿素，拯救了全球数百万生命。\n\n'
        '对于正准备迎接竞争激烈且瞬息万变未来的当代大学生而言，这份智慧依然不可或缺。与其将学业挫折或求职障碍视为永久失败，我们不如以沉着决心直面挑战。正是在历经风雨的过程中，潜藏的才华才会转化为切实成就。',
    keyExpressions: [
      'illuminate a profound truth（阐明深刻真理）',
      'foster complacency（助长自满）',
      'a compelling case in point（一个极具说服力的例证）',
      'calm resolve（沉着的决心）',
      'transform latent talent into tangible achievement（将潜能转化为切实成就）',
    ],
  ),

  // 3. 图表 / 图画作文
  WritingTopic(
    id: 'wt_chart_01',
    genre: WritingGenre.chart,
    genreLabel: '图表 / 图画作文',
    title: '大学生课外阅读方式变迁调查',
    directions:
        'Directions: For this part, you are allowed 30 minutes to write an essay based on the chart below showing changes in Chinese university students’ primary extracurricular reading formats between 2018 and 2026. You should describe the data, analyze the reasons, and give your comments (150–200 words).',
    chartTitle: '大学生主要课外阅读载体占比对比（2018 vs 2026）',
    chartItems: [
      ChartBarItem(label: '纸质图书 (2018)', value: 58, unitText: '58%'),
      ChartBarItem(label: '纸质图书 (2026)', value: 34, unitText: '34%'),
      ChartBarItem(label: '电子书/屏读 (2018)', value: 33, unitText: '33%'),
      ChartBarItem(label: '电子书/屏读 (2026)', value: 45, unitText: '45%'),
      ChartBarItem(label: '有声书/播客 (2018)', value: 9, unitText: '9%'),
      ChartBarItem(label: '有声书/播客 (2026)', value: 21, unitText: '21%'),
    ],
    templates: [
      WritingTemplateBlock(
        stage: '第一段 · 精准概括图表核心趋势',
        pattern:
            'As is vividly depicted in the bar chart, a substantial shift has occurred in [主题] between [年份1] and [年份2]. While [项目A] declined noticeably from [X]% to [Y]%, [项目B] and [项目C] surged to [M]% and [N]% respectively.',
        usageNote: '图表作文切忌逐条流水账，抓住“一降两升”核心对比即可！',
      ),
      WritingTemplateBlock(
        stage: '第二段 · 双维度归因分析',
        pattern:
            'Two primary factors account for this trajectory. First and foremost, [技术/便利因素] has made [新方式] virtually ubiquitous. Furthermore, [生活节奏/场景因素] encourages students to leverage fragmented commuting hours.',
        usageNote: '用 trajectory / ubiquitous / leverage 精准点出技术普及与碎片化场景两大动因。',
      ),
      WritingTemplateBlock(
        stage: '第三段 · 理性评价 + 建议',
        pattern:
            'In my view, digital and audio formats should complement rather than render print books obsolete. By combining portable listening with uninterrupted print reading for complex classics, students can reap the best of both worlds.',
        usageNote: '避免非黑即白，用 complement rather than render ... obsolete 展现六级思辨深度。',
      ),
    ],
    modelEssayEn:
        'As is vividly depicted in the chart, a substantial shift has occurred in university students’ extracurricular reading habits between 2018 and 2026. Whereas traditional print books dropped sharply from 58% to 34%, e-books rose from 33% to become the predominant format at 45%. Meanwhile, audiobooks more than doubled, climbing from a modest 9% to 21%.\n\n'
        'Two primary factors propel this notable trajectory. First and foremost, lightweight tablets, eye-care e-ink screens, and vast digital libraries have made electronic reading both affordable and ubiquitous. Furthermore, under intense academic schedules, students increasingly leverage audiobooks and podcasts to absorb knowledge during commuting or evening walks, turning fragmented intervals into productive study time.\n\n'
        'From my perspective, this diversification is largely encouraging, provided that convenience does not erode reading depth. Digital formats excel at rapid lookup and portability, yet paper volumes remain uniquely conducive to annotating intricate academic works. Ideally, students should reconcile both mediums—using audio and e-books for daily breadth while reserving quiet hours with print classics for deep contemplation.',
    modelEssayZh:
        '如图所示，2018年至2026年间，大学生的课外阅读习惯发生了显著转变。传统纸质图书占比从58%大幅降至34%，而电子书则从33%攀升至45%，成为占主导地位的阅读载体。与此同时，有声书占比翻了一番以上，从区区9%跃升至21%。\n\n'
        '两大主要因素推动了这一显著轨迹。首先，轻便平板、护眼墨水屏和海量数字图书馆使电子阅读既经济又触手可及。此外，在紧张的学业安排下，学生越来越多地利用有声书和播客在通勤或晚间散步时吸收知识，将碎片间隙转化为高效学习时间。\n\n'
        '在我看来，只要便利性不侵蚀阅读深度，这种多元化趋势总体上令人鼓舞。数字载体擅长快速检索与便携，而纸质书依然特别有利于批注精深的学术著作。理想状态下，学生应协调两种媒介——借助有声书与电子书拓展日常广度，同时为纸质经典留出安静的深度沉思时光。',
    keyExpressions: [
      'become the predominant format（成为主导形式）',
      'more than doubled（翻了一番以上）',
      'leverage ... during fragmented intervals（在碎片间隙充分利用……）',
      'conducive to annotating intricate works（有利于批注精深著作）',
      'reconcile both mediums（协调两种媒介）',
    ],
  ),
];

/// ==================== 六级段落翻译实战题库（三大必考主题全覆盖） ====================
const List<TranslationTopic> cet6TranslationTopics = [
  // 1. 中国传统文化
  TranslationTopic(
    id: 'tr_culture_01',
    theme: TranslationTheme.culture,
    themeLabel: '中国传统文化',
    title: '丝绸之路与非物质文化遗产保护',
    sourceZh:
        '丝绸之路不仅是一条连接东西方的古代商道，更是一座促进文明互鉴的文化桥梁。数百年来，丝绸、瓷器与造纸术沿此路传向世界，深刻影响了人类社会的发展进程。如今，中国高度重视非物质文化遗产的保护与传承。借助高清数字化采集与创意文创产品，敦煌壁画、苏绣和传统皮影戏等珍贵技艺正吸引越来越多年轻人的关注，在现代生活中焕发出新的生机。',
    keyTerms: [
      ThemeTerm(zh: '丝绸之路', en: 'the Silk Road'),
      ThemeTerm(zh: '文明互鉴', en: 'mutual learning among civilizations'),
      ThemeTerm(zh: '非物质文化遗产', en: 'intangible cultural heritage'),
      ThemeTerm(zh: '保护与传承', en: 'preservation and inheritance'),
      ThemeTerm(zh: '敦煌壁画', en: 'the Dunhuang murals'),
      ThemeTerm(zh: '苏绣', en: 'Suzhou embroidery'),
      ThemeTerm(zh: '传统皮影戏', en: 'traditional shadow puppetry'),
      ThemeTerm(zh: '焕发新生机', en: 'take on new vitality / be revitalized'),
    ],
    sentencePairs: [
      TranslationSentencePair(
        zh: '丝绸之路不仅是一条连接东西方的古代商道，更是一座促进文明互鉴的文化桥梁。',
        en: 'The Silk Road was not merely an ancient trade route linking East and West, but also a cultural bridge fostering mutual learning among civilizations.',
        note: '用 not merely ... but also ... 替代基础的 not only；用现在分词 linking / fostering 压缩长定语，句式紧凑高级。',
      ),
      TranslationSentencePair(
        zh: '数百年来，丝绸、瓷器与造纸术沿此路传向世界，深刻影响了人类社会的发展进程。',
        en: 'For centuries, silk, porcelain, and papermaking spread along this corridor to the wider world, exerting a profound influence on the course of human civilization.',
        note: '“深刻影响了……”用现在分词作结果状语 exerting a profound influence on... 是六级翻译绝对高分结构。',
      ),
      TranslationSentencePair(
        zh: '如今，中国高度重视非物质文化遗产的保护与传承。',
        en: 'Today, China attaches great importance to the preservation and inheritance of intangible cultural heritage.',
        note: 'attach great importance to（高度重视）+ intangible cultural heritage（非物质文化遗产）均为六级必背核心表达。',
      ),
      TranslationSentencePair(
        zh: '借助高清数字化采集与创意文创产品，敦煌壁画、苏绣和传统皮影戏等珍贵技艺正吸引越来越多年轻人的关注，在现代生活中焕发出新的生机。',
        en: 'Through high-definition digital archiving and creative cultural products, treasured art forms such as the Dunhuang murals, Suzhou embroidery, and traditional shadow puppetry are drawing growing attention from young people and taking on new vitality in modern life.',
        note: '“借助……”用介词短语 Through... 置前；结尾并列动作 drawing ... and taking on new vitality 流畅自然。',
      ),
    ],
  ),

  // 2. 社会经济发展
  TranslationTopic(
    id: 'tr_economy_01',
    theme: TranslationTheme.economy,
    themeLabel: '社会经济发展',
    title: '数字经济赋能乡村振兴与绿色发展',
    sourceZh:
        '近年来，随着农村宽带网络与现代物流体系的不断完善，数字经济已成为推动中国乡村振兴的重要引擎。越来越多的农民借助电商平台和直播带货，将本地优质农产品直接销往全国乃至海外市场，显著增加了家庭收入。与此同时，各地积极推进绿色低碳转型，将生态农业与乡村旅游有机结合，不仅保护了绿水青山，也为农村经济的可持续发展注入了持久动力。',
    keyTerms: [
      ThemeTerm(zh: '数字经济', en: 'the digital economy'),
      ThemeTerm(zh: '乡村振兴', en: 'rural revitalization'),
      ThemeTerm(zh: '现代物流体系', en: 'modern logistics systems'),
      ThemeTerm(zh: '直播带货', en: 'livestreaming e-commerce'),
      ThemeTerm(zh: '绿色低碳转型', en: 'green and low-carbon transition'),
      ThemeTerm(zh: '生态农业', en: 'ecological agriculture'),
      ThemeTerm(zh: '绿水青山', en: 'lucid waters and lush mountains'),
      ThemeTerm(zh: '可持续发展', en: 'sustainable development'),
    ],
    sentencePairs: [
      TranslationSentencePair(
        zh: '近年来，随着农村宽带网络与现代物流体系的不断完善，数字经济已成为推动中国乡村振兴的重要引擎。',
        en: 'In recent years, with the steady improvement of rural broadband networks and modern logistics systems, the digital economy has emerged as a vital engine driving China’s rural revitalization.',
        note: '用 with + 名词短语处理“随着……”，主干用 has emerged as a vital engine 替代单调的 has become。',
      ),
      TranslationSentencePair(
        zh: '越来越多的农民借助电商平台和直播带货，将本地优质农产品直接销往全国乃至海外市场，显著增加了家庭收入。',
        en: 'Leveraging e-commerce platforms and livestreaming sales, a growing number of farmers now sell high-quality local produce directly to domestic and even overseas markets, substantially boosting household incomes.',
        note: '用分词短语 Leveraging... 表方式，substantially boosting... 作结果状语，层次极清晰。',
      ),
      TranslationSentencePair(
        zh: '与此同时，各地积极推进绿色低碳转型，将生态农业与乡村旅游有机结合，不仅保护了绿水青山，也为农村经济的可持续发展注入了持久动力。',
        en: 'Meanwhile, local regions are actively advancing a green, low-carbon transition by integrating ecological agriculture with rural tourism, which not only preserves lucid waters and lush mountains but also injects lasting momentum into the sustainable development of the rural economy.',
        note: 'by integrating A with B 精准对应“将A与B有机结合”；inject lasting momentum into（注入持久动力）为六级政经高频加分句型。',
      ),
    ],
  ),

  // 3. 科技成就
  TranslationTopic(
    id: 'tr_tech_01',
    theme: TranslationTheme.tech,
    themeLabel: '科技成就',
    title: '中国高铁网络与绿色智慧出行',
    sourceZh:
        '过去十余年间，中国建成了世界上规模最大、技术最先进的高速铁路网络。时速高达350公里的“复兴号”列车不仅大幅缩短了城市间的时空距离，也凭借平稳舒适与准点高效赢得了国内外旅客的广泛赞誉。如今，中国高铁正加速向智能化与绿色化迈进，通过应用北斗导航、人工智能调度与节能新材料，持续降低能源消耗，为全球现代轨道交通树立了典范。',
    keyTerms: [
      ThemeTerm(zh: '高速铁路网络', en: 'high-speed railway network'),
      ThemeTerm(zh: '复兴号列车', en: 'Fuxing bullet trains'),
      ThemeTerm(zh: '时空距离', en: 'spatial and temporal distance'),
      ThemeTerm(zh: '准点高效', en: 'punctuality and high efficiency'),
      ThemeTerm(zh: '北斗导航', en: 'the BeiDou Navigation Satellite System'),
      ThemeTerm(zh: '人工智能调度', en: 'AI-powered scheduling'),
      ThemeTerm(zh: '能源消耗', en: 'energy consumption'),
      ThemeTerm(zh: '树立典范', en: 'set a benchmark / model for'),
    ],
    sentencePairs: [
      TranslationSentencePair(
        zh: '过去十余年间，中国建成了世界上规模最大、技术最先进的高速铁路网络。',
        en: 'Over the past decade and more, China has built the world’s largest and most technologically advanced high-speed railway network.',
        note: '现在完成时 has built 搭配 Over the past decade and more，准确传达持续至今的建设成就。',
      ),
      TranslationSentencePair(
        zh: '时速高达350公里的“复兴号”列车不仅大幅缩短了城市间的时空距离，也凭借平稳舒适与准点高效赢得了国内外旅客的广泛赞誉。',
        en: 'Operating at speeds of up to 350 kilometers per hour, Fuxing bullet trains have not only dramatically shortened travel times between cities, but also earned widespread acclaim from passengers at home and abroad for their smooth comfort, punctuality, and efficiency.',
        note: '用 Operating at speeds of up to... 作前置定语修饰列车；earn widespread acclaim for... 是六级科技成就高频高分短语。',
      ),
      TranslationSentencePair(
        zh: '如今，中国高铁正加速向智能化与绿色化迈进，通过应用北斗导航、人工智能调度与节能新材料，持续降低能源消耗，为全球现代轨道交通树立了典范。',
        en: 'Today, China’s high-speed rail is accelerating toward smarter and greener operations. By applying the BeiDou navigation system, AI-powered scheduling, and energy-saving new materials, it continuously reduces energy consumption and sets a prominent benchmark for modern rail transit worldwide.',
        note: '汉语长流水句在英译时拆为两句，主次分明；set a prominent benchmark for 完美对应“树立典范”。',
      ),
    ],
  ),
];
