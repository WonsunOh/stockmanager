import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screen/item_indicator.dart';

class itemInput extends StatefulWidget {
  final String currentCollection;
  final String id;
  final String title;
  const itemInput(
      {Key? key,
      required this.id,
      required this.currentCollection,
      required this.title})
      : super(key: key);

  @override
  State<itemInput> createState() => _itemInputState();
}

class _itemInputState extends State<itemInput> {
  final _formkey = GlobalKey<FormState>();

  String itemColor = '';
  String itemTitle = '';
  String itemIncomeAdress = '';
  String itemProductAdress = '';
  String itemCoverMaterial = '';
  String itemSourceName = '';
  String itemWeight = '';
  String itemOfferWeight = '';
  String itemCalorie = '';
  String itemNatriumWeight = '';
  String itemNatriumPersent = '';
  String itemCarbohydrateWeight = '';
  String itemCarbohydratePersent = '';
  String itemSugarsWeight = '';
  String itemSugarsPersent = '';
  String itemFatWeight = '';
  String itemFatPersent = '';
  String itemTransfatWeight = '';
  String itemTransfatPersent = '';
  String itemSaturatedfatWeight = '';
  String itemSaturatedfatPersent = '';
  String itemCholesterolWeight = '';
  String itemCholesterolPersent = '';
  String itemProteinWeight = '';
  String itemProteinPersent = '';
  String itemServiceCenter = '';

  late String _updateItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateItem = '색상';
  }

  final Map<String, String> goodsFieldString = {
    'itemColor': '색상',
    'itemTitle': '제품명',
    'itemIncomeAdress': '수입원',
    'itemProductAdress': '제조원',
    'itemCoverMaterial': '내포장재질',
    'itemSourceName': '원재료및 함량',
    'itemWeight': '총내용량',
    'itemOfferWeight': '제공량',
    'itemCalorie': '열량',
    'itemNatriumWeight': '나트륨량',
    'itemNatriumPersent': '나트륨비율',
    'itemCarbohydrateWeight': '탄수화물량',
    'itemCarbohydratePersent': '탄수화물비율',
    'itemSugarsWeight': '당류량',
    'itemSugarsPersent': '당류비율',
    'itemFatWeight': '지방량',
    'itemFatPersent': '지방비율',
    'itemTransfatWeight': '트랜스지방량',
    'itemTransfatPersent': '트랜스지방비율',
    'itemSaturatedfatWeight': '포화지방량',
    'itemSaturatedfatPersent': '포화지방비율',
    'itemCholesterolWeight': '콜레스테롤량',
    'itemCholesterolPersent': '콜레스테롤비율',
    'itemProteinWeight': '단백질량',
    'itemProteinPersent': '단백질비율',
    'itemServiceCenter': '고객상담실'
  };

  showUpdateDialog() {
    int index = int.parse(widget.id) - 1;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: 800,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '데이터 수정',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '상품유형 : ${widget.currentCollection}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Icon(Icons.add_circle),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '상품번호 : ${widget.id}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 150,
                          //값선택이 변화되지 않아 DropdownButtonFormField 로 바꿔줌
                          child: DropdownButtonFormField<String>(
                            value: _updateItem,
                            items: goodsFieldString
                                .map((key, value) {
                                  return MapEntry(
                                    key,
                                    DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _updateItem = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              goodsFieldString[_updateItem] = value;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('datas')
                        .doc('goods')
                        .collection('${widget.currentCollection}')
                        .doc('${widget.currentCollection}${widget.id}')
                        .update(
                      {
                        //map에서 key값을 선택하는 방법 중 하나
                        '${goodsFieldString.keys.firstWhere((element) => goodsFieldString[element] == _updateItem)}':
                            goodsFieldString[_updateItem]
                      },
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ItemIndicator(
                            currentCollection: widget.currentCollection,
                            index: index,
                          );
                        },
                      ),
                    );
                  },
                  child: Text('업데이트')),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('닫기'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    int index = int.parse(widget.id) - 1;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('${widget.title}의 한글 표시사항'),
          onTap: () {
            print('${widget.currentCollection}, ${widget.id}');
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return ItemIndicator(
                    currentCollection: widget.currentCollection,
                    index: index,
                  );
                }),
              );
            },
            icon: Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              _sendItem();
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              showUpdateDialog();
            },
            icon: Icon(Icons.update),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //상품유형, 상품번호
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '상품유형 : ${widget.currentCollection}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      // goodsTypeDropdownButton(),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '상품번호 : ${widget.id}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                //색상, 내포장재질, 유통기한
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '색상',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemColor = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '내포장재질',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCoverMaterial = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //상품명
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '상품명',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemTitle = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //수입원
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '수입원',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemIncomeAdress = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //제조원
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '제조원',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemProductAdress = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //원재료 함량
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '원재료및 함량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemSourceName = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //총내용량, 제공량, 열량, 나트륨량
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '총내용량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '제공량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemOfferWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '열량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCalorie = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '나트륨량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemNatriumWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //나트륨비율, 탄수화물, 당류량
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '나트륨비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemNatriumPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '탄수화물량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCarbohydrateWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '탄수화물비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCarbohydratePersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '당류량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemSugarsWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //당류비율, 지방, 트랜스지방량
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '당류비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemSugarsPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '지방량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemFatWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '지방비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemFatPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '트렌스지방량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemTransfatWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //트랜스지방비율, 포화지방, 콜레스테롤량
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '트랜스지방비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemTransfatPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '포화지방량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemSaturatedfatWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '포화지방비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemSaturatedfatPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '콜레스테롤량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCholesterolWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                //콜레스테롤비율, 단백질
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '콜레스테롤비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemCholesterolPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '단백질량',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemProteinWeight = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '단백질비율',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemProteinPersent = value;
                          },
                          // decoration: InputDecoration(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '고객상담실',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: null,

                          onChanged: (value) {
                            itemServiceCenter = value;
                          },
                          // decoration: InputDecoration(),
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

  // goodsTypeDropdownButton() {
  //   return DropdownButton(
  //     value: widget.currentCollection,
  //     items: goodsTypeList.map(
  //           (value) {
  //         return DropdownMenuItem(
  //           value: value,
  //           child: Text(value),
  //         );
  //       },
  //     ).toList(),
  //     onChanged: (String? value) {
  //       setState(() {
  //         _selectedValue = value!;
  //       });
  //     },
  //   );
  // }

  void _sendItem() {
    FirebaseFirestore.instance
        .collection('datas')
        .doc('goods')
        .collection('${widget.currentCollection}')
        .doc('${widget.currentCollection}${widget.id}')
        .update({
      'itemColor': itemColor,
      'itemTitle': itemTitle,
      'itemIncomeAdress': itemIncomeAdress,
      'itemProductAdress': itemProductAdress,
      'itemCoverMaterial': itemCoverMaterial,
      'itemSourceName': itemSourceName,
      'itemWeight': itemWeight,
      'itemOfferWeight': itemOfferWeight,
      'itemCalorie': itemCalorie,
      'itemNatriumWeight': itemNatriumWeight,
      'itemNatriumPersent': itemNatriumPersent,
      'itemCarbohydrateWeight': itemCarbohydrateWeight,
      'itemCarbohydratePersent': itemCarbohydratePersent,
      'itemSugarsWeight': itemSugarsWeight,
      'itemSugarsPersent': itemSugarsPersent,
      'itemFatWeight': itemFatWeight,
      'itemFatPersent': itemFatPersent,
      'itemTransfatWeight': itemTransfatWeight,
      'itemTransfatPersent': itemTransfatPersent,
      'itemSaturatedfatWeight': itemSaturatedfatWeight,
      'itemSaturatedfatPersent': itemSaturatedfatPersent,
      'itemCholesterolWeight': itemCholesterolWeight,
      'itemCholesterolPersent': itemCholesterolPersent,
      'itemProteinWeight': itemProteinWeight,
      'itemProteinPersent': itemProteinPersent,
      'itemServiceCenter': itemServiceCenter
    });
  }

  // goodsTypeDropdownButton() {
  //   return DropdownButton(
  //     value: selectedValue,
  //     items: goodsTypeList.map(
  //       (value) {
  //         return DropdownMenuItem(
  //           value: value,
  //           child: Text(value),
  //         );
  //       },
  //     ).toList(),
  //     onChanged: (String? value) {
  //       setState(() {
  //         selectedValue = value!;
  //       });
  //     },
  //   );
  // }
}
