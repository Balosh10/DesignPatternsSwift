import Foundation

//==============================================================
// MARK: - ENTITY
//==============================================================

/// Representa una reservación dentro del dominio.
///
/// Una Entity modela un objeto de negocio y contiene únicamente
/// información relevante para el dominio.
///
/// Características:
/// • No depende de UIKit.
/// • No depende de SwiftUI.
/// • No depende de bases de datos.
/// • No depende de servicios web.
/// • Puede utilizarse desde cualquier capa de la aplicación.
///
/// En Clean Architecture las entidades representan el núcleo
/// del negocio y normalmente son las clases más estables.
struct Reservation {

    /// Identificador único de la reservación.
    let id: String

    /// Nombre del huésped.
    let guestName: String

    /// Estado actual de la reservación.
    let status: ReservationStatus

    /// Importe total de la reservación.
    let total: Double
}

//==============================================================
// MARK: - RESERVATION STATUS
//==============================================================

/// Define todos los estados posibles de una reservación.
///
/// Utilizar un enum en lugar de String proporciona:
///
/// • Type Safety.
/// • Autocompletado.
/// • Validaciones más sencillas.
/// • Evita errores de escritura.
///
/// Ejemplo:
///
/// ✅ reservation.status == .pending
///
/// En lugar de:
///
/// ❌ reservation.status == "Pending"
///
enum ReservationStatus: CustomStringConvertible {

    case pending
    case confirmed
    case checkedIn
    case checkedOut
    case cancelled

    /// Representación legible del estado.
    var description: String {

        switch self {

        case .pending:
            return "Pendiente"

        case .confirmed:
            return "Confirmada"

        case .checkedIn:
            return "Check-In"

        case .checkedOut:
            return "Check-Out"

        case .cancelled:
            return "Cancelada"
        }
    }
}

//==============================================================
// MARK: - ERRORS
//==============================================================

/// Define los errores propios del dominio.
///
/// El Interactor utiliza estos errores para indicar
/// que alguna regla de negocio no pudo cumplirse.
///
/// Posteriormente el Presenter decide cómo mostrar
/// estos errores en la interfaz.
enum ReservationError: LocalizedError {

    case invalidGuest
    case invalidStatus
    case invalidAmount
    case paymentFailed
    case reservationNotFound
    case networkError
    case unknown

    var errorDescription: String? {

        switch self {

        case .invalidGuest:
            return "El nombre del huésped es obligatorio."

        case .invalidStatus:
            return "La reservación no se encuentra en un estado válido."

        case .invalidAmount:
            return "El monto debe ser mayor a cero."

        case .paymentFailed:
            return "No fue posible procesar el pago."

        case .reservationNotFound:
            return "No se encontró la reservación."

        case .networkError:
            return "Error de conexión."

        case .unknown:
            return "Ocurrió un error inesperado."
        }
    }
}

//==============================================================
// MARK: - VIEW
//==============================================================

/// Contrato que debe implementar la capa de presentación.
///
/// La View únicamente es responsable de:
///
/// • Mostrar información.
/// • Mostrar estados de carga.
/// • Mostrar mensajes de éxito.
/// • Mostrar mensajes de error.
///
/// Nunca contiene reglas de negocio.
protocol ReservationView: AnyObject {

    /// Muestra un indicador de carga.
    func showLoading()

    /// Oculta el indicador de carga.
    func hideLoading()

    /// Muestra un mensaje de éxito.
    func showSuccess(message: String)

    /// Muestra un mensaje de error.
    func showError(message: String)
}

//==============================================================
// MARK: - REPOSITORY
//==============================================================

/// Define el contrato para acceder a los datos.
///
/// El Interactor desconoce cómo se almacenan
/// o recuperan los datos.
///
/// Una implementación concreta podría utilizar:
///
/// • REST API
/// • GraphQL
/// • Core Data
/// • SQLite
/// • Realm
/// • Firebase
///
/// Gracias a este protocolo el dominio permanece
/// desacoplado de la infraestructura.
protocol ReservationRepository {

    /// Confirma una reservación.
    ///
    /// - Parameter reservation:
    ///     Reservación a confirmar.
    ///
    /// - Throws:
    ///     Error si la operación falla.
    func confirm(
        reservation: Reservation
    ) async throws
}

//==============================================================
// MARK: - SERVICES
//==============================================================

/// Servicio especializado encargado del procesamiento
/// del pago.
///
/// Se mantiene separado del Repository porque representa
/// una responsabilidad completamente distinta.
///
/// Aplicando SRP:
///
/// Repository → Datos
///
/// PaymentService → Pagos
protocol PaymentService {

