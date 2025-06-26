import 'dart:io';

class FileStorageData {
  static String filePath = "assets/data/book.txt";

  static Future<List<String>> readDataFromFile() async {
    // Get File
    File file = File(filePath);
    // Read File
    List<String> data = await file.readAsLines();
    return data;
  }

  static Future<void> writeDataToFile(String data) async {
    // Get File
    File file = File(filePath);
    // Check Exist
    if (file.exists() == false) {
      print("File is not exist, create new file");
      await file.create();
    }
    // Replace data
    // await file.writeAsString(data);

    // Append data
    file.openWrite(mode: FileMode.append).writeln(data);
  }
}
