
import 'package:flutter/services.dart';

class DetectFalseGps {
  static const MethodChannel _channel = MethodChannel('detect_false_gps');

  /// Retorna `true` se o GPS for falso e `false` caso contrário.
  /// Retorna `false` em versões do iOS anteriores a 15, que não suportam a detecção nativa.
  static Future<bool> isFakeGps() async {
    try {
      final bool? result = await _channel.invokeMethod('isFakeGps');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Falha ao detectar GPS falso: '${e.message}'.");
      return false;
    }
  }
}
