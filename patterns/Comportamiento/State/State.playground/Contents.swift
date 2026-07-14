import Foundation

// MARK: - State
// Todos los estados deben implementar las mismas acciones.
// Cada estado decide qué operaciones están permitidas y cuándo cambiar al siguiente estado.
protocol ReservationState {

    /// Nombre del estado actual
    var name: String { get }

    /// Realiza el Check-In
    func checkIn(context: ReservationContext)

    /// Realiza el Check-Out
    func checkOut(context: ReservationContext)

    /// Cancela la reserva
    func cancel(context: ReservationContext)
}

// MARK: - Context
// Representa una reserva de hotel.
// El contexto no conoce las reglas de negocio; únicamente delega las acciones
// al estado actual.
final class ReservationContext {

    /// Estado actual de la reserva
    var state: ReservationState

    /// Datos de la reserva (ejemplo)
    let reservationNumber: String
    let guestName: String

    init(
        reservationNumber: String,
        guestName: String
    ) {
        self.reservationNumber = reservationNumber
        self.guestName = guestName
        self.state = ReservedState()
    }

    func checkIn() {
        state.checkIn(context: self)
    }

    func checkOut() {
        state.checkOut(context: self)
    }

    func cancel() {
        state.cancel(context: self)
    }

    func currentStatus() {
        print("""
        -------------------------
        Reserva: \(reservationNumber)
        Huésped: \(guestName)
        Estado: \(state.name)
        -------------------------
        """)
    }
}

// MARK: - Reserved State
// Estado inicial de la reserva.
//
// Acciones permitidas:
// ✅ Check-In
// ✅ Cancelar
//
// Acciones bloqueadas:
// ❌ Check-Out
final class ReservedState: ReservationState {

    let name = "Reserved"

    func checkIn(context: ReservationContext) {

        print("✅ Check-In realizado para \(context.guestName)")

        // Cambia al siguiente estado válido
        context.state = CheckedInState()
    }

    func checkOut(context: ReservationContext) {

        print("❌ No puedes hacer Check-Out antes del Check-In")
    }

    func cancel(context: ReservationContext) {

        print("✅ Reserva cancelada")
    }
}

// MARK: - Checked-In State
// El huésped ya ingresó al hotel.
//
// Acciones permitidas:
// ✅ Check-Out
//
// Acciones bloqueadas:
// ❌ Check-In
// ❌ Cancelar
final class CheckedInState: ReservationState {

    let name = "Checked-In"

    func checkIn(context: ReservationContext) {

        print("❌ El huésped ya realizó el Check-In")
    }

    func checkOut(context: ReservationContext) {

        print("✅ Check-Out realizado")

        // Cambia al siguiente estado válido
        context.state = CheckedOutState()
    }

    func cancel(context: ReservationContext) {

        print("❌ No puedes cancelar una reserva con Check-In")
    }
}

// MARK: - Checked-Out State
// La estancia terminó.
//
// No se permiten más acciones.
final class CheckedOutState: ReservationState {

    let name = "Checked-Out"

    func checkIn(context: ReservationContext) {

        print("❌ La estancia ya terminó")
    }

    func checkOut(context: ReservationContext) {

        print("❌ El huésped ya realizó el Check-Out")
    }

    func cancel(context: ReservationContext) {

        print("❌ No puedes cancelar una reserva finalizada")
    }
}

// MARK: - Ejemplo

let reservation = ReservationContext(
    reservationNumber: "VL-2026-0001",
    guestName: "Osvaldo Céspedes"
)

reservation.currentStatus()

reservation.cancel()

reservation.checkOut()

reservation.checkIn()

reservation.currentStatus()

reservation.checkIn()

reservation.cancel()

reservation.checkOut()

reservation.currentStatus()

reservation.checkOut()

reservation.cancel()
