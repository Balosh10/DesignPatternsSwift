import Foundation

// MARK: - Reservation Status

/// Representa los posibles estados de una reserva.
enum ReservationStatus: String {
    case reserved
    case checkedIn
    case checkedOut
}

// MARK: - Reservation

/// Modelo de una reserva.
///
/// Este es el objeto observado (Observable State).
/// Cuando alguna de sus propiedades cambia, en este caso `status`,
/// el Subject notificará a todos los observadores registrados.
struct Reservation {

    let id: String
    let guestName: String
    var status: ReservationStatus

}

// MARK: - Observer

/// Define el contrato que deben implementar todos los
/// objetos interesados en recibir cambios de una reserva.
///
/// Se restringe a `AnyObject` para permitir almacenar
/// referencias débiles (`weak`) dentro de `WeakObserver`.
///
/// Cualquier clase que implemente este protocolo puede
/// registrarse como observador.
protocol ReservationObserver: AnyObject {

    /// Se ejecuta cuando cambia el estado de la reserva.
    func reservationDidUpdate(_ reservation: Reservation)

}

// MARK: - Subject

/// Define las responsabilidades del Subject.
///
/// El Subject administra el ciclo de vida
/// de los observadores.
///
/// Responsabilidades:
/// - Registrar observadores.
/// - Eliminar observadores.
/// - Notificar cambios.
///
/// El Subject NO conoce implementaciones concretas.
/// Únicamente conoce el contrato `ReservationObserver`.
protocol ReservationSubject: AnyObject {

    /// Registra un nuevo observador.
    func addObserver(_ observer: ReservationObserver)

    /// Elimina un observador.
    func removeObserver(_ observer: ReservationObserver)

    /// Notifica el cambio a todos los observadores.
    func notifyObservers()

}

// MARK: - Weak Observer

/// Wrapper que envuelve al observador utilizando
/// una referencia débil (`weak`).
///
/// ¿Por qué existe?
///
/// Swift no permite crear un Array de referencias
/// débiles directamente.
///
/// El Array mantiene referencias fuertes a sus elementos.
/// Este wrapper permite que el Subject conserve
/// referencias débiles hacia los observadores.
///
/// Cuando un observador es liberado de memoria,
/// la propiedad `observer` automáticamente será `nil`.
final class WeakObserver {

    weak var observer: ReservationObserver?

    init(_ observer: ReservationObserver) {
        self.observer = observer
    }

}

// MARK: - Reservation Manager (Subject)

/// Subject encargado de administrar la reserva.
///
/// Cuando cambia el estado de la reserva,
/// notifica automáticamente a todos
/// los observadores registrados.
final class ReservationManager: ReservationSubject {

    /// Objeto observado.
    private var reservation: Reservation

    /// Lista de observadores registrados.
    ///
    /// El Array mantiene referencias fuertes
    /// hacia los wrappers.
    ///
    /// Cada wrapper mantiene una referencia
    /// débil (`weak`) hacia el observador real.
    private var observers: [WeakObserver] = []

    init(reservation: Reservation) {
        self.reservation = reservation
    }

    // MARK: - Observer Management

    func addObserver(_ observer: ReservationObserver) {

        /// El Subject únicamente conoce el protocolo
        /// ReservationObserver.
        ///
        /// No sabe si está registrando:
        ///
        /// - RestaurantService
        /// - SpaService
        /// - ToursService
        /// - AnalyticsService
        /// - NotificationService
        ///
        /// Solo sabe que cumple el contrato.
        observers.append(
            WeakObserver(observer)
        )

    }

    func removeObserver(_ observer: ReservationObserver) {

        observers.removeAll {

            /// === compara identidad.
            ///
            /// Verifica que ambas referencias
            /// apunten exactamente al mismo objeto
            /// en memoria.
            ///
            /// No usamos == porque queremos eliminar
            /// la misma instancia registrada.
            $0.observer === observer

        }

    }

    // MARK: - Notifications

