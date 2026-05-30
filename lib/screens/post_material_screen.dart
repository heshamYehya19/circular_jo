import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../services/material_analysis_service.dart';

class PostMaterialScreen extends StatefulWidget {
  const PostMaterialScreen({super.key});

  @override
  State<PostMaterialScreen> createState() => _PostMaterialScreenState();
}

class _PostMaterialScreenState extends State<PostMaterialScreen> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => isDark ? const Color(0xFF081A16) : AppColors.softBackground;

  Color get card => isDark ? const Color(0xFF122823) : AppColors.white;

  Color get cardSoft =>
      isDark ? const Color(0xFF0F221E) : AppColors.softBackground;

  Color get text => isDark ? const Color(0xFFEAF6F0) : AppColors.charcoal;

  Color get muted =>
      isDark ? const Color(0xFFA9BDB4) : AppColors.charcoal.withOpacity(0.62);

  Color get border => isDark ? const Color(0xFF24433A) : AppColors.mintBorder;

  File? selectedImage;

  bool isAnalyzing = false;
  bool analysisCompleted = false;
  bool uploadPressed = false;
  bool descriptionFocused = false;

  final quantityController = TextEditingController(text: '10');
  final pickupTimeController = TextEditingController(text: 'Today before 8 PM');
  final descriptionController = TextEditingController();

  String materialType = '';
  String condition = '';
  String urgency = '';
  String recoveryPath = '';
  String suggestedReceiver = '';
  String expectedPoints = '';
  String impactEstimate = '';

  @override
  void dispose() {
    quantityController.dispose();
    pickupTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.mediumImpact();

    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
      analysisCompleted = false;
    });
  }

  Future<void> _analyzeMaterial() async {
    if (selectedImage == null) {
      _showMessage('Please upload a material photo first');
      return;
    }

    setState(() {
      isAnalyzing = true;
      analysisCompleted = false;
    });

    try {
      final result = await MaterialAnalysisService.analyzeMaterial(
        imageFile: selectedImage!,
        quantity: quantityController.text.trim(),
        pickupTime: pickupTimeController.text.trim(),
      );

      setState(() {
        isAnalyzing = false;
        analysisCompleted = true;

        materialType = result.materialType;
        condition = result.condition;
        urgency = result.urgency;
        recoveryPath = result.recoveryPath;
        suggestedReceiver = result.suggestedReceiver;
        expectedPoints = _pointsOnly(result.expectedPoints);
        impactEstimate = result.impactEstimate;

        descriptionController.text = result.generatedDescription;
      });
    } catch (e) {
      final quantity = quantityController.text.trim().isEmpty
          ? '10'
          : quantityController.text.trim();

      setState(() {
        isAnalyzing = false;
        analysisCompleted = true;

        materialType = 'Surplus Food';
        condition = 'Likely edible';
        urgency = 'High';
        recoveryPath = 'Charity donation';
        suggestedReceiver = 'Nearby charities';
        expectedPoints = '80';

        descriptionController.text =
        'Around $quantity kg of surplus food is available for pickup today. '
            'The material appears suitable for donation and should be collected as soon as possible. '
            'Best suited for nearby charities or food recovery organizations.';

        impactEstimate =
        'Estimated impact: $quantity kg diverted from landfill, around 20 meals supported, and 80 verified impact points after pickup confirmation.';
      });

      _showMessage('AI service unavailable. Showing demo analysis.');
    }
  }

  String _pointsOnly(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    return match?.group(0) ?? value;
  }

  void _postListing() {
    if (!analysisCompleted) {
      _showMessage('Please analyze the material before posting');
      return;
    }

    Navigator.pop(context, {
      'posted': true,
      'title': materialType,
      'points': expectedPoints,
    });
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
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _buildUploadSection(),
                    const SizedBox(height: 16),
                    _buildInputGrid(),
                    const SizedBox(height: 16),
                    _buildAnalyzeButton(),
                    const SizedBox(height: 16),
                    if (isAnalyzing) _buildAnalyzingCard(),
                    if (analysisCompleted) ...[
                      _buildAIClassificationSection(),
                      const SizedBox(height: 16),
                      _buildEditableDescription(),
                      const SizedBox(height: 16),
                      _buildImpactEstimate(),
                      const SizedBox(height: 16),
                      _buildPostListingButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          Text(
            'AI Waste Assistant',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          _TopIconButton(
            icon: Icons.auto_awesome_rounded,
            onTap: () => HapticFeedback.lightImpact(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.deepTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            bottom: -45,
            right: -45,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.10),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post with AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Upload a photo and let AI classify, describe, and estimate impact',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTapDown: (_) => setState(() => uploadPressed = true),
      onTapUp: (_) => setState(() => uploadPressed = false),
      onTapCancel: () => setState(() => uploadPressed = false),
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: uploadPressed ? AppColors.primaryGreen : border,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: selectedImage == null
              ? CustomPaint(
            painter: _DashedBorderPainter(
              color: uploadPressed ? AppColors.primaryGreen : border,
              strokeWidth: 2,
              dashLength: 8,
              dashGap: 5,
              radius: 18,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 34,
                horizontal: 24,
              ),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: uploadPressed
                          ? AppColors.primaryGreen.withOpacity(0.10)
                          : cardSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primaryGreen,
                      size: 29,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload Material Photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Food surplus, cardboard, plastic, or organic waste',
                    style: TextStyle(
                      fontSize: 14,
                      color: muted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              : Stack(
            children: [
              Image.file(
                selectedImage!,
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.48),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Tap to change',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputGrid() {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.scale_outlined,
            label: 'Quantity',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 14,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InfoTile(
            icon: Icons.schedule_outlined,
            label: 'Pickup Time',
            child: TextField(
              controller: pickupTimeController,
              style: TextStyle(
                fontSize: 14,
                color: text,
                height: 1.4,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return _PrimaryButton(
      label: isAnalyzing ? 'Analyzing Material...' : 'Analyze with AI',
      icon: Icons.auto_awesome_rounded,
      isLoading: isAnalyzing,
      onTap: isAnalyzing ? () {} : _analyzeMaterial,
    );
  }

  Widget _buildAnalyzingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryGreen,
            strokeWidth: 3,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'AI is classifying the material, checking condition, and estimating impact...',
              style: TextStyle(
                color: text,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIClassificationSection() {
    final rows = [
      _ClassificationRow('Material Type', materialType, isError: false),
      _ClassificationRow('Condition', condition, isError: false),
      _ClassificationRow(
        'Urgency',
        urgency,
        isError: urgency.toLowerCase().contains('high'),
      ),
      _ClassificationRow('Recovery Path', recoveryPath, isError: false),
      _ClassificationRow('Suggested Receiver', suggestedReceiver, isError: false),
    ];

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'AI Classification',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'VERIFIED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rows.map(_buildClassificationRow).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expected Points',
                  style: TextStyle(
                    fontSize: 14,
                    color: muted,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      expectedPoints,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.eco_rounded,
                      color: AppColors.primaryGreen,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationRow(_ClassificationRow row) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.label,
                style: TextStyle(
                  fontSize: 14,
                  color: muted,
                ),
              ),
              Flexible(
                child: Text(
                  row.value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: row.isError ? Colors.redAccent : text,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: border.withOpacity(0.65),
        ),
      ],
    );
  }

  Widget _buildEditableDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EDITABLE LISTING DESCRIPTION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: muted,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              descriptionFocused = hasFocus;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: descriptionFocused ? AppColors.primaryGreen : border,
                width: descriptionFocused ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: descriptionController,
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                color: text,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImpactEstimate() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brightTeal.withOpacity(isDark ? 0.10 : 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brightTeal.withOpacity(isDark ? 0.14 : 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco_rounded,
              color: isDark ? const Color(0xFF9BEFE0) : AppColors.deepTeal,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF9BEFE0) : AppColors.deepTeal,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Estimated impact: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: impactEstimate.replaceFirst('Estimated impact: ', ''),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostListingButton() {
    return _PrimaryButton(
      label: 'Post Listing',
      icon: Icons.publish_rounded,
      extraShadow: true,
      onTap: _postListing,
    );
  }
}

class _TopIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_TopIconButton> createState() => _TopIconButtonState();
}

class _TopIconButtonState extends State<_TopIconButton> {
  bool pressed = false;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get pressedColor => isDark
      ? const Color(0xFF24433A).withOpacity(0.65)
      : AppColors.mintBorder.withOpacity(0.55);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) {
        setState(() => pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: pressed ? pressedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          widget.icon,
          color: AppColors.primaryGreen,
          size: 24,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF122823) : AppColors.white;
    final borderColor = isDark ? const Color(0xFF24433A) : AppColors.mintBorder;
    final mutedTextColor =
    isDark ? const Color(0xFFA9BDB4) : AppColors.charcoal.withOpacity(0.62);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.brightTeal,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: mutedTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool extraShadow;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.extraShadow = false,
    this.isLoading = false,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => pressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
        setState(() => pressed = false);
        widget.onTap();
      },
      onTapCancel:
      widget.isLoading ? null : () => setState(() => pressed = false),
      child: AnimatedScale(
        scale: pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: pressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                if (widget.extraShadow)
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.20),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

class _ClassificationRow {
  final String label;
  final String value;
  final bool isError;

  const _ClassificationRow(
      this.label,
      this.value, {
        required this.isError,
      });
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            strokeWidth / 2,
            strokeWidth / 2,
            size.width - strokeWidth,
            size.height - strokeWidth,
          ),
          Radius.circular(radius),
        ),
      );

    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      double distance = 0;

      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashLength),
          paint,
        );

        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}