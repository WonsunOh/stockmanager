import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemIndicator extends StatelessWidget {
  String currentCollection;
  int index;
  ItemIndicator(
      {Key? key, required this.currentCollection, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var datas = FirebaseFirestore.instance.collection('datas').doc('goods');
    // var snapshot;
    // var _itColor = snapshot.data.docs[index]['itemColor'];

    return Scaffold(
      body: FutureBuilder<Object>(
          future: datas.collection('$currentCollection').get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var itColor =
                int.parse('0xff${snapshot.data.docs[index]['itemColor']}');
            var itColor2 =
                int.parse('0x40${snapshot.data.docs[index]['itemColor']}');
            var itColor3 =
                int.parse('0x10${snapshot.data.docs[index]['itemColor']}');
            double itWith = 2;

            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.only(left: 20, top: 50, right: 20),
                // color: Colors.deepOrange,
                width: 1200,
                // height: 450,
                child: Row(
                  children: [
                    Container(
                      width: 470,
                      // color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            width: 470,
                            child: Text(
                              '식품위생법에 의한 한글 표시사항',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'SCDream',
                                  letterSpacing: -1.0),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.deepOrange,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          Table(
                            columnWidths: {
                              0: FixedColumnWidth(120),
                              1: FlexColumnWidth(),
                            },
                            children: [
                              //제품명
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '제품명',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]['itemTitle'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // 식품의 유형
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '식품의 유형',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]['goodsType'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // 수입원
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '수입원',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]
                                          ['itemIncomeAdress'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //제조원
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '제조원',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]
                                          ['itemProductAdress'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // 원산지
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '원산지',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]['makecountry'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // 내용량
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '내용량',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]['weight'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //유통기한
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '유통기한',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      '제품포장 표기일까지(년월일순)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //원재료및 함량
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '원재료 및 \n함량',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]
                                          ['itemSourceName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //내포장재질
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '내포장재질',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      snapshot.data.docs[index]
                                          ['itemCoverMaterial'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //반품 및 교환
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '반품 및 교환',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      '구입처 또는 판매원',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //소분업체명
                              TableRow(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.yellow,
                                    child: Text(
                                      '소분업체명',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                    ),
                                    // color: Colors.red,
                                    child: Text(
                                      '코스트고(제2015-02854호) \n 경기도 의정부시 둔야로61번길 38',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            snapshot.data.docs[index]['precautions2'],
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 409,
                      // color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //제목
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            width: 409,
                            height: 60,
                            color: Color(itColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '영양정보',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SCDream',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 35,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1회 제공량 ${snapshot.data.docs[index]['itemOfferWeight']}g',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'SCDream',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //부제목
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(int.parse(
                                      '0x40${snapshot.data.docs[index]['itemColor']}')),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '1회 제공량당 함량',
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '1일 영양성분 기준치에 대한 비율',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //열량
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              color: Color(itColor3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '열량   ${snapshot.data.docs[index]['itemCalorie']}kcal',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //나트륨
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              // color: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '나트륨   ${snapshot.data.docs[index]['itemNatriumWeight']}mg',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemNatriumPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //탄수화물
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              color: Color(itColor3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '탄수화물   ${snapshot.data.docs[index]['itemCarbohydrateWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemCarbohydratePersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //당류
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              // color: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '   당류   ${snapshot.data.docs[index]['itemSugarsWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemSugarsPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //지방
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              color: Color(itColor3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '지방   ${snapshot.data.docs[index]['itemFatWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemFatPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //트랜스지방
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              // color: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '  트랜스지방   ${snapshot.data.docs[index]['itemTransfatWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemTransfatPersent']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //포화지방
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              color: Color(itColor3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '  포화지방   ${snapshot.data.docs[index]['itemTransfatPersent']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemSaturatedfatPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //콜레스테롤
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              // color: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '콜레스테롤   ${snapshot.data.docs[index]['itemCholesterolWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemCholesterolPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //단백질
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: itWith,
                                  color: Color(itColor2),
                                ),
                              ),
                              color: Color(itColor3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '단백질   ${snapshot.data.docs[index]['itemProteinWeight']}g',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '${snapshot.data.docs[index]['itemProteinPersent']}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 450,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '-${snapshot.data.docs[index]['precautions']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  '-보관방법 : ${snapshot.data.docs[index]['storagemethod']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  '-${snapshot.data.docs[index]['storagemethod2']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  '-불량식품 신고는 국번없이 1399',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  '-소비자 상담실 : ${snapshot.data.docs[index]['itemServiceCenter']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
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
              );
            } else {
              CircularProgressIndicator();
            }

            return Center(
              child: Text('데이터 오류'),
            );
          }),
    );
  }
}
