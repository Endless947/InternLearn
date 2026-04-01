import 'package:flutter/material.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageProfilePage extends StatefulWidget {
  const ManageProfilePage({super.key});

  @override
  State<ManageProfilePage> createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = supabase.auth.currentUser;
    final metadata = user?.userMetadata ?? const <String, dynamic>{};
    final emailName = user?.email?.split('@').first ?? '';

    _nameController = TextEditingController(
      text: (metadata['display_name'] as String?)?.trim().isNotEmpty == true
          ? (metadata['display_name'] as String)
          : emailName,
    );
    _bioController = TextEditingController(
      text: (metadata['bio'] as String?) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final displayName = _nameController.text.trim();
    final bio = _bioController.text.trim();

    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name cannot be empty.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': displayName,
            'bio': bio,
          },
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save profile. Please try again.')),
      );
      logger.e('Profile update failed', error: e);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final namePreview = _nameController.text.trim();
    final initials = namePreview.isEmpty
        ? '?'
        : namePreview
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Update how you appear in the app.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                initials,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Display name',
              hintText: 'Your name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: 'Bio',
              hintText: 'Tell others about yourself',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 3,
            maxLength: 160,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
