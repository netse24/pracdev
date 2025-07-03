import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorageData {
  // static String filePath = "assets/data/book.txt";

  // static Future<List<String>> readDataFromFile() async {
  //   // Get File
  //   File file = File(filePath);
  //   // Read File
  //   List<String> data = await file.readAsLines();
  //   return data;
  // }

  // static Future<void> writeDataToFile(String data) async {
  //   // Get File
  //   File file = File(filePath);
  //   // Check Exist
  //   if (file.exists() == false) {
  //     print("File is not exist, create new file");
  //     await file.create();
  //   }
  //   // Replace data
  //   // await file.writeAsString(data);

  //   // Append data
  //   file.openWrite(mode: FileMode.append).writeln(data);
  // }

  static String? _filePath;
  static Future<void> _initializeFilePath() async {
    if (_filePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      print(directory);
      _filePath =
          '${directory.path}/book.txt'; // Construct the full path for book.txt
      print("File path initialized to: $_filePath"); // Print for debugging
    }
  }

  // Reads data from the file
  static Future<List<String>> readDataFromFile() async {
    await _initializeFilePath(); // Ensure the path is initialized before reading
    File file =
        File(_filePath!); // Create a File object using the determined path

    if (await file.exists()) {
      // Check if the file actually exists
      print("Reading data from: $_filePath");
      List<String> data = await file.readAsLines();
      return data;
    }
    print("File does not exist at: $_filePath. Returning empty list.");
    return []; // Return an empty list if the file isn't found
  }

  static Future<void> writeDataToFile(String data) async {
    await _initializeFilePath();
    File file = File(_filePath!);

    if (!await file.exists()) {
      print("File is not exist, creating new file at: $_filePath");
      await file.create(recursive: true);
    }

    // Open the file in append mode, write the line, and crucially, close the sink.
    final IOSink sink = file.openWrite(mode: FileMode.append);
    sink.writeln(data);
    await sink.close(); // MUST AWAIT this to ensure data is flushed to disk

    print("Data appended to: $_filePath with content: '$data'");
  }

  static Future<void> overwriteFile(String data) async {
    await _initializeFilePath();
    File file = File(_filePath!);
    await file.writeAsString(data); // writeAsString overwrites the file
    print("Data overwritten to: $_filePath with content: '$data'");
  }
}
