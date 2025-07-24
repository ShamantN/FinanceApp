// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revesion/models/document_model.dart';

class DocumentType {
  final String englishName;
  final String kannadaName;
  final IconData icon;
  final Color color;

  DocumentType({
    required this.englishName,
    required this.kannadaName,
    required this.icon,
    required this.color,
  });
}

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  late Box<DocumentModel> documentBox;
  bool isLoading = true;
  String? errorMessage;

  final List<DocumentType> documentTypes = [
    DocumentType(
      englishName: 'Aadhaar Card',
      kannadaName: 'ಆಧಾರ್ ಕಾರ್ಡ್',
      icon: Icons.credit_card,
      color: Colors.blue.shade700,
    ),
    DocumentType(
      englishName: 'PAN Card',
      kannadaName: 'ಪ್ಯಾನ್ ಕಾರ್ಡ್',
      icon: Icons.account_balance_wallet,
      color: Colors.green.shade700,
    ),
    DocumentType(
      englishName: 'Voter ID',
      kannadaName: 'ಮತದಾರ ಗುರುತಿನ ಚೀಟಿ',
      icon: Icons.how_to_vote,
      color: Colors.purple.shade700,
    ),
    DocumentType(
      englishName: 'Income Certificate',
      kannadaName: 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ',
      icon: Icons.receipt_long,
      color: Colors.orange.shade700,
    ),
    DocumentType(
      englishName: 'Caste Certificate',
      kannadaName: 'ಜಾತಿ ಪ್ರಮಾಣಪತ್ರ',
      icon: Icons.verified_user,
      color: Colors.teal.shade700,
    ),
    DocumentType(
      englishName: 'Bank Passbook',
      kannadaName: 'ಬ್ಯಾಂಕ್ ಪಾಸ್ಬುಕ್',
      icon: Icons.account_balance,
      color: Colors.indigo.shade700,
    ),
    DocumentType(
      englishName: 'Life Insurance',
      kannadaName: 'ಜೀವ ವಿಮೆ',
      icon: Icons.security,
      color: Colors.red.shade700,
    ),
    DocumentType(
      englishName: 'Vehicle Insurance',
      kannadaName: 'ವಾಹನ ವಿಮೆ',
      icon: Icons.directions_car,
      color: Colors.brown.shade700,
    ),
    DocumentType(
      englishName: 'Health Insurance',
      kannadaName: 'ಆರೋಗ್ಯ ವಿಮೆ',
      icon: Icons.local_hospital,
      color: Colors.pink.shade700,
    ),
    DocumentType(
      englishName: 'Ration Card',
      kannadaName: 'ರೇಷನ್ ಕಾರ್ಡ್',
      icon: Icons.food_bank,
      color: Colors.amber.shade700,
    ),
    DocumentType(
      englishName: 'Driving License',
      kannadaName: 'ಚಾಲನಾ ಪರವಾನಗಿ',
      icon: Icons.drive_eta,
      color: Colors.cyan.shade700,
    ),
    DocumentType(
      englishName: 'Other Document',
      kannadaName: 'ಇತರ ದಾಖಲೆ',
      icon: Icons.description,
      color: Colors.grey.shade700,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      documentBox =
          await HiveFunctions.openBox<DocumentModel>(docBoxWithUid(uid));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error opening document box: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage!,
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _addDocument() async {
    // First, let user select document type
    final selectedType = await showDialog<DocumentType>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'ದಾಖಲೆಯ ಪ್ರಕಾರ ಆಯ್ಕೆ ಮಾಡಿ\nSelect Document Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: documentTypes.length,
            itemBuilder: (context, index) {
              final type = documentTypes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(type.icon, color: type.color, size: 24),
                  ),
                  title: Text(
                    type.kannadaName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    type.englishName,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => Navigator.pop(context, type),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ರದ್ದು / Cancel', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );

    if (selectedType == null) return;

    // Then, let user pick file
    const typeGroup = XTypeGroup(
      label: 'files',
      extensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) return;

    final pickedFile = File(file.path);
    final titleController = TextEditingController();

    // Pre-fill with document type name
    titleController.text = selectedType.kannadaName;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedType.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(selectedType.icon, color: selectedType.color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ದಾಖಲೆ ಸೇರಿಸಿ', style: TextStyle(fontSize: 16)),
                  Text(
                    selectedType.kannadaName,
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedType.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ದಾಖಲೆಯ ಹೆಸರು (ಬದಲಾಯಿಸಬಹುದು)\nDocument name (can be changed):',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: selectedType.color.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: selectedType.color, width: 2),
                ),
                prefixIcon: Icon(Icons.edit, color: selectedType.color),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedType.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selectedType.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.attachment, color: selectedType.color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ಆಯ್ಕೆ ಮಾಡಿದ ಫೈಲ್ / Selected File:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          pickedFile.path.split('/').last,
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedType.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ರದ್ದು / Cancel', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedType.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('ಉಳಿಸಿ / Save',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true || titleController.text.trim().isEmpty) return;

    try {
      final title = titleController.text.trim();
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = pickedFile.path.split('.').last;
      final newFilePath =
          '${appDir.path}/${timestamp}_${title.replaceAll(' ', '_')}.$extension';
      await pickedFile.copy(newFilePath);

      // Store document with type information
      final newDoc = DocumentModel(
        title: title,
        path: newFilePath,
      );
      await documentBox.add(newDoc);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${selectedType.kannadaName} ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ!\n${selectedType.englishName} added successfully!',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: selectedType.color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ತಪ್ಪು ಸಂಭವಿಸಿದೆ / Error: $e',
              style: const TextStyle(fontSize: 16)),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deleteDocument(int index) async {
    final doc = documentBox.getAt(index);
    if (doc == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade700, size: 28),
            const SizedBox(width: 12),
            const Text(
              'ದಾಖಲೆ ಅಳಿಸಿ / Delete Document',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'ನೀವು "${doc.title}" ಅಳಿಸಲು ಖಚಿತವಾಗಿದ್ದೀರಾ?\n\nAre you sure you want to delete "${doc.title}"?\n\nಇದನ್ನು ಮರಳಿ ತರಲು ಸಾಧ್ಯವಿಲ್ಲ / This cannot be undone.',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ರದ್ದು / Cancel', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('ಅಳಿಸಿ / Delete',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final file = File(doc.path);
      if (await file.exists()) await file.delete();
      await documentBox.deleteAt(index);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ದಾಖಲೆ ಅಳಿಸಲಾಗಿದೆ / Document "${doc.title}" deleted',
              style: const TextStyle(fontSize: 16)),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ತಪ್ಪು ಸಂಭವಿಸಿದೆ / Error: $e',
              style: const TextStyle(fontSize: 16)),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openDocument(String path) {
    OpenFile.open(path);
  }

  DocumentType _getDocumentTypeFromTitle(String title) {
    final lowerTitle = title.toLowerCase();
    for (final type in documentTypes) {
      if (lowerTitle.contains(type.englishName.toLowerCase()) ||
          lowerTitle.contains(type.kannadaName)) {
        return type;
      }
    }
    return documentTypes.last; // Return "Other Document" as default
  }

  String _getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red.shade700, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _initializeHive();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: const CustomNavBar(navIndex: 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "ನನ್ನ ದಾಖಲೆಗಳು / My Documents",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: documentBox.listenable(),
        builder: (context, Box<DocumentModel> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 100,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "ಇನ್ನೂ ಯಾವುದೇ ದಾಖಲೆಗಳಿಲ್ಲ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "No documents uploaded yet",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.orange.shade200, width: 2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.folder, color: Colors.orange.shade700, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      "ಒಟ್ಟು ${box.length} ದಾಖಲೆ${box.length == 1 ? '' : 'ಗಳು'} / Total ${box.length} Document${box.length == 1 ? '' : 's'}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final doc = box.getAt(index);
                    if (doc == null) return const SizedBox.shrink();

                    final docType = _getDocumentTypeFromTitle(doc.title);
                    final extension = _getFileExtension(doc.path);

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _openDocument(doc.path),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: docType.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  docType.icon,
                                  color: docType.color,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      docType.englishName,
                                      style: TextStyle(
                                        color: docType.color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                docType.color.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            extension.toUpperCase(),
                                            style: TextStyle(
                                              color: docType.color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.touch_app,
                                            color: Colors.grey.shade500,
                                            size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'ತೆರೆಯಲು ಒತ್ತಿ / Tap to open',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteDocument(index),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade700,
                                  size: 24,
                                ),
                                tooltip: 'ಅಳಿಸಿ / Delete',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDocument,
        label: const Text(
          "ದಾಖಲೆ ಸೇರಿಸಿ / Add Document",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        icon: const Icon(Icons.add, size: 24),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }
}
