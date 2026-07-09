# 🌉 Bridge Pattern en Swift

Implementación del **Patrón de Diseño Bridge** utilizando **Swift**, simulando un sistema de analítica donde diferentes proveedores (**Firebase**, **Datadog** y **Pendo**) pueden ser utilizados sin modificar la lógica de negocio.

El objetivo es demostrar cómo **desacoplar una abstracción de su implementación**, permitiendo que ambas evolucionen de manera independiente.

---

# 📖 ¿Qué es el patrón Bridge?

El **Bridge (Puente)** es un patrón de diseño **estructural** que separa una **abstracción** de su **implementación**, permitiendo que ambas puedan evolucionar de manera independiente.

En lugar de depender de implementaciones concretas, la abstracción trabaja contra una interfaz común, mientras que las implementaciones pueden cambiar sin afectar al resto del sistema.

El patrón favorece la **composición sobre la herencia**, reduciendo el acoplamiento entre clases.

---

# 🎯 Objetivo

En este ejemplo aprenderás a:

- Comprender la estructura del patrón Bridge.
- Desacoplar la lógica de negocio de las implementaciones concretas.
- Cambiar el proveedor de analítica sin modificar el código del cliente.
- Aplicar el principio **Open/Closed**.
- Utilizar composición para crear código flexible y escalable.

---

# 🏗 Problema

Supongamos que una aplicación utiliza **Firebase Analytics** para registrar eventos.

```swift
class ScreenTracker {

    func track() {
        Firebase.track(...)
    }

}
```

Con el tiempo surge la necesidad de soportar nuevos proveedores como:

- Firebase
- Datadog
- Pendo

Si `ScreenTracker` depende directamente de Firebase, cada vez que cambie el proveedor será necesario modificar la clase.

Esto provoca un fuerte **acoplamiento** entre la lógica de negocio y la implementación de analítica.

---

# ✅ Solución

El patrón **Bridge** divide el problema en dos partes:

- **Abstraction** → Contiene la lógica de negocio.
- **Implementor** → Define el contrato que deben cumplir las implementaciones.

La abstracción delega el trabajo al implementador sin conocer qué proveedor está realizando realmente el envío del evento.

```
                 ScreenTracker
                        │
                        ▼
              AnalyticsProvider
                        ▲
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
   Firebase        Datadog          Pendo
```

Gracias a esta separación, es posible agregar nuevos proveedores sin modificar la lógica existente.

---

# 🏛 Estructura del patrón

```
                     Cliente
                        │
                        ▼
             +----------------------+
             |    ScreenTracker     |  ← Refined Abstraction
             +----------+-----------+
                        │
                        ▼
             +----------------------+
             |  AnalyticsTracker    |  ← Abstraction
             +----------+-----------+
                        │
                        ▼
             +----------------------+
             | AnalyticsProvider    |  ← Implementor
             +----------+-----------+
                        ▲
       ┌────────────────┼─────────────────┐
       │                │                 │
       ▼                ▼                 ▼
 FirebaseProvider  DatadogProvider  PendoProvider
Concrete Impl.     Concrete Impl.   Concrete Impl.
```

---

# 🧩 Componentes

## 1. Implementor

Define el contrato que todos los proveedores deben implementar.

```swift
protocol AnalyticsProvider {

    func track(
        _ key: String,
        parameters: [String: Any]
    )

}
```

---

## 2. Concrete Implementor

Son las implementaciones concretas del contrato.

En este proyecto existen tres proveedores:

- FirebaseAnalyticsProvider
- DatadogAnalyticsProvider
- PendoAnalyticsProvider

Cada uno conoce la forma de enviar el evento.

---

## 3. Abstraction

Mantiene una referencia al protocolo.

```swift
class AnalyticsTracker {

    let provider: AnalyticsProvider

    init(provider: AnalyticsProvider) {
        self.provider = provider
    }

}
```

La abstracción nunca conoce Firebase, Datadog o Pendo.

---

## 4. Refined Abstraction

Especializa la abstracción.

```swift
final class ScreenTracker: AnalyticsTracker {

    func trackScreen(
        _ screen: String,
        parameters: [String: Any]
    ) {

        provider.track(
            screen,
            parameters: parameters
        )

    }

}
```

Aquí puede agregarse lógica adicional antes de enviar el evento.

Por ejemplo:

- Validaciones
- Logs
- Parámetros comunes
- Formato del nombre del evento

---

## 5. Client

El cliente únicamente decide qué implementación utilizar.

```swift
let provider: AnalyticsProvider = FirebaseAnalyticsProvider()

let tracker = ScreenTracker(provider: provider)

tracker.trackScreen(
    "Screen_Login",
    parameters: [
        "user": "Osvaldo"
    ]
)
```

Cambiar de proveedor es tan sencillo como:

```swift
let provider: AnalyticsProvider = DatadogAnalyticsProvider()
```

No es necesario modificar ninguna otra clase.

---

# 🔄 Flujo de ejecución

```
Cliente
   │
   ▼
ScreenTracker
   │
   ▼
AnalyticsTracker
   │
   ▼
AnalyticsProvider
   │
   ▼
Firebase / Datadog / Pendo
```

---

# ✅ Ventajas

- Bajo acoplamiento.
- Fácil mantenimiento.
- Implementaciones intercambiables.
- Escalable.
- Favorece la composición sobre la herencia.
- Cumple con el principio Open/Closed.
- Permite agregar nuevos proveedores sin modificar el código existente.

---

# ⚠️ Desventajas

- Incrementa el número de clases.
- Puede ser excesivo para proyectos pequeños.
- Requiere comprender correctamente la separación entre abstracción e implementación.

---

# 💡 Casos de uso

El patrón Bridge es ideal cuando una abstracción necesita trabajar con múltiples implementaciones que pueden cambiar con el tiempo.

Ejemplos:

- Analytics (Firebase, Datadog, Pendo, Mixpanel).
- Pasarelas de pago (Stripe, PayPal, Mercado Pago).
- Servicios de almacenamiento.
- Bases de datos.
- Motores de renderizado.
- Servicios de autenticación.
- Sistemas de notificaciones.
- APIs de terceros.

---

# 🧠 Principios SOLID aplicados

## Single Responsibility Principle (SRP)

Cada clase tiene una única responsabilidad.

- `ScreenTracker` administra la lógica de seguimiento.
- Los proveedores únicamente envían eventos.

---

## Open/Closed Principle (OCP)

Es posible agregar un nuevo proveedor sin modificar el código existente.

---

## Dependency Inversion Principle (DIP)

La abstracción depende de una interfaz (`AnalyticsProvider`) y no de implementaciones concretas.

---

# 🔀 Bridge vs Strategy

| Bridge | Strategy |
|---------|----------|
| Separa una abstracción de su implementación. | Permite cambiar un algoritmo o comportamiento. |
| La abstracción y la implementación evolucionan de forma independiente. | El cliente cambia la estrategia según la necesidad. |
| Su objetivo es reducir el acoplamiento entre jerarquías de clases. | Su objetivo es encapsular algoritmos intercambiables. |

---

# 🚀 Resultado

Con el patrón **Bridge**, `ScreenTracker` nunca necesita conocer si el evento será enviado a Firebase, Datadog o Pendo.

La única dependencia es el contrato `AnalyticsProvider`, haciendo que el sistema sea más flexible, mantenible y preparado para crecer.

---

# 📚 Referencias

- Design Patterns: Elements of Reusable Object-Oriented Software (Gang of Four)
- Head First Design Patterns
- Apple Developer Documentation