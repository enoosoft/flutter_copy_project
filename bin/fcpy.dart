import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

//userge: dart bin/fcpy.dart --converter to-be.txt --source C:\Sync\Works\smmy --destination C:\Sync\Works\dmmy

Map<String, String> tobeMap = {};
Future<void> main(List<String> arguments) async {
  exitCode = 0; // presume success
  var parser = ArgParser();
  parser.addOption('source', abbr: 's');
  parser.addOption('destination', abbr: 'd');
  parser.addOption('converter', abbr: 'c');

  var args = parser.parse(arguments);

  await load(args['converter']);
  tobeMap.forEach((key, value) => stdout.writeln('$key $value'));

  copyDirectory(Directory(args['source']), Directory(args['destination']));
}

void copyDirectory(Directory source, Directory destination) =>
    source.listSync(recursive: false).forEach((var entity) {
      final fullPath = decodePath(
          path.join(destination.absolute.path, path.basename(entity.path)));
      if (fullPath.contains('\\build\\') ||
          fullPath.contains('\\.gradle\\') ||
          fullPath.contains('\\.git\\')) {
        stdout.writeln('SKIPED>>> $fullPath');
      } else if (entity is Directory) {
        var newDirectory = Directory(fullPath);
        stdout.writeln('*CREATE ${newDirectory.path}');
        newDirectory.createSync(recursive: true);

        copyDirectory(entity.absolute, newDirectory);
      } else if (entity is File) {
        // final filePath =
        //     path.join(destination.path, path.basename(entity.path));

        if (isBinary(entity)) {
          stdout.writeln('[BINARY] $fullPath');
          entity.copySync(fullPath);
        } else {
          stdout.writeln('[TEXT] $fullPath');
          final sourceFile = entity.readAsStringSync();
          var destFile = File(fullPath);
          destFile.writeAsString(decode(sourceFile));
        }
      }
    });

String decode(String str) {
  tobeMap.forEach((key, value) {
    if (str.contains(key)) {
      str = str.replaceAll(key, value);
      stdout.writeln('  $key -> $value');
    }
  });
  return str;
}

String decodePath(String str) {
  tobeMap.forEach((key, value) {
    if (key.startsWith('/') || key.startsWith('\\')) {
      if (str.contains(key)) {
        str = str.replaceAll(key, value);
        stdout.writeln('  $value -> $value');
      }
    }
  });
  return str;
}

bool isBinary(File file) {
  final raf = file.openSync(mode: FileMode.read);
  final data = raf.readSync(124);
  for (final b in data) {
    if (b >= 0x00 && b <= 0x08) {
      raf.close();
      return true;
    }
  }
  raf.close();
  return false;
}

Future<void> load(String convertFile) async {
  final lines = utf8.decoder
      .bind(File(convertFile).openRead())
      .transform(const LineSplitter());
  try {
    await for (final line in lines) {
      if (line.trim().length > 8 && !line.trim().startsWith('#')) {
        final tobe = line.split('\-\>');
        tobeMap[tobe[0].trim()] = tobe[1].trim();
      }
    }
  } catch (_) {
    await _handleError(convertFile);
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
