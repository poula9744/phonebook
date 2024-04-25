import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phonebook/PersonVo.dart';


class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("읽기 페이지"),),
      body: _ReadPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
      ),
    );
  }
}

//상태변화를 감시하게 등록시키는 클래스
class _ReadPage extends StatefulWidget {
  const _ReadPage({super.key});

  @override
  State<_ReadPage> createState() => _ReadPageState();
}
//할일 정의 클래스(통신, 데이터 적용)
class _ReadPageState extends State<_ReadPage> {

  //미래의 데이터가 담김
  late Future<PersonVo> personVoFuture;

  //초기화 함수(1번만 실행됨)
  @override
  void initState() {
    super.initState();
    //추가코드
    //데이터 불러오기 메소드 호출
    print("getPersonByNo(): 데이터 가져오기 전");
    personVoFuture = getPersonByNo();
    print("getPersonByNo(): 데이터 가져오기 후");
  }

  //화면 그리기
  @override
  Widget build(BuildContext context) {
    print("build(): 그리기 작업");
    return FutureBuilder
      (
      future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          } else { //데이터가 있으면
          return Container
            (
            color: Color(0xffd6d6d6),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      color: Color(0xffff0000),
                      alignment: Alignment.center,
                      child: Text("번호", style: TextStyle(fontSize: 20),),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      color: Color(0xffd47373),
                      alignment: Alignment.center,
                      child: Text("${snapshot.data!.personId}"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      color: Color(0xffff6200),
                      alignment: Alignment.center,
                      child: Text("이름", style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      color: Color(0xfff8d3b9),
                      alignment: Alignment.center,
                      child: Text("${snapshot.data!.name}"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      color: Color(0xffe0ff00),
                      alignment: Alignment.center,
                      child: Text("핸드폰", style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      color: Color(0xfff5ffa1),
                      alignment: Alignment.center,
                      child: Text("${snapshot.data!.hp}"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      color: Color(0xff08ff00),
                      alignment: Alignment.center,
                      child: Text("회사", style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      color: Color(0xffaaffa7),
                      alignment: Alignment.center,
                      child: Text("${snapshot.data!.company}"),
                    ),
                  ],
                ),
              ],
            ),
          );
        } // 데이터가있으면
      },
    );
  }

  //3번 데이터 가져오기
  Future<PersonVo> getPersonByNo() async{
    print("getPersonByNo(): 데이터 가져오는 중");
    //코드 작성
    try {
    /*----요청처리-------------------*/
    //Dio 객체 생성및 설정
    var dio = Dio();
    // 헤더설정:json으로 전송
    dio.options.headers['Content-Type'] = 'application/json';
    // 서버 요청
    final response = await dio.get
    (
    'http://localhost:9002/api/phones/2',
    );

    /*----응답처리----*/
    if (response.statusCode == 200) {
      //접속성공 200 이면
      print(response.data); // json->map 자동변경
      print(response.data["name"]);
    return PersonVo.fromJson(response.data);
    } else {
     //접속실패 404, 502등등 api서버 문제
      throw Exception('api 서버 문제'); }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }
}
