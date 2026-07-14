# Strategy Design Pattern (Patrón Estrategia)

## Introducción

**Strategy** es un patrón de diseño de comportamiento que permite definir una familia de algoritmos, encapsular cada algoritmo en una clase independiente y hacerlos intercambiables durante la ejecución.

La idea principal del patrón es:

> **Mantener una responsabilidad, pero permitir cambiar el proveedor encargado de ejecutarla.**

En otras palabras:

- La tarea no cambia.
- El contrato no cambia.
- La implementación puede cambiar.

---

# ¿Qué problema resuelve?

Supongamos una aplicación de reservas de hotel donde un huésped puede realizar un pago utilizando diferentes métodos:

- Tarjeta de crédito.
- Apple Pay.
- Transferencia bancaria.
- PayPal.
- Mercado Pago.

Una implementación tradicional podría ser:

```swift
func processPayment(
    type: PaymentType,
    amount: Double
) {

    switch type {

    case .creditCard:

        // Procesar tarjeta

    case .applePay:

        // Procesar Apple Pay

    case .bankTransfer:

        // Procesar transferencia

    }

}
```

## Problemas de esta implementación

Cada vez que aparece un nuevo proveedor:

```text
PayPal

Google Pay

Mercado Pago
```

es necesario modificar la lógica existente.

Esto genera:

- Código difícil de mantener.
- Clases con demasiadas responsabilidades.
- Alto acoplamiento.
- Violación del principio Open/Closed Principle.

---

# Solución con Strategy

Strategy propone separar cada algoritmo en una clase independiente.

Cada proveedor implementa un contrato común.

```text
                    PaymentStrategy
                          |
                          |
          ---------------------------------
          |               |               |
          ▼               ▼               ▼

   CreditCard      ApplePayment    BankTransfer
    Strategy        Strategy          Strategy
```

El objeto que utiliza la estrategia no sabe cómo se ejecuta el proceso.

Solo sabe que existe un proveedor capaz de realizarlo.

---

# Conceptos principales

## Context

Es el objeto que utiliza una estrategia.

En nuestro ejemplo:

```text
PaymentProcessor
```

Su responsabilidad es:

- Mantener una estrategia.
- Ejecutar la estrategia.
- Permitir cambiar la estrategia.

No debe conocer detalles de implementación.

---

## Strategy

Es el contrato común.

Define qué operación debe realizar cualquier estrategia.

Ejemplo:

```swift
protocol PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    )

}
```

---

## Concrete Strategy

Son las implementaciones reales.

Cada una representa una forma diferente de ejecutar la misma operación.

Ejemplo:

```text
CreditCardStrategy

ApplePaymentStrategy

BankTransferStrategy
```

---

# Ejemplo del proyecto

## Escenario

Una aplicación de reservaciones necesita procesar pagos.

La responsabilidad es:

```
Procesar pago
```

Pero existen diferentes proveedores.

```text
                    PaymentProcessor
                          |
                          |
                    PaymentStrategy
                          |
        ---------------------------------
        |               |               |
        ▼               ▼               ▼

    Tarjeta        Apple Pay       Transferencia
```

---

# Implementación

## Modelo Reservation

Representa la información de la reserva.

```swift
struct Reservation {

    let id: String
    let guestName: String

}
```

---

# Strategy Protocol

Define el contrato que deben cumplir todos los proveedores.

```swift
protocol PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    )

}
```

El Context solamente conoce este contrato.

No conoce:

- Tarjeta.
- Apple Pay.
- Transferencia.

---

# CreditCardStrategy

Implementación para pagos con tarjeta.

```swift
final class CreditCardStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print(
            "Processing \(amount) for \(reservation.guestName) via CreditCard"
        )

    }

}
```

---

# ApplePaymentStrategy

Implementación para Apple Pay.

```swift
final class ApplePaymentStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print(
            "Processing \(amount) for \(reservation.guestName) via ApplePay"
        )

    }

}
```

---

# BankTransferStrategy

Implementación para transferencia bancaria.

```swift
final class BankTransferStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print(
            "Processing \(amount) for \(reservation.guestName) via BankTransfer"
        )

    }

}
```

---

# Context: PaymentProcessor

Es el objeto que utiliza la estrategia.

```swift
final class PaymentProcessor {

    private var strategy: PaymentStrategy

    init(strategy: PaymentStrategy) {

        self.strategy = strategy

    }


    func setStrategy(
        _ strategy: PaymentStrategy
    ) {

        self.strategy = strategy

    }


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
```

---

# ¿Qué responsabilidad tiene PaymentProcessor?

PaymentProcessor NO procesa pagos.

No sabe:

- Cómo funciona una tarjeta.
- Cómo funciona Apple Pay.
- Cómo funciona una transferencia.

Su única responsabilidad es:

```
Delegar la ejecución al proveedor actual.
```

---

# Ejecución

Creamos una reserva:

```swift
let reservation = Reservation(
    id: "PR-2026-001",
    guestName: "Osvaldo Céspedes"
)
```

---

## Primera estrategia

Seleccionamos transferencia:

```swift
let paymentProcessor = PaymentProcessor(
    strategy: BankTransferStrategy()
)
```

Flujo:

```text
PaymentProcessor

        |

        ▼

BankTransferStrategy
```

Ejecutamos:

```swift
paymentProcessor.processPayment(
    amount: 3500,
    reservation: reservation
)
```

Resultado:

