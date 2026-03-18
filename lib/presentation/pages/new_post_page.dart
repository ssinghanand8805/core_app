import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/post_entity.dart';
import '../../l10n/translation_keys.dart';
import '../controllers/post_controller.dart';

class NewPostPage extends StatefulWidget {
  final PostEntity? existingPost;
  const NewPostPage({super.key, this.existingPost});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _formKey    = GlobalKey<FormState>();
  final _titleCtrl  = TextEditingController();
  final _bodyCtrl   = TextEditingController();
  final _ctrl       = Get.find<PostController>();

  bool get _isEditing => widget.existingPost != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleCtrl.text = widget.existingPost!.title;
      _bodyCtrl.text  = widget.existingPost!.body;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_isEditing) {
      _ctrl.editPost(
        id:    widget.existingPost!.id,
        title: _titleCtrl.text.trim(),
        body:  _bodyCtrl.text.trim(),
      );
    } else {
      _ctrl.addPost(
        title: _titleCtrl.text.trim(),
        body:  _bodyCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final subColor  = isDark ? Colors.white54 : Colors.black45;
    final cardColor = isDark ? const Color(0xFF141A19) : Colors.white;
    const teal      = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: Text(_isEditing ? TKeys.editPost.tr : TKeys.newPost.tr),
        // actions: [
        //   Obx(() => _ctrl.isSubmitting.value
        //       ? const Padding(
        //       padding: EdgeInsets.all(16),
        //       child: SizedBox(
        //         width: 20, height: 20,
        //         child: CircularProgressIndicator(strokeWidth: 2),
        //       ))
        //       : TextButton(
        //     onPressed: _submit,
        //     child: Text(TKeys.save.tr,
        //         style: const TextStyle(
        //             color: teal,
        //             fontWeight: FontWeight.w700,
        //             fontSize: 15)),
        //   )),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: teal.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_note_rounded, color: teal, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        '${TKeys.editPost.tr} #${widget.existingPost!.id}',
                        style: const TextStyle(
                            color: teal, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              _FieldLabel(label: TKeys.title.tr, color: subColor),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: teal.withOpacity(0.12)),
                ),
                child: TextFormField(
                  controller: _titleCtrl,
                  style: TextStyle(color: textColor, fontSize: 15),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: TKeys.titleHint.tr,
                    hintStyle: TextStyle(color: subColor, fontSize: 14),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title_rounded, color: teal.withOpacity(0.6), size: 20),
                  ),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? TKeys.titleRequired.tr : null,
                ),
              ),

              const SizedBox(height: 20),

              _FieldLabel(label: TKeys.body.tr, color: subColor),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: teal.withOpacity(0.12)),
                ),
                child: TextFormField(
                  controller: _bodyCtrl,
                  style: TextStyle(color: textColor, fontSize: 15, height: 1.5),
                  maxLines: 10,
                  minLines: 6,
                  decoration: InputDecoration(
                    hintText: TKeys.bodyHint.tr,
                    hintStyle: TextStyle(color: subColor, fontSize: 14),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? TKeys.bodyRequired.tr : null,
                ),
              ),

              const SizedBox(height: 32),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _ctrl.isSubmitting.value ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: teal,
                    disabledBackgroundColor: teal.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _ctrl.isSubmitting.value
                      ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isEditing ? Icons.save_rounded : Icons.send_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        TKeys.save.tr,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final Color  color;
  const _FieldLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          color: color),
    );
  }
}