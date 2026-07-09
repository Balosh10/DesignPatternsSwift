import Foundation

// MARK: - Implementor

/// Define el contrato que todos los proveedores de analítica deben implementar.
///
/// El lado izquierdo del Bridge (Abstraction) solo conoce este protocolo,
/// sin importar si el proveedor es Firebase, Datadog, Pendo o cualquier otro.
protocol AnalyticsProvider {

    /// Envía un evento de analítica.
    ///
    /// - Parameters:
    ///   - key: Nombre del evento.
    ///   - parameters: Información adicional del evento.
    func track(_ key: String, parameters: [String: Any])
}

// MARK: - Concrete Implementors

/// Implementación del proveedor Firebase.
final class FirebaseAnalyticsProvider: AnalyticsProvider {

    func track(_ key: String, parameters: [String: Any]) {
        print("🔥 Firebase -> \(key)")
        print("Parameters: \(parameters)")
    }
}

/// Implementación del proveedor Datadog.
final class DatadogAnalyticsProvider: AnalyticsProvider {

    func track(_ key: String, parameters: [String: Any]) {
        print("📊 Datadog -> \(key)")
        print("Parameters: \(parameters)")
    }
}

/// Implementación del proveedor Pendo.
final class PendoAnalyticsProvider: AnalyticsProvider {

    func track(_ key: String, parameters: [String: Any]) {
        print("📱 Pendo -> \(key)")
        print("Parameters: \(parameters)")
    }
}

// MARK: - Abstraction

/// Representa la abstracción del patrón Bridge.
///
/// Esta clase mantiene una referencia únicamente al contrato
/// (`AnalyticsProvider`) y desconoce qué proveedor concreto
/// realizará el envío del evento.
///
/// Gracias a esta composición, es posible cambiar el proveedor
/// sin modificar las clases que utilizan la analítica.
class AnalyticsTracker {

    /// Implementador del Bridge.
    let provider: AnalyticsProvider

    init(provider: AnalyticsProvider) {
        self.provider = provider
    }
}

// MARK: - Refined Abstraction

/// Encargado del seguimiento de pantallas de la aplicación.
///
/// Aquí puede existir lógica adicional antes de enviar el evento:
/// - Validaciones
/// - Formato del nombre del evento
/// - Agregar parámetros comunes
/// - Logs
///
/// Finalmente delega el envío al proveedor configurado.
final class ScreenTracker: AnalyticsTracker {

    /// Envía un evento indicando que una pantalla fue visualizada.
    ///
    /// - Parameters:
    ///   - screenName: Nombre de la pantalla.
    ///   - parameters: Información adicional.
    func trackScreen(
        _ screenName: String,
        parameters: [String: Any] = [:]
    ) {

        provider.track(screenName, parameters: parameters)
    }
}

// MARK: - Client

/// El cliente únicamente decide qué proveedor utilizar.
///
/// Puede cambiar Firebase por Datadog o Pendo
/// sin modificar `ScreenTracker`.
let provider: AnalyticsProvider = FirebaseAnalyticsProvider()

let screenTracker = ScreenTracker(provider: provider)

screenTracker.trackScreen(
    "Screen_Login",
    parameters: [
        "user": "Osvaldo",
        "platform": "iOS"
    ]
)