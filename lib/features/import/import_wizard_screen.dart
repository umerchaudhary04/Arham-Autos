import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'legacy_import_service.dart';

class ImportWizardScreen extends ConsumerStatefulWidget {
  const ImportWizardScreen({super.key});

  @override
  ConsumerState<ImportWizardScreen> createState() => _ImportWizardScreenState();
}

class _ImportWizardScreenState extends ConsumerState<ImportWizardScreen> {
  int _currentStep = 0;
  String? _selectedFile;
  Map<String, dynamic>? _rawData;
  List<Map<String, dynamic>> _validParts = [];
  List<Map<String, dynamic>> _skippedRecords = [];
  bool _isLoading = false;
  String _errorMsg = '';

  void _extractData() async {
    if (_selectedFile == null) return;
    setState(() => _isLoading = true);
    try {
      final svc = ref.read(legacyImportServiceProvider);
      if (svc == null) throw Exception("Import Service unavailable");

      _rawData = await svc.extractDatabase(_selectedFile!);

      final validationResult = svc.validateAndMap(_rawData!);
      _validParts = List<Map<String, dynamic>>.from(
        validationResult['validParts'],
      );
      _skippedRecords = List<Map<String, dynamic>>.from(
        validationResult['skippedRecords'],
      );

      setState(() {
        _currentStep = 1;
        _errorMsg = '';
      });
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _commitData() async {
    setState(() => _isLoading = true);
    try {
      final svc = ref.read(legacyImportServiceProvider);
      await svc!.commitImport(_validParts, _skippedRecords);
      setState(() {
        _currentStep = 4;
        _errorMsg = '';
      });
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Legacy Import Wizard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (_errorMsg.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Text(_errorMsg, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep == 0) {
                  _extractData();
                } else if (_currentStep == 1) {
                  setState(() => _currentStep = 2);
                } else if (_currentStep == 2) {
                  setState(() => _currentStep = 3);
                } else if (_currentStep == 3) {
                  _commitData();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              steps: [
                Step(
                  title: const Text('1. Select .accdb File'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.folder_open),
                            label: const Text('Browse...'),
                            onPressed: () async {
                              final result = await FilePicker.pickFile(
                                type: FileType.custom,
                                allowedExtensions: ['accdb'],
                              );
                              if (result != null && result.path != null) {
                                setState(() => _selectedFile = result.path!);
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _selectedFile ?? 'No file selected',
                              style: TextStyle(color: _selectedFile == null ? Colors.grey : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('2. Validation & Skipped Records'),
                  content: Column(
                    children: [
                      Text('Valid Parts: ${_validParts.length}'),
                      Text(
                        'Skipped Records: ${_skippedRecords.length}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      // Display skipped list...
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('3. Opening Stock & Costs'),
                  content: Column(
                    children: [
                      const Text(
                        'Manually enter Opening Stock and Unit Costs for legacy items.',
                      ),
                      // Structural Table
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _validParts.length,
                          itemBuilder: (context, index) {
                            final part = _validParts[index];
                            return ListTile(
                              title: Text(part['partName']),
                              trailing: SizedBox(
                                width: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Qty',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) =>
                                            part['openingQuantity'] =
                                                int.tryParse(v) ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Cost',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) => part['openingCost'] =
                                            double.tryParse(v) ?? 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                ),
                Step(
                  title: const Text('4. Commit Migration'),
                  content: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Ready to commit to Drift DB.'),
                  isActive: _currentStep >= 3,
                ),
                Step(
                  title: const Text('5. Summary'),
                  content: const Text('Migration Complete!'),
                  isActive: _currentStep >= 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
