import 'package:flutter/material.dart';
import 'package:procdev/features/account/screens/profile_viewmodel.dart';
import 'package:provider/provider.dart';

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
    _viewModel = ProfileViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            // Show a loading spinner while data is being fetched from Firebase
            if (viewModel.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.pink));
            }
            // Show an error if the user profile couldn't be loaded
            if (viewModel.userProfile == null) {
              return const Center(child: Text('Could not load user profile.'));
            }
            final String? photoUrl = viewModel.userProfile?.photoUrl;
            print("Photo URL: $photoUrl");

            // Once loaded, display the main content
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.pink, // A nice background color
                    // Use a NetworkImage if the URL exists, otherwise show a default person icon
                    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
                    child: (photoUrl == null || photoUrl.isEmpty)
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    viewModel.userProfile!.fullName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                      label: 'Full name', controller: viewModel.nameController),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(viewModel),
                  const SizedBox(height: 16),
                  _buildDateField(context, viewModel),
                  const SizedBox(height: 16),
                  _buildTextField(
                      label: 'Email',
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: viewModel.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Helper Widgets for Form Fields ---

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, ProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of birth',
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.dobController,
          readOnly: true,
          onTap: () => viewModel.pickDate(context),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown(ProfileViewModel viewModel) {
    final String? currentGender =
        viewModel.userProfile?.gender.isNotEmpty == true &&
                viewModel.genderOptions.contains(viewModel.userProfile!.gender)
            ? viewModel.userProfile!.gender
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender',
            style: TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentGender,
          hint: const Text('Select your gender'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: viewModel.genderOptions.map((String gender) {
            return DropdownMenuItem<String>(value: gender, child: Text(gender));
          }).toList(),
          onChanged: viewModel.onGenderChanged,
        ),
      ],
    );
  }
}