    func notifyObservers() {

        /// Si algún observador ya fue liberado
        /// de memoria, la referencia weak
        /// será automáticamente nil.
        ///
        /// Eliminamos esos registros para
        /// mantener limpia la colección.
        observers.removeAll {

            $0.observer == nil

        }

        /// El Subject solamente conoce
        /// el contrato ReservationObserver.
        ///
        /// No conoce la implementación concreta
        /// de cada observador.
        observers.forEach {

            $0.observer?.reservationDidUpdate(reservation)

        }

    }

    // MARK: - Reservation

    /// Actualiza el estado de la reserva.
    ///
    /// El Subject detecta el cambio
    /// y posteriormente notifica
    /// a todos los observadores.
    func updateReservationStatus(_ status: ReservationStatus) {

        reservation.status = status

        print("\n===================================")
        print("📢 Estado actualizado: \(status.rawValue)")
        print("===================================\n")

        notifyObservers()

    }

}

// MARK: - Restaurant

/// Observador.
///
/// Decide cómo reaccionar cuando cambia
/// el estado de la reserva.
final class RestaurantService: ReservationObserver {

    func reservationDidUpdate(_ reservation: Reservation) {

        switch reservation.status {

        case .reserved:
            print("🍽 Restaurant -> Preparando disponibilidad")

        case .checkedIn:
            print("🍽 Restaurant -> Habilitar reservas")

        case .checkedOut:
            print("🍽 Restaurant -> Deshabilitar reservas")

        }

    }

}

// MARK: - SPA

/// Observador.
final class SpaService: ReservationObserver {

    func reservationDidUpdate(_ reservation: Reservation) {

        switch reservation.status {

        case .reserved:
            print("💆 SPA -> Preparando promociones")

        case .checkedIn:
            print("💆 SPA -> Habilitar servicios")

        case .checkedOut:
            print("💆 SPA -> Finalizar servicios")

        }

    }

}

// MARK: - Tours

/// Observador.
final class ToursService: ReservationObserver {

    func reservationDidUpdate(_ reservation: Reservation) {

        switch reservation.status {

        case .reserved:
            print("🚌 Tours -> Preparando excursiones")

        case .checkedIn:
            print("🚌 Tours -> Mostrar tours disponibles")

        case .checkedOut:
            print("🚌 Tours -> Cerrar servicios")

        }

    }

}

// MARK: - Client

/// El cliente crea los observadores.
///
/// Posteriormente los registra dentro del Subject.
///
/// A partir de este momento,
/// cualquier cambio en la reserva
/// será notificado automáticamente.
let reservation = Reservation(
    id: "PR-2026-001",
    guestName: "Osvaldo Céspedes",
    status: .reserved
)

let reservationManager = ReservationManager(
    reservation: reservation
)

let restaurant = RestaurantService()
let spa = SpaService()
let tours = ToursService()

reservationManager.addObserver(restaurant)
reservationManager.addObserver(spa)
reservationManager.addObserver(tours)

// Reserva creada.
reservationManager.updateReservationStatus(.reserved)

// Check-In.
reservationManager.updateReservationStatus(.checkedIn)

// Check-Out.
reservationManager.updateReservationStatus(.checkedOut)

/*
 --------------------------------------------------------------------

                    Observer Pattern

               Reservation (Objeto observado)
                         │
                  status cambia
                         │
                         ▼
            ReservationManager (Subject)
                         │
                  notifyObservers()
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
   Restaurant      SpaService     ToursService
      Observer        Observer         Observer

 --------------------------------------------------------------------

 El Subject tiene tres responsabilidades:

 1. Registrar observadores.
 2. Eliminar observadores.
 3. Notificar cambios.

 El Subject trabaja únicamente con el protocolo
 ReservationObserver.

 Nunca conoce implementaciones concretas.

 Los Observers son responsables de decidir
 cómo reaccionar al cambio de estado.

 Gracias a este desacoplamiento es posible agregar
 nuevos observadores sin modificar el Subject,
 cumpliendo con el principio Open/Closed (OCP).

 --------------------------------------------------------------------
*/
