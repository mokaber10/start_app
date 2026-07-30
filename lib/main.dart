import 'package:flutter/material.dart';
import 'views/mood/mood_tracker_view.dart';
import 'views/soundscapes/soundscapes_view.dart';
import 'views/journal/journal_view.dart';
import 'views/streak/streak_view.dart';
import 'views/courses/courses_view.dart';
import 'views/tests/tests_view.dart';
void main() => runApp(const StartApp());
class StartApp extends StatelessWidget {
  const StartApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(title: 'Start', debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor:const Color(0xFF0F0F23), colorScheme: ColorScheme.fromSeed(seedColor:const Color(0xFF6C63FF), brightness: Brightness.dark)), home: const HomeScreen());
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) {
    final im=['🧘','😊','🎵','📝','🔥','📚','🧪'];
    final il=['تمارين التنفس','مزاجي','أصوات','مذكرات','الاستمرارية','دورات','اختبارات'];
    final p=[null,const MoodTrackerScreen(),const SoundscapesScreen(),const JournalScreen(),const StreakScreen(),const CoursesScreen(),const TestsScreen()];
    return Scaffold(body: SafeArea(child: Padding(padding:const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height:20), const Text('Start',style:TextStyle(fontSize:32,fontWeight:FontWeight.bold,color:Colors.white)),
      const SizedBox(height:8), Text('رحلة التأمل والتنفس',style:TextStyle(fontSize:16,color:Colors.white70)),
      const SizedBox(height:32),
      Expanded(child: GridView.count(crossAxisCount:2, childAspectRatio:1, children: List.generate(7,(i)=>GestureDetector(onTap:()=>i>0?Navigator.push(context,MaterialPageRoute(builder:(_)=>p[i]!)):null, child: Container(margin:const EdgeInsets.all(6), decoration:BoxDecoration(color:Colors.white.withOpacity(0.05), borderRadius:BorderRadius.circular(20)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(im[i],style:const TextStyle(fontSize:36)), const SizedBox(height:8), Text(il[i],style:const TextStyle(color:Colors.white,fontSize:14)) ])))))) ]))));
  }
}