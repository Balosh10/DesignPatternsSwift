# 🏛️ Facade Pattern - Swift

Ejemplo práctico del patrón de diseño **Facade** implementado en Swift.

El objetivo de este ejemplo es comprender cómo podemos **simplificar la interacción con múltiples subsistemas** mediante una única interfaz, reduciendo el acoplamiento del código cliente.

Este patrón es especialmente útil en aplicaciones iOS cuando necesitamos coordinar diferentes servicios como:

- Autenticación.
- Configuración del usuario.
- Analytics.
- Persistencia de sesión.
- Inicialización de SDKs externos.

---

# 📚 ¿Qué es el patrón Facade?

**Facade** es un patrón de diseño estructural que proporciona una interfaz simplificada para interactuar con un conjunto de interfaces más complejas dentro de un sistema.

En lugar de que el cliente conozca todos los componentes internos y cómo deben ejecutarse, delega esa responsabilidad en una clase fachada.

---

## ❌ Sin utilizar Facade

El cliente debe conocer todos los subsistemas:

```swift
let profile = ProfileConfigurator()
profile.configure()

let datadog = DataDogAnalytics()
datadog.configure()

let pendo = PendoAnalytics()
pendo.configure()

await SessionManager.shared.saveSession(session)
```

Problemas:

- Alto acoplamiento.
- El cliente conoce demasiados detalles.
- Difícil modificar el flujo de inicialización.
- Mayor probabilidad de duplicar lógica.

---

# ✅ Utilizando Facade

El cliente únicamente conoce una clase:

```swift
let facade = ApplicationFacade(
    userSession: session
)

await facade.initialize()
```

La fachada internamente coordina:

```
ApplicationFacade
        |
        |
 ┌──────┼────────┐
 |      |        |
 ▼      ▼        ▼
Profile Session Analytics
Configurator Manager
              |
        ┌─────┴─────┐
        ▼           ▼
    DataDog       Pendo
```

---

# 🎯 Objetivo del ejemplo

Crear una fachada encargada de inicializar los componentes necesarios después de una autenticación exitosa.

Flujo:

```
Usuario
  |
  ▼
AuthenticationService
  |
  ▼
Session
  |
  ▼
ApplicationFacade
  |
  ├── Configure Profile
  |
  ├── Initialize Analytics
  |
  └── Save Session
```

---

# 🏗️ Arquitectura del ejemplo

```
FacadePattern

├── AuthenticationService
│
├── ApplicationFacade
│
├── ProfileConfigurator
│
├── SessionManager
│
└── Analytics
    │
    ├── DataDogAnalytics
    │
    └── PendoAnalytics
```

---

# 🧩 Componentes principales

## ApplicationFacade

Es la implementación del patrón Facade.

Responsabilidades:

- Coordinar la inicialización.
- Ocultar la complejidad de los subsistemas.
- Proporcionar una interfaz sencilla al cliente.

Ejemplo:

```swift
await facade.initialize()
```

---

## AuthenticationService

Responsabilidad:

- Simular la autenticación del usuario.
- Crear la sesión.

Ejemplo:

```swift
let session = await authenticationService.authenticate()
```

---

## ProfileConfigurator

Responsabilidad:

- Configurar información relacionada al perfil del usuario.

Implementa:

```swift
ProfileConfiguratorProtocol
```

---

## SessionManager

Responsabilidad:

- Administrar la sesión activa.

Implementa:

```swift
SessionManagerProtocol
```

Además utiliza:

```swift
actor
```

para garantizar seguridad en concurrencia.

---

## Analytics

Define una abstracción para proveedores de analítica.

Implementaciones:

```swift
DataDogAnalytics
```

```swift
PendoAnalytics
```

Gracias al protocolo es posible agregar nuevos proveedores.

Ejemplo:

```swift
final class FirebaseAnalytics: Analytics {

    func configure() {
        print("Firebase configurado")
    }

}
```

