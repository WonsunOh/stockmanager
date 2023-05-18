import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodNameInputField extends StatelessWidget {
  const FoodNameInputField({
    Key? key,
    // this.product,
  }) : super(key: key);

  // final Product? product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: ScreenSize.width * 0.55,
      child: TextFormField(
        // initialValue: product != null ? product?.foodName : '',
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '상품명 입력',
        ),
        validator: (name) {
          return name == null || name.isEmpty ? '보관하실 물품의 이름을 입력하세요.' : null;
        },
        onChanged: (value) {},
      ),
    );
  }
}
