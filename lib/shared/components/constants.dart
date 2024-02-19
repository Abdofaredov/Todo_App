// دي ميثود جاهزه بتبرينت فول تيكست علشان لو تيكست كبير محتاج يتعمله برينت
void printFullText(String text) {
  final pattern = RegExp('.{1.800}'); // 800 is size of   each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

dynamic token = '';
dynamic uId = '';
