import 'package:flutter/material.dart';
import 'package:procdev/features/account/screens/profile_viewmodel.dart';
import 'package:provider/provider.dart';
// Adjust the import path to where your viewmodel is located

class AccountScreenDetail extends StatefulWidget {
  const AccountScreenDetail({super.key});

  @override
  State<AccountScreenDetail> createState() => _AccountScreenDetailState();
}

class _AccountScreenDetailState extends State<AccountScreenDetail> {
  // We create an instance of our ViewModel.
  // The State object will manage its lifecycle.
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Initialize the ViewModel when the screen is first created.
    // The ViewModel's constructor handles loading data and setting up controllers.
    _viewModel = ProfileViewModel();
  }

  @override
  void dispose() {
    // It's crucial to dispose of the ViewModel to clean up its resources,
    // especially the TextEditingControllers.
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We provide the ViewModel to the widget tree so descendant widgets
    // (like our UI) can access it.
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            // Example: Using Get for navigation if you prefer
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Personal Data',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {
                // Handle more options action
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.pink,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 12),
              // We use a Consumer here so that if the name changes
              // via the ViewModel, this Text widget would automatically update.
              Consumer<ProfileViewModel>(
                builder: (context, vm, child) {
                  return Text(
                    vm.userProfile?.fullName ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Form Fields
              _buildTextField(
                label: 'Full name',
                controller: _viewModel.nameController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Gender',
                controller: _viewModel.genderController,
              ),
              const SizedBox(height: 16),

              // Special case for Date of Birth field
              _buildDateField(context, _viewModel),

              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                controller: _viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _viewModel.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        // You can add your BottomNavigationBar here if this is a main screen
        // bottomNavigationBar: ...
      ),
    );
  }

  // Helper widget for standard text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Helper widget specifically for the date field to make it tappable
  Widget _buildDateField(BuildContext context, ProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of birth',
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.dobController,
          readOnly: true, // Makes the field not editable by keyboard
          onTap: () {
            // This calls the logic in our ViewModel to show the date picker.
            viewModel.pickDate(context);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}
