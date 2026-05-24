import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/company_verification_service.dart';
import 'package:video_player/video_player.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  late VideoPlayerController _symbolController;

  bool isVerifyingCompany = false;
  bool isCompanyVerified = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  CompanyVerificationResult? verificationResult;

  final businessIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();




  @override
  void initState() {
    super.initState();

    _symbolController = VideoPlayerController.asset(
      'assets/videos/circular_symbol.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
        _symbolController.play();
        _symbolController.setLooping(true);
        _symbolController.setVolume(0);
      });
  }

  @override
  void dispose() {
    businessIdController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    _symbolController.dispose();
    super.dispose();
  }

  Future<void> _verifyCompany() async {
    final nationalNumber = businessIdController.text.trim();

    if (nationalNumber.isEmpty) {
      _showMessage('Please enter the organization national number');
      return;
    }

    setState(() {
      isVerifyingCompany = true;
      isCompanyVerified = false;
      verificationResult = null;
    });

    try {
      final result =
      await CompanyVerificationService.verifyCompany(nationalNumber);

      setState(() {
        verificationResult = result;
        isCompanyVerified = result.verified;
        isVerifyingCompany = false;
      });

      if (result.verified) {
        _showMessage('Company verified successfully');
      } else {
        _showMessage(result.message ?? 'Company not found');
      }
    } catch (e) {
      setState(() {
        isVerifyingCompany = false;
      });

      _showMessage('Could not connect to verification service');
    }
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;

    if (!isCompanyVerified) {
      _showMessage('Please verify your organization first');
      return;
    }

    _showMessage('Account created successfully');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildLogo(),

                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      color: AppColors.charcoal,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _buildVerificationInput(),

                const SizedBox(height: 18),

                if (verificationResult != null && verificationResult!.verified)
                  _buildVerifiedCard(),

                if (verificationResult != null && !verificationResult!.verified)
                  _buildFailedCard(),

                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'USER DETAILS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.charcoal,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildRoundedField(
                  controller: fullNameController,
                  label: 'Your Full Name',
                  icon: Icons.person_rounded,
                  validatorMessage: 'Full name is required',
                ),

                const SizedBox(height: 16),

                _buildRoundedField(
                  controller: phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  prefixText: '🇯🇴  ',
                  validatorMessage: 'Phone number is required',
                ),

                const SizedBox(height: 16),

                _buildRoundedField(
                  controller: emailController,
                  label: 'Email Address',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validatorMessage: 'Email is required',
                  customValidator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildPasswordField(
                        controller: passwordController,
                        label: 'CREATE PASSWORD',
                        isHidden: hidePassword,
                        onToggle: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPasswordField(
                        controller: confirmPasswordController,
                        label: 'Confirm PASSWORD',
                        isHidden: hideConfirmPassword,
                        onToggle: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                        isConfirm: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 34),

                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      elevation: 14,
                      shadowColor: AppColors.primaryGreen.withOpacity(0.40),
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Existing user?',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.charcoal,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.deepTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: _symbolController.value.isInitialized
                ? ClipOval(
              child: VideoPlayer(_symbolController),
            )
                : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withOpacity(0.10),
              ),
              child: Icon(
                Icons.recycling_rounded,
                color: AppColors.deepTeal,
                size: 38,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Circular ',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.charcoal,
                        letterSpacing: -1.0,
                      ),
                    ),
                    TextSpan(
                      text: 'JO',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brightTeal,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'RECOVER • REDISTRIBUTE • REGENERATE',
                style: TextStyle(
                  fontSize: 8.5,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'JORDAN • IMPACT • FUTURE',
                style: TextStyle(
                  fontSize: 8.5,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationInput() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2EE),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 12,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Text(
            '#',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: TextFormField(
              controller: businessIdController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Organization number is required';
                }
                return null;
              },
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.charcoal,
                letterSpacing: 1.1,
              ),
              decoration: InputDecoration(
                labelText: 'Organization National Number',
                labelStyle: TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isVerifyingCompany ? null : _verifyCompany,
                icon: isVerifyingCompany
                    ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.deepTeal,
                  ),
                )
                    : Icon(
                  Icons.search_rounded,
                  color: AppColors.deepTeal,
                  size: 26,
                ),
                label: Text(
                  isVerifyingCompany ? 'Wait' : 'Verify',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.charcoal,
                    letterSpacing: 1.4,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: AppColors.deepTeal.withOpacity(0.25),
                  backgroundColor: const Color(0xFFE9EFEB),
                  foregroundColor: AppColors.charcoal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.freshGreen.withOpacity(0.28),
            AppColors.freshGreen.withOpacity(0.10),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.freshGreen.withOpacity(0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.freshGreen.withOpacity(0.28),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.freshGreen,
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Verified',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                _verifiedLine(
                  'Registered Organization',
                  verificationResult!.companyName ?? '-',
                ),
                _verifiedLine(
                  'Type',
                  verificationResult!.type ?? '-',
                ),
                _verifiedLine(
                  'Status',
                  verificationResult!.status ?? '-',
                ),
                const SizedBox(height: 16),
                Text(
                  verificationResult!.source ??
                      'Verified through the Jordan Company Registry',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.charcoal.withOpacity(0.80),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_rounded,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              verificationResult!.message ??
                  'Company not found. Please check the number.',
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verifiedLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15.5,
            color: AppColors.charcoal,
            height: 1.25,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? validatorMessage,
    String? Function(String?)? customValidator,
  }) {
    return Container(
      height: 66,
      decoration: _softFieldDecoration(),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: customValidator ??
                (value) {
              if (value == null || value.trim().isEmpty) {
                return validatorMessage ?? '$label is required';
              }
              return null;
            },
        style: TextStyle(
          fontSize: 20,
          color: AppColors.charcoal,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.charcoal.withOpacity(0.85),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.deepTeal,
            size: 26,
          ),
          prefixText: prefixText,
          prefixStyle: const TextStyle(
            fontSize: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 11, right: 18),
          errorStyle: const TextStyle(height: 0),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isHidden,
    required VoidCallback onToggle,
    bool isConfirm = false,
  }) {
    return Container(
      height: 66,
      decoration: _softFieldDecoration(),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (!isConfirm && value.length < 6) {
            return 'Min 6';
          }
          if (isConfirm && value != passwordController.text) {
            return 'No match';
          }
          return null;
        },
        style: TextStyle(
          fontSize: 18,
          color: AppColors.charcoal,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.charcoal.withOpacity(0.80),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: Icon(
            Icons.lock_rounded,
            color: AppColors.deepTeal,
            size: 25,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              isHidden
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.black45,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 11),
          errorStyle: const TextStyle(height: 0),
        ),
      ),
    );
  }

  BoxDecoration _softFieldDecoration() {
    return BoxDecoration(
      color: const Color(0xFFEFF2EE),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(
        color: Colors.white.withOpacity(0.85),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.13),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.95),
          blurRadius: 12,
          offset: const Offset(-4, -4),
        ),
      ],
    );
  }
}