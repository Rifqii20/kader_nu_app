import 'dart:io';
import 'package:excel/excel.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:path_provider/path_provider.dart';


Future<void> exportJamaahsToExcel(List<Jamaah> jamaahs) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  // Menambahkan header
  sheet
    ..cell(CellIndex.indexByString('A1')).value = 'ID'
    ..cell(CellIndex.indexByString('B1')).value = 'Nama'
    ..cell(CellIndex.indexByString('C1')).value = 'Jabatan'
    ..cell(CellIndex.indexByString('D1')).value = 'Email'
    ..cell(CellIndex.indexByString('E1')).value = 'Alamat'
    ..cell(CellIndex.indexByString('F1')).value = 'Telepon';

  // Menambahkan data
  for (int i = 0; i < jamaahs.length; i++) {
    var jamaah = jamaahs[i];
    sheet
      ..cell(CellIndex.indexByString('A${i + 2}')).value = jamaah.id
      ..cell(CellIndex.indexByString('B${i + 2}')).value = jamaah.nama
      ..cell(CellIndex.indexByString('C${i + 2}')).value = jamaah.jabatan
      ..cell(CellIndex.indexByString('D${i + 2}')).value = jamaah.email
      ..cell(CellIndex.indexByString('E${i + 2}')).value = jamaah.alamat
      ..cell(CellIndex.indexByString('F${i + 2}')).value = jamaah.telepon;
  }

  // Menyimpan file
  var directory = await getApplicationDocumentsDirectory();
  var file = File('${directory.path}/jamaahs.xlsx');

  // Pastikan excel.save() tidak null
  List<int> bytes = excel.save() ?? [];
  await file.writeAsBytes(bytes);
}
