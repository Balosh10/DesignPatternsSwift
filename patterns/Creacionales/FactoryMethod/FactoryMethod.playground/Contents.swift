import Foundation

// MARK: - Producto

/// Objeto que el cliente desea obtener.
///
/// El cliente solo utilizará este objeto, sin conocer
/// cómo fue construido internamente.
struct House {

    let color: HouseColor
    let rooms: Int
    let hasGarage: Bool
    let hasGarden: Bool

}

// MARK: - Tipos

/// Colores disponibles para una casa.
enum HouseColor {
    case blue
    case pink
}

// MARK: - Factory

/// Fábrica responsable de construir objetos `House`.
///
/// Su responsabilidad es encapsular la lógica de creación
/// de una casa y entregarla lista para usarse.
///
/// El cliente no conoce:
/// - Cuántas habitaciones tendrá.
/// - Si tendrá garaje.
/// - Si tendrá jardín.
/// - Qué configuraciones internas fueron necesarias.
final class HouseFactory {

    /// Factory Method.
    ///
    /// Crea y devuelve una instancia de `House`
    /// completamente configurada.
    ///
    /// - Parameter color: Color solicitado por el cliente.
    /// - Returns: Una casa lista para usarse.
    func makeHouse(color: HouseColor) -> House {

        return House(
            color: color,
            rooms: 3,
            hasGarage: true,
            hasGarden: true
        )

    }

}

// MARK: - Cliente

/// El cliente únicamente solicita una casa.
/// No conoce cómo fue construida.
let house = HouseFactory().makeHouse(color: .blue)

print(house)
