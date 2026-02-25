import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> resetAndSeed() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final wordsRef = db.collection('users').doc(uid).collection('words');
  final categoriesRef = db
      .collection('users')
      .doc(uid)
      .collection('categories');

  // ---- RESET ----
  final oldWords = await wordsRef.get();
  for (final doc in oldWords.docs) {
    await doc.reference.delete();
  }

  final oldCats = await categoriesRef.get();
  for (final doc in oldCats.docs) {
    await doc.reference.delete();
  }

  // ---- CATEGORIES ----
  final categories = [
    {'name': 'Salutations & Bases', 'color': 0xFFD81B60},
    {'name': 'Pronoms & Personnes', 'color': 0xFF8E24AA},
    {'name': 'Famille & Relations', 'color': 0xFF5E35B1},
    {'name': 'Métiers & Rôles', 'color': 0xFF3949AB},
    {'name': 'Lieux & Argent', 'color': 0xFF1E88E5},
    {'name': 'Pays & Nationalités', 'color': 0xFF00ACC1},
    {'name': 'Nourriture & Boissons', 'color': 0xFF00897B},
    {'name': 'Animaux', 'color': 0xFF43A047},
    {'name': 'Chiffres', 'color': 0xFFC0CA33},
    {'name': 'Temps', 'color': 0xFFFDD835},
    {'name': 'Verbes Courants', 'color': 0xFFFB8C00},
    {'name': 'Adjectifs & Descriptions', 'color': 0xFFF4511E},
    {'name': 'Directions & Positions', 'color': 0xFF6D4C41},
    {'name': 'Mots Interrogatifs', 'color': 0xFF607D8B},
    {'name': 'Classificateurs', 'color': 0xFF546E7A},
    {'name': 'Loisirs & Médias', 'color': 0xFF039BE5},
  ];

  for (final cat in categories) {
    await categoriesRef.add(cat);
  }

  // ---- WORDS ----
  final words = [
    // Salutations & Bases
    {
      'chinese': '你好',
      'pinyin': 'nǐ hǎo',
      'translation': 'Bonjour',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '再见',
      'pinyin': 'zàijiàn',
      'translation': 'Au revoir',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '请问',
      'pinyin': 'qǐngwèn',
      'translation': 'Excusez-moi / S\'il vous plaît',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '谢谢',
      'pinyin': 'xièxiè',
      'translation': 'Merci',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '不',
      'pinyin': 'bù',
      'translation': 'Non / Négation',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '的',
      'pinyin': 'de',
      'translation': 'Particule possessif',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '吗',
      'pinyin': 'ma',
      'translation': 'Particule interrogative',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '也',
      'pinyin': 'yě',
      'translation': 'Aussi',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '和',
      'pinyin': 'hé',
      'translation': 'Et',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '这',
      'pinyin': 'zhè',
      'translation': 'Ceci',
      'category': 'Salutations & Bases',
    },
    {
      'chinese': '那',
      'pinyin': 'nà',
      'translation': 'Cela (loin)',
      'category': 'Salutations & Bases',
    },

    // Pronoms & Personnes
    {
      'chinese': '我',
      'pinyin': 'wǒ',
      'translation': 'Je / Moi',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '你',
      'pinyin': 'nǐ',
      'translation': 'Tu / Toi',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '他',
      'pinyin': 'tā',
      'translation': 'Il / Lui',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '我们',
      'pinyin': 'wǒmen',
      'translation': 'Nous',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '你们',
      'pinyin': 'nǐmen',
      'translation': 'Vous',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '他们',
      'pinyin': 'tāmen',
      'translation': 'Ils',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '人',
      'pinyin': 'rén',
      'translation': 'Personne / Être humain',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '男人',
      'pinyin': 'nánrén',
      'translation': 'Homme',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '女人',
      'pinyin': 'nǚrén',
      'translation': 'Femme',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '男孩儿',
      'pinyin': 'nánháir',
      'translation': 'Garçon',
      'category': 'Pronoms & Personnes',
    },
    {
      'chinese': '女孩儿',
      'pinyin': 'nǚháir',
      'translation': 'Fille',
      'category': 'Pronoms & Personnes',
    },

    // Famille & Relations
    {
      'chinese': '爸爸',
      'pinyin': 'bàba',
      'translation': 'Papa',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '妈妈',
      'pinyin': 'māma',
      'translation': 'Maman',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '姐姐',
      'pinyin': 'jiějie',
      'translation': 'Grande sœur',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '妹妹',
      'pinyin': 'mèimei',
      'translation': 'Petite sœur',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '哥哥',
      'pinyin': 'gēgē',
      'translation': 'Grand frère',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '弟弟',
      'pinyin': 'dìdi',
      'translation': 'Petit frère',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '儿子',
      'pinyin': 'érzi',
      'translation': 'Fils',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '女儿',
      'pinyin': 'nǚ\'ér',
      'translation': 'Fille (de)',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '孩子',
      'pinyin': 'háizi',
      'translation': 'Enfant',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '朋友',
      'pinyin': 'péngyǒu',
      'translation': 'Ami',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '女朋友',
      'pinyin': 'nǚpéngyǒu',
      'translation': 'Petite amie',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '男朋友',
      'pinyin': 'nánpéngyǒu',
      'translation': 'Petit ami',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '网友',
      'pinyin': 'wǎngyǒu',
      'translation': 'Ami en ligne',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '室友',
      'pinyin': 'shìyǒu',
      'translation': 'Colocataire',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '邻居',
      'pinyin': 'línjū',
      'translation': 'Voisin',
      'category': 'Famille & Relations',
    },
    {
      'chinese': '岁',
      'pinyin': 'suì',
      'translation': 'Ans (âge)',
      'category': 'Famille & Relations',
    },

    // Métiers & Rôles
    {
      'chinese': '学生',
      'pinyin': 'xuéshēng',
      'translation': 'Élève / Étudiant',
      'category': 'Métiers & Rôles',
    },
    {
      'chinese': '医生',
      'pinyin': 'yīshēng',
      'translation': 'Médecin',
      'category': 'Métiers & Rôles',
    },
    {
      'chinese': '老师',
      'pinyin': 'lǎoshī',
      'translation': 'Professeur',
      'category': 'Métiers & Rôles',
    },
    {
      'chinese': '老板',
      'pinyin': 'lǎobǎn',
      'translation': 'Boss / Patron',
      'category': 'Métiers & Rôles',
    },
    {
      'chinese': '同事',
      'pinyin': 'tóngshì',
      'translation': 'Collègue',
      'category': 'Métiers & Rôles',
    },
    {
      'chinese': '同学',
      'pinyin': 'tóngxué',
      'translation': 'Camarade de classe',
      'category': 'Métiers & Rôles',
    },

    // Lieux & Argent
    {
      'chinese': '钱',
      'pinyin': 'qián',
      'translation': 'Argent',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '块',
      'pinyin': 'kuài',
      'translation': 'Yuan (unité monétaire)',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '家',
      'pinyin': 'jiā',
      'translation': 'Maison / Famille',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '医院',
      'pinyin': 'yīyuàn',
      'translation': 'Hôpital',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '学校',
      'pinyin': 'xuéxiào',
      'translation': 'École',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '学院',
      'pinyin': 'xuéyuàn',
      'translation': 'Institut / Faculté',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '商场',
      'pinyin': 'shāngchǎng',
      'translation': 'Centre commercial',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '咖啡厅',
      'pinyin': 'kāfēitīng',
      'translation': 'Café',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '超市',
      'pinyin': 'chāoshì',
      'translation': 'Supermarché',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '饭馆',
      'pinyin': 'fànguǎn',
      'translation': 'Restaurant',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '电影院',
      'pinyin': 'diànyǐngyuàn',
      'translation': 'Cinéma',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '洗手间',
      'pinyin': 'xǐshǒujiān',
      'translation': 'Toilettes',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '公司',
      'pinyin': 'gōngsī',
      'translation': 'Entreprise',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '办公室',
      'pinyin': 'bàngōngshì',
      'translation': 'Bureau',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '这里',
      'pinyin': 'zhèlǐ',
      'translation': 'Ici',
      'category': 'Lieux & Argent',
    },
    {
      'chinese': '那里',
      'pinyin': 'nàlǐ',
      'translation': 'Là-bas',
      'category': 'Lieux & Argent',
    },

    // Pays & Nationalités
    {
      'chinese': '中国',
      'pinyin': 'Zhōngguó',
      'translation': 'Chine',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '中国人',
      'pinyin': 'Zhōngguórén',
      'translation': 'Chinois',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '法国',
      'pinyin': 'Fǎguó',
      'translation': 'France',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '法国人',
      'pinyin': 'Fǎguórén',
      'translation': 'Français',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '英国',
      'pinyin': 'Yīngguó',
      'translation': 'Angleterre',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '英国人',
      'pinyin': 'Yīngguórén',
      'translation': 'Anglais',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '美国',
      'pinyin': 'Měiguó',
      'translation': 'États-Unis',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '美国人',
      'pinyin': 'Měiguórén',
      'translation': 'Américain',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '德国',
      'pinyin': 'Déguó',
      'translation': 'Allemagne',
      'category': 'Pays & Nationalités',
    },
    {
      'chinese': '德国人',
      'pinyin': 'Déguórén',
      'translation': 'Allemand',
      'category': 'Pays & Nationalités',
    },

    // Nourriture & Boissons
    {
      'chinese': '饺子',
      'pinyin': 'jiǎozi',
      'translation': 'Ravioli chinois',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '包子',
      'pinyin': 'bāozi',
      'translation': 'Petit pain farci',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '油条',
      'pinyin': 'yóutiáo',
      'translation': 'Beignet frit',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '面条儿',
      'pinyin': 'miàntiáor',
      'translation': 'Nouilles',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '米饭',
      'pinyin': 'mǐfàn',
      'translation': 'Riz cuit',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '粥',
      'pinyin': 'zhōu',
      'translation': 'Bouillie de riz',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '汤',
      'pinyin': 'tāng',
      'translation': 'Soupe',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '豆浆',
      'pinyin': 'dòujiāng',
      'translation': 'Lait de soja',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '蛋糕',
      'pinyin': 'dàngāo',
      'translation': 'Gâteau',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '面包',
      'pinyin': 'miànbāo',
      'translation': 'Pain',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '果汁',
      'pinyin': 'guǒzhī',
      'translation': 'Jus de fruit',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '咖啡',
      'pinyin': 'kāfēi',
      'translation': 'Café',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '茶',
      'pinyin': 'chá',
      'translation': 'Thé',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '牛奶',
      'pinyin': 'niúnǎi',
      'translation': 'Lait',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '鸡蛋',
      'pinyin': 'jīdàn',
      'translation': 'Œuf',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '水',
      'pinyin': 'shuǐ',
      'translation': 'Eau',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '热水',
      'pinyin': 'rè shuǐ',
      'translation': 'Eau chaude',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '可乐',
      'pinyin': 'kělè',
      'translation': 'Cola',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '啤酒',
      'pinyin': 'píjiǔ',
      'translation': 'Bière',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '酒',
      'pinyin': 'jiǔ',
      'translation': 'Alcool',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '肉',
      'pinyin': 'ròu',
      'translation': 'Viande',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '花生',
      'pinyin': 'huāshēng',
      'translation': 'Cacahuète',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '海鲜',
      'pinyin': 'hǎixiān',
      'translation': 'Fruits de mer',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '豆腐',
      'pinyin': 'dòufu',
      'translation': 'Tofu',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '巧克力',
      'pinyin': 'qiǎokèlì',
      'translation': 'Chocolat',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '饼干',
      'pinyin': 'bǐnggān',
      'translation': 'Biscuit',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '酸奶',
      'pinyin': 'suānnǎi',
      'translation': 'Yaourt',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '苹果',
      'pinyin': 'píngguǒ',
      'translation': 'Pomme',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '香蕉',
      'pinyin': 'xiāngjiāo',
      'translation': 'Banane',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '胡萝卜',
      'pinyin': 'húluóbo',
      'translation': 'Carotte',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '土豆',
      'pinyin': 'tǔdòu',
      'translation': 'Pomme de terre',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '碗',
      'pinyin': 'wǎn',
      'translation': 'Bol',
      'category': 'Nourriture & Boissons',
    },
    {
      'chinese': '杯',
      'pinyin': 'bēi',
      'translation': 'Tasse / Verre',
      'category': 'Nourriture & Boissons',
    },

    // Animaux
    {
      'chinese': '猫',
      'pinyin': 'māo',
      'translation': 'Chat',
      'category': 'Animaux',
    },
    {
      'chinese': '狗',
      'pinyin': 'gǒu',
      'translation': 'Chien',
      'category': 'Animaux',
    },
    {
      'chinese': '熊猫',
      'pinyin': 'xióngmāo',
      'translation': 'Panda',
      'category': 'Animaux',
    },
    {
      'chinese': '鸡',
      'pinyin': 'jī',
      'translation': 'Poule',
      'category': 'Animaux',
    },
    {
      'chinese': '牛',
      'pinyin': 'niú',
      'translation': 'Vache',
      'category': 'Animaux',
    },
    {
      'chinese': '羊',
      'pinyin': 'yáng',
      'translation': 'Mouton / Chèvre',
      'category': 'Animaux',
    },
    {
      'chinese': '鱼',
      'pinyin': 'yú',
      'translation': 'Poisson',
      'category': 'Animaux',
    },

    // Chiffres
    {
      'chinese': '一',
      'pinyin': 'yī',
      'translation': '1',
      'category': 'Chiffres',
    },
    {
      'chinese': '二',
      'pinyin': 'èr',
      'translation': '2',
      'category': 'Chiffres',
    },
    {
      'chinese': '两',
      'pinyin': 'liǎng',
      'translation': 'Deux (devant classif.)',
      'category': 'Chiffres',
    },
    {
      'chinese': '三',
      'pinyin': 'sān',
      'translation': '3',
      'category': 'Chiffres',
    },
    {
      'chinese': '四',
      'pinyin': 'sì',
      'translation': '4',
      'category': 'Chiffres',
    },
    {
      'chinese': '五',
      'pinyin': 'wǔ',
      'translation': '5',
      'category': 'Chiffres',
    },
    {
      'chinese': '六',
      'pinyin': 'liù',
      'translation': '6',
      'category': 'Chiffres',
    },
    {
      'chinese': '七',
      'pinyin': 'qī',
      'translation': '7',
      'category': 'Chiffres',
    },
    {
      'chinese': '八',
      'pinyin': 'bā',
      'translation': '8',
      'category': 'Chiffres',
    },
    {
      'chinese': '九',
      'pinyin': 'jiǔ',
      'translation': '9',
      'category': 'Chiffres',
    },
    {
      'chinese': '十',
      'pinyin': 'shí',
      'translation': '10',
      'category': 'Chiffres',
    },
    {
      'chinese': '二十六',
      'pinyin': 'èrshíliù',
      'translation': '26',
      'category': 'Chiffres',
    },
    {
      'chinese': '百',
      'pinyin': 'bǎi',
      'translation': 'Cent',
      'category': 'Chiffres',
    },

    // Temps
    {
      'chinese': '点',
      'pinyin': 'diǎn',
      'translation': 'Heure (o\'clock)',
      'category': 'Temps',
    },
    {
      'chinese': '分',
      'pinyin': 'fēn',
      'translation': 'Minute',
      'category': 'Temps',
    },
    {
      'chinese': '钟',
      'pinyin': 'zhōng',
      'translation': 'Horloge',
      'category': 'Temps',
    },
    {
      'chinese': '半',
      'pinyin': 'bàn',
      'translation': 'Demi',
      'category': 'Temps',
    },
    {
      'chinese': '过',
      'pinyin': 'guò',
      'translation': 'Passé (heure)',
      'category': 'Temps',
    },
    {
      'chinese': '现在',
      'pinyin': 'xiànzài',
      'translation': 'Maintenant',
      'category': 'Temps',
    },
    {
      'chinese': '上午',
      'pinyin': 'shàngwǔ',
      'translation': 'Matinée (avant midi)',
      'category': 'Temps',
    },
    {
      'chinese': '中午',
      'pinyin': 'zhōngwǔ',
      'translation': 'Midi',
      'category': 'Temps',
    },
    {
      'chinese': '下午',
      'pinyin': 'xiàwǔ',
      'translation': 'Après-midi',
      'category': 'Temps',
    },
    {
      'chinese': '晚上',
      'pinyin': 'wǎnshang',
      'translation': 'Soir',
      'category': 'Temps',
    },
    {
      'chinese': '早上',
      'pinyin': 'zǎoshang',
      'translation': 'Matin',
      'category': 'Temps',
    },
    {
      'chinese': '天',
      'pinyin': 'tiān',
      'translation': 'Jour',
      'category': 'Temps',
    },
    {
      'chinese': '今天',
      'pinyin': 'jīntiān',
      'translation': 'Aujourd\'hui',
      'category': 'Temps',
    },
    {
      'chinese': '明天',
      'pinyin': 'míngtiān',
      'translation': 'Demain',
      'category': 'Temps',
    },
    {
      'chinese': '昨天',
      'pinyin': 'zuótiān',
      'translation': 'Hier',
      'category': 'Temps',
    },
    {
      'chinese': '后天',
      'pinyin': 'hòutiān',
      'translation': 'Après-demain',
      'category': 'Temps',
    },
    {
      'chinese': '前天',
      'pinyin': 'qiántiān',
      'translation': 'Avant-hier',
      'category': 'Temps',
    },
    {
      'chinese': '星期',
      'pinyin': 'xīngqī',
      'translation': 'Semaine',
      'category': 'Temps',
    },
    {
      'chinese': '星期一',
      'pinyin': 'xīngqīyī',
      'translation': 'Lundi',
      'category': 'Temps',
    },
    {
      'chinese': '星期二',
      'pinyin': 'xīngqī\'èr',
      'translation': 'Mardi',
      'category': 'Temps',
    },
    {
      'chinese': '星期三',
      'pinyin': 'xīngqīsān',
      'translation': 'Mercredi',
      'category': 'Temps',
    },
    {
      'chinese': '星期四',
      'pinyin': 'xīngqīsì',
      'translation': 'Jeudi',
      'category': 'Temps',
    },
    {
      'chinese': '星期五',
      'pinyin': 'xīngqīwǔ',
      'translation': 'Vendredi',
      'category': 'Temps',
    },
    {
      'chinese': '星期六',
      'pinyin': 'xīngqīliù',
      'translation': 'Samedi',
      'category': 'Temps',
    },
    {
      'chinese': '星期天',
      'pinyin': 'xīngqītiān',
      'translation': 'Dimanche',
      'category': 'Temps',
    },
    {
      'chinese': '月',
      'pinyin': 'yuè',
      'translation': 'Mois',
      'category': 'Temps',
    },
    {
      'chinese': '年',
      'pinyin': 'nián',
      'translation': 'Année',
      'category': 'Temps',
    },
    {
      'chinese': '生日',
      'pinyin': 'shēngrì',
      'translation': 'Anniversaire',
      'category': 'Temps',
    },
    {
      'chinese': '一月',
      'pinyin': 'yīyuè',
      'translation': 'Janvier',
      'category': 'Temps',
    },
    {
      'chinese': '二月',
      'pinyin': 'èryuè',
      'translation': 'Février',
      'category': 'Temps',
    },
    {
      'chinese': '三月',
      'pinyin': 'sānyuè',
      'translation': 'Mars',
      'category': 'Temps',
    },
    {
      'chinese': '四月',
      'pinyin': 'sìyuè',
      'translation': 'Avril',
      'category': 'Temps',
    },
    {
      'chinese': '五月',
      'pinyin': 'wǔyuè',
      'translation': 'Mai',
      'category': 'Temps',
    },
    {
      'chinese': '六月',
      'pinyin': 'liùyuè',
      'translation': 'Juin',
      'category': 'Temps',
    },
    {
      'chinese': '七月',
      'pinyin': 'qīyuè',
      'translation': 'Juillet',
      'category': 'Temps',
    },
    {
      'chinese': '八月',
      'pinyin': 'bāyuè',
      'translation': 'Août',
      'category': 'Temps',
    },
    {
      'chinese': '九月',
      'pinyin': 'jiǔyuè',
      'translation': 'Septembre',
      'category': 'Temps',
    },
    {
      'chinese': '十月',
      'pinyin': 'shíyuè',
      'translation': 'Octobre',
      'category': 'Temps',
    },
    {
      'chinese': '十一月',
      'pinyin': 'shíyīyuè',
      'translation': 'Novembre',
      'category': 'Temps',
    },
    {
      'chinese': '十二月',
      'pinyin': 'shí\'èryuè',
      'translation': 'Décembre',
      'category': 'Temps',
    },

    // Verbes Courants
    {
      'chinese': '是',
      'pinyin': 'shì',
      'translation': 'Être',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '叫',
      'pinyin': 'jiào',
      'translation': 'S\'appeler',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '吃',
      'pinyin': 'chī',
      'translation': 'Manger',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '喝',
      'pinyin': 'hē',
      'translation': 'Boire',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '去',
      'pinyin': 'qù',
      'translation': 'Aller',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '来',
      'pinyin': 'lái',
      'translation': 'Venir',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '说',
      'pinyin': 'shuō',
      'translation': 'Parler / Dire',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '要',
      'pinyin': 'yào',
      'translation': 'Vouloir / Avoir besoin',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '有',
      'pinyin': 'yǒu',
      'translation': 'Avoir',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '没有',
      'pinyin': 'méiyǒu',
      'translation': 'Ne pas avoir',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '在',
      'pinyin': 'zài',
      'translation': 'Être dans / Se trouver',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '会',
      'pinyin': 'huì',
      'translation': 'Savoir (compétence)',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '爱',
      'pinyin': 'ài',
      'translation': 'Aimer (fort)',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '喜欢',
      'pinyin': 'xǐhuān',
      'translation': 'Aimer / Apprécier',
      'category': 'Verbes Courants',
    },
    {
      'chinese': '讨厌',
      'pinyin': 'tǎoyàn',
      'translation': 'Détester',
      'category': 'Verbes Courants',
    },

    // Adjectifs & Descriptions
    {
      'chinese': '大',
      'pinyin': 'dà',
      'translation': 'Grand',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '小',
      'pinyin': 'xiǎo',
      'translation': 'Petit',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '好',
      'pinyin': 'hǎo',
      'translation': 'Bon / Bien',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '贵',
      'pinyin': 'guì',
      'translation': 'Cher (prix)',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '便宜',
      'pinyin': 'piányí',
      'translation': 'Pas cher',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '多',
      'pinyin': 'duō',
      'translation': 'Beaucoup',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '少',
      'pinyin': 'shǎo',
      'translation': 'Peu',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '很',
      'pinyin': 'hěn',
      'translation': 'Très',
      'category': 'Adjectifs & Descriptions',
    },
    {
      'chinese': '太',
      'pinyin': 'tài',
      'translation': 'Trop',
      'category': 'Adjectifs & Descriptions',
    },

    // Directions & Positions
    {
      'chinese': '前边',
      'pinyin': 'qiánbiān',
      'translation': 'Devant',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '后边',
      'pinyin': 'hòubiān',
      'translation': 'Derrière',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '外边',
      'pinyin': 'wàibiān',
      'translation': 'Dehors / Extérieur',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '里边',
      'pinyin': 'lǐbiān',
      'translation': 'Dedans / Intérieur',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '东边',
      'pinyin': 'dōngbiān',
      'translation': 'Est',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '西边',
      'pinyin': 'xībiān',
      'translation': 'Ouest',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '南边',
      'pinyin': 'nánbiān',
      'translation': 'Sud',
      'category': 'Directions & Positions',
    },
    {
      'chinese': '北边',
      'pinyin': 'běibiān',
      'translation': 'Nord',
      'category': 'Directions & Positions',
    },

    // Mots Interrogatifs
    {
      'chinese': '谁',
      'pinyin': 'shéi',
      'translation': 'Qui ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '什么',
      'pinyin': 'shénme',
      'translation': 'Quoi ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '哪里',
      'pinyin': 'nǎlǐ',
      'translation': 'Où ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '多少钱',
      'pinyin': 'duōshǎo qián',
      'translation': 'Combien (argent) ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '几',
      'pinyin': 'jǐ',
      'translation': 'Combien (objets) ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '怎么',
      'pinyin': 'zěnme',
      'translation': 'Comment ?',
      'category': 'Mots Interrogatifs',
    },
    {
      'chinese': '为什么',
      'pinyin': 'wèishénme',
      'translation': 'Pourquoi ?',
      'category': 'Mots Interrogatifs',
    },

    // Classificateurs
    {
      'chinese': '个',
      'pinyin': 'gè',
      'translation': 'Classif. général (personnes, objets)',
      'category': 'Classificateurs',
    },
    {
      'chinese': '只',
      'pinyin': 'zhī',
      'translation': 'Classif. animaux',
      'category': 'Classificateurs',
    },
    {
      'chinese': '瓶',
      'pinyin': 'píng',
      'translation': 'Classif. bouteille',
      'category': 'Classificateurs',
    },
    {
      'chinese': '块',
      'pinyin': 'kuài',
      'translation': 'Classif. morceau',
      'category': 'Classificateurs',
    },

    // Loisirs & Médias
    {
      'chinese': '电影',
      'pinyin': 'diànyǐng',
      'translation': 'Film',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '看',
      'pinyin': 'kàn',
      'translation': 'Regarder / Lire',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '经常',
      'pinyin': 'jīngcháng',
      'translation': 'Souvent',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '电视',
      'pinyin': 'diànshì',
      'translation': 'Télévision',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '还是',
      'pinyin': 'háishì',
      'translation': 'Ou (choix)',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '运动',
      'pinyin': 'yùndòng',
      'translation': 'Sport / Faire du sport',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '做',
      'pinyin': 'zuò',
      'translation': 'Faire / Fabriquer',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '游戏',
      'pinyin': 'yóuxì',
      'translation': 'Jeu',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '玩儿',
      'pinyin': 'wánr',
      'translation': 'Jouer / S\'amuser',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '音乐',
      'pinyin': 'yīnyuè',
      'translation': 'Musique',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '听',
      'pinyin': 'tīng',
      'translation': 'Écouter',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '打球',
      'pinyin': 'dǎqiú',
      'translation': 'Jouer à un sport de balle',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '书',
      'pinyin': 'shū',
      'translation': 'Livre',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '读',
      'pinyin': 'dú',
      'translation': 'Lire (à voix haute)',
      'category': 'Loisirs & Médias',
    },
    {
      'chinese': '报纸',
      'pinyin': 'bàozhǐ',
      'translation': 'Journal',
      'category': 'Loisirs & Médias',
    },
  ];

  // Batch par 499 max (limite Firestore)
  const batchSize = 499;
  for (int i = 0; i < words.length; i += batchSize) {
    final batch = db.batch();
    final end = (i + batchSize > words.length) ? words.length : i + batchSize;
    final chunk = words.sublist(i, end);
    for (final word in chunk) {
      final doc = wordsRef.doc();
      batch.set(doc, {
        ...word,
        'mastery': 0,
        'reviewCount': 0,
        'correctCount': 0,
        'incorrectCount': 0,
        'lastReview': null,
        'interval': 1,
      });
    }
    await batch.commit();
  }
}