    /// Procesa el pago de la reservación.
    ///
    /// - Parameter reservation:
    ///     Reservación a pagar.
    ///
    /// - Throws:
    ///     Error cuando el pago no puede completarse.
    func processPayment(
        for reservation: Reservation
    ) async throws
}

//==============================================================
// MARK: - INTERACTOR
//==============================================================

/// Caso de uso encargado de confirmar una reservación.
///
/// Un Interactor representa una única acción del negocio.
///
/// En Clean Architecture cada caso de uso posee
/// su propio Interactor.
///
/// El Presenter invoca este caso de uso y posteriormente
/// recibe el resultado para actualizar la interfaz.
protocol ConfirmReservationInteractor {

    /// Ejecuta el caso de uso Confirmar Reservación.
    ///
    /// Flujo:
    ///
    /// 1. Validar información.
    /// 2. Ejecutar reglas de negocio.
    /// 3. Coordinar servicios.
    /// 4. Coordinar el acceso al Repository.
    /// 5. Devolver la entidad actualizada.
    ///
    /// - Parameter reservation:
    ///     Reservación a confirmar.
    ///
    /// - Returns:
    ///     Reservación actualizada.
    ///
    /// - Throws:
    ///     ReservationError cuando alguna regla
    ///     de negocio no puede cumplirse.
    func execute(
        reservation: Reservation
    ) async throws -> Reservation
}
//==============================================================
// MARK: - INTERACTOR IMPLEMENTATION
//==============================================================

/// Implementación del caso de uso Confirmar Reservación.
///
/// El Interactor representa el corazón de la lógica de negocio.
///
/// Responsabilidades:
///
/// • Validar la información recibida.
/// • Ejecutar las reglas de negocio.
/// • Coordinar los servicios necesarios.
/// • Coordinar el acceso a los datos mediante Repositories.
/// • Devolver el resultado del caso de uso al Presenter.
///
/// No es responsabilidad del Interactor:
///
/// ✗ Mostrar pantallas.
/// ✗ Mostrar alertas.
/// ✗ Navegar entre pantallas.
/// ✗ Consumir URLSession directamente.
/// ✗ Acceder directamente a la base de datos.
/// ✗ Actualizar la interfaz.
///
/// El Interactor únicamente conoce protocolos,
/// nunca implementaciones concretas.
///
/// Esto permite cumplir con el principio
/// Dependency Inversion (DIP).
final class DefaultConfirmReservationInteractor:
ConfirmReservationInteractor {

    //==========================================================
    // MARK: - Dependencies
    //==========================================================

    /// Responsable de persistir o recuperar información.
    ///
    /// El Interactor desconoce si los datos provienen
    /// de una API, una base de datos o un archivo local.
    private let repository: ReservationRepository

    /// Servicio encargado del procesamiento del pago.
    ///
    /// Se inyecta mediante un protocolo para mantener
    /// el desacoplamiento entre capas.
    private let paymentService: PaymentService

    //==========================================================
    // MARK: - Initialization
    //==========================================================

    /// Inicializa el caso de uso.
    ///
    /// - Parameters:
    ///   - repository:
    ///       Responsable del acceso a los datos.
    ///
    ///   - paymentService:
    ///       Responsable del procesamiento del pago.
    init(
        repository: ReservationRepository,
        paymentService: PaymentService
    ) {

        self.repository = repository
        self.paymentService = paymentService
    }

    //==========================================================
    // MARK: - Execute Use Case
    //==========================================================

    /// Ejecuta el caso de uso Confirmar Reservación.
    ///
    /// Flujo del caso de uso:
    ///
    /// 1️⃣ Validar el nombre del huésped.
    ///
    /// 2️⃣ Validar el estado de la reservación.
    ///
    /// 3️⃣ Validar el importe.
    ///
    /// 4️⃣ Procesar el pago.
    ///
    /// 5️⃣ Confirmar la reservación.
    ///
    /// 6️⃣ Devolver la entidad actualizada.
    ///
    /// Si cualquiera de estos pasos falla,
    /// el caso de uso termina lanzando un error.
    ///
    /// - Parameter reservation:
    ///     Reservación que será confirmada.
    ///
    /// - Returns:
    ///     Reservación actualizada con estado
    ///     `.confirmed`.
    ///
    /// - Throws:
    ///     ReservationError cuando alguna regla
    ///     de negocio no puede cumplirse.
    func execute(
        reservation: Reservation
    ) async throws -> Reservation {

        //------------------------------------------------------
        // 1. Validar nombre del huésped
        //------------------------------------------------------

        guard !reservation.guestName.isEmpty else {
            throw ReservationError.invalidGuest
        }

        //------------------------------------------------------
        // 2. Validar estado
        //------------------------------------------------------

        /// Regla de negocio:
        ///
        /// Solamente las reservaciones pendientes
        /// pueden confirmarse.
        guard reservation.status == .pending else {
            throw ReservationError.invalidStatus
        }

        //------------------------------------------------------
        // 3. Validar monto
        //------------------------------------------------------

        /// Regla de negocio:
        ///
        /// No puede procesarse una reservación
        /// cuyo importe sea menor o igual a cero.
        guard reservation.total > 0 else {
            throw ReservationError.invalidAmount
        }

        //------------------------------------------------------
        // 4. Procesar pago
        //------------------------------------------------------

        /// El Interactor coordina el servicio
        /// encargado del pago.
        ///
        /// Observa que el Interactor no conoce
        /// cómo funciona el procesamiento.
        ///
        /// Solamente solicita ejecutar el servicio.
        do {

            try await paymentService.processPayment(
                for: reservation
            )

        } catch {

            throw ReservationError.paymentFailed
        }

        //------------------------------------------------------
        // 5. Confirmar reservación
        //------------------------------------------------------

        /// Después de completar el pago,
        /// el Interactor solicita al Repository
        /// confirmar la reservación.
        ///
        /// Nuevamente, el Interactor desconoce
        /// si la información será enviada
        /// a una API, una base de datos,
        /// Firebase o cualquier otra fuente.
        try await repository.confirm(
            reservation: reservation
        )

        //------------------------------------------------------
        // 6. Devolver resultado
        //------------------------------------------------------

        /// El caso de uso ha finalizado correctamente.
        ///
        /// Se devuelve una nueva entidad con el
        /// estado actualizado.
        ///
        /// El Presenter utilizará esta información
        /// para actualizar la interfaz.
        return Reservation(
            id: reservation.id,
            guestName: reservation.guestName,
            status: .confirmed,
            total: reservation.total
        )
    }
}

