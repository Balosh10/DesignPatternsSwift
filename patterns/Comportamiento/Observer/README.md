# Observer

## ¿Qué es?

El patrón **Observer** es un patrón de comportamiento que define una dependencia **uno a muchos** entre objetos.

Cuando el estado de un objeto cambia, todos los objetos interesados (observadores) son notificados automáticamente para que reaccionen al cambio.

Su principal objetivo es **desacoplar** al objeto que genera el cambio de los objetos que responden a ese cambio.

---

# Problema

Supongamos que una reserva cambia de estado.

Cuando un huésped realiza un **Check-In**, diferentes módulos del sistema necesitan actualizarse:

- Restaurant
- SPA
- Tours
- Analytics
- Room Service

Una implementación sin Observer sería:

```swift
restaurant.enable()

spa.enable()

tours.enable()

analytics.track()

roomService.enable()
```

Cada vez que se agregue un nuevo módulo será necesario modificar la clase que administra la reserva.

Esto provoca:

- Alto acoplamiento.
- Difícil mantenimiento.
- Violación del principio **Open/Closed**.

---

# Solución

Observer introduce un **Subject** que administra una lista de observadores.

Cuando ocurre un cambio en la reserva, el Subject únicamente notifica el evento.

Cada observador decide cómo reaccionar.

```text
Reservation

↓

Status cambia

↓

ReservationManager

↓

notifyObservers()

↓

Restaurant

SPA

Tours

Analytics
```

El Subject no conoce la implementación de los observadores.

Únicamente conoce el contrato que todos implementan.

---

# Estructura

```text
                 +-----------------------+
                 | ReservationManager    |
                 |      (Subject)        |
                 +-----------------------+
                 | addObserver()         |
                 | removeObserver()      |
                 | notifyObservers()     |
                 +-----------+-----------+
                             |
        --------------------------------------------
        |                  |                       |
        ▼                  ▼                       ▼
+----------------+ +----------------+ +----------------+
| Restaurant     | | SPA            | | Tours          |
|   Observer     | |   Observer     | |   Observer     |
+----------------+ +----------------+ +----------------+
```

---

# Participantes

## Reservation

Es el objeto observado.

Contiene el estado de la reserva.

```swift
struct Reservation {

    let id: String
    let guestName: String
    var status: ReservationStatus

}
```

Cuando cambia `status`, el Subject notificará a todos los observadores.

---

## ReservationObserver

Define el contrato que todos los observadores deben implementar.

```swift
protocol ReservationObserver: AnyObject {

    func reservationDidUpdate(_ reservation: Reservation)

}
```

Gracias a este contrato cualquier clase puede convertirse en observador.

---

## ReservationSubject

Define las responsabilidades del Subject.

```swift
protocol ReservationSubject {

    func addObserver()

    func removeObserver()

    func notifyObservers()

}
```

Responsabilidades:

- Registrar observadores.
- Eliminar observadores.
- Notificar cambios.

---

## ReservationManager

Es el Subject.

Su única responsabilidad es administrar los observadores.

No conoce las implementaciones concretas.

Solo conoce el protocolo:

```text
ReservationObserver
```

---

## Observers

Los observadores reaccionan al cambio.

Ejemplo:

```text
RestaurantService
```

```text
SpaService
```

```text
ToursService
```

Cada uno interpreta el nuevo estado de la reserva y ejecuta únicamente la lógica que le corresponde.

---

# Flujo del patrón

```text
Reservation

↓

status cambia

↓

ReservationManager

↓

notifyObservers()

↓

RestaurantService

↓

SpaService

↓

ToursService
```

---

# WeakObserver

Swift no permite almacenar referencias `weak` directamente dentro de un `Array`.

Por esta razón se utiliza un wrapper.

```swift
final class WeakObserver {

    weak var observer: ReservationObserver?

}
```

El Array mantiene referencias fuertes hacia los wrappers.

Cada wrapper mantiene una referencia débil (`weak`) hacia el observador real.

```text
ReservationManager

↓

Array<WeakObserver>

↓

WeakObserver

↓

RestaurantService
```

Cuando un observador es liberado de memoria:

```swift
observer == nil
```

El Subject elimina automáticamente ese registro.

```swift
observers.removeAll {

    $0.observer == nil

}
```

---

# ¿Por qué AnyObject?

El protocolo está restringido a clases.

```swift
protocol ReservationObserver: AnyObject
```

Esto permite utilizar:

```swift
weak var observer
```

Las referencias débiles (`weak`) únicamente funcionan con tipos por referencia (`class`).

---

# ¿Por qué usar `===`?

Cuando se elimina un observador se utiliza:

```swift
$0.observer === observer
```

`===` compara la identidad del objeto.

Verifica que ambas referencias apunten exactamente a la misma instancia en memoria.

No se utiliza `==` porque:

- `==` compara igualdad de valores.
- `===` compara identidad de objetos.

---

# Beneficios

- Bajo acoplamiento.
- Fácil mantenimiento.
- Fácil extensión.
- Cumple con Open/Closed Principle.
- Permite agregar nuevos observadores sin modificar el Subject.
- Facilita la reutilización del código.

---

# Desventajas

- Si existen demasiados observadores puede ser más difícil seguir el flujo de ejecución.
- Es importante administrar correctamente el ciclo de vida de los observadores.
- El orden de notificación normalmente no debe asumirse.

---

# Casos de uso en iOS

Observer está presente en múltiples APIs del ecosistema Apple.

- NotificationCenter
- Combine (Publisher / Subscriber)
- SwiftUI (@Published)
- ObservableObject
- KVO (Key-Value Observing)

También es común utilizarlo para:

- Cambios de sesión.
- Actualización de interfaces.
- Estado de descargas.
- Cambios de conectividad.
- Actualización de carrito de compras.
- Estado de una reserva.

---

# Ventajas sobre una implementación tradicional

Sin Observer:

```text
ReservationManager

↓

Restaurant

↓

SPA

↓

Tours

↓

Analytics
```

El administrador conoce todos los módulos.

Con Observer:

```text
ReservationManager

↓

ReservationObserver

↓

Restaurant

SPA

Tours

Analytics
```

El Subject únicamente conoce el contrato.

Nunca conoce las implementaciones concretas.

---

# Principios SOLID

Este patrón aplica principalmente:

## Open/Closed Principle (OCP)

Es posible agregar nuevos observadores sin modificar el Subject.

Ejemplo:

```swift
final class NotificationService: ReservationObserver {

    func reservationDidUpdate(_ reservation: Reservation) {

        print("Enviar notificación")

    }

}
```

Solo es necesario registrarlo.

```swift
reservationManager.addObserver(notificationService)
```

No se modifica el Subject.

---

# Conclusión

Observer permite que múltiples objetos reaccionen automáticamente cuando cambia el estado de otro objeto.

En este ejemplo:

- `Reservation` representa el objeto cuyo estado cambia.
- `ReservationManager` actúa como el **Subject**, administrando y notificando a los observadores.
- `RestaurantService`, `SpaService` y `ToursService` son los **Observers**, responsables de reaccionar al cambio de estado.

Gracias al uso de protocolos, referencias débiles (`weak`) y un bajo acoplamiento entre los participantes, el sistema es más flexible, escalable y fácil de mantener.
