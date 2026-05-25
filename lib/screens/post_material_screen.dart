import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../services/material_analysis_service.dart';

class PostMaterialScreen extends StatefulWidget {
  const PostMaterialScreen({super.key});

  @override
  State<PostMaterialScreen> createState() => _PostMaterialScreenState();
}

class _PostMaterialScreenState extends State<PostMaterialScreen> {
  File? selectedImage;

  bool isAnalyzing = false;
  bool analysisCompleted = false;

  final quantityController = TextEditingController(text: '10');
  final pickupTimeController =
  TextEditingController(text: 'Today before 8:00 PM');

  String materialType = '';
  String condition = '';
  String urgency = '';
  String recoveryPath = '';
  String suggestedReceiver = '';
  String expectedPoints = '';
  String generatedDescription = '';
  String impactEstimate = '';

  @override
  void dispose() {
    quantityController.dispose();
    pickupTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
        expectedPoints = result.expectedPoints;
        generatedDescription = result.generatedDescription;
        impactEstimate = result.impactEstimate;
      });
    } catch (e) {
      setState(() {
        isAnalyzing = false;
      });

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _postListing() {
    if (!analysisCompleted) {
      _showMessage('Please analyze the material before posting');
      return;
    }

    _showMessage('Material listing posted successfully');
    Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: AppColors.softBackground,
        elevation: 0,
        foregroundColor: AppColors.charcoal,
        title: const Text(
          'AI Waste Assistant',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroCard(),
            const SizedBox(height: 22),
            _buildUploadCard(),
            const SizedBox(height: 18),
            _buildDetailsInputs(),
            const SizedBox(height: 18),
            _buildAnalyzeButton(),
            const SizedBox(height: 22),
            if (isAnalyzing) _buildAnalyzingCard(),
            if (analysisCompleted) ...[
              _buildAiResultsCard(),
              const SizedBox(height: 18),
              _buildGeneratedDescriptionCard(),
              const SizedBox(height: 18),
              _buildImpactCard(),
              const SizedBox(height: 24),
              _buildPostButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.deepTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post with AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upload a photo and let AI classify, describe, and estimate impact.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppColors.mintBorder,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 66,
              width: 66,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.add_photo_alternate_rounded,
                color: AppColors.primaryGreen,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Upload Material Photo',
              style: TextStyle(
                color: AppColors.charcoal,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Food surplus, cardboard, plastic, or organic waste',
              style: TextStyle(
                color: AppColors.charcoal.withOpacity(0.55),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                selectedImage!,
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
                    color: Colors.black.withOpacity(0.45),
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

  Widget _buildDetailsInputs() {
    return Row(
      children: [
        Expanded(
          child: _smallInput(
            label: 'Quantity',
            controller: quantityController,
            icon: Icons.scale_rounded,
            suffix: 'kg',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _smallInput(
            label: 'Pickup Time',
            controller: pickupTimeController,
            icon: Icons.schedule_rounded,
          ),
        ),
      ],
    );
  }

  Widget _smallInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mintBorder),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.charcoal,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          prefixIcon: Icon(
            icon,
            color: AppColors.deepTeal,
            size: 22,
          ),
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: AppColors.charcoal.withOpacity(0.55),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isAnalyzing ? null : _analyzeMaterial,
        icon: isAnalyzing
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.auto_awesome_rounded),
        label: Text(
          isAnalyzing ? 'Analyzing Material...' : 'Analyze with AI',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.mintBorder),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryGreen,
            strokeWidth: 3,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'AI is classifying the material, checking condition, and estimating impact...',
              style: TextStyle(
                color: AppColors.charcoal,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiResultsCard() {
    return _whiteCard(
      title: 'AI Classification',
      icon: Icons.psychology_rounded,
      child: Column(
        children: [
          _resultRow('Material Type', materialType),
          _resultRow('Condition', condition),
          _resultRow('Urgency', urgency),
          _resultRow('Recovery Path', recoveryPath),
          _resultRow('Suggested Receiver', suggestedReceiver),
          _resultRow('Expected Points', expectedPoints),
        ],
      ),
    );
  }

  Widget _buildGeneratedDescriptionCard() {
    return _whiteCard(
      title: 'Auto-Generated Listing',
      icon: Icons.description_rounded,
      child: Text(
        generatedDescription,
        style: TextStyle(
          color: AppColors.charcoal.withOpacity(0.78),
          fontSize: 14,
          height: 1.55,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.23),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              impactEstimate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: _postListing,
        icon: const Icon(Icons.publish_rounded),
        label: const Text(
          'Post Listing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 12,
          shadowColor: AppColors.primaryGreen.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _whiteCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.mintBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 38,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.charcoal.withOpacity(0.55),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 62,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.charcoal,
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}