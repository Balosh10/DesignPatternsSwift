import Foundation

// MARK: - Model

/// Representa un hotel obtenido desde la API.
struct Hotel: Codable {
    let name: String
    let resort: String
    let id: Int
}

// MARK: - Subject

/// Define el contrato que conocerá el cliente.
///
/// Tanto el servicio real como el Proxy implementan
/// este protocolo, permitiendo que el cliente no
/// conozca la implementación concreta.
protocol HotelsServiceProtocol {
    func getHotels() -> [Hotel]
}

// MARK: - Proxy

/// Proxy encargado de controlar el acceso al servicio real.
///
/// Responsabilidades:
/// - Consultar el caché antes de acceder a la API.
/// - Guardar la respuesta en caché.
/// - Delegar la petición al servicio real cuando sea necesario.
final class HotelsServiceProxy: HotelsServiceProtocol {

    /// Servicio real.
    private let api: HotelsServiceProtocol

    /// Almacenamiento local.
    private let session = UserDefaults.standard

    /// Llave utilizada para almacenar el caché.
    private let cacheKey = "hotels"

    init(api: HotelsServiceProtocol) {
        self.api = api
    }

    /// Obtiene la lista de hoteles.
    ///
    /// Flujo:
    /// 1. Intenta obtener el caché.
    /// 2. Si existe, lo devuelve.
    /// 3. Si no existe, consulta la API.
    /// 4. Guarda la respuesta en caché.
    func getHotels() -> [Hotel] {

        if let hotels = getHotelsFromCache(),
           !hotels.isEmpty {

            print("📦 Hoteles obtenidos desde caché")
            return hotels
        }

        print("🌐 Consultando hoteles desde la API")

        let hotels = api.getHotels()

        saveHotelsInCache(hotels)

        return hotels
    }
}

// MARK: - Cache

private extension HotelsServiceProxy {

    /// Recupera los hoteles almacenados en caché.
    func getHotelsFromCache() -> [Hotel]? {

        guard let data = session.data(forKey: cacheKey) else {
            return nil
        }

        return try? JSONDecoder().decode([Hotel].self, from: data)
    }

    /// Guarda los hoteles en el almacenamiento local.
    func saveHotelsInCache(_ hotels: [Hotel]) {

        guard let data = try? JSONEncoder().encode(hotels) else {
            print("❌ No fue posible guardar el caché.")
            return
        }

        session.set(data, forKey: cacheKey)
    }
}

// MARK: - Real Subject

/// Servicio encargado únicamente de consultar la API.
///
/// No conoce absolutamente nada sobre:
/// - Caché
/// - UserDefaults
/// - JSON
/// - Persistencia
///
/// Su única responsabilidad es obtener la información.
final class HotelsAPIService: HotelsServiceProtocol {

    func getHotels() -> [Hotel] {

        print("🌍 Realizando petición HTTP...")

        return [
            Hotel(name: "Moon Palace", resort: "MP", id: 1),
            Hotel(name: "Le Blanc", resort: "LB", id: 2)
        ]
    }
}

// MARK: - Client

/// El cliente únicamente conoce el protocolo.
///
/// No sabe si está utilizando un Proxy o el servicio real.
let hotelService: HotelsServiceProtocol = HotelsServiceProxy(
    api: HotelsAPIService()
)

let hotels = hotelService.getHotels()

print(hotels)
