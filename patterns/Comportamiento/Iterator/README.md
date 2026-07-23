# Interactor Pattern (Use Case) - Swift

## Introducción

El **Interactor** es un patrón arquitectónico utilizado principalmente en **Clean Architecture**, **VIPER** y otras arquitecturas orientadas a casos de uso.

Su objetivo es encapsular la **lógica de negocio** de una acción específica de la aplicación.

En otras palabras, un **Interactor representa un único caso de uso**.

Ejemplos:

- Confirmar una reservación.
- Cancelar una reservación.
- Realizar Check-In.
- Realizar Check-Out.
- Procesar un pago.
- Obtener el perfil de un usuario.

Cada uno de estos casos de uso debería implementarse mediante un Interactor independiente.

---

# Objetivos

El Interactor tiene como finalidad:

- Encapsular la lógica de negocio.
- Validar la información de entrada.
- Ejecutar reglas del dominio.
- Coordinar servicios.
- Coordinar el acceso a los datos mediante Repositories.
- Devolver el resultado del caso de uso.

---

# Arquitectura

```text
                    Usuario
                       │
                       ▼
                    View
                       │
                       ▼
                  Presenter
                       │
                       ▼
                  Interactor
             (Caso de Uso)
                │        │
                │        │
                ▼        ▼
       PaymentService   Repository
                │
                ▼
          API / Database
```

---

# Flujo completo

```text
Usuario

↓

Presiona botón Confirmar

↓

View

↓

Presenter

↓

Interactor

↓

Validaciones

↓

PaymentService

↓

Repository

↓

Interactor devuelve resultado

↓

Presenter

↓

View actualiza la interfaz
```

---

# Responsabilidades

## View

La View únicamente muestra información al usuario.

Responsabilidades:

- Mostrar datos.
- Mostrar indicadores de carga.
- Mostrar mensajes.
- Capturar eventos del usuario.

No debe:

- Ejecutar reglas de negocio.
- Consumir APIs.
- Validar información.

---

## Presenter

El Presenter actúa como intermediario entre la View y el Interactor.

Responsabilidades:

- Recibir eventos de la View.
- Ejecutar casos de uso.
- Interpretar resultados.
- Actualizar la interfaz.

No debe:

- Contener reglas de negocio.
- Consumir servicios.
- Acceder a bases de datos.

---

## Interactor

El Interactor representa el caso de uso.

Responsabilidades:

- Validar información.
- Ejecutar reglas de negocio.
- Coordinar servicios.
- Coordinar Repositories.
- Devolver el resultado del caso de uso.

No debe:

- Mostrar pantallas.
- Navegar.
- Consumir `URLSession`.
- Acceder directamente a la base de datos.
- Actualizar la interfaz.

---

## Repository

Responsable del acceso a los datos.

Puede obtener información desde:

- REST API
- GraphQL
- Core Data
- SQLite
- Realm
- Firebase

El Interactor únicamente conoce el protocolo.

---

## Services

Representan funcionalidades especializadas.

Ejemplos:

- PaymentService
- EmailService
- NotificationService
- AnalyticsService

Cada servicio posee una única responsabilidad.

---

# Flujo del caso de uso

```text
Presenter

↓

Interactor.execute()

↓

Validar información

↓

Ejecutar reglas de negocio

↓

Procesar pago

↓

Confirmar reservación

↓

Devolver Reservation

↓

Presenter

↓

Actualizar View
```

---

# Ejemplo

```swift
let confirmedReservation = try await interactor.execute(
    reservation: reservation
)

view.showSuccess(
    message: confirmedReservation.status.description
)
```

---

# ¿Qué hace el Interactor?

El Interactor actúa como el **orquestador del caso de uso**.

Ejemplo:

```text
ConfirmReservationInteractor

↓

Validar huésped

↓

Validar estado

↓

Procesar pago

↓

Guardar información

↓

Devolver resultado
```

No realiza el pago.

No consume la API.

No muestra pantallas.

Únicamente coordina el flujo.

---

# ¿Por qué usar un Repository?

Sin Repository:

```text
Interactor

↓

URLSession

↓

API
```

El dominio queda acoplado a la infraestructura.

Con Repository:

```text
Interactor

↓

ReservationRepository

↓

API
```

El dominio permanece independiente.

---

# ¿Por qué usar Services?

Cada servicio representa una responsabilidad específica.

Ejemplo:

```text
Interactor

├── PaymentService

├── EmailService

├── AnalyticsService

└── NotificationService
```

Esto evita clases gigantes y mejora el mantenimiento.

---

# Principios SOLID

## Single Responsibility Principle (SRP)

Cada clase tiene una única responsabilidad.

| Clase | Responsabilidad |
|--------|-----------------|
| View | Mostrar información |
| Presenter | Coordinar View e Interactor |
| Interactor | Ejecutar el caso de uso |
| Repository | Acceder a datos |
| PaymentService | Procesar pagos |

---

## Open / Closed Principle (OCP)

Podemos crear nuevas implementaciones sin modificar el Interactor.

Ejemplo:

```swift
ApiReservationRepository

FirebaseReservationRepository

MockReservationRepository
```

---

## Liskov Substitution Principle (LSP)

Cualquier implementación que cumpla el protocolo puede reemplazar otra.

Ejemplo:

```swift
ReservationRepository

↓

ApiReservationRepository

↓

MockReservationRepository
```

---

## Interface Segregation Principle (ISP)

Cada protocolo expone únicamente lo necesario.

```swift
protocol PaymentService

protocol ReservationRepository

protocol ConfirmReservationInteractor
```

No existen interfaces gigantes.

---

## Dependency Inversion Principle (DIP)

El Interactor depende de abstracciones.

```swift
private let repository: ReservationRepository

private let paymentService: PaymentService
```

Nunca depende de implementaciones concretas.

---

# Ventajas

- Código desacoplado.
- Fácil de probar.
- Reutilizable.
- Escalable.
- Mantenible.
- Casos de uso independientes.
- Arquitectura limpia.

---

# Desventajas

- Mayor cantidad de clases.
- Más protocolos.
- Puede parecer excesivo para proyectos pequeños.

---

# Ejemplo aplicado a un Hotel

Caso de uso:

**Confirmar Reservación**

```text
Usuario

↓

Presiona Confirmar

↓

Presenter

↓

ConfirmReservationInteractor

↓

Validar huésped

↓

Validar estado

↓

Procesar pago

↓

ReservationRepository

↓

API

↓

Interactor devuelve Reservation

↓

Presenter

↓

View actualiza la interfaz
```

---

# Casos de uso comunes

Cada acción importante del negocio debería tener su propio Interactor.

Ejemplos:

```text
LoginInteractor

LogoutInteractor

RegisterUserInteractor

GetReservationsInteractor

GetReservationDetailInteractor

ConfirmReservationInteractor

CancelReservationInteractor

ProcessPaymentInteractor

CheckInInteractor

CheckOutInteractor

GenerateDigitalKeyInteractor

UpdateGuestInformationInteractor

SendEmailInteractor
```

Cada uno representa **un único caso de uso**.

---

# Conclusión

El **Interactor** es el componente encargado de ejecutar un caso de uso completo.

No conoce la interfaz gráfica.

No conoce la base de datos.

No conoce la implementación de los servicios.

Únicamente conoce las reglas del negocio y coordina las dependencias necesarias para completar una acción.

Gracias a esta separación de responsabilidades, las aplicaciones son más fáciles de mantener, probar y evolucionar, convirtiendo al Interactor en una pieza fundamental dentro de arquitecturas como **Clean Architecture** y **VIPER**.