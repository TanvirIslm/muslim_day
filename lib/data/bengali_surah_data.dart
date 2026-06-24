// এই ক্লাসটি প্রতিটি সূরার বাংলা নাম ও অর্থ ধারণ করবে
class SurahBengaliData {
  final String name;
  final String meaning;

  const SurahBengaliData({required this.name, required this.meaning});
}

// ১১৪টি সূরার বাংলা নাম ও অর্থের তালিকা
const List<SurahBengaliData> bengaliSurahData = [
  SurahBengaliData(name: "আল-ফাতিহা", meaning: "সূচনা"), // 1
  SurahBengaliData(name: "আল-বাকারা", meaning: "বকনা-বাছুর"), // 2
  SurahBengaliData(name: "আলে'ইমরান", meaning: "ইমরানের পরিবার"), // 3
  SurahBengaliData(name: "আন-নিসা", meaning: "নারী"), // 4
  SurahBengaliData(name: "আল-মা'ইদাহ", meaning: "খাদ্য পরিবেশিত টেবিল"), // 5
  SurahBengaliData(name: "আল-আন'আম", meaning: "গৃহপালিত পশু"), // 6
  SurahBengaliData(name: "আল-আ'রাফ", meaning: "উঁচু স্থানসমূহ"), // 7
  SurahBengaliData(name: "আল-আনফাল", meaning: "যুদ্ধলব্ধ সম্পদ"), // 8
  SurahBengaliData(name: "আত-তাওবাহ", meaning: "অনুশোচনা"), // 9
  SurahBengaliData(name: "ইউনুস", meaning: "ইউনুস (নবী)"), // 10
  SurahBengaliData(name: "হূদ", meaning: "হূদ (নবী)"), // 11
  SurahBengaliData(name: "ইউসুফ", meaning: "ইউসুফ (নবী)"), // 12
  SurahBengaliData(name: "আর-রা'দ", meaning: "বজ্রনাদ"), // 13
  SurahBengaliData(name: "ইবরাহীম", meaning: "ইবরাহীম (নবী)"), // 14
  SurahBengaliData(name: "আল-হিজর", meaning: "পাথুরে পাহাড়"), // 15
  SurahBengaliData(name: "আন-নাহল", meaning: "মৌমাছি"), // 16
  SurahBengaliData(name: "বনী ইসরাঈল", meaning: "ইসরাঈল বংশধর"), // 17
  SurahBengaliData(name: "আল-কাহফ", meaning: "গুহা"), // 18
  SurahBengaliData(name: "মারইয়াম", meaning: "মারইয়াম (ঈসা নবীর মা)"), // 19
  SurahBengaliData(name: "ত্বা-হা", meaning: "ত্বা-হা"), // 20
  SurahBengaliData(name: "আল-আম্বিয়া", meaning: "নবীগণ"), // 21
  SurahBengaliData(name: "আল-হাজ্জ", meaning: "হজ্জ"), // 22
  SurahBengaliData(name: "আল-মু'মিনূন", meaning: "মুমিনগণ"), // 23
  SurahBengaliData(name: "আন-নূর", meaning: "আলো"), // 24
  SurahBengaliData(
      name: "আল-ফুরকান", meaning: "সত্য-মিথ্যার পার্থক্যকারী"), // 25
  SurahBengaliData(name: "আশ-শু'আরা", meaning: "কবিগণ"), // 26
  SurahBengaliData(name: "আন-নামল", meaning: "পিপীলিকা"), // 27
  SurahBengaliData(name: "আল-কাসাস", meaning: "কাহিনী"), // 28
  SurahBengaliData(name: "আল-'আনকাবূত", meaning: "মাকড়সা"), // 29
  SurahBengaliData(name: "আর-রূম", meaning: "রোমানগণ"), // 30
  SurahBengaliData(
      name: "লুকমান", meaning: "লুকমান (একজন জ্ঞানী ব্যক্তি)"), // 31
  SurahBengaliData(name: "আস-সাজদাহ", meaning: "সিজদা"), // 32
  SurahBengaliData(name: "আল-আহযাব", meaning: "জোট"), // 33
  SurahBengaliData(name: "সাবা'", meaning: "সাবা (একটি রাজ্য)"), // 34
  SurahBengaliData(name: "ফাতির", meaning: "স্রষ্টা"), // 35
  SurahBengaliData(name: "ইয়াসীন", meaning: "ইয়াসীন"), // 36
  SurahBengaliData(name: "আস-সাফফাত", meaning: "সারিবদ্ধভাবে দাঁড়ানো"), // 37
  SurahBengaliData(name: "স্বা-দ", meaning: "স্বা-দ"), // 38
  SurahBengaliData(name: "আয-যুমার", meaning: "দলবদ্ধ"), // 39
  SurahBengaliData(name: "গাফির", meaning: "ক্ষমাকারী"), // 40
  SurahBengaliData(name: "ফুসসিলাত", meaning: "বিস্তারিতভাবে বর্ণিত"), // 41
  SurahBengaliData(name: "আশ-শূরা", meaning: "পরামর্শ"), // 42
  SurahBengaliData(name: "আয-যুখরুফ", meaning: "স্বর্ণালংকার"), // 43
  SurahBengaliData(name: "আদ-দুখান", meaning: "ধোঁয়া"), // 44
  SurahBengaliData(name: "আল-জাসিয়াহ", meaning: "নতজানু"), // 45
  SurahBengaliData(name: "আল-আহকাফ", meaning: "বালির পাহাড়"), // 46
  SurahBengaliData(name: "মুহাম্মাদ", meaning: "মুহাম্মাদ (নবী)"), // 47
  SurahBengaliData(name: "আল-ফাতহ্", meaning: "বিজয়"), // 48
  SurahBengaliData(name: "আল-হুজুরাত", meaning: "অন্তরসমূহ"), // 49
  SurahBengaliData(name: "কাফ", meaning: "কাফ"), // 50
  SurahBengaliData(name: "আয-যারিয়াত", meaning: "বিক্ষেপকারী বাতাস"), // 51
  SurahBengaliData(name: "আত-তূর", meaning: "তূর পর্বত"), // 52
  SurahBengaliData(name: "আন-নাজম", meaning: "তারা"), // 53
  SurahBengaliData(name: "আল-ক্বমার", meaning: "চন্দ্র"), // 54
  SurahBengaliData(name: "আর-রাহমান", meaning: "পরম করুণাময়"), // 55
  SurahBengaliData(name: "আল-ওয়াকিয়া", meaning: "অনিবার্য ঘটনা"), // 56
  SurahBengaliData(name: "আল-হাদীদ", meaning: "লোহা"), // 57
  SurahBengaliData(name: "আল-মুজাদালাহ", meaning: "অনুযোগকারিণী"), // 58
  SurahBengaliData(name: "আল-হাশর", meaning: "সমাবেশ"), // 59
  SurahBengaliData(name: "আল-মুমতাহিনাহ", meaning: "পরীক্ষিতা নারী"), // 60
  SurahBengaliData(name: "আস-সাফ", meaning: "সারিবদ্ধ"), // 61
  SurahBengaliData(name: "আল-জুমু'আহ", meaning: "জুমু'আ (শুক্রবার)"), // 62
  SurahBengaliData(name: "আল-মুনাফিকূন", meaning: "কপট বিশ্বাসীগণ"), // 63
  SurahBengaliData(name: "আত-তাগাবুন", meaning: "মোহমুক্তি"), // 64
  SurahBengaliData(name: "আত-তালাক", meaning: "তালাক"), // 65
  SurahBengaliData(name: "আত-তাহরীম", meaning: "নিষিদ্ধকরণ"), // 66
  SurahBengaliData(name: "আল-মুলক", meaning: "সার্বভৌমত্ব"), // 67
  SurahBengaliData(name: "আল-কালাম", meaning: "কলম"), // 68
  SurahBengaliData(name: "আল-হাক্কাহ", meaning: "নিশ্চিত ঘটনা"), // 69
  SurahBengaliData(name: "আল-মা'আরিজ", meaning: "উন্নয়নের সোপান"), // 70
  SurahBengaliData(name: "নূহ", meaning: "নূহ (নবী)"), // 71
  SurahBengaliData(name: "আল-জ্বিন", meaning: "জ্বিন"), // 72
  SurahBengaliData(name: "আল-মুযযাম্মিল", meaning: "বস্ত্রাচ্ছাদনকারী"), // 73
  SurahBengaliData(name: "আল-মুদ্দাসসির", meaning: "পোশাক পরিহিত"), // 74
  SurahBengaliData(name: "আল-কিয়ামাহ", meaning: "পুনরুত্থান"), // 75
  SurahBengaliData(name: "আল-ইনসান", meaning: "মানুষ"), // 76
  SurahBengaliData(name: "আল-মুরসালাত", meaning: "প্রেরিত বাতাস"), // 77
  SurahBengaliData(name: "আন-নাবা", meaning: "মহাসংবাদ"), // 78
  SurahBengaliData(name: "আন-নাযি'আত", meaning: "প্রচেষ্টাকারী"), // 79
  SurahBengaliData(name: "আবাসা", meaning: "তিনি ভ্রু কুঁচকালেন"), // 80
  SurahBengaliData(name: "আত-তাকবীর", meaning: "অন্ধকারাচ্ছন্ন"), // 81
  SurahBengaliData(name: "আল-ইনফিতার", meaning: "বিদীর্ণ হওয়া"), // 82
  SurahBengaliData(name: "আল-মুতফফিফীন", meaning: "প্রতারকগণ"), // 83
  SurahBengaliData(name: "আল-ইনশিকাক", meaning: "খণ্ডিত হওয়া"), // 84
  SurahBengaliData(name: "আল-বুরূজ", meaning: "নক্ষত্রপুঞ্জ"), // 85
  SurahBengaliData(name: "আত-তারিক", meaning: "রাতের আগন্তুক"), // 86
  SurahBengaliData(name: "আল-আ'লা", meaning: "সর্বোচ্চ"), // 87
  SurahBengaliData(name: "আল-গাশিয়াহ", meaning: "বিপর্যয়"), // 88
  SurahBengaliData(name: "আল-ফাজর", meaning: "ভোরবেলা"), // 89
  SurahBengaliData(name: "আল-বালাদ", meaning: "নগর"), // 90
  SurahBengaliData(name: "আশ-শামস", meaning: "সূর্য"), // 91
  SurahBengaliData(name: "আল-লাইল", meaning: "রাত্রি"), // 92
  SurahBengaliData(name: "আদ-দুহা", meaning: "পূর্বাহ্ন"), // 93
  SurahBengaliData(name: "আশ-শারহ", meaning: "প্রশস্তকরণ"), // 94
  SurahBengaliData(name: "আত-তীন", meaning: "ডুমুর"), // 95
  SurahBengaliData(name: "আল-'আলাক", meaning: "রক্তপিন্ড"), // 96
  SurahBengaliData(name: "আল-কদর", meaning: "মহিমান্বিত"), // 97
  SurahBengaliData(name: "আল-বাইয়িনাহ", meaning: " সুস্পষ্ট প্রমাণ"), // 98
  SurahBengaliData(name: "আয-যিলযাল", meaning: "ভূমিকম্প"), // 99
  SurahBengaliData(name: "আল-'আদিয়াত", meaning: "অভিযানকারী অশ্ব"), // 100
  SurahBengaliData(name: "আল-কারি'আহ", meaning: "মহাপ্রলয়"), // 101
  SurahBengaliData(
      name: "আত-তাকাসুর", meaning: "প্রাচুর্যের প্রতিযোগিতা"), // 102
  SurahBengaliData(name: "আল-'আসর", meaning: "সময়"), // 103
  SurahBengaliData(name: "আল-হুমাযাহ", meaning: "পরনিন্দাকারী"), // 104
  SurahBengaliData(name: "আল-ফীল", meaning: "হাতি"), // 105
  SurahBengaliData(name: "কুরাইশ", meaning: "কুরাইশ (একটি গোত্র)"), // 106
  SurahBengaliData(name: "আল-মা'ঊন", meaning: "নিত্য ব্যবহার্য সামগ্রী"), // 107
  SurahBengaliData(name: "আল-কাওসার", meaning: "প্রাচুর্য"), // 108
  SurahBengaliData(name: "আল-কাফিরূন", meaning: "অবিশ্বাসীগণ"), // 109
  SurahBengaliData(name: "আন-নাসর", meaning: "সাহায্য"), // 110
  SurahBengaliData(name: "লাহাব", meaning: "খেজুর আঁশ"), // 111
  SurahBengaliData(name: "আল-ইখলাস", meaning: "একনিষ্ঠতা"), // 112
  SurahBengaliData(name: "আল-ফালাক", meaning: "নিশিভোর"), // 113
  SurahBengaliData(name: "আন-নাস", meaning: "মানবজাতি"), // 114
];
