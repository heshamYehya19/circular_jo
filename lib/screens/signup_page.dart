
import 'home_screen.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../constants/app_colors.dart';
import '../services/company_verification_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final VideoPlayerController _symbolController;

  bool isVerifyingCompany = false;
  bool isCompanyVerified = false;
  bool isCreatingAccount = false;
  bool accountCreated = false;
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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _symbolController = VideoPlayerController.asset(
      'assets/videos/circular_symbol.mp4',
    )
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _symbolController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _symbolController.dispose();

    businessIdController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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

      if (!mounted) return;

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
      if (!mounted) return;

      setState(() {
        isVerifyingCompany = false;
      });

      _showMessage('Could not connect to verification service');
    }
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isCompanyVerified) {
      _showMessage('Please verify your organization first');
      return;
    }

    setState(() {
      isCreatingAccount = true;
      accountCreated = false;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      isCreatingAccount = false;
      accountCreated = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );

    // Later:
    // 1. Create account using Firebase Authentication.
    // 2. Save user info + verified company info in Firestore.
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
      backgroundColor: AppColors.softBackground,
      body: Stack(
        children: [
          _AnimatedBlob(
            controller: _pulseController,
            top: -90,
            left: -90,
            color: AppColors.primaryGreen,
          ),
          _AnimatedBlob(
            controller: _floatController,
            bottom: -110,
            right: -100,
            color: AppColors.deepTeal,
          ),
          const _LeafLayer(),
          Column(
            children: [
              _buildTopHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroTitle(),
                        const SizedBox(height: 24),
                        _buildOrganizationVerificationCard(),
                        const SizedBox(height: 24),
                        _buildUserDetailsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildFooterButton(),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24,
            right: 24,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.softBackground.withOpacity(0.82),
            border: Border(
              bottom: BorderSide(
                color: AppColors.mintBorder.withOpacity(0.55),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 54,
                height: 54,
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
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Circular ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.charcoal,
                              letterSpacing: -0.8,
                            ),
                          ),
                          TextSpan(
                            text: 'JO',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brightTeal,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'RECOVER • REDISTRIBUTE • REGENERATE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                        color: AppColors.deepTeal,
                      ),
                    ),
                    Text(
                      'JORDAN • IMPACT • FUTURE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.45,
                        color: AppColors.freshGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w900,
              color: AppColors.charcoal,
              letterSpacing: -0.9,
            ),
            children: [
              const TextSpan(text: 'Create Account'),
              TextSpan(
                text: '.',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Verify your organization using its company national number, then create your user account.',
          style: TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: AppColors.charcoal.withOpacity(0.62),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationVerificationCard() {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            title: 'ORGANIZATION VERIFICATION',
            icon: Icons.corporate_fare_rounded,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('ORGANIZATION NATIONAL NUMBER'),
          const SizedBox(height: 6),
          _buildVerificationInput(),
          if (verificationResult != null && verificationResult!.verified) ...[
            const SizedBox(height: 14),
            _SuccessCard(result: verificationResult!),
          ],
          if (verificationResult != null && !verificationResult!.verified) ...[
            const SizedBox(height: 14),
            _FailedCard(
              message: verificationResult!.message ??
                  'Company not found. Please check the number.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerificationInput() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.74),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompanyVerified ? AppColors.freshGreen : AppColors.mintBorder,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Icon(
                Icons.tag_rounded,
                color: isCompanyVerified
                    ? AppColors.freshGreen
                    : AppColors.primaryGreen,
                size: 20,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: businessIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Organization number is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'e.g. 100200300',
                  hintStyle: TextStyle(
                    color: AppColors.charcoal.withOpacity(0.25),
                  ),
                  border: InputBorder.none,
                  errorStyle: const TextStyle(height: 0),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: isVerifyingCompany ? null : _verifyCompany,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                color: isCompanyVerified
                    ? AppColors.freshGreen
                    : AppColors.primaryGreen,
                child: isVerifyingCompany
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : isCompanyVerified
                    ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                )
                    : const Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'USER DETAILS',
          icon: Icons.person_add_alt_1_rounded,
        ),
        const SizedBox(height: 12),
        _InteractiveFormField(
          label: 'YOUR FULL NAME',
          placeholder: 'Your name',
          icon: Icons.person_rounded,
          controller: fullNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _InteractiveFormField(
          label: 'PHONE NUMBER',
          placeholder: '+962 7X XXX XXXX',
          icon: Icons.phone_iphone_rounded,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _InteractiveFormField(
          label: 'EMAIL ADDRESS',
          placeholder: 'name@organization.jo',
          icon: Icons.alternate_email_rounded,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@')) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _InteractivePasswordField(
          label: 'CREATE PASSWORD',
          icon: Icons.lock_rounded,
          controller: passwordController,
          visible: !hidePassword,
          onToggle: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _InteractivePasswordField(
          label: 'CONFIRM PASSWORD',
          icon: Icons.verified_user_rounded,
          controller: confirmPasswordController,
          visible: !hideConfirmPassword,
          onToggle: () {
            setState(() {
              hideConfirmPassword = !hideConfirmPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _sectionHeader({
    required String title,
    required IconData icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGreen,
            letterSpacing: 1.5,
          ),
        ),
        Icon(
          icon,
          color: AppColors.primaryGreen.withOpacity(0.45),
        ),
      ],
    );
  }

  Widget _buildFooterButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.72),
              border: Border(
                top: BorderSide(
                  color: AppColors.mintBorder.withOpacity(0.38),
                ),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: isCreatingAccount ? null : _createAccount,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: accountCreated
                          ? AppColors.freshGreen
                          : AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.34),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCreatingAccount)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        else ...[
                          Text(
                            accountCreated ? 'Welcome!' : 'Create Account',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            accountCreated
                                ? Icons.celebration_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.charcoal.withOpacity(0.45),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                    children: [
                      const TextSpan(text: 'ALREADY HAVE AN ACCOUNT?  '),
                      TextSpan(
                        text: 'LOG IN',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.mintBorder.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.06),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: AppColors.deepTeal,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SuccessCard extends StatefulWidget {
  final CompanyVerificationResult result;

  const _SuccessCard({required this.result});

  @override
  State<_SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<_SuccessCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.055),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.22),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.result.companyName ?? 'Company Verified',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TYPE: ${(widget.result.type ?? '-').toUpperCase()}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepTeal.withOpacity(0.72),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const _PulsingDot(),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${widget.result.status ?? 'Active'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.freshGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.result.source ??
                        'Verified through the Jordan Company Registry',
                    style: TextStyle(
                      fontSize: 9,
                      fontStyle: FontStyle.italic,
                      color: AppColors.charcoal.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailedCard extends StatelessWidget {
  final String message;

  const _FailedCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.45),
        ),
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
              message,
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
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.freshGreen.withOpacity(
              0.45 + _controller.value * 0.55,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _InteractiveFormField extends StatefulWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _InteractiveFormField({
    required this.label,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<_InteractiveFormField> createState() => _InteractiveFormFieldState();
}

class _InteractiveFormFieldState extends State<_InteractiveFormField> {
  bool focused = false;
  bool showCheck = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          transform: focused
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused ? AppColors.primaryGreen : AppColors.mintBorder,
              width: 2,
            ),
            boxShadow: focused
                ? [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.10),
                blurRadius: 16,
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Icon(
                  widget.icon,
                  color: focused
                      ? AppColors.primaryGreen
                      : AppColors.primaryGreen.withOpacity(0.36),
                  size: 20,
                ),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (value) {
                    setState(() {
                      focused = value;
                    });
                  },
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    validator: widget.validator,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(
                        color: AppColors.charcoal.withOpacity(0.22),
                      ),
                      border: InputBorder.none,
                      errorStyle: const TextStyle(height: 0),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      final shouldShow = value.trim().length > 3;
                      if (shouldShow != showCheck) {
                        setState(() {
                          showCheck = shouldShow;
                        });
                      }
                    },
                  ),
                ),
              ),
              if (showCheck)
                const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.freshGreen,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InteractivePasswordField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _InteractivePasswordField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.visible,
    required this.onToggle,
    this.validator,
  });

  @override
  State<_InteractivePasswordField> createState() =>
      _InteractivePasswordFieldState();
}

class _InteractivePasswordFieldState extends State<_InteractivePasswordField> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          transform: focused
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused ? AppColors.primaryGreen : AppColors.mintBorder,
              width: 2,
            ),
            boxShadow: focused
                ? [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.10),
                blurRadius: 16,
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Icon(
                  widget.icon,
                  color: focused
                      ? AppColors.primaryGreen
                      : AppColors.primaryGreen.withOpacity(0.36),
                  size: 20,
                ),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (value) {
                    setState(() {
                      focused = value;
                    });
                  },
                  child: TextFormField(
                    controller: widget.controller,
                    obscureText: !widget.visible,
                    validator: widget.validator,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        color: AppColors.charcoal.withOpacity(0.22),
                      ),
                      border: InputBorder.none,
                      errorStyle: const TextStyle(height: 0),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onToggle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      widget.visible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      key: ValueKey(widget.visible),
                      color: AppColors.primaryGreen.withOpacity(0.45),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;

  const _AnimatedBlob({
    required this.controller,
    required this.color,
    this.top,
    this.left,
    this.bottom,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Opacity(
            opacity: 0.22 + controller.value * 0.12,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.34),
                    color.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LeafLayer extends StatefulWidget {
  const _LeafLayer();

  @override
  State<_LeafLayer> createState() => _LeafLayerState();
}

class _LeafLayerState extends State<_LeafLayer> with TickerProviderStateMixin {
  late final List<_LeafData> leaves;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    leaves = List.generate(
      13,
          (_) => _LeafData(
        left: random.nextDouble(),
        size: 10 + random.nextDouble() * 18,
        duration: 6 + random.nextDouble() * 8,
        icon: [Icons.eco_rounded, Icons.spa_rounded, Icons.energy_savings_leaf][
        random.nextInt(3)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: leaves
            .map(
              (leaf) => _FallingLeaf(
            data: leaf,
          ),
        )
            .toList(),
      ),
    );
  }
}

class _LeafData {
  final double left;
  final double size;
  final double duration;
  final IconData icon;

  const _LeafData({
    required this.left,
    required this.size,
    required this.duration,
    required this.icon,
  });
}

class _FallingLeaf extends StatefulWidget {
  final _LeafData data;

  const _FallingLeaf({
    required this.data,
  });

  @override
  State<_FallingLeaf> createState() => _FallingLeafState();
}

class _FallingLeafState extends State<_FallingLeaf>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.data.duration * 1000).toInt(),
      ),
    )..repeat();

    position = Tween<double>(begin: -0.1, end: 1.12).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final top = position.value * screenHeight;

        double opacity = 0.45;
        if (position.value < 0.15) {
          opacity = position.value / 0.15 * 0.45;
        } else if (position.value > 0.9) {
          opacity = (1 - position.value) / 0.1 * 0.45;
        }

        return Positioned(
          left: widget.data.left * screenWidth,
          top: top,
          child: Opacity(
            opacity: opacity.clamp(0.0, 0.45),
            child: Transform.rotate(
              angle: controller.value * 2 * pi,
              child: Icon(
                widget.data.icon,
                color: AppColors.primaryGreen.withOpacity(0.14),
                size: widget.data.size,
              ),
            ),
          ),
        );
      },
    );
  }
}