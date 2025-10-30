import Flutter
import UIKit
import CoreLocation

public class FakeGpsDetectorIosPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var channel: FlutterMethodChannel!
    var locationResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FakeGpsDetectorIosPlugin()
        instance.channel = FlutterMethodChannel(name: "detect_false_gps", binaryMessenger: registrar.messenger)
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "isFakeGps" {
            self.locationResult = result

            // Verifica a versão do iOS para usar a API correta
            if #available(iOS 15.0, *) {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestLocation()
            } else {
                // Retorna 'false' para versões anteriores a 15, onde a API não existe.
                result(false)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    // Delegate do CLLocationManager: chamado quando uma nova localização é recebida
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationResult = self.locationResult else { return }

        if #available(iOS 15.0, *) {
            if let lastLocation = locations.last, let sourceInfo = lastLocation.sourceInformation {
                locationResult(sourceInfo.isSimulatedBySoftware)
            } else {
                locationResult(false) // Sem informações de origem, assume legítimo
            }
        }
        self.locationResult = nil
    }

    // Delegate do CLLocationManager: chamado quando há falha na obtenção da localização
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationResult?(false)
        self.locationResult = nil
    }

    // Delegate do CLLocationManager: chamado quando o status de autorização muda
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Em caso de mudança na autorização, uma nova requisição pode ser necessária
    }
}
