import 'package:flutter/material.dart';
import 'package:phonebook/PersonVo.dart';
import 'package:dio/dio.dart';

class ModifyForm extends StatelessWidget {
  const ModifyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("수정페이지")),
      body: Container(
          padding: EdgeInsets.all(15),
          color: Color(0xffd6d6d6),
          child: _ModifyForm()
      ),
    );
  }
}


class _ModifyForm extends StatefulWidget {
  const _ModifyForm({super.key});

  @override
  State<_ModifyForm> createState() => _ModifyFormState();
}

//할일
class _ModifyFormState extends State<_ModifyForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  //변수
  late Future<PersonVo> personVoFuture;

  //초기화(1번 실행)
  @override
  void initState() {
    super.initState();
  }


  //화면 그리기
  @override
  Widget build(BuildContext context) {
    //라우터로 전달받은 personId
    late final args = ModalRoute.of(context)!.settings.arguments as Map;

    late final personId = args['personId'];
    personVoFuture = modifyPerson(personId);

    return FutureBuilder(
        future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
        builder: (context, snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('데이터가 없습니다.'));
      } else {
        //데이터가 있으면
        _nameController.text = snapshot.data!.name;
        _hpController.text = snapshot.data!.hp;
        _companyController.text = snapshot.data!.company;

        return Container(
          color: Color(0xffffffff),
          child: Form(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    controller: _hpController,
                    decoration: InputDecoration(
                      labelText: '핸드폰',
                      hintText: '핸드폰번호를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: '회사',
                      hintText: '회사번호를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 450,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        print("수정");
                        modify(personId);
                      },
                      child: Text("수정")),
                )
              ],
            ),
          ),
        );
      }
    }
    );
}


  Future<PersonVo> modifyPerson(int personId) async {
    print("getPersonByNo(): 데이터 가져오기 중");
    //코드 작성
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://localhost:9002/api/phones/${personId}',
        /*
        queryParameters: {
          // 예시 파라미터
          'page': 1,
          'keyword': '홍길동',
        },
        data: {
          // 예시 data  map->json자동변경
          'id': 'aaa',
          'pw': '값',
        },
        */
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경

        return PersonVo.fromJson(response.data);
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }

  //수정하기
  Future<void> modify(int personId) async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';


      // 서버 요청
      final response = await dio.put(
        'http://localhost:9002/api/phones/modify/${personId}',

        data: {
          // 예시 data  map->json자동변경
          'name': _nameController.text,
          'hp': _hpController.text,
          'company': _companyController.text,
        },

      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);

        Navigator.pushNamed(context, "/list");
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }
}