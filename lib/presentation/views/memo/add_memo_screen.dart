import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/screen_size.dart';
import '../../../data/models/memo_model.dart';
import '../../viewmodels/add_memo_viewmodel.dart';
//이름을 memo_list.dart로 바꿀것.
// 작성한 메모를 listview로 보여줄 것.

class AddMemoScreen extends ConsumerStatefulWidget {
  final MemoFirebaseModel? memo;

  const AddMemoScreen({super.key, this.memo});

  @override
  ConsumerState<AddMemoScreen> createState() => _AddMemoScreenState();
}

class _AddMemoScreenState extends ConsumerState<AddMemoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 각 입력 필드를 위한 컨트롤러
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _completionRateController;

  // 드롭다운 메뉴를 위한 상태 변수
  String? _selectedWriter;
  String? _selectedCategory;

  // 드롭다운 메뉴 아이템 리스트 (기존 MemoController에서 가져옴)
  final List<String> writerName = ['오원선', '왕희경'];
  final List<String> memoCategory = ['코스트고 작업', '아이디어', '기타'];

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 컨트롤러와 변수 초기화
    _titleController = TextEditingController(text: widget.memo?.title ?? '');
    _contentController =
        TextEditingController(text: widget.memo?.content ?? '');
    _completionRateController =
        TextEditingController(text: widget.memo?.completionRate ?? '0');
    _selectedWriter = widget.memo?.writer;
    _selectedCategory = widget.memo?.category;
  }

  @override
  void dispose() {
    // 위젯이 사라질 때 컨트롤러 리소스 해제
    _titleController.dispose();
    _contentController.dispose();
    _completionRateController.dispose();
    super.dispose();
  }

  // 저장 버튼을 눌렀을 때 실행될 함수
  void _submit() async {
    // 폼 유효성 검사
    if (_formKey.currentState!.validate()) {
      // 유효성 검사를 통과하면 ViewModel의 saveMemo 메서드 호출
      final success =
          await ref.read(addMemoViewModelProvider.notifier).saveMemo(
                existingMemo: widget.memo,
                title: _titleController.text,
                writer: _selectedWriter!,
                category: _selectedCategory!,
                content: _contentController.text,
                completionRate: _completionRateController.text,
              );

      // 저장이 성공하면 이전 화면으로 돌아감
      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel의 상태(로딩, 에러 등)를 감지하여 UI에 피드백을 줄 수 있음
    ref.listen<AsyncValue<void>>(addMemoViewModelProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장에 실패했습니다: ${next.error}')),
        );
      }
    });

    final isLoading = ref.watch(addMemoViewModelProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          widget.memo == null ? '메모 추가' : '메모 수정',
          style: TextStyle(
            fontSize: ScreenSize.sWidth(context) * 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: '제목', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.isEmpty ? '제목을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWriter,
                decoration: const InputDecoration(
                    labelText: '작성자', border: OutlineInputBorder()),
                items: writerName
                    .map((name) =>
                        DropdownMenuItem(value: name, child: Text(name)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedWriter = value),
                validator: (value) => value == null ? '작성자를 선택하세요.' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: '분류', border: OutlineInputBorder()),
                items: memoCategory
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? '분류를 선택하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                    labelText: '내용', border: OutlineInputBorder()),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _completionRateController,
                decoration: const InputDecoration(
                    labelText: '완료율 (%)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return '완료율을 입력하세요.';
                  final number = int.tryParse(value);
                  if (number == null || number < 0 || number > 100)
                    return '0과 100 사이의 숫자를 입력하세요.';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _submit, // 로딩 중일 때 버튼 비활성화
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 3))
                    : const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