```
Processing 3500 for Osvaldo Céspedes via BankTransfer
```

---

## Cambiando estrategia

Ahora el usuario decide pagar con Apple Pay.

```swift
paymentProcessor.setStrategy(
    ApplePaymentStrategy()
)
```

Nuevo flujo:

```text
PaymentProcessor

        |

        ▼

ApplePaymentStrategy
```

Ejecutamos:

```swift
paymentProcessor.processPayment(
    amount: 2500,
    reservation: reservation
)
```

Resultado:

```
Processing 2500 for Osvaldo Céspedes via ApplePay
```

---

# Punto importante

El objeto `PaymentProcessor` nunca cambió.

Antes:

```text
PaymentProcessor

↓

BankTransferStrategy
```

Después:

```text
PaymentProcessor

↓

ApplePaymentStrategy
```

Solo cambió el proveedor encargado de ejecutar la responsabilidad.

---

# ¿Por qué usar protocolos?

Porque permiten trabajar con abstracciones.

PaymentProcessor depende de:

```swift
PaymentStrategy
```

No depende de:

```swift
CreditCardStrategy
```

```swift
ApplePaymentStrategy
```

```swift
BankTransferStrategy
```

Esto permite agregar nuevas estrategias sin modificar el Context.

---

# Agregar un nuevo proveedor

Supongamos que necesitamos PayPal.

Creamos una nueva estrategia:

```swift
final class PayPalStrategy: PaymentStrategy {

    func processPayment(
        amount: Double,
        reservation: Reservation
    ) {

        print("Processing PayPal")

    }

}
```

Ahora podemos utilizarla:

```swift
paymentProcessor.setStrategy(
    PayPalStrategy()
)
```

No modificamos:

```text
PaymentProcessor
```

No modificamos:

```text
PaymentStrategy
```

Solo agregamos una nueva implementación.

---

# Principios SOLID

## Open / Closed Principle

Strategy cumple:

> Las clases deben estar abiertas para extensión, pero cerradas para modificación.

Agregar nuevas estrategias no requiere modificar código existente.

---

## Dependency Inversion Principle

El Context depende de una abstracción:

```swift
PaymentStrategy
```

No depende de implementaciones concretas.

---

# Strategy vs Observer

Aunque ambos utilizan protocolos, resuelven problemas diferentes.

## Observer

Pregunta:

```
¿Quién necesita enterarse cuando algo cambia?
```

Ejemplo:

```
Reservation

       |

notify()

       |

Restaurant
SPA
Tours
```

Tiene múltiples receptores.

---

## Strategy

Pregunta:

```
¿Qué proveedor ejecutará esta tarea?
```

Ejemplo:

```
PaymentProcessor

       |

ApplePaymentStrategy
```

Tiene una implementación activa.

---

# Strategy vs Delegate

Son similares porque ambos utilizan protocolos.

## Delegate

Delega una responsabilidad.

Ejemplo:

```swift
tableView.delegate = self
```

Pregunta:

```
¿Quién decide cómo responder?
```

---

## Strategy

Cambia un algoritmo.

Pregunta:

```
¿Cómo se debe ejecutar esta operación?
```

---

# Strategy vs State

Son patrones muy parecidos estructuralmente.

Ambos utilizan:

```
Context

↓

Protocol

↓

Implementaciones
```

Pero tienen diferente intención.

## Strategy

El cliente selecciona la estrategia.

Ejemplo:

```
Usuario selecciona Apple Pay
```

---

## State

El propio objeto cambia su comportamiento dependiendo de su estado.

Ejemplo:

```
Reservation

Reserved

CheckedIn

CheckedOut
```

---

# Casos de uso en iOS

## URLSessionConfiguration

Apple utiliza una idea similar:

```swift
URLSessionConfiguration.default

URLSessionConfiguration.background

URLSessionConfiguration.ephemeral
```

Cada configuración representa una estrategia diferente.

---

## JSONEncoder

Cambio de estrategia para fechas:

```swift
encoder.dateEncodingStrategy
```

Ejemplos:

```swift
.iso8601

.secondsSince1970

.formatted
```

---

## Ordenamiento

Una colección puede ordenarse usando diferentes estrategias:

```text
Ordenar por nombre

Ordenar por fecha

Ordenar por precio
```

---

# Ventajas

✅ Reduce acoplamiento.

✅ Facilita agregar nuevos comportamientos.

✅ Evita grandes bloques de condiciones.

✅ Permite cambiar comportamiento en tiempo de ejecución.

✅ Facilita pruebas unitarias.

---

# Desventajas

❌ Aumenta el número de clases.

❌ Puede ser excesivo para problemas simples.

❌ Requiere identificar correctamente qué comportamiento debe variar.

---

# Conclusión

El patrón **Strategy** permite encapsular diferentes formas de realizar una misma responsabilidad.

En este ejemplo:

| Elemento | Responsabilidad |
|---|---|
| PaymentProcessor | Ejecuta la estrategia |
| PaymentStrategy | Define el contrato |
| CreditCardStrategy | Pago con tarjeta |
| ApplePaymentStrategy | Pago con Apple Pay |
| BankTransferStrategy | Pago por transferencia |

La idea principal es:

> **La responsabilidad permanece igual, pero el proveedor encargado de ejecutarla puede cambiar en cualquier momento.**

Strategy es especialmente útil cuando una aplicación tiene diferentes proveedores, algoritmos o reglas de negocio que pueden variar sin querer modificar la lógica principal.