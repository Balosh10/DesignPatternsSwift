import Foundation

/// Representa el protocolo base de todos los elementos que pueden ser visitados.
///
/// En el patrón Visitor este protocolo corresponde al **Element**.
///
/// Su única responsabilidad es aceptar un Visitor para que ejecute
/// una operación sobre la instancia concreta.
///
/// El Element no conoce qué operación realizará el Visitor,
/// simplemente le permite "entrar".
protocol Reservation {

    /// Permite que un Visitor procese la reservación.
    ///
    /// - Parameter visitor:
    ///   Objeto que ejecutará una operación sobre la reservación.
    func accept(visitor: ReservationVisitor)
}

/// Define todas las operaciones que pueden realizarse
/// sobre cada tipo de reservación.
///
/// Corresponde al **Visitor** dentro del patrón.
///
/// Cada nuevo tipo de reservación requiere agregar
/// un nuevo método visit().
protocol ReservationVisitor {

    /// Procesa una reservación Palace.
    func visit(_ reservation: PalaceReservation)

    /// Procesa una reservación Le Blanc.
    func visit(_ reservation: LeBlancReservation)
}

/// Representa una reservación del hotel Palace Resorts.
///
/// Corresponde al **Concrete Element**.
final class PalaceReservation: Reservation {

    /// Nombre del huésped.
    let guestName: String

    /// Número de reservación.
    let reservationNumber: String

    /// Total de la reservación.
    let total: Double

    init(
        guestName: String,
        reservationNumber: String,
        total: Double
    ) {
        self.guestName = guestName
        self.reservationNumber = reservationNumber
        self.total = total
    }

    /// Permite que un Visitor procese esta reservación.
    ///
    /// Aquí ocurre el primer paso del Double Dispatch.
    func accept(visitor: ReservationVisitor) {
        visitor.visit(self)
    }
}

/// Representa una reservación del hotel Le Blanc.
///
/// También corresponde a un Concrete Element.
final class LeBlancReservation: Reservation {

    let guestName: String

    let reservationNumber: String

    let total: Double

    init(
        guestName: String,
        reservationNumber: String,
        total: Double
    ) {
        self.guestName = guestName
        self.reservationNumber = reservationNumber
        self.total = total
    }

    /// Permite que el Visitor procese esta reservación.
    func accept(visitor: ReservationVisitor) {
        visitor.visit(self)
    }
}

/// Visitor encargado de calcular impuestos.
///
/// Cada tipo de reservación puede tener
/// reglas fiscales diferentes.
final class TaxVisitor: ReservationVisitor {

    func visit(_ reservation: PalaceReservation) {

        let taxes = reservation.total * 0.16

        print("""
        -------------------------
        Palace Resorts
        Guest: \(reservation.guestName)
        Reservation: \(reservation.reservationNumber)
        Total: \(reservation.total)
        Taxes: \(taxes)
        -------------------------
        """)
    }

    func visit(_ reservation: LeBlancReservation) {

        let taxes = reservation.total * 0.18

        print("""
        -------------------------
        Le Blanc
        Guest: \(reservation.guestName)
        Reservation: \(reservation.reservationNumber)
        Total: \(reservation.total)
        Taxes: \(taxes)
        -------------------------
        """)
    }
}

/// Visitor encargado de generar documentos PDF.
///
/// Observa que las clases Reservation no contienen
/// ninguna lógica relacionada con PDF.
final class PDFVisitor: ReservationVisitor {

    func visit(_ reservation: PalaceReservation) {

        print("""
        Generando PDF Palace...

        Guest:
        \(reservation.guestName)

        Reservation:
        \(reservation.reservationNumber)
        """)
    }

    func visit(_ reservation: LeBlancReservation) {

        print("""
        Generando PDF Le Blanc...

        Guest:
        \(reservation.guestName)

        Reservation:
        \(reservation.reservationNumber)
        """)
    }
}

/// Ejemplo completo del patrón Visitor.
///
/// Este archivo simula el flujo de una aplicación
/// que necesita ejecutar distintas operaciones
/// sobre el mismo conjunto de reservaciones.
struct VisitorExample {

    static func run() {

        //----------------------------------------------------
        // Se crean distintas reservaciones.
        //----------------------------------------------------

        let reservations: [Reservation] = [

            PalaceReservation(
                guestName: "Carlos López",
                reservationNumber: "PAL-1001",
                total: 3000
            ),

            LeBlancReservation(
                guestName: "María García",
                reservationNumber: "LB-2020",
                total: 5000
            )
        ]

        //----------------------------------------------------
        // Primer Visitor.
        //----------------------------------------------------

        let taxVisitor = TaxVisitor()

        print("======== TAX VISITOR ========")

        reservations.forEach {

            $0.accept(visitor: taxVisitor)
        }

        //----------------------------------------------------
        // Segundo Visitor.
        //----------------------------------------------------

        let pdfVisitor = PDFVisitor()

        print("======== PDF VISITOR ========")

        reservations.forEach {

            $0.accept(visitor: pdfVisitor)
        }
    }
}
