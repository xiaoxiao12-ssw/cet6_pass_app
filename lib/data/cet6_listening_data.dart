import '../models/cet6_models.dart';

/// 六级听力全真模拟题库：完整覆盖 Section A 长对话 / Section B 听力篇章 / Section C 讲话报道讲座
const List<ListeningExercise> cet6ListeningExercises = [
  // ==================== ① 长对话 (Long Conversations) ====================
  ListeningExercise(
    id: 'lc_01',
    sectionType: ListeningSectionType.longConversation,
    title: '长对话 1 · 远程办公与职场沟通困境',
    subtitle: '4 题 · 职场心理与混合办公模式（高频考点：转折与建议）',
    sentences: [
      ListeningSentence(
        speaker: 'W',
        en: 'Mark, you look exhausted lately. I thought switching to remote work was supposed to alleviate your daily stress.',
        zh: '马克，你最近看起来很疲惫。我原以为转为远程办公能减轻你每天的压力呢。',
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'At first it did. Eliminating a two-hour commute saved substantial time, and I felt far more productive in the morning.',
        zh: '一开始确实如此。省去两小时通勤节省了大量时间，而且我上午效率高多了。',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'So what changed? Is your manager piling on extra assignments?',
        zh: '那后来怎么变了？是你们经理给你加了额外任务吗？',
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'Not really. The real dilemma is that work boundaries have grown completely ambiguous; colleagues message me at ten at night expecting immediate replies.',
        zh: '其实不是。真正的困境在于工作边界变得完全模糊了；同事晚上十点发消息，还指望我立刻回复。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'That sounds familiar. Constant digital availability can quietly undermine sleep quality and erode personal time.',
        zh: '听起来太熟悉了。随时在线会悄悄破坏睡眠质量，侵蚀个人时间。',
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'Exactly. Plus, I miss spontaneous hallway conversations. Solving a minor technical discrepancy now requires scheduling a formal thirty-minute video call.',
        zh: '没错。而且我怀念走廊里那种随性的交流。现在解决一个微小的技术出入都得预约三十分钟的正式视频会议。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'Our design team ran into the exact same obstacle last quarter. What actually turned things around was drafting a clear communication charter.',
        zh: '我们设计团队上季度遇到了完全一样的障碍。真正扭转局面的是起草了一份清晰的沟通公约。',
        locatesQuestion: 3,
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'A communication charter? How does that work in practice?',
        zh: '沟通公约？实际操作中怎么运行？',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'We agreed on core collaborative hours from ten to four, muted non-urgent alerts after six, and reserved Wednesdays exclusively for uninterrupted deep work.',
        zh: '我们约定了上午十点到下午四点为核心协作时段，六点后静音非紧急提醒，并把每周三专门留作不受打扰的深度工作时间。',
        locatesQuestion: 4,
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'That sounds remarkably pragmatic. I will propose a pilot version at Monday’s team meeting.',
        zh: '听起来非常务实。我会在周一的团队会议上提议试行一版。',
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'What is the main cause of Mark’s recent exhaustion?',
        options: [
          'A) His manager keeps assigning him heavier workloads.',
          'B) The line between work and personal life has become blurred.',
          'C) He still has to endure a two-hour daily commute.',
          'D) He lacks sufficient technical skills for remote projects.',
        ],
        answerIndex: 1,
        explanation: '男士明确指出 “The real dilemma is that work boundaries have grown completely ambiguous”，对应选项 B 中的 blurred（模糊的）。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'Why does Mark say he misses working in the physical office?',
        options: [
          'A) Office equipment is more reliable than home internet.',
          'B) Formal video meetings are too short to reach consensus.',
          'C) Casual talks made resolving small issues much faster.',
          'D) Colleagues were less likely to contact him during lunch.',
        ],
        answerIndex: 2,
        explanation: '男士提到怀念 “spontaneous hallway conversations”，如今小问题都得约30分钟视频会，对应选项 C（随性交流能更快解决小问题）。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'How did the woman’s team overcome a similar problem?',
        options: [
          'A) By returning to full-time office attendance immediately.',
          'B) By establishing explicit rules for team communication.',
          'C) By hiring an external consultant to audit their workflow.',
          'D) By replacing all video meetings with email summaries.',
        ],
        answerIndex: 1,
        explanation: '女士说 “drafting a clear communication charter”（起草清晰的沟通公约），即制定明确的团队沟通规则。',
      ),
      ListeningQuestion(
        number: 4,
        question: 'What is special about Wednesdays for the woman’s design team?',
        options: [
          'A) Everyone attends a mandatory in-person brainstorming session.',
          'B) Employees are allowed to log off before four o’clock.',
          'C) The whole day is dedicated to focused work without interruptions.',
          'D) Team members review their weekly communication charter.',
        ],
        answerIndex: 2,
        explanation: '女士提到 “reserved Wednesdays exclusively for uninterrupted deep work”，对应选项 C。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'ambiguous boundaries',
        replacement: 'line ... has become blurred',
        note: '六级高频替换：ambiguous（模糊的）↔ blurred',
      ),
      SynonymPair(
        original: 'spontaneous hallway conversations',
        replacement: 'casual talks',
        note: 'spontaneous（自发的/随性的）↔ casual',
      ),
      SynonymPair(
        original: 'communication charter',
        replacement: 'explicit rules for communication',
        note: 'charter（章程/公约）↔ explicit rules',
      ),
      SynonymPair(
        original: 'uninterrupted deep work',
        replacement: 'focused work without interruptions',
        note: 'deep work ↔ focused work',
      ),
    ],
  ),

  ListeningExercise(
    id: 'lc_02',
    sectionType: ListeningSectionType.longConversation,
    title: '长对话 2 · 城市旧建筑改造与商业平衡',
    subtitle: '4 题 · 城市规划与文化遗产（高频考点：态度对比与细节推理）',
    sentences: [
      ListeningSentence(
        speaker: 'M',
        en: 'Elena, have you visited the renovated textile mill down by the riverfront yet?',
        zh: '埃琳娜，你去过河滨那边翻新后的旧纺织厂了吗？',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'I went last weekend, actually. Honestly, I was skeptical before going, because so many heritage restorations turn historic sites into generic shopping malls.',
        zh: '其实我上周末去了。老实说去之前我很怀疑，因为太多古迹修复把历史遗址变成了千篇一律的商场。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'And did this project surprise you?',
        zh: '那这个项目让你感到惊喜吗？',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'Tremendously. The architects managed to reconcile industrial heritage with everyday public use. They kept the original brick chimneys and timber beams completely intact.',
        zh: '非常惊喜。建筑师成功调和了工业遗产与日常公共使用。他们把原来的砖烟囱和木梁完整保留了下来。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'I heard the city faced a fierce debate over funding. Preserving old masonry costs far more than demolishing and building anew.',
        zh: '我听说市政府在资金问题上争论很激烈。保护旧砖石结构的成本远高于推倒重建。',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'True, the upfront budget was daunting. To offset maintenance expenses, the municipal council leased the ground floor to independent bookstores and craft studios while keeping the courtyard permanently free.',
        zh: '确实，前期预算很吓人。为了抵消维护费用，市议会将一楼租给了独立书店和手作工作室，同时保持中庭永久免费开放。',
        locatesQuestion: 3,
      ),
      ListeningSentence(
        speaker: 'M',
        en: 'That explains why local residents seem so enthusiastic. Still, do you think it can sustain that momentum once the initial curiosity fades?',
        zh: '难怪当地居民这么热情。不过，你觉得等最初的新鲜感过去后，它还能保持这种势头吗？',
      ),
      ListeningSentence(
        speaker: 'W',
        en: 'Only if they keep hosting community workshops and seasonal night markets. Buildings thrive when neighbors feel genuine ownership, not just when tourists snap photos.',
        zh: '只有坚持举办社区工坊和季节性夜市才行。建筑真正焕发生机，靠的是邻里拥有归属感，而不仅仅是游客拍照打卡。',
        locatesQuestion: 4,
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'Why was Elena doubtful about the renovated textile mill at first?',
        options: [
          'A) She thought the riverfront location was inconvenient to reach.',
          'B) Many similar renovations end up as ordinary commercial malls.',
          'C) The industrial structures were too fragile to be safely entered.',
          'D) Admission tickets were rumored to be excessively expensive.',
        ],
        answerIndex: 1,
        explanation: '女士说之前 skeptical 是因为很多改造把历史遗址变成了 “generic shopping malls”，对应选项 B。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'What impressed Elena most about the architects’ work?',
        options: [
          'A) They replaced the old roof with high-tech solar glass.',
          'B) They preserved original architectural elements while making it practical.',
          'C) They finished the entire restoration well under budget.',
          'D) They converted the chimneys into observation towers.',
        ],
        answerIndex: 1,
        explanation: '女士称赞建筑师 “reconcile industrial heritage with everyday public use” 并完整保留了原始砖烟囱与木梁。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'How does the city cover the ongoing maintenance costs of the site?',
        options: [
          'A) By charging visitors an entrance fee to the courtyard.',
          'B) By soliciting donations from international heritage foundations.',
          'C) By renting part of the space to small cultural businesses.',
          'D) By raising property taxes in the surrounding neighborhood.',
        ],
        answerIndex: 2,
        explanation: '女士指出为了 “offset maintenance expenses”，将一楼出租给独立书店和手作工作室（small cultural businesses）。',
      ),
      ListeningQuestion(
        number: 4,
        question: 'What does Elena believe is essential for the site’s long-term vitality?',
        options: [
          'A) Expanding parking lots to attract more out-of-town tourists.',
          'B) Fostering continuous local participation through regular events.',
          'C) Inviting luxury retail chains to open flagship branches.',
          'D) Restricting visitor numbers to protect the brick floors.',
        ],
        answerIndex: 1,
        explanation: '女士强调持续举办社区工坊和夜市，让当地居民产生归属感，对应选项 B。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'skeptical',
        replacement: 'doubtful',
        note: '六级态度题必考替换：skeptical ↔ doubtful',
      ),
      SynonymPair(
        original: 'generic shopping malls',
        replacement: 'ordinary commercial malls',
        note: 'generic（千篇一律的/普通的）↔ ordinary',
      ),
      SynonymPair(
        original: 'offset maintenance expenses',
        replacement: 'cover ongoing maintenance costs',
        note: 'offset（抵消/弥补）↔ cover',
      ),
      SynonymPair(
        original: 'genuine ownership',
        replacement: 'continuous local participation',
        note: '居民归属感与社区活动参与的语义呼应',
      ),
    ],
  ),

  // ==================== ② 听力篇章 (Passages) ====================
  ListeningExercise(
    id: 'ps_01',
    sectionType: ListeningSectionType.passage,
    title: '听力篇章 1 · 城市“微森林”的生态降温效应',
    subtitle: '3 题 · 生态与可持续发展（高频考点：因果逻辑与研究结论）',
    sentences: [
      ListeningSentence(
        en: 'As summer heat waves intensify across densely populated cities, urban planners are searching for viable cooling solutions that fit inside crowded neighborhoods.',
        zh: '随着人口密集城市的夏季热浪不断加剧，城市规划者正寻找适合拥挤街区的可行降温方案。',
      ),
      ListeningSentence(
        en: 'Traditional municipal parks require vast stretches of land that few modern metropolises can still spare.',
        zh: '传统市政公园需要大片土地，而如今很少有现代大都市还能腾出这样的空间。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        en: 'In response, a growing number of cities have embraced "pocket forests"—dense clusters of native trees planted on plots no larger than a tennis court.',
        zh: '作为回应，越来越多城市引入了“口袋森林”——在不大于一个网球场的地块上密集种植本土树木。',
      ),
      ListeningSentence(
        en: 'Pioneered by Japanese botanist Akira Miyawaki, the method involves enriching the soil with organic compost and planting dozens of native species closely together.',
        zh: '该方法由日本植物学家宫胁昭首创，做法是用有机堆肥改良土壤，并将数十种本土树种紧密混种在一起。',
      ),
      ListeningSentence(
        en: 'Because the saplings must compete intensely for sunlight, they grow up to ten times faster than trees in conventional plantations and become self-sustaining within three years.',
        zh: '由于树苗必须激烈争夺阳光，它们的生长速度比传统人工林快十倍，且三年内就能实现自我维持。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        en: 'Field measurements in Europe and Asia show that these miniature woodlands can lower surrounding surface temperatures by up to four degrees Celsius while absorbing heavy storm runoff.',
        zh: '欧洲和亚洲的实地测量显示，这些微型林地可将周边地表温度降低多达四摄氏度，同时吸收强降雨径流。',
      ),
      ListeningSentence(
        en: 'Equally important, ecologists note that inviting local schoolchildren to plant and monitor the plots fosters lasting environmental stewardship across the entire district.',
        zh: '同样重要的是，生态学家指出，邀请当地学童参与种植和监测地块，能在整个街区培养持久的环保责任感。',
        locatesQuestion: 3,
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'Why are traditional large parks difficult to build in many modern cities?',
        options: [
          'A) They require rare imported tree species.',
          'B) Available urban land is extremely scarce.',
          'C) Residents prefer indoor sports complexes.',
          'D) They fail to absorb seasonal rainwater.',
        ],
        answerIndex: 1,
        explanation: '原文提到 “require vast stretches of land that few modern metropolises can still spare”，即城市可用土地稀缺。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'What causes trees in a pocket forest to grow remarkably quickly?',
        options: [
          'A) Automated underground irrigation systems.',
          'B) Genetically engineered fast-growing seeds.',
          'C) Fierce competition for light among closely planted saplings.',
          'D) Constant pruning by professional municipal gardeners.',
        ],
        answerIndex: 2,
        explanation: '因果标志词 Because 后明确说明 “saplings must compete intensely for sunlight”，对应选项 C。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'What social benefit do ecologists highlight at the end of the passage?',
        options: [
          'A) Raising nearby residential property values.',
          'B) Creating full-time forestry jobs for graduates.',
          'C) Cultivating long-term ecological awareness among young residents.',
          'D) Reducing the cost of public school science labs.',
        ],
        answerIndex: 2,
        explanation: '结尾 Equally important 引出重点：“fosters lasting environmental stewardship”，对应选项 C。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'few metropolises can spare',
        replacement: 'extremely scarce',
        note: '委婉表达转直接形容：腾不出土地 ↔ 极其稀缺',
      ),
      SynonymPair(
        original: 'compete intensely for sunlight',
        replacement: 'fierce competition for light',
        note: '动词短语转名词短语：compete intensely ↔ fierce competition',
      ),
      SynonymPair(
        original: 'fosters lasting environmental stewardship',
        replacement: 'cultivating long-term ecological awareness',
        note: 'foster ↔ cultivate；lasting ↔ long-term',
      ),
    ],
  ),

  ListeningExercise(
    id: 'ps_02',
    sectionType: ListeningSectionType.passage,
    title: '听力篇章 2 · 消费决策中的“选择过载”效应',
    subtitle: '4 题 · 行为心理学实验（高频考点：实验对照与结论反转）',
    sentences: [
      ListeningSentence(
        en: 'Conventional economic theory long assumed that giving consumers more choices inevitably enhances satisfaction and drives higher sales.',
        zh: '传统经济理论长期假定，给消费者提供更多选择必然会提升满意度并拉动更高销量。',
      ),
      ListeningSentence(
        en: 'Yet a landmark psychological experiment conducted at an upscale grocery store challenged this deep-rooted premise.',
        zh: '然而，在一家高端杂货店进行的标志性心理学实验挑战了这一根深蒂固的前提。',
      ),
      ListeningSentence(
        en: 'On certain days, researchers set up a tasting booth displaying twenty-four varieties of specialty jam; on other days, they offered only six carefully selected flavors.',
        zh: '在某些日子里，研究人员摆出展示二十四种特色果酱的试吃台；在另一些日子，他们只提供六种精选口味。',
      ),
      ListeningSentence(
        en: 'Unsurprisingly, the larger display attracted significantly more passersby to stop and sample the jars.',
        zh: '不出所料，更大的展示台吸引了多得多的路人驻足品尝。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        en: 'When it came to actual purchases, however, the outcome flipped dramatically: thirty percent of shoppers at the six-jam table bought a jar, compared with merely three percent at the twenty-four-jam display.',
        zh: '然而落到实际购买时，结果急剧反转：六种果酱台前有30%的顾客买了一罐，而二十四种果酱台前仅有3%购买。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        en: 'Psychologists call this phenomenon "choice overload." When options proliferate beyond a comfortable threshold, evaluating every trade-off induces cognitive fatigue and lingering regret.',
        zh: '心理学家称这一现象为“选择过载”。当选项激增超过舒适阈值时，权衡每个取舍会诱发认知疲劳和挥之不去的懊悔。',
        locatesQuestion: 3,
      ),
      ListeningSentence(
        en: 'Consequently, savvy digital platforms no longer dump endless catalogs onto users; instead, they curate concise shortlists tailored to explicit preferences.',
        zh: '因此，精明的数字平台不再向用户倾倒无尽的商品目录，而是根据明确偏好精选简洁的候选清单。',
        locatesQuestion: 4,
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'What advantage did the 24-jam tasting booth have over the 6-jam booth?',
        options: [
          'A) It generated ten times more completed purchases.',
          'B) It drew a greater number of shoppers to stop and taste.',
          'C) Its specialty jams were sold at a lower promotional price.',
          'D) Shoppers spent less time deciding which flavor to sample.',
        ],
        answerIndex: 1,
        explanation: '原文指出 “the larger display attracted significantly more passersby to stop and sample”，吸引驻足试吃的人更多。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'What surprising result emerged when researchers tracked actual buying behavior?',
        options: [
          'A) Both displays achieved virtually identical conversion rates.',
          'B) Most shoppers preferred buying online after tasting in store.',
          'C) The smaller assortment produced a much higher purchase rate.',
          'D) Consumers complained that six flavors were too restrictive.',
        ],
        answerIndex: 2,
        explanation: '转折词 however 后给出核心数据：6种果酱30%购买 vs 24种仅3%购买，小组合转化率高得多。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'According to psychologists, why does "choice overload" discourage buying?',
        options: [
          'A) Excessive options trigger mental exhaustion and fear of regret.',
          'B) Shoppers assume large displays contain lower-quality goods.',
          'C) Store clerks cannot accurately explain twenty-four products.',
          'D) People tend to distrust unfamiliar specialty brands.',
        ],
        answerIndex: 0,
        explanation: '原文指出评估过多选项会 “induces cognitive fatigue and lingering regret”，对应选项 A。',
      ),
      ListeningQuestion(
        number: 4,
        question: 'How have modern online platforms adapted to this finding?',
        options: [
          'A) By removing customer reviews from product pages.',
          'B) By limiting each user to six daily recommendations.',
          'C) By presenting focused, personalized selections instead of huge lists.',
          'D) By offering full refunds on every impulse purchase.',
        ],
        answerIndex: 2,
        explanation: '结尾 Consequently 指出平台 “curate concise shortlists tailored to explicit preferences”，对应选项 C。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'cognitive fatigue',
        replacement: 'mental exhaustion',
        note: '六级心理学高频替换：cognitive ↔ mental；fatigue ↔ exhaustion',
      ),
      SynonymPair(
        original: 'curate concise shortlists',
        replacement: 'present focused selections',
        note: 'concise shortlists（简洁候选清单）↔ focused selections',
      ),
      SynonymPair(
        original: 'deep-rooted premise',
        replacement: 'conventional assumption',
        note: 'premise（前提假设）↔ assumption',
      ),
    ],
  ),

  // ==================== ③ 讲话/报道/讲座 (Lectures/Talks) ====================
  ListeningExercise(
    id: 'lt_01',
    sectionType: ListeningSectionType.lecture,
    title: '讲座 1 · 睡眠与大脑记忆巩固机制',
    subtitle: '4 题 · 神经科学学术讲座（高频考点：分点信号词与否定陷阱）',
    sentences: [
      ListeningSentence(
        en: 'Good afternoon, everyone. Today we are going to examine a misconception that remains stubbornly prevalent on university campuses: the belief that pulling an all-nighter before an exam helps you retain more material.',
        zh: '各位下午好。今天我们要剖析一个在大学校园里依然顽固盛行的误区：认为考前通宵达旦能帮你记住更多内容。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        en: 'Decades of neuroscience research reveal that sleep is not a passive shutdown of the brain; rather, it is an active night shift dedicated to memory consolidation.',
        zh: '数十年的神经科学研究揭示，睡眠并非大脑的被动关机，而是一场专门用于巩固记忆的活跃“夜班”。',
      ),
      ListeningSentence(
        en: 'During the day, newly learned facts—such as CET-6 vocabulary or historical dates—are stored temporarily in a fragile neural hub called the hippocampus.',
        zh: '白天，新学到的知识——比如六级词汇或历史年代——会暂时储存在一个叫海马体的脆弱神经中枢里。',
      ),
      ListeningSentence(
        en: 'Think of the hippocampus like a smartphone’s short-term cache: its capacity is limited, and fresh memories are highly susceptible to interference.',
        zh: '可以把海马体想象成智能手机的短期缓存：容量有限，新记忆极易受到干扰。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        en: 'Once you enter deep slow-wave sleep, however, the brain replays those daytime neural patterns and transfers them to the neocortex for durable long-term storage.',
        zh: '然而一旦进入深度慢波睡眠，大脑就会重放白天的神经模式，并将其转移到新皮层以实现持久的长期储存。',
        locatesQuestion: 3,
      ),
      ListeningSentence(
        en: 'Even more strikingly, REM sleep—the stage associated with vivid dreaming—weaves newly acquired knowledge together with older concepts, sparking creative insights.',
        zh: '更令人惊叹的是，与鲜明梦境相关的快速眼动睡眠会把新知识和旧概念编织在一起，激发创造性洞见。',
      ),
      ListeningSentence(
        en: 'What happens when students deprive themselves of sleep after studying? Brain scans demonstrate a forty percent drop in the hippocampus’s ability to encode new information the following day.',
        zh: '如果学生在学习后剥夺自己的睡眠会发生什么？脑部扫描显示，次日海马体编码新信息的能力会骤降40%。',
      ),
      ListeningSentence(
        en: 'Therefore, if you want your revision to yield tangible exam scores, treat seven to eight hours of consistent sleep as an integral part of your study timetable, not a luxury to sacrifice.',
        zh: '因此，如果你想让复习换来实打实的考试分数，请把七到八小时规律睡眠视为学习计划中不可或缺的一部分，而非可以牺牲的奢侈品。',
        locatesQuestion: 4,
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'What widespread campus myth does the speaker challenge at the beginning?',
        options: [
          'A) Reviewing notes in the morning is ineffective.',
          'B) Studying all night improves exam memory retention.',
          'C) Daytime naps permanently disrupt nighttime sleep.',
          'D) Memorizing vocabulary requires silent environments.',
        ],
        answerIndex: 1,
        explanation: '讲座开篇即点明要剖析的误区：“pulling an all-nighter before an exam helps you retain more material”。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'Why does the speaker compare the hippocampus to a smartphone cache?',
        options: [
          'A) Both consume massive amounts of energy during rest.',
          'B) Both automatically erase files after twenty-four hours.',
          'C) Both hold limited temporary data that can easily be disturbed.',
          'D) Both require manual updates to function smoothly.',
        ],
        answerIndex: 2,
        explanation: '类比处明确说明 “its capacity is limited, and fresh memories are highly susceptible to interference”。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'What primarily occurs during deep slow-wave sleep?',
        options: [
          'A) The brain shuts down all electrical activity to conserve glucose.',
          'B) Vivid dreams blend unrelated memories into creative stories.',
          'C) Temporary daytime memories are moved to long-term brain storage.',
          'D) The hippocampus expands its temporary storage capacity by 40%.',
        ],
        answerIndex: 2,
        explanation: '原文指出慢波睡眠期间，大脑重放白天神经模式并 “transfers them to the neocortex for durable long-term storage”。',
      ),
      ListeningQuestion(
        number: 4,
        question: 'What practical advice does the speaker give to students preparing for exams?',
        options: [
          'A) Replace evening review sessions with brief afternoon naps.',
          'B) Schedule adequate regular sleep as a core study requirement.',
          'C) Focus exclusively on memorizing vocabulary right before bed.',
          'D) Avoid dreaming stages by waking up earlier than usual.',
        ],
        answerIndex: 1,
        explanation: '结尾 Therefore 给出核心建议：把7-8小时规律睡眠作为 “an integral part of your study timetable”。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'pulling an all-nighter',
        replacement: 'studying all night',
        note: '校园高频习语：pull an all-nighter（熬通宵）',
      ),
      SynonymPair(
        original: 'susceptible to interference',
        replacement: 'easily be disturbed',
        note: 'susceptible to（易受……影响）↔ easily disturbed',
      ),
      SynonymPair(
        original: 'an integral part',
        replacement: 'a core requirement',
        note: 'integral（不可或缺的/核心的）↔ core',
      ),
    ],
  ),

  ListeningExercise(
    id: 'lt_02',
    sectionType: ListeningSectionType.lecture,
    title: '报道 2 · 海洋塑料微粒治理与生物酶突破',
    subtitle: '3 题 · 前沿科技报道（高频考点：瓶颈限制与未来前景）',
    sentences: [
      ListeningSentence(
        en: 'For decades, mechanical recycling has struggled to keep pace with the sheer magnitude of global plastic waste.',
        zh: '几十年来，机械回收一直难以跟上全球塑料垃圾的庞大规模。',
      ),
      ListeningSentence(
        en: 'Each time conventional plastic bottles are melted down and reshaped, their polymer chains shorten, causing the material’s quality to deteriorate until it can no longer be reused.',
        zh: '每次传统塑料瓶被熔化重塑时，其聚合物链都会变短，导致材料品质不断恶化，最终无法再利用。',
        locatesQuestion: 1,
      ),
      ListeningSentence(
        en: 'Now, however, biochemical engineers report a compelling breakthrough: a lab-engineered enzyme capable of breaking down common PET plastic into its original chemical building blocks within twenty-four hours.',
        zh: '不过如今，生物化学工程师报告了一项极具说服力的突破：一种实验室改造的酶能在24小时内将常见PET塑料分解为原始化学单体。',
      ),
      ListeningSentence(
        en: 'Unlike traditional melting, this biological recycling process yields virgin-grade raw materials that can be reassembled repeatedly without losing strength or clarity.',
        zh: '与传统熔融不同，这种生物回收工艺产出原生级原料，可反复重新聚合而不损失强度或透明度。',
        locatesQuestion: 2,
      ),
      ListeningSentence(
        en: 'Even so, industry analysts caution against premature optimism. Scaling enzyme production for industrial plants remains costly, and sorting contaminated mixed plastics still hampers efficiency.',
        zh: '即便如此，行业分析师仍警告不要过早乐观。工业化规模生产这种酶依然成本高昂，而且分拣受污染的混合塑料仍在制约效率。',
        locatesQuestion: 3,
      ),
      ListeningSentence(
        en: 'Experts emphasize that biochemical recycling should complement, rather than replace, stringent policies that curb single-use packaging at the source.',
        zh: '专家强调，生物化学回收应当补充而非取代从源头遏制一次性包装的严格政策。',
      ),
    ],
    questions: [
      ListeningQuestion(
        number: 1,
        question: 'What is a major limitation of conventional mechanical plastic recycling?',
        options: [
          'A) It consumes far more water than chemical manufacturing.',
          'B) Repeated melting degrades the plastic’s structural quality.',
          'C) It can only process transparent beverage containers.',
          'D) It releases toxic enzymes into municipal landfills.',
        ],
        answerIndex: 1,
        explanation: '原文指出传统熔化重塑会让聚合物链变短，“causing the material’s quality to deteriorate”。',
      ),
      ListeningQuestion(
        number: 2,
        question: 'What makes the newly engineered enzyme recycling method superior?',
        options: [
          'A) It turns plastic waste directly into liquid aviation fuel.',
          'B) It allows plastics to be recreated repeatedly with original quality.',
          'C) It operates automatically inside ocean currents.',
          'D) It completely eliminates the need for plastic sorting.',
        ],
        answerIndex: 1,
        explanation: '原文指出该生物工艺产出 “virgin-grade raw materials”，可以反复重组且不损失强度和透明度。',
      ),
      ListeningQuestion(
        number: 3,
        question: 'Why do industry analysts warn against being overly optimistic right now?',
        options: [
          'A) The enzyme takes several months to break down thick bottles.',
          'B) Consumers refuse to buy biologically recycled packaging.',
          'C) High large-scale production costs and waste sorting remain hurdles.',
          'D) Governments have banned lab-engineered enzymes from factories.',
        ],
        answerIndex: 2,
        explanation: 'Even so 转折后给出两大现实障碍：规模化生产昂贵（remains costly）和分拣受污染混合塑料制约效率（hampers efficiency）。',
      ),
    ],
    synonyms: [
      SynonymPair(
        original: 'quality to deteriorate',
        replacement: 'degrades structural quality',
        note: 'deteriorate（恶化/退化）↔ degrade',
      ),
      SynonymPair(
        original: 'premature optimism',
        replacement: 'being overly optimistic right now',
        note: 'premature（过早的）↔ overly ... right now',
      ),
      SynonymPair(
        original: 'remains costly / hampers efficiency',
        replacement: 'high costs ... remain hurdles',
        note: 'hamper（阻碍）↔ hurdle（障碍）',
      ),
    ],
  ),
];