//==============================================================
// MARK: - SOLID
//==============================================================

/*
 Principios SOLID aplicados

 ✅ Single Responsibility (SRP)

 El Interactor únicamente ejecuta el caso de uso
 Confirmar Reservación.

 No muestra pantallas.

 No hace navegación.

 No consume APIs directamente.

 No actualiza la interfaz.


 ------------------------------------------------------------


 ✅ Open / Closed (OCP)

 Podemos crear nuevos servicios o nuevos
 Repositories sin modificar esta clase.

 Ejemplo:

 • ApiReservationRepository
 • FirebaseReservationRepository
 • MockReservationRepository


 ------------------------------------------------------------


 ✅ Liskov Substitution (LSP)

 Cualquier implementación que cumpla con:

 ReservationRepository

 o

 PaymentService

 puede utilizarse sin modificar el Interactor.


 ------------------------------------------------------------


 ✅ Interface Segregation (ISP)

 Cada protocolo expone únicamente
 las operaciones necesarias.

 ReservationRepository

 PaymentService

 ConfirmReservationInteractor


 ------------------------------------------------------------


 ✅ Dependency Inversion (DIP)

 El Interactor depende únicamente
 de abstracciones.

 Nunca conoce implementaciones concretas.

 Esto facilita:

 • Testing
 • Mocking
 • Escalabilidad
 • Mantenimiento

*/
 
//==============================================================
// MARK: - PRESENTER
//==============================================================

/// Actúa como intermediario entre la View y el Interactor.
///
/// El Presenter pertenece a la capa de Presentación.
///
/// Su responsabilidad consiste en coordinar la comunicación
/// entre la interfaz de usuario y los casos de uso.
///
/// Responsabilidades:
///
/// • Recibir eventos provenientes de la View.
/// • Ejecutar el caso de uso correspondiente.
/// • Interpretar el resultado del Interactor.
/// • Actualizar la View.
///
/// El Presenter NO debe:
///
/// ✗ Contener reglas de negocio.
/// ✗ Consumir servicios.
/// ✗ Consumir APIs.
/// ✗ Acceder a la base de datos.
///
/// Toda la lógica de negocio debe permanecer
/// dentro del Interactor.
final class ReservationPresenter {

    //==========================================================
    // MARK: - Dependencies
    //==========================================================

    /// Referencia débil para evitar ciclos de retención.
    private weak var view: ReservationView?

    /// Caso de uso encargado de confirmar reservaciones.
    private let interactor: ConfirmReservationInteractor

    //==========================================================
    // MARK: - Initialization
    //==========================================================

    init(
        view: ReservationView,
        interactor: ConfirmReservationInteractor
    ) {

        self.view = view
        self.interactor = interactor
    }

    //==========================================================
    // MARK: - User Actions
    //==========================================================