Sin modificar:

```swift
ApplicationFacade
```

---

# 🧱 Principios SOLID aplicados

## S — Single Responsibility Principle

Cada clase tiene una única responsabilidad.

| Clase | Responsabilidad |
|-|-|
| AuthenticationService | Autenticación |
| ProfileConfigurator | Configuración del perfil |
| SessionManager | Administración de sesión |
| DataDogAnalytics | Configuración de DataDog |
| PendoAnalytics | Configuración de Pendo |
| ApplicationFacade | Coordinación del flujo |

---

# O — Open / Closed Principle

El sistema está abierto para extensión y cerrado para modificación.

Ejemplo:

Agregar Firebase:

```swift
final class FirebaseAnalytics: Analytics {

    func configure() {
        print("Firebase configurado")
    }

}
```

No requiere modificar:

```swift
ApplicationFacade
```

Solo agregar la nueva implementación.

---

# L — Liskov Substitution Principle

Las implementaciones pueden sustituirse mediante sus protocolos.

Ejemplo:

```swift
let analytics: Analytics = DataDogAnalytics()
```

También:

```swift
let analytics: Analytics = PendoAnalytics()
```

Ambas cumplen el mismo contrato.

---

# I — Interface Segregation Principle

Los protocolos contienen únicamente lo necesario.

Ejemplo:

```swift
protocol Analytics {

    func configure()

}
```

No obliga a implementar métodos innecesarios.

---

# D — Dependency Inversion Principle

La fachada depende de abstracciones:

```swift
Analytics
```

```swift
ProfileConfiguratorProtocol
```

```swift
SessionManagerProtocol
```

No depende directamente de clases concretas.

Esto permite:

- Testing más sencillo.
- Menor acoplamiento.
- Mayor flexibilidad.

---

# 🚀 Ejecución del ejemplo

El flujo principal es:

```swift
Task {

    let authenticationService = AuthenticationService()

    let session = await authenticationService.authenticate()

    let facade = ApplicationFacade(
        userSession: session
    )

    await facade.initialize()

}
```

Salida esperada:

```
🔐 Validando credenciales...
✅ Usuario autenticado.
👤 Configurando perfil del usuario...
📊 Inicializando DataDog...
📊 Inicializando Pendo...
💾 Sesión almacenada correctamente.
✅ Aplicación inicializada correctamente.
```

---

# 🧠 ¿Cuándo utilizar Facade?

Utiliza Facade cuando:

✅ Tienes muchos objetos interactuando entre sí.

✅ Existe una secuencia compleja de inicialización.

✅ Quieres ocultar detalles internos.

✅ Necesitas una API más simple para otros módulos.

Ejemplos reales en iOS:

- Inicialización de SDKs.
- Configuración inicial de una aplicación.
- Flujos de login.
- Procesos de checkout.
- Coordinación de servicios externos.

---

# ⚠️ ¿Cuándo NO utilizar Facade?

No lo uses si:

- Solo tienes una clase simple.
- No existe complejidad que ocultar.
- La fachada se convierte en una clase gigante con demasiadas responsabilidades.

Una fachada debe **coordinar**, no implementar toda la lógica del sistema.

---

# 📌 Conclusión

El patrón **Facade** permite crear un punto de entrada simple hacia sistemas complejos.

En este ejemplo:

```
Cliente
  |
  ▼
ApplicationFacade
  |
  ├── ProfileConfigurator
  ├── SessionManager
  └── Analytics Services
```

El cliente obtiene una API simple mientras la fachada se encarga de coordinar todos los detalles internos.

Este patrón combinado con principios SOLID permite crear código:

- Más mantenible.
- Más testeable.
- Más escalable.
- Menos acoplado.

---

# 📖 Referencias

- Design Patterns: Elements of Reusable Object-Oriented Software  
  Gang of Four (GoF)

- Apple Developer Documentation  
  Swift Programming Language
