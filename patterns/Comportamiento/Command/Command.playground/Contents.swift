import Foundation

// MARK: - Model

/// Representa una reservación realizada por un huésped.
struct Reservation {

    /// Identificador único de la reservación.
    let id: String

    /// Nombre del huésped.
    let guestName: String

}

// MARK: - Command

/// Define el contrato que deben implementar
/// todos los comandos.
///
/// Un Command representa una acción que puede
/// ejecutarse en cualquier momento.
///
/// El Command NO conoce la lógica del negocio,
/// únicamente sabe cómo invocar al Receiver.
protocol Command {

    /// Ejecuta la acción encapsulada.
    func execute()

}

// MARK: - Receiver

/// Receiver.
///
/// Contiene la lógica real del negocio.
///
/// Los Command delegan la ejecución al Receiver,
/// ya que éste es quien sabe cómo realizar
/// cada operación.
final class HotelServiceManager {

    /// Prepara un pedido de Room Service.
    func prepareRoomService(
        reservation: Reservation
    ) {

        print("""
        🍽 Room Service solicitado

        Reserva:
        \(reservation.id)

        Huésped:
        \(reservation.guestName)

        Preparando alimentos...
        """)

    }

    /// Agenda un servicio de SPA.
    func prepareSpaService(
        reservation: Reservation
    ) {

        print("""
        💆 SPA solicitado

        Reserva:
        \(reservation.id)

        Huésped:
        \(reservation.guestName)

        Preparando experiencia SPA...
        """)

    }

    /// Reserva un Tour.
    func reserveTour(
        reservation: Reservation
    ) {

        print("""
        🚌 Tour solicitado

        Reserva:
        \(reservation.id)

        Huésped:
        \(reservation.guestName)

        Reservando actividad...
        """)

    }

}

// MARK: - Concrete Commands

/// Command encargado de solicitar
/// Room Service.
///
/// Su única responsabilidad es representar
/// la acción y delegar la ejecución
/// al Receiver.
final class RoomServiceCommand: Command {

    /// Receiver encargado de realizar
    /// la lógica del negocio.
    private let receiver: HotelServiceManager

    /// Información necesaria para ejecutar
    /// el comando.
    private let reservation: Reservation

    init(
        receiver: HotelServiceManager,
        reservation: Reservation
    ) {

        self.receiver = receiver
        self.reservation = reservation

    }

    func execute() {

        receiver.prepareRoomService(
            reservation: reservation
        )

    }

}

/// Command encargado de solicitar
/// un servicio de SPA.
final class SpaCommand: Command {

    private let receiver: HotelServiceManager
    private let reservation: Reservation

    init(
        receiver: HotelServiceManager,
        reservation: Reservation
    ) {

        self.receiver = receiver
        self.reservation = reservation

    }

    func execute() {

        receiver.prepareSpaService(
            reservation: reservation
        )

    }

}

/// Command encargado de reservar
/// un Tour.
final class TourCommand: Command {

    private let receiver: HotelServiceManager
    private let reservation: Reservation

    init(
        receiver: HotelServiceManager,
        reservation: Reservation
    ) {

        self.receiver = receiver
        self.reservation = reservation

    }

    func execute() {

        receiver.reserveTour(
            reservation: reservation
        )

    }

}

// MARK: - Invoker

/// Invoker.
///
/// Es el objeto encargado de administrar
/// y ejecutar comandos.
///
/// No conoce la lógica del negocio.
/// No sabe preparar un Room Service,
/// un SPA o un Tour.
///
/// Su única responsabilidad es:
/// - Mantener un Command.
/// - Ejecutar el Command.
/// - Guardar un historial de comandos.
/// - Repetir comandos cuando sea necesario.
final class GuestRequestInvoker {

    /// Command que será ejecutado.
    private var command: Command?

    /// Historial de comandos ejecutados.
    ///
    /// Gracias a que un Command es un objeto,
    /// puede almacenarse para ejecutarse
    /// nuevamente en cualquier momento.
    private var commandHistory: [Command] = []

    /// Asigna el comando actual.
    func setCommand(
        _ command: Command
    ) {

        self.command = command

    }

    /// Ejecuta el comando actual y lo agrega
    /// al historial.
    func executeCommand() {

        guard let command else {
            return
        }

        command.execute()

        commandHistory.append(command)

    }

    /// Muestra el historial de comandos.
    func showHistory() {

        print("""

        ===============================
              COMMAND HISTORY
        ===============================

        """)

        commandHistory.enumerated().forEach { index, command in

            print("\(index + 1). \(type(of: command))")

        }

    }

    /// Ejecuta nuevamente todos los comandos
    /// almacenados en el historial.
    func replayHistory() {

        print("""

        ===============================
             REPLAY COMMAND HISTORY
        ===============================

        """)

        commandHistory.forEach {

            $0.execute()

            print("--------------------------------")

        }

    }

}

// MARK: - Client

/// El cliente crea el Receiver.
let hotelService = HotelServiceManager()

/// El cliente crea la reservación.
let reservation = Reservation(
    id: "PR-2026-0001",
    guestName: "John Doe"
)

/// El cliente crea el Invoker.
let requestInvoker = GuestRequestInvoker()

//------------------------------------------------------
// Room Service
//------------------------------------------------------

let roomServiceCommand = RoomServiceCommand(
    receiver: hotelService,
    reservation: reservation
)

requestInvoker.setCommand(roomServiceCommand)
requestInvoker.executeCommand()

print("\n-----------------------------\n")

//------------------------------------------------------
// SPA
//------------------------------------------------------

let spaCommand = SpaCommand(
    receiver: hotelService,
    reservation: reservation
)

requestInvoker.setCommand(spaCommand)
requestInvoker.executeCommand()

print("\n-----------------------------\n")

//------------------------------------------------------
// Tour
//------------------------------------------------------

let tourCommand = TourCommand(
    receiver: hotelService,
    reservation: reservation
)

requestInvoker.setCommand(tourCommand)
requestInvoker.executeCommand()

//------------------------------------------------------
// Mostrar historial
//------------------------------------------------------

requestInvoker.showHistory()

//------------------------------------------------------
// Repetir historial
//------------------------------------------------------

requestInvoker.replayHistory()

/*
 ===========================================================

                    COMMAND PATTERN

 Cliente

      │

      ▼

 GuestRequestInvoker
      (Invoker)

      │

      ▼

     Command
 (Contrato común)

      ▲
      │
 ┌────┼───────────────┐
 │    │               │
 ▼    ▼               ▼

RoomService      Spa        Tour
 Command       Command    Command

      │
      ▼

HotelServiceManager
    (Receiver)

 ===========================================================

 RESPONSABILIDADES

 Client
 • Crea el Receiver.
 • Crea los Commands.
 • Configura el Invoker.

 Invoker
 • Mantiene un Command.
 • Ejecuta el Command.
 • No conoce la lógica del negocio.

 Command
 • Representa una acción.
 • Define execute().

 Concrete Command
 • Implementa execute().
 • Mantiene una referencia al Receiver.
 • Delega la ejecución.

 Receiver
 • Contiene la lógica del negocio.
 • Sabe cómo ejecutar cada operación.

 ===========================================================

 IDEA PRINCIPAL

 Command convierte una acción en un objeto.

 Esto permite:

 • Desacoplar quien solicita la acción
   de quien la ejecuta.

 • Guardar comandos.

 • Crear historial.

 • Crear colas de ejecución.

 • Implementar Undo / Redo.

 ===========================================================
*/
