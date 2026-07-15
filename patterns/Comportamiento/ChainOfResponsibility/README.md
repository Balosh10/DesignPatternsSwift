# Chain of Responsibility

## Descripción

Este proyecto demuestra la implementación del patrón de diseño **Chain of Responsibility (Cadena de Responsabilidad)** utilizando **Swift**.

El ejemplo simula el proceso de validación de una **reserva de hotel** para realizar un **Check-In**. Cada estado de la reserva es representado por un `Handler`, el cual decide si puede procesar la solicitud o debe delegarla al siguiente elemento de la cadena.

---

# Objetivo

Comprender cómo funciona el patrón **Chain of Responsibility**, identificando:

- Cómo desacoplar el emisor de la solicitud del objeto que la procesa.
- Cómo construir una cadena de responsabilidades.
- Cómo aplicar principios SOLID durante la implementación.
- Cómo separar la validación de la lógica de negocio.

---

# Problema

Sin este patrón, normalmente terminaríamos escribiendo grandes bloques de decisión.

```swift
switch reservation.status {
case .pending:
    ...
case .reserved:
    ...
case .checkedIn:
    ...
case .checkedOut:
    ...
case .cancelled:
    ...
}
```

Cada vez que aparece un nuevo estado es necesario modificar el código existente.

Esto incrementa el acoplamiento y dificulta el mantenimiento.

---

# Solución

Cada estado de la reserva se convierte en un **Handler**.

Cada handler responde dos preguntas:

1. ¿Puedo procesar esta solicitud?
2. Si no puedo, ¿quién sigue?

Visualmente:

```text
Solicitud

        │

        ▼

PendingHandler

        │

        ▼

ReservedHandler

        │

        ▼

CheckedInHandler

        │

        ▼

CheckedOutHandler

        │

        ▼

CancelledHandler
```

Cuando un handler reconoce la condición correspondiente, ejecuta la acción y finaliza la cadena.

---

# Estructura del proyecto

```text
Reservation
│
├── ReservationStatus
│
├── ReservationService
│
├── ReservationHandler
│
├── PendingHandler
├── ReservedHandler
├── CheckedInHandler
├── CheckedOutHandler
└── CancelledHandler
```

---

# Flujo del ejemplo

Supongamos que la reserva tiene el estado:

```swift
.reserved
```

El recorrido será:

```text
Solicitud

        │

        ▼

PendingHandler
        │
        │ No aplica
        ▼

ReservedHandler
        │
        │ Estado válido
        ▼

ReservationService

        │

        ▼

Check-In realizado
```

Si el estado fuera:

```swift
.checkedOut
```

La solicitud recorrería toda la cadena hasta llegar al handler correspondiente.

---

# Componentes principales

## Reservation

Representa la entidad del dominio.

```swift
struct Reservation
```

Contiene la información necesaria para procesar la solicitud.

---

## ReservationHandler

Define el contrato que todos los handlers deben implementar.

```swift
protocol ReservationHandler
```

Responsabilidades:

- Mantener la referencia al siguiente handler.
- Procesar o delegar la solicitud.

---

## Concrete Handlers

Cada handler valida una única condición.

Ejemplo:

- PendingHandler
- ReservedHandler
- CheckedInHandler
- CheckedOutHandler
- CancelledHandler

Si la condición no corresponde, delega la solicitud al siguiente handler.

```swift
next?.handle(reservation)
```

---

## ReservationService

Contiene la lógica de negocio.

En este ejemplo se encarga de realizar el proceso de Check-In.

Esto evita que los handlers conozcan cómo ejecutar la operación.

---

# Principios SOLID utilizados

## Single Responsibility Principle (SRP)

Cada clase tiene una única responsabilidad.

Ejemplos:

- PendingHandler valida reservas pendientes.
- ReservedHandler valida reservas confirmadas.
- ReservationService ejecuta el Check-In.

---

## Open / Closed Principle (OCP)

Es posible agregar nuevos handlers sin modificar los existentes.

Ejemplo:

```text
NoShowHandler
```

Solo se conecta a la cadena.

---

## Liskov Substitution Principle (LSP)

Todos los handlers implementan la misma interfaz.

```swift
ReservationHandler
```

Cualquier handler puede sustituir a otro.

---

## Interface Segregation Principle (ISP)

La interfaz es pequeña y específica.

```swift
var next

func handle(...)
```

Los handlers únicamente implementan lo necesario.

---

## Dependency Inversion Principle (DIP)

Los handlers dependen de abstracciones.

```swift
ReservationService
```

y no de implementaciones concretas.

Esto facilita el desacoplamiento y las pruebas unitarias.

---

# Ventajas del patrón

- Reduce el acoplamiento entre objetos.
- Elimina grandes bloques de `if` o `switch`.
- Facilita la extensión del sistema.
- Favorece el cumplimiento de SOLID.
- Permite agregar nuevas reglas sin modificar el código existente.
- Mejora la mantenibilidad del proyecto.

---

# Casos de uso

Este patrón es común en aplicaciones empresariales para implementar:

- Validaciones de Check-In.
- Aprobación de solicitudes.
- Procesamiento de pagos.
- Flujos de autorización.
- Validación de formularios.
- Middleware de networking.
- Pipelines de autenticación.
- Procesamiento de eventos.

---

# Resultado esperado

Para una reserva con estado:

```swift
.reserved
```

La salida será:

```text
🏨 Iniciando Check-In...
📄 Reserva: ABC123
🪪 Validando identidad...
🔑 Asignando habitación...
✅ Check-In realizado correctamente.
```

---

# Conclusión

El patrón **Chain of Responsibility** permite que una solicitud recorra una cadena de objetos hasta encontrar el responsable de procesarla.

Cada handler conoce únicamente al siguiente elemento de la cadena, reduciendo el acoplamiento y facilitando la extensión del sistema.

En este ejemplo, la responsabilidad se divide claramente:

- **ReservationHandler** decide si procesa o delega la solicitud.
- **ReservationService** ejecuta la lógica de negocio.
- **El cliente** únicamente conoce el primer elemento de la cadena.

Esta separación produce un código más limpio, flexible y alineado con los principios SOLID.