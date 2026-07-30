import 'package:flutter/material.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Start', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F0F23),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark)
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) {
    final items = [
      ('🧘', 'تمارين التنفس', const BreathingSection()),
      ('😊', 'مزاجي', const MoodSection()),
      ('🎵', 'أصوات', const SoundSection()),
      ('📝', 'مذكرات', const JournalSection()),
      ('🔥', 'الاستمرارية', const StreakSection()),
      ('📚', 'دورات', const CoursesSection()),
      ('🧪', 'اختبارات', const TestsSection()),
    ];
    return Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height:20), const Text('Start',style: TextStyle(fontSize:32,fontWeight:FontWeight.bold,color: Colors.white)),
        const SizedBox(height:8), Text('رحلة التأمل والتنفس',style: TextStyle(fontSize:16,color:Colors.white70)),
        const SizedBox(height:32),
        Expanded(child: GridView.count(crossAxisCount:2, childAspectRatio:1, children: List.generate(7,(i)=>GestureDetector(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>items[i].$3)),
          child: Container(margin:const EdgeInsets.all(6), decoration:BoxDecoration(color:Colors.white.withOpacity(0.05), borderRadius:BorderRadius.circular(20)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(items[i].$1,style:const TextStyle(fontSize:36)),
              const SizedBox(height:8), Text(items[i].$2,style:const TextStyle(color:Colors.white,fontSize:14)),
            ]))))),
      ]))));
  }
}

class BreathingSection extends StatelessWidget {
  const BreathingSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('تمارين التنفس')), body:Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
    const Text('🧘',style:TextStyle(fontSize:72)), const SizedBox(height:20),
    const Text('تنفس 4-7-8\nشهيق 4 ثوان - احتباس 7 - زفير 8',textAlign:TextAlign.center,style:TextStyle(fontSize:18,color:Colors.white70)),
    const SizedBox(height:30),
    ElevatedButton(onPressed:(){}, child:const Text('ابدأ التمرين'))
  ])));
}

class MoodSection extends StatelessWidget {
  const MoodSection({super.key});
  final _moods = ['😊سعيد','😐محايد','😢حزين','😡غاضب','😰قلق','😌هادئ','🥱متعب','🤩متحمس','😔مكتئب','🤗ممتن'];
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('مزاجي')), body: Padding(padding:const EdgeInsets.all(20), child: Column(children:[
    const Text('كيف تشعر الآن؟',style:TextStyle(fontSize:22,color:Colors.white)), const SizedBox(height:20),
    Expanded(child: ListView.separated(itemCount:_moods.length,separatorBuilder:(_,__)=>const SizedBox(height:8),
      itemBuilder:(_,i)=>ListTile(title:Text(_moods[i],style:const TextStyle(fontSize:18)), tileColor:Colors.white.withOpacity(0.05),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)))))
  ])));
}

class SoundSection extends StatelessWidget {
  const SoundSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('أصوات')), body:Center(child:Text('قائمة الأصوات قريباً',style:TextStyle(fontSize:18,color:Colors.white70))));
}

class JournalSection extends StatelessWidget {
  const JournalSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('مذكرات')), body:Center(child:Text('صفحة المذكرات قريباً',style:TextStyle(fontSize:18,color:Colors.white70))));
}

class StreakSection extends StatelessWidget {
  const StreakSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('الاستمرارية')), body:Center(child:Text('عداد الاستمرارية قريباً',style:TextStyle(fontSize:18,color:Colors.white70))));
}

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('دورات')), body:Center(child:Text('الدورات قريباً',style:TextStyle(fontSize:18,color:Colors.white70))));
}

class TestsSection extends StatelessWidget {
  const TestsSection({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('اختبارات')), body:Center(child:Text('الاختبارات قريباً',style:TextStyle(fontSize:18,color:Colors.white70))));
}
