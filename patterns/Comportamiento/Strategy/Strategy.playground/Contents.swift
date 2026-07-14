import Foundation

// MARK: - Model

/// Representa la información de una reserva.
///
/// En este ejemplo únicamente se utilizan
/// el identificador y el nombre del huésped.
struct Reservation {

    let id: String
    let guestName: String

}

// MARK: - Strategy

/// Define el contrato que deben implementar
/// todos los algoritmos de pago.
///
/// Cada estrategia conoce la forma en la que
/// debe procesar un pago.
///
/// El Context únicamente conoce este contrato,
/// nunca las implementaciones concretas.
protocol PaymentStrategy {

    /// Procesa el pago utilizando
    /// la estrategia correspondiente.
    func processPayment(
        amount: Double,
        reservation: Reservation
    )

}

// MARK: - Credit Card Strategy

/// Estrategia para procesar pagos
/// mediante tarjeta de crédito.
final class CreditCardStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print("""
        💳 Credit Card

        Reservation: \(reservation.id)

        Guest: \(reservation.guestName)

        Amount: $\(amount)
        """)

    }

}

// MARK: - Apple Pay Strategy

/// Estrategia para procesar pagos
/// mediante Apple Pay.
final class ApplePaymentStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print("""
        📱 Apple Pay

        Reservation: \(reservation.id)

        Guest: \(reservation.guestName)

        Amount: $\(amount)
        """)

    }

}

// MARK: - Bank Transfer Strategy

/// Estrategia para procesar pagos
/// mediante transferencia bancaria.
final class BankTransferStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print("""
        🏦 Bank Transfer

        Reservation: \(reservation.id)

        Guest: \(reservation.guestName)

        Amount: $\(amount)
        """)

    }

}

// MARK: - Context

/// Context del patrón Strategy.
///
/// Su responsabilidad es:
///
/// - Mantener una estrategia.
/// - Permitir cambiar la estrategia.
/// - Delegar la ejecución del algoritmo.
///
/// El Context nunca conoce la implementación
/// concreta del algoritmo.
final class PaymentProcessor {

    /// Estrategia utilizada para procesar
    /// el pago actual.
    private var strategy: PaymentStrategy

    init(strategy: PaymentStrategy) {

        self.strategy = strategy

    }

    /// Permite cambiar la estrategia
    /// durante la ejecución.
    func setStrategy(_ strategy: PaymentStrategy) {

        self.strategy = strategy

    }

    /// Delega el procesamiento del pago
    /// a la estrategia seleccionada.
    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        strategy.processPayment(
            amount: amount,
            reservation: reservation
        )

    }

}

// MARK: - Client

/// El cliente crea la estrategia inicial
/// y la inyecta al Context.
///
/// El Context trabajará únicamente
/// con el contrato PaymentStrategy.
let reservation = Reservation(
    id: "PR-2026-001",
    guestName: "Osvaldo Céspedes Hernández"
)

let paymentProcessor = PaymentProcessor(
    strategy: BankTransferStrategy()
)

paymentProcessor.processPayment(
    amount: 3500,
    reservation: reservation
)

/// La estrategia puede cambiar
/// durante la ejecución sin modificar
/// el Context.
paymentProcessor.setStrategy(
    ApplePaymentStrategy()
)

paymentProcessor.processPayment(
    amount: 2500,
    reservation: reservation
)

/*
 ----------------------------------------------------------------

                    Strategy Pattern

                 PaymentProcessor
                    (Context)
                        │
                        ▼
               PaymentStrategy
                        ▲
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
 CreditCard      ApplePay        BankTransfer

 ----------------------------------------------------------------

 Context

 Responsabilidades

 • Mantener una estrategia.
 • Permitir cambiar la estrategia.
 • Delegar la ejecución.

 Nunca conoce las implementaciones concretas.

 ----------------------------------------------------------------

 Strategy

 Define el contrato común para todos
 los algoritmos.

 ----------------------------------------------------------------

 Concrete Strategy

 Implementan el algoritmo específico.

 • CreditCardStrategy
 • ApplePaymentStrategy
 • BankTransferStrategy

 ----------------------------------------------------------------

 Beneficios

 • Bajo acoplamiento.
 • Algoritmos intercambiables.
 • Cumple Open/Closed Principle.
 • Evita grandes estructuras if/switch.

 ----------------------------------------------------------------
*/
