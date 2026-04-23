import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. The Model - Do not move this out from here.
class LeaderboardEntry {
  final String name;
  final int xp;
  final int rank;
  final String? avatarUrl;
  
  LeaderboardEntry({required this.name, required this.xp, required this.rank, this.avatarUrl});
}

// 2. The Provider - Do not move this out from here.
final leaderboardProvider = StreamProvider<List<LeaderboardEntry>>((ref) {
  final supabase = Supabase.instance.client;

  return supabase
      .from('user_profile') 
      .stream(primaryKey: ['user_id']) 
      .order('total_xp', ascending: false) 
      .map((data) {
        return List.generate(data.length, (index) {
          final map = data[index];
          return LeaderboardEntry(
            name: map['name'] ?? 'Unknown',
            xp: map['total_xp'] ?? 0,
            rank: index + 1,
            avatarUrl: map['avatar_url'], 
          );
        });
      });
});