import 'package:flutter/material.dart';
import '../../data/riverpod/leaderboard_provider.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardTile({super.key, required this.entry, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    bool isEven = entry.rank % 2 == 0;

    if (entry.rank <= 3) { 
      bgColor = isEven ? const Color(0xFFE8F5E9) : const Color(0xFFC8E6C9); 
    } else if (entry.rank <= 10) { 
      bgColor = isEven ? const Color(0xFFE3F2FD) : const Color(0xFFBBDEFB); 
    } else if (entry.rank >= 33) { // FIXED: Now exactly matches the Danger Zone line!
      bgColor = isEven ? const Color(0xFFFFEBEE) : const Color(0xFFFFCDD2); 
    } else { 
      bgColor = isEven ? Colors.white : Colors.grey.shade100; 
    }

    if (isCurrentUser) bgColor = const Color(0xFFFFF9C4); 

    Widget rankDisplay;
    if (entry.rank == 1) rankDisplay = const Text('🏆', style: TextStyle(fontSize: 18));
    else if (entry.rank == 2) rankDisplay = const Text('🥈', style: TextStyle(fontSize: 18));
    else if (entry.rank == 3) rankDisplay = const Text('🥉', style: TextStyle(fontSize: 18));
    else rankDisplay = Text('${entry.rank}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14));

    String initial = entry.name.trim().isNotEmpty ? entry.name.trim()[0].toUpperCase() : '?';
    String displayName = entry.name.trim().isEmpty ? 'Unknown User' : entry.name;

    return Container(
      color: bgColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: SizedBox(
          width: 70,
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: rankDisplay)),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade200,
                // 1. If avatarUrl is NOT null, show the network image
                // 2. If it is null, show the initial text as a fallback
                backgroundImage: entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty
                    ? NetworkImage(entry.avatarUrl!)
                    : null,
                child: (entry.avatarUrl == null || entry.avatarUrl!.isEmpty)
                    ? Text(initial, style: const TextStyle(fontSize: 14, color: Colors.black87))
                    : null,
              ),
            ],
          ),
        ),
        title: Text(
          displayName, 
          style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500, fontSize: 15, color: Colors.black87)
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 22),
            const SizedBox(width: 4),
            Text('${entry.xp}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}