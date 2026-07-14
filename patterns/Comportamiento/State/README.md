# State Pattern en Swift

## Introducción

El patrón **State** es un patrón de diseño de comportamiento (*Behavioral Pattern*) que permite que un objeto cambie su comportamiento cuando cambia su estado interno.

Su principal objetivo es **encapsular la lógica de cada estado en clases independientes**, evitando el uso excesivo de `if` o `switch`.

---

## Problema

Supongamos una reserva de hotel con los siguientes estados:

```text
Reserved
Checked-In
Checked-Out
```

Una implementación tradicional podría verse así:

```swift
if reservation.status == .reserved {
    // Check-In
} else if reservation.status == .checkedIn {
    // Check-Out
} else {
    // No hacer nada
}
```

A medida que aumentan los estados y las reglas de negocio, este código se vuelve difícil de mantener.

---

## Solución

Con el patrón **State**, cada estado conoce:

- Qué acciones están permitidas.
- Qué acciones están bloqueadas.
- A qué estado puede transicionar.

```text
Reserved
    │
    ▼
Checked-In
    │
    ▼
Checked-Out
```

Cada estado implementa la misma interfaz, pero con un comportamiento diferente.

---

# Estructura

```text
                    ReservationContext
                            │
                            ▼
                  ReservationState (Protocol)
                    ▲        ▲        ▲
                    │        │        │
          ReservedState  CheckedInState  CheckedOutState
```

---

## Componentes

### ReservationContext

Representa la reserva.

Su única responsabilidad es mantener el estado actual y delegar las acciones.

```swift
reservation.checkIn()
reservation.checkOut()
reservation.cancel()
```

El contexto **no conoce las reglas de negocio**.

---

### ReservationState

Es el contrato que todos los estados deben implementar.

```swift
protocol ReservationState {

    var name: String { get }

    func checkIn(context: ReservationContext)

    func checkOut(context: ReservationContext)

    func cancel(context: ReservationContext)
}
```

---

### Estados Concretos

Cada estado implementa la lógica correspondiente.

**Reserved**

Permite:

- ✅ Check-In
- ✅ Cancelar

Bloquea:

- ❌ Check-Out

---

**Checked-In**

Permite:

- ✅ Check-Out

Bloquea:

- ❌ Check-In
- ❌ Cancelar

---

**Checked-Out**

No permite ninguna acción adicional.

---

# Flujo

```text
                Check-In             Check-Out

 Reserved ----------------> Checked-In ----------------> Checked-Out
```

Las transiciones inválidas son bloqueadas automáticamente.

Por ejemplo:

```text
❌ Reserved → Checked-Out

❌ Checked-Out → Checked-In

❌ Checked-Out → Reserved
```

---

# Ejemplo

```swift
let reservation = ReservationContext(
    reservationNumber: "VL-2026-0001",
    guestName: "John Doe"
)

reservation.currentStatus()

reservation.checkIn()

reservation.currentStatus()

reservation.checkOut()

reservation.currentStatus()
```

Salida:

```text
Estado actual: Reserved

✅ Check-In realizado

Estado actual: Checked-In

✅ Check-Out realizado

Estado actual: Checked-Out
```

---

# Ventajas

- Elimina grandes bloques de `if` y `switch`.
- Cada estado encapsula su propia lógica.
- Facilita el mantenimiento del código.
- Permite agregar nuevos estados fácilmente.
- Garantiza transiciones válidas.
- Mejora la legibilidad y reutilización.

---

# Desventajas

- Incrementa el número de clases.
- Puede ser excesivo para flujos muy simples.
- Requiere comprender bien las transiciones entre estados.

---

# Principios SOLID aplicados

## S — Single Responsibility Principle

Cada estado tiene una única responsabilidad.

```text
ReservedState
CheckedInState
CheckedOutState
```

Cada clase administra únicamente la lógica de su estado.

---

## O — Open/Closed Principle

Es posible agregar nuevos estados sin modificar los existentes.

Ejemplo:

```text
PendingPaymentState
NoShowState
CancelledState
```

Solo se crea una nueva clase que implemente `ReservationState`.

---

## L — Liskov Substitution Principle

El contexto trabaja con la abstracción.

```swift
var state: ReservationState
```

Puede recibir cualquier implementación del protocolo.

---

## I — Interface Segregation Principle

Todos los estados implementan únicamente las operaciones necesarias mediante un protocolo pequeño y específico.

---

## D — Dependency Inversion Principle

El contexto depende de la abstracción.

```swift
ReservationState
```

No depende directamente de:

- ReservedState
- CheckedInState
- CheckedOutState

---

# ¿Cuándo utilizar State?

Utiliza este patrón cuando:

- Un objeto tiene múltiples estados.
- El comportamiento cambia según el estado actual.
- Existen muchas validaciones mediante `if` o `switch`.
- Se desea controlar las transiciones entre estados.

Ejemplos:

- Reservas de hotel
- Pedidos de comida
- Reproductores multimedia
- Máquinas expendedoras
- Procesos de aprobación
- Estados de autenticación
- Descargas de archivos

---

# Conclusión

El patrón **State** permite modelar el comportamiento de un objeto de forma limpia y mantenible.

En lugar de centralizar todas las reglas en una sola clase, cada estado encapsula su propio comportamiento y controla las transiciones permitidas, haciendo que el código sea más fácil de extender, probar y mantener.