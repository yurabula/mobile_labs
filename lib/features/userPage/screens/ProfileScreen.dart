import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/CustomButton.dart';
import 'package:flutter_application_1/features/userPage/widgets/ProfileInfoItem.dart';
import 'package:flutter_application_1/services/AuthService.dart';
import 'package:flutter_application_1/utils/ValidationUtils.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() == true) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        );

        final result = await authService.updateUser(updatedUser);

        if (result && mounted) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.deleteAccount();

      if (result && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
        actions: [
          if (_isEditing)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _loadUserData();
                    });
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: authService.isLoading ? null : _saveChanges,
                  child:
                      authService.isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: _isEditing ? _buildEditingView() : _buildProfileView(user),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(user) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xFFD6EFFF),
          child: Icon(Icons.person, size: 48, color: Color(0xFF009FFD)),
        ),
        const SizedBox(height: 12),
        Text(
          user.name as String,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email as String,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        if (user.phone != null &&
            user.phone is String &&
            (user.phone as String).isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            user.phone! as String,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
        const SizedBox(height: 16),
        const ProfileInfoItem(
          icon: Icons.account_circle,
          title: 'Account',
          subtitle: 'Personal details',
        ),
        const Divider(height: 1),
        const ProfileInfoItem(
          icon: Icons.devices,
          title: 'My Devices',
          subtitle: 'Air conditioners, sensors',
        ),
        const Divider(height: 1),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Edit Profile',
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        CustomButton(text: 'Log Out', onPressed: _logout, isPrimary: false),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Delete Account',
          onPressed: _deleteAccount,
          isPrimary: false,
        ),
        if (Provider.of<AuthService>(context).errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            Provider.of<AuthService>(context).errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildEditingView() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFD6EFFF),
            child: Icon(Icons.person, size: 48, color: Color(0xFF009FFD)),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
            validator: ValidationUtils.validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.email),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.phone),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
            validator: ValidationUtils.validatePhone,
          ),
          const SizedBox(height: 24),
          const Text(
            'Tap save in the top right corner to save changes',
            style: TextStyle(color: Colors.black54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