    /// Evento ejecutado cuando el usuario presiona
    /// el botón Confirmar.
    ///
    /// Flujo:
    ///
    /// View
    ///     ↓
    /// Presenter
    ///     ↓
    /// Interactor
    ///     ↓
    /// PaymentService
    ///     ↓
    /// Repository
    ///     ↓
    /// Presenter
    ///     ↓
    /// View
    func confirmReservation(
        reservation: Reservation
    ) {

        Task {

            //--------------------------------------------------
            // Mostrar indicador de carga
            //--------------------------------------------------

            view?.showLoading()

            do {

                //--------------------------------------------------
                // Ejecutar caso de uso
                //--------------------------------------------------

                let confirmedReservation =
                    try await interactor.execute(
                        reservation: reservation
                    )

                //--------------------------------------------------
                // Actualizar la interfaz
                //--------------------------------------------------

                view?.hideLoading()

                view?.showSuccess(
                    message: """
                    Reservación confirmada.

                    Folio: \(confirmedReservation.id)
                    Huésped: \(confirmedReservation.guestName)
                    Estado: \(confirmedReservation.status)
                    """
                )

            } catch {

                //--------------------------------------------------
                // Mostrar error
                //--------------------------------------------------

                view?.hideLoading()

                view?.showError(
                    message: error.localizedDescription
                )
            }
        }
    }
}

//
//==============================================================
// MARK: - VIEW CONTROLLER (Ejemplo)
//==============================================================

/// Implementación sencilla de la View.
///
/// En una aplicación real podría ser:
///
/// • UIViewController
/// • SwiftUI View + ViewModel
/// • macOS ViewController
///
/// La View únicamente muestra información.
/// Nunca ejecuta lógica de negocio.
final class ReservationViewController: ReservationView {

    private let presenter: ReservationPresenter

    init(
        presenter: ReservationPresenter
    ) {

        self.presenter = presenter
    }

    /// Simula el evento del botón Confirmar.
    func confirmButtonTapped() {

        let reservation = Reservation(
            id: "RSV-1001",
            guestName: "Osvaldo Céspedes",
            status: .pending,
            total: 2500
        )

        presenter.confirmReservation(
            reservation: reservation
        )
    }

    func showLoading() {

        print("⏳ Loading...")
    }

    func hideLoading() {

        print("✅ Hide Loading")
    }

    func showSuccess(
        message: String
    ) {

        print(message)
    }

    func showError(
        message: String
    ) {

        print("❌ \(message)")
    }
}

//
//==============================================================
// MARK: - FLUJO COMPLETO
//==============================================================

/*

                 Usuario
                     │
                     ▼
      Presiona botón "Confirmar"
                     │
                     ▼
        ReservationViewController
                     │
                     ▼
     presenter.confirmReservation()
                     │
                     ▼
          ReservationPresenter
                     │
         view.showLoading()
                     │
                     ▼
 interactor.execute(reservation)
                     │
                     ▼
 DefaultConfirmReservationInteractor
                     │
        ├─────────────────────────────┐
        │                             │
        ▼                             ▼
 Validar información          Procesar pago
                                      │
                                      ▼
                             PaymentService
                                      │
                                      ▼
                              Pago exitoso
                                      │
                                      ▼
                           ReservationRepository
                                      │
                                      ▼
                          Confirmar reservación
                                      │
                                      ▼
                      Reservation(status: .confirmed)
                                      │
                                      ▼
                ReservationPresenter recibe resultado
                                      │
                                      ▼
                    hideLoading()
                                      │
                                      ▼
              showSuccess(reservation)
                                      │
                                      ▼
                 ReservationViewController
                                      │
                                      ▼
               Actualizar la interfaz

*/

//
//==============================================================
// MARK: - RESPONSABILIDADES
//==============================================================

/*

VIEW

• Mostrar información.
• Mostrar Loading.
• Mostrar errores.
• Capturar eventos del usuario.


------------------------------------------------------------


PRESENTER

• Recibir eventos de la View.
• Ejecutar el caso de uso.
• Interpretar resultados.
• Actualizar la View.


------------------------------------------------------------


INTERACTOR

• Ejecutar el caso de uso.
• Validar información.
• Ejecutar reglas de negocio.
• Coordinar servicios.
• Coordinar Repositories.
• Devolver el resultado.


------------------------------------------------------------


PAYMENT SERVICE

• Procesar pagos.


------------------------------------------------------------


REPOSITORY

• Obtener datos.
• Persistir datos.
• Consumir API.
• Acceder a Base de Datos.


------------------------------------------------------------


ENTITY

• Representar el modelo del dominio.
• Contener únicamente información del negocio.

*/
