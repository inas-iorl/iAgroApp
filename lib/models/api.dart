import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class Api {
  static var uri = "https://cabinet.btcom.kz/co2";
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      // ignore: missing_return
      // validateStatus: (code) {
      //   if (code! >= 200) {
      //     return true;
      //   }
      // }
      );
  Dio dio = Dio(options);

  void addIntercept(){
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401){
          navigatorKey.currentState?.pushNamed('/login');
        }
      },
    ));
  }

  void setToken(String token_type, String token){
    dio.options.headers= {"Authorization" : "${token_type} ${token}"};
  }

  Future<dynamic> logIn(String _login, String _pass) async {
    try {
      Response response = await dio.post('/auth/',
          data: FormData.fromMap({
            'username': _login,
            'password': _pass,
          }));
      dynamic json_data = json.decode(response.data);
      if (json_data['success']){
        setToken(json_data['token_type'], json_data['access_token']);
      }
      return json_data;
    }
    catch(a) {
      debugPrint('logIn error');
    }
  }

  Future<dynamic> loadWeather(String field_id) async {
    try {
      Response response = await dio.get('/fields/${field_id}/weather/');
      return response;
    }
    catch(a) {
      debugPrint('loadWeather error');
    }
  }

  Future<dynamic> getFields() async {
    try {
      Response response = await dio.get('/fields/');
      return response;
    }
    catch(a) {
      debugPrint('getFields error');
    }
  }

  Future<dynamic> getField(String fieldId) async {
    try {
      Response response = await dio.get('/fields/${fieldId}/');
      return response;
    }
    catch(a) {
      debugPrint('getField error');
    }
  }

  Future<dynamic> addField(String name, String culture) async {
    try {
      Response response = await dio.post('/fields/',
          data: FormData.fromMap({
            'name': name,
            'culture': culture,
          }));
      return response;
    }
    catch(a) {
      debugPrint('addField error');
    }
  }

  Future<dynamic> editField(
      String _id,
      String name,
      String culture,
      String descr,
      String cadNumber
      ) async {
    try {
      Response response = await dio.put('/fields/{_id}/',
          data: FormData.fromMap({
            'name': name,
            'culture': culture,
            'descr': descr,
            'cad_number': cadNumber,
          }));
      return response;
    }
    catch(a) {
      debugPrint('editField error');
    }
  }

  Future<dynamic> setFieldImage(
      String _id,
      String _image,
      ) async {
    try {
      print('setFieldImage');
      print(_id);
      print(_image);
      String fileName = _image.split('/').last;
      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image, filename: fileName)
      });
      // Response response = await dio.post('/uploadfile/',
      Response response = await dio.post('/fields/${_id}/image',
          data: data,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data'
            },
          ),
      );
      return response;
    }
    catch(a) {
      debugPrint('setFieldImage error');
    }
  }


  Future<dynamic> loadFieldDetail(String fieldId) async {
    try {
      Response response = await dio.get('/fields/${fieldId}/detail/');
      return response;
    }
    catch(a) {
      debugPrint('loadFieldDetail error');
    }
  }

  Future<dynamic> loadRecommendBio(int fieldId) async {
    try {
      Response response = await dio.get('/recommends/biological');
      return response;
    }
    catch(a) {
      debugPrint('loadRecommendBio error');
    }
  }

  Future<dynamic> loadRecommendPhys(int fieldId) async {
    try {
      Response response = await dio.get('/recommends/physical');
      return response;
    }
    catch(a) {
      debugPrint('loadRecommendPhys error');
    }
  }

  Future<dynamic> loadRecommendChem(int fieldId) async {
    try {
      Response response = await dio.get('/recommends/chemical');
      return response;
    }
    catch(a) {
      debugPrint('loadRecommendChem error');
    }
  }

  Future<dynamic> loadAnnouncement(String field_id) async {
    try {
      Response response = await dio.get('/fields/${field_id}/announcement/');
      return response;
    }
    catch(a) {
      debugPrint('loadAnnouncement error');
    }
  }

  Future<dynamic> getDevices() async {
    try {
      Response response = await dio.get('/devices/');
      return response;
    }
    catch(a) {
      debugPrint('getDevices error');
    }
  }

  Future<dynamic> getDevice(String device_id) async {
    try {
      Response response = await dio.get('/devices/${device_id}/');
      print(response);
      return response;
    }
    catch(a) {
      debugPrint('getDevice error');
    }
  }

  Future<dynamic> addDevice(String device_id, String name, String field_id) async {
    try {
      Response response = await dio.post('/devices/',
          data: FormData.fromMap({
            "device_id": device_id,
            'name': name,
            'field_id': field_id,
          }));
      return response;
    }
    catch(a) {
      debugPrint('addDevice error');
    }
  }

  Future<dynamic> editDevice(String _id, String name, String field_id) async {
    try {
      Response response = await dio.put('/devices/{_id}/',
          data: FormData.fromMap({
            'name': name,
            'field_id': field_id,
          }));
      return response;
    }
    catch(a) {
      debugPrint('editDevice error');
    }
  }

  Future<dynamic> addDiagnostic(String device_id, String field_id, String field_part) async {
    try {
      Response response = await dio.post('/diagnostic/',
          data: FormData.fromMap({
            'device_id': device_id,
            'field_id': field_id,
            'field_part': field_part,
          }));
      return response;
    }
    catch(a) {
      debugPrint('addDiagnostic error');
    }
  }

  Future<dynamic> fieldCntDiagnostic(String field_id) async {
    try {
      Response response = await dio.get('/fields/${field_id}/diagnostics/count/');
      return response;
    }
    catch(a) {
      debugPrint('fieldCntDiagnostic error');
    }
  }

  Future<dynamic> getFieldDiagnostics(String field_id) async {
    try {
      Response response = await dio.get('/fields/${field_id}/diagnostics/');
      return response;
    }
    catch(a) {
      debugPrint('getFieldDiagnostics error');
    }
  }

  Future<dynamic> getDiagnostic(String diagnostic_id) async {
    try {
      Response response = await dio.get('/diagnostic/${diagnostic_id}/');
      return response;
    }
    catch(a) {
      debugPrint('getDiagnostic error');
    }
  }

  Future<dynamic> co2Sample(
      String _diagnostic_id,
      String _image,
      ) async {
    try {
      String fileName = _image.split('/').last;
      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image, filename: fileName)
      });
      Response response = await dio.post('/diagnostic/${_diagnostic_id}/sample/',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data'
          },
        ),
      );
      return response;
    }
    catch(a) {
      debugPrint('co2Measure error');
    }
  }

}