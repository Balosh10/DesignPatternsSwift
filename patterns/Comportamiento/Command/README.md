# Command Pattern (Patrón Comando)

## ¿Qué es?

El **Command** es un patrón de diseño de comportamiento que **encapsula una acción como un objeto**.

En lugar de ejecutar directamente una operación, la acción se representa mediante un objeto (`Command`) que puede:

- Ejecutarse inmediatamente.
- Almacenarse en un historial.
- Ejecutarse posteriormente.
- Agregarse a una cola de tareas.
- Implementar operaciones de **Undo** y **Redo**.

Su principal objetivo es **desacoplar el objeto que solicita una acción del objeto que realmente la ejecuta**.

---

# ¿Qué problema resuelve?

Sin el patrón Command, un objeto suele llamar directamente a los métodos del servicio.

```swift
hotelService.prepareRoomService(reservation: reservation)
hotelService.prepareSpaService(reservation: reservation)
hotelService.reserveTour(reservation: reservation)
```

Conforme la aplicación crece aparecen problemas:

- Alto acoplamiento entre objetos.
- Difícil almacenar acciones.
- No existe un historial de operaciones.
- No es posible reejecutar acciones fácilmente.
- Implementar Undo / Redo resulta complejo.

---

# Solución

Command convierte cada acción en un objeto.

En lugar de ejecutar directamente:

```swift
hotelService.prepareRoomService(...)
```

creamos un objeto:

```swift
let roomServiceCommand = RoomServiceCommand(
    receiver: hotelService,
    reservation: reservation
)
```

Ahora la acción existe como un objeto independiente y puede administrarse.

---

# Estructura del patrón

```text
                    Client
                      │
                      ▼
                GuestRequestInvoker
                    (Invoker)
                      │
                      ▼
                    Command
               (Contrato común)
                      ▲
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
RoomService      SpaCommand     TourCommand
   Command
        │
        ▼
HotelServiceManager
     (Receiver)
```

---

# Participantes

## 1. Model

Representa la información necesaria para ejecutar un comando.

```swift
struct Reservation
```

Contiene los datos del huésped y la reservación.

---

## 2. Command

Define el contrato común para todos los comandos.

```swift
protocol Command {

    func execute()

}
```

Todos los comandos deben implementar `execute()`.

---

## 3. Concrete Commands

Representan acciones específicas.

En este proyecto:

- `RoomServiceCommand`
- `SpaCommand`
- `TourCommand`

Cada comando:

- Representa una acción.
- Mantiene una referencia al Receiver.
- Delega la ejecución al Receiver.

Ejemplo:

```swift
func execute() {

    receiver.prepareRoomService(
        reservation: reservation
    )

}
```

El comando **no contiene la lógica del negocio**.

Su única responsabilidad es invocar al Receiver.

---

## 4. Receiver

Es el objeto que conoce la lógica real del negocio.

En este proyecto:

```swift
HotelServiceManager
```

Responsabilidades:

- Preparar Room Service.
- Preparar SPA.
- Reservar Tours.

El Receiver sabe **cómo** realizar cada operación.

---

## 5. Invoker

Es el encargado de administrar y ejecutar los comandos.

En este proyecto:

```swift
GuestRequestInvoker
```

Responsabilidades:

- Mantener el comando actual.
- Ejecutarlo.
- Guardar el historial.
- Repetir comandos.

El Invoker **no conoce la lógica del negocio**.

---

## 6. Client

Es quien construye el patrón.

Su responsabilidad es:

- Crear el Receiver.
- Crear los Commands.
- Crear el Invoker.
- Conectar todos los objetos.

---

# Flujo del patrón

```text
Client

↓

Crea Receiver

↓

Crea Commands

↓

Asigna Command al Invoker

↓

Invoker.executeCommand()

↓

Command.execute()

↓

Receiver ejecuta la lógica
```

---

# Historial de comandos

Una de las mayores ventajas del patrón es que los comandos son objetos.

Gracias a ello pueden almacenarse.

```swift
private var commandHistory: [Command] = []
```

Cada vez que un comando se ejecuta:

```swift
command.execute()

commandHistory.append(command)
```

Posteriormente el historial puede recorrerse nuevamente.

```swift
commandHistory.forEach {

    $0.execute()

}
```

Visualmente:

```text
Historial

↓

[
    RoomServiceCommand,
    SpaCommand,
    TourCommand
]
```

Cada objeto mantiene toda la información necesaria para volver a ejecutarse.

---

# ¿Por qué el historial usa referencias fuertes?

El historial almacena los comandos mediante referencias fuertes.

```swift
private var commandHistory: [Command] = []
```

Esto es correcto porque el historial **es propietario de los comandos**.

Mientras un comando forme parte del historial debe permanecer vivo para poder:

- Reejecutarse.
- Consultarse.
- Implementar Undo.
- Implementar Redo.

A diferencia del patrón **Observer**, aquí no se utilizan referencias débiles (`weak`) porque el historial necesita conservar los objetos.

---

# Struct vs Class

En este proyecto `Reservation` es un `struct`.

```swift
struct Reservation
```

Esto significa que cada Command almacena una **copia** de la reservación.

```text
RoomServiceCommand

↓

Reservation (copia)
```

Si posteriormente cambia la reservación original, el comando seguirá utilizando la información con la que fue creado.

Si `Reservation` fuera una `class`, todos los comandos compartirían la misma instancia y observarían los cambios realizados posteriormente.

---

# Ventajas

- Bajo acoplamiento.
- Cada acción es un objeto independiente.
- Fácil agregar nuevos comandos.
- Permite crear historial.
- Permite crear colas de ejecución.
- Facilita implementar Undo / Redo.
- Cumple con el principio Open/Closed.

---

# Desventajas

- Incrementa el número de clases.
- Puede resultar excesivo para operaciones muy simples.
- Requiere mayor organización del proyecto.

---

# Comparación con otros patrones

## Strategy

**Pregunta que responde:**

> ¿Qué algoritmo utilizar?

Ejemplo:

```text
PaymentProcessor

↓

ApplePayStrategy
```

Strategy cambia el algoritmo o comportamiento.

---

## Observer

**Pregunta que responde:**

> ¿Quién debe enterarse cuando algo cambia?

Ejemplo:

```text
Reservation

↓

Restaurant

SPA

Tours
```

Observer notifica cambios.

---

## Delegate

**Pregunta que responde:**

> ¿A quién delego una responsabilidad?

Ejemplo:

```swift
tableView.delegate
```

Delegate delega responsabilidades a otro objeto.

---

## Command

**Pregunta que responde:**

> ¿Cómo convierto una acción en un objeto?

Ejemplo:

```text
RoomServiceCommand

↓

execute()

↓

HotelServiceManager
```

Command representa acciones mediante objetos.

---

# Ejemplo del proyecto

El huésped puede realizar diferentes solicitudes.

- 🍽 Room Service
- 💆 SPA
- 🚌 Tour

Cada solicitud es un Command diferente.

```text
GuestRequestInvoker

↓

RoomServiceCommand

↓

HotelServiceManager

↓

Preparar alimentos
```

Posteriormente el mismo comando puede almacenarse en un historial y ejecutarse nuevamente.

---

# Casos de uso

El patrón Command es ampliamente utilizado para implementar:

- Historial de acciones.
- Undo / Redo.
- Colas de procesamiento.
- Macros.
- Sistemas de tareas.
- Menús y botones.
- Automatización de procesos.

---

# Conclusión

El patrón **Command** permite representar una acción como un objeto independiente.

Al encapsular una operación dentro de un objeto obtenemos una arquitectura más desacoplada y flexible, donde las acciones pueden almacenarse, ejecutarse posteriormente, organizarse en colas, mantenerse en un historial o incluso revertirse mediante mecanismos de **Undo** y **Redo**.

En este ejemplo, cada solicitud del huésped (**Room Service, SPA y Tour**) se modela como un `Command` que delega la ejecución al `HotelServiceManager`, mientras que el `GuestRequestInvoker` administra y ejecuta dichas acciones sin conocer la lógica del negocio.

## Idea principal

> **Command convierte una acción en un objeto para desacoplar quién solicita la operación de quién la ejecuta.**
