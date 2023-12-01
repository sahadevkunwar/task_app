import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_app/common/constants.dart';
import 'package:task_app/model/task.dart';

class DataSource {
  List<TaskModel> totalList = [];

  Future<Either<String, List<TaskModel>>> fetchData() async {
    try {
      final Dio dio = Dio();
      final res = await dio.get(GlobalVariable.baseUrl);
      totalList = List.from(res.data).map((e) => TaskModel.fromMap(e)).toList();

      return Right(totalList);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to fetch product");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> addData(
      {required String title, required String status}) async {
    try {
      final Dio dio = Dio();
      final Map<String, dynamic> body = {"title": title, "status": status};
      final _ = await dio.post(
        GlobalVariable.baseUrl,
        data: jsonEncode(body),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to add task");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> updateTask({
    required String title,
    required String id,
    required String status,
  }) async {
    try {
      final Dio dio = Dio();
      final Map<String, dynamic> body = {
        "_id": id,
        "title": title,
        "status": status
      };
      final _ = await dio.put(
        '${GlobalVariable.baseUrl}/$id',
        data: jsonEncode(body),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to update task");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteTask({required String id}) async {
    try {
      final Dio dio = Dio();
      final _ = await dio.delete(
        "${GlobalVariable.baseUrl}/$id",
      );

      return const Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to delete task");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
