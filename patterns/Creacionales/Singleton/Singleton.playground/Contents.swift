import Foundation

// MARK: - ReservationRepresentable
//
// POO - Abstracción
// ------------------
// Define el contrato de una reserva.
//
// Permite que la app no dependa de una implementación concreta.
//

protocol ReservationRepresentable {

    var reservationNumber: String { get }
    var resort: String { get }
    var hotelName: String { get }
    var guestName: String { get }
    var guestType: String { get }
    var isPremium: Bool { get }

}

// MARK: - Reservation
//
// Modelo concreto del dominio.
//

struct Reservation: ReservationRepresentable {

    let reservationNumber: String
    let resort: String
    let hotelName: String
    let guestName: String
    let guestType: String
    let isPremium: Bool
}

// MARK: - CurrentReservationProviding
//
// POO - Abstracción real para DI
// ------------------------------
// En lugar de depender del Singleton directamente,
// la app depende de este contrato.
//

protocol CurrentReservationProviding {

    var reservation: Reservation? { get }

    func updateReservation(_ reservation: Reservation)
    func clear()
}

// MARK: - CurrentReservationManager (Singleton)
//
// POO - Singleton Pattern
// -----------------------
// Garantiza una única instancia en toda la app.
//
// Caso real:
// El usuario puede tener muchas reservas,
// pero SOLO una puede estar activa.
//

final class CurrentReservationManager: CurrentReservationProviding {

    /// Única instancia global.
    static let shared = CurrentReservationManager()

    /// Constructor privado para evitar múltiples instancias.
    private init() {}

    // MARK: Encapsulamiento
    //
    // private(set) permite:
    // ✔ Leer desde cualquier parte
    // ✖ Evitar modificaciones directas desde fuera
    private(set) var reservation: Reservation?

    // MARK: - Public API

    /// Abstracción
    /// El cliente no sabe cómo se almacena la reserva.
    func updateReservation(_ reservation: Reservation) {
        self.reservation = reservation
    }

    /// Abstracción
    /// Oculta la lógica interna de limpieza.
    func clear() {
        reservation = nil
    }
}

// MARK: - Uso en la App (Production)

class HomeViewModel {

    // POO - Dependency Injection
    // --------------------------
    // El ViewModel NO depende del Singleton directamente.
    private let reservationProvider: CurrentReservationProviding

    init(reservationProvider: CurrentReservationProviding) {
        self.reservationProvider = reservationProvider
    }

    func getHotelName() -> String? {
        reservationProvider.reservation?.hotelName
    }
}

// MARK: - Composition Root (App Start)

let reservation = Reservation(
    reservationNumber: "123456",
    resort: "Hotel Cancun",
    hotelName: "Hotel Cancun New",
    guestName: "Osvaldo Cespedes",
    guestType: "Member",
    isPremium: true
)

// Singleton sigue existiendo, pero se usa solo como implementación concreta.
CurrentReservationManager.shared.updateReservation(reservation)

let viewModel = HomeViewModel(
    reservationProvider: CurrentReservationManager.shared
)

print(viewModel.getHotelName() ?? "")


// MARK: - Mock para Unit Tests

final class MockReservationManager: CurrentReservationProviding {

    var reservation: Reservation?

    func updateReservation(_ reservation: Reservation) {
        self.reservation = reservation
    }

    func clear() {
        self.reservation = nil
    }
}