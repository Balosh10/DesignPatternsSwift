# Singleton (con Dependency Injection en iOS)

## ¿Qué es Singleton?

**Singleton** es un patrón de diseño creacional que garantiza que una clase tenga **una única instancia** durante toda la ejecución de la aplicación y proporciona un punto de acceso global a ella.

---

## ¿Qué problema resuelve?

En muchas aplicaciones, existe información que debe ser **única y compartida en toda la app**, por ejemplo:

- Sesión del usuario
- Configuración global
- Estado actual de una entidad seleccionada

En este ejemplo de una app tipo **Hotel Cancun**:

> El usuario puede tener múltiples reservas, pero solo una puede estar activa dentro de la app.

---

## Ejemplo real del problema

Un usuario tiene varias reservas:

- Hotel Cancun 1
- Hotel Cancun 2
- Hotel Cancun 3

Pero la aplicación solo debe manejar **una reserva seleccionada**:

```text
Home
Spa
Room Service
Check-In
Restaurants

        ↓

CurrentReservationManager
        ↓
Reserva activa
```

---

## Diseño de la solución

En este ejemplo se combinan:

- Singleton
- Abstracción (Protocol)
- Encapsulamiento
- Dependency Injection (DI)

---

# Modelo del dominio

## ReservationRepresentable (Abstracción)

Define el contrato de una reserva.

```swift
protocol ReservationRepresentable {

    var reservationNumber: String { get }
    var resort: String { get }
    var hotelName: String { get }
    var guestName: String { get }
    var guestType: String { get }
    var isPremium: Bool { get }

}
```

---

## Reservation (Entidad)

Modelo concreto del dominio.

```swift
struct Reservation: ReservationRepresentable {

    let reservationNumber: String
    let resort: String
    let hotelName: String
    let guestName: String
    let guestType: String
    let isPremium: Bool

}
```

---

# Abstracción para DI

## CurrentReservationProviding

Permite desacoplar la app del Singleton.

```swift
protocol CurrentReservationProviding {

    var reservation: Reservation? { get }

    func updateReservation(_ reservation: Reservation)
    func clear()

}
```

---

# Singleton

## CurrentReservationManager

Implementación única del estado global.

```swift
final class CurrentReservationManager: CurrentReservationProviding {

    static let shared = CurrentReservationManager()

    private init() {}

    private(set) var reservation: Reservation?

    func updateReservation(_ reservation: Reservation) {
        self.reservation = reservation
    }

    func clear() {
        reservation = nil
    }
}
```

---

## POO aplicada

### Abstracción
La app no necesita saber cómo se guarda la reserva.

Solo interactúa con:

```swift
updateReservation()
clear()
```

---

### Encapsulamiento

```swift
private(set) var reservation
```

- ✔ Se puede leer desde cualquier parte
- ✖ No se puede modificar directamente

---

# Uso en la app (Production)

## ViewModel con Dependency Injection

```swift
class HomeViewModel {

    private let reservationProvider: CurrentReservationProviding

    init(reservationProvider: CurrentReservationProviding) {
        self.reservationProvider = reservationProvider
    }

    func getHotelName() -> String? {
        reservationProvider.reservation?.hotelName
    }
}
```

---

## Composition Root

```swift
let reservation = Reservation(
    reservationNumber: "123456",
    resort: "Hotel Cancun",
    hotelName: "Hotel Cancun New",
    guestName: "Osvaldo Cespedes",
    guestType: "Member",
    isPremium: true
)

CurrentReservationManager.shared.updateReservation(reservation)

let viewModel = HomeViewModel(
    reservationProvider: CurrentReservationManager.shared
)

print(viewModel.getHotelName() ?? "")
```

---

# Mock para Unit Tests

```swift
final class MockReservationManager: CurrentReservationProviding {

    var reservation: Reservation?

    func updateReservation(_ reservation: Reservation) {
        self.reservation = reservation
    }

    func clear() {
        self.reservation = nil
    }
}
```

---

# Ventajas del diseño

## ✔ Singleton controlado
Solo existe una fuente de verdad para la reserva activa.

## ✔ Bajo acoplamiento
Las vistas no dependen directamente del Singleton.

## ✔ Testable
Se pueden usar mocks fácilmente.

## ✔ Escalable
Se puede reemplazar la implementación sin cambiar el ViewModel.

---

# Desventajas del Singleton (importante)

- Puede generar estado global compartido
- Dificulta pruebas si no se usa DI
- Puede generar acoplamiento si se usa directamente

---

# Mejores prácticas

✔ Usar Singleton solo como implementación  
✔ No depender directamente de `.shared` en vistas  
✔ Usar protocolos para abstraer dependencias  
✔ Inyectar dependencias en ViewModels  

---

# Conclusión

Este ejemplo muestra una evolución real de Singleton en iOS:

> De un Singleton global rígido  
> → a una arquitectura desacoplada con Dependency Injection

Es el enfoque que se usa en aplicaciones enterprise como apps de hotelería, banca o e-commerce.

---