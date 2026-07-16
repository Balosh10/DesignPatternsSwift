import Foundation

// MARK: - Reservation Events

/// Eventos que los componentes pueden notificar al Mediator.
///
/// En lugar de utilizar Strings, se emplea un enum para aprovechar
/// el tipado fuerte de Swift y evitar errores de escritura.
enum ReservationEvent {

    case guestInformationUpdated
    case stayDatesUpdated
    case paymentUpdated
    case confirmReservation

}

// MARK: - Mediator

/// Define el contrato que utilizarán todos los componentes para
/// comunicarse entre sí de forma indirecta.
///
/// Los componentes nunca se comunican directamente;
/// únicamente notifican eventos al Mediator.
protocol ReservationMediator: AnyObject {

    func notify(
        sender: ReservationComponent,
        event: ReservationEvent
    )

}

// MARK: - Base Component

/// Clase base para todos los componentes participantes.
///
/// Cada componente mantiene únicamente una referencia al Mediator,
/// evitando conocer o depender de otros componentes.
class ReservationComponent {

    weak var mediator: ReservationMediator?

    init(mediator: ReservationMediator? = nil) {
        self.mediator = mediator
    }

}

// MARK: - Guest Form

/// Responsable únicamente de administrar la información del huésped.
final class GuestForm: ReservationComponent {

    private(set) var guestName: String?
    private(set) var guestEmail: String?

    /// Actualiza la información del huésped y notifica al Mediator.
    func updateGuestInformation(
        name: String,
        email: String
    ) {

        guestName = name
        guestEmail = email

        print("""
        👤 Guest Information Updated
        Name : \(name)
        Email: \(email)
        """)

        mediator?.notify(
            sender: self,
            event: .guestInformationUpdated
        )

    }

    /// Indica si el formulario contiene toda la información requerida.
    var isCompleted: Bool {

        guestName != nil &&
        guestEmail != nil

    }

}

// MARK: - Stay Date Selector

/// Responsable de administrar las fechas de hospedaje.
final class StayDateSelector: ReservationComponent {

    private(set) var checkInDate: Date?
    private(set) var checkOutDate: Date?

    /// Guarda las fechas seleccionadas y notifica el cambio.
    func selectStayDates(
        checkIn: Date,
        checkOut: Date
    ) {

        checkInDate = checkIn
        checkOutDate = checkOut

        print("""
        📅 Stay Dates Updated
        Check-In : \(checkIn)
        Check-Out: \(checkOut)
        """)

        mediator?.notify(
            sender: self,
            event: .stayDatesUpdated
        )

    }

    /// Indica si ambas fechas fueron seleccionadas.
    var isCompleted: Bool {

        checkInDate != nil &&
        checkOutDate != nil

    }

}

// MARK: - Payment Section

/// Responsable únicamente de administrar la información del pago.
final class PaymentSection: ReservationComponent {

    private(set) var cardHolder: String?
    private(set) var lastFourDigits: String?

    /// Actualiza el método de pago y notifica al Mediator.
    func updatePaymentMethod(
        holder: String,
        lastFourDigits: String
    ) {

        cardHolder = holder
        self.lastFourDigits = lastFourDigits

        print("""
        💳 Payment Updated
        Holder : \(holder)
        Card   : **** \(lastFourDigits)
        """)

        mediator?.notify(
            sender: self,
            event: .paymentUpdated
        )

    }

    /// Indica si existe un método de pago válido.
    var isCompleted: Bool {

        cardHolder != nil &&
        lastFourDigits != nil

    }

}

// MARK: - Confirm Button

/// Representa el botón para confirmar la reservación.
///
/// No conoce el estado del formulario.
/// Únicamente cambia entre habilitado o deshabilitado
/// cuando el Mediator lo indica.
final class ConfirmButton: ReservationComponent {

    private(set) var isEnabled = false

    func setEnabled(_ enabled: Bool) {

        isEnabled = enabled

        print("🟢 Confirm Button: \(enabled ? "Enabled" : "Disabled")")

    }

}

// MARK: - Concrete Mediator

/// Coordina toda la comunicación entre los componentes.
///
/// Es el único objeto que conoce el estado completo
/// del proceso de reservación.
///
/// Los componentes nunca interactúan directamente entre ellos.
final class HotelReservationMediator: ReservationMediator {

    let guestForm: GuestForm
    let stayDates: StayDateSelector
    let paymentSection: PaymentSection
    let confirmButton: ConfirmButton

    init() {

        guestForm = GuestForm()
        stayDates = StayDateSelector()
        paymentSection = PaymentSection()
        confirmButton = ConfirmButton()

        // Se registra este Mediator en todos los componentes.
        guestForm.mediator = self
        stayDates.mediator = self
        paymentSection.mediator = self
        confirmButton.mediator = self

    }

    /// Punto central de comunicación.
    ///
    /// Todos los componentes notifican sus eventos aquí.
    func notify(
        sender: ReservationComponent,
        event: ReservationEvent
    ) {

        switch event {

        case .guestInformationUpdated:
            print("Mediator → Guest information received.")

        case .stayDatesUpdated:
            print("Mediator → Stay dates received.")

        case .paymentUpdated:
            print("Mediator → Payment received.")

        case .confirmReservation:
            confirmReservation()

        }

        validateReservation()

    }

    /// Valida si toda la información requerida
    /// para confirmar la reservación ya fue capturada.
    ///
    /// Si todo está completo, habilita el botón.
    /// En caso contrario, lo mantiene deshabilitado.
    private func validateReservation() {

        let isReady =
            guestForm.isCompleted &&
            stayDates.isCompleted &&
            paymentSection.isCompleted

        confirmButton.setEnabled(isReady)

    }

    /// Simula la confirmación de la reservación.
    private func confirmReservation() {

        guard confirmButton.isEnabled else {

            print("❌ Reservation cannot be confirmed.")

            return

        }

        print("""
        ✅ Reservation Confirmed

        Guest : \(guestForm.guestName ?? "")
        Email : \(guestForm.guestEmail ?? "")
        Card  : **** \(paymentSection.lastFourDigits ?? "")
        """)

    }

}

// MARK: - Client

/// El cliente únicamente interactúa con el Mediator.
/// Nunca comunica directamente un componente con otro.

let mediator = HotelReservationMediator()

mediator.guestForm.updateGuestInformation(
    name: "Osvaldo Cespedes",
    email: "osvaldo@hotel.com"
)

mediator.stayDates.selectStayDates(
    checkIn: .now,
    checkOut: .now.addingTimeInterval(86400 * 5)
)

mediator.paymentSection.updatePaymentMethod(
    holder: "Osvaldo Cespedes",
    lastFourDigits: "4589"
)

mediator.notify(
    sender: mediator.confirmButton,
    event: .confirmReservation
)
