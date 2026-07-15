import Foundation

// MARK: - Entity

/// Representa una reserva del hotel.
struct Reservation {
    let id: String
    let status: ReservationStatus
}

/// Posibles estados de una reserva.
enum ReservationStatus {
    case pending
    case reserved
    case checkedIn
    case checkedOut
    case cancelled
}

// MARK: - Service

/// Servicio encargado de ejecutar acciones sobre una reserva.
///
/// El Chain of Responsibility únicamente decide
/// quién debe atender la solicitud.
/// La lógica de negocio vive en este servicio.
protocol ReservationService {
    func performCheckIn(for reservation: Reservation)
}

/// Implementación simulada del servicio.
final class HotelReservationService: ReservationService {

    func performCheckIn(for reservation: Reservation) {

        print("🏨 Iniciando Check-In...")
        print("📄 Reserva: \(reservation.id)")
        print("🪪 Validando identidad...")
        print("🔑 Asignando habitación...")
        print("✅ Check-In realizado correctamente.")

    }
}

// MARK: - Handler

/// Define el contrato que todos los handlers deben implementar.
///
/// Cada handler tiene dos responsabilidades:
/// 1. Validar si puede atender la solicitud.
/// 2. Delegarla al siguiente handler cuando no pueda hacerlo.
protocol ReservationHandler: AnyObject {

    /// Referencia al siguiente elemento de la cadena.
    var next: ReservationHandler? { get set }

    /// Procesa o delega la solicitud.
    func handle(_ reservation: Reservation)

}

// MARK: - Pending

/// Valida si la reserva continúa pendiente.
final class PendingHandler: ReservationHandler {

    var next: ReservationHandler?

    func handle(_ reservation: Reservation) {

        guard reservation.status == .pending else {
            next?.handle(reservation)
            return
        }

        print("❌ La reserva aún está pendiente de confirmación.")

    }
}

// MARK: - Reserved

/// Si la reserva está confirmada,
/// realiza el Check-In.
final class ReservedHandler: ReservationHandler {

    var next: ReservationHandler?

    private let service: ReservationService

    init(service: ReservationService) {
        self.service = service
    }

    func handle(_ reservation: Reservation) {

        guard reservation.status == .reserved else {
            next?.handle(reservation)
            return
        }

        service.performCheckIn(for: reservation)

    }
}

// MARK: - Checked In

/// Valida si el huésped ya realizó el Check-In.
final class CheckedInHandler: ReservationHandler {

    var next: ReservationHandler?

    func handle(_ reservation: Reservation) {

        guard reservation.status == .checkedIn else {
            next?.handle(reservation)
            return
        }

        print("⚠️ El huésped ya realizó el Check-In.")

    }
}

// MARK: - Checked Out

/// Valida si la reserva ya fue cerrada.
final class CheckedOutHandler: ReservationHandler {

    var next: ReservationHandler?

    func handle(_ reservation: Reservation) {

        guard reservation.status == .checkedOut else {
            next?.handle(reservation)
            return
        }

        print("❌ La reserva ya realizó el Check-Out.")

    }
}

// MARK: - Cancelled

/// Valida si la reserva fue cancelada.
final class CancelledHandler: ReservationHandler {

    var next: ReservationHandler?

    func handle(_ reservation: Reservation) {

        guard reservation.status == .cancelled else {
            next?.handle(reservation)
            return
        }

        print("❌ La reserva fue cancelada.")

    }
}

// MARK: - Client

let service = HotelReservationService()

let pending = PendingHandler()
let reserved = ReservedHandler(service: service)
let checkedIn = CheckedInHandler()
let checkedOut = CheckedOutHandler()
let cancelled = CancelledHandler()

// Construcción de la cadena.
pending.next = reserved
reserved.next = checkedIn
checkedIn.next = checkedOut
checkedOut.next = cancelled

let reservation = Reservation(
    id: "ABC123",
    status: .reserved
)

// El cliente únicamente conoce el primer handler.
pending.handle(reservation)
