# Proxy

## Descripción

El patrón de diseño **Proxy** es un patrón **estructural** que proporciona un objeto intermediario entre el cliente y un objeto real. Su objetivo es **controlar el acceso** al objeto real antes de delegar la operación.

El cliente nunca interactúa directamente con el objeto real; todas las solicitudes pasan primero por el Proxy, quien decide cómo y cuándo acceder al servicio.

---

# Objetivo

Controlar el acceso a un objeto mediante un intermediario, agregando funcionalidades como:

- Caché.
- Validación de permisos.
- Lazy Loading.
- Registro de logs.
- Seguridad.
- Control de acceso.

Sin modificar el objeto real.

---

# Problema

Supongamos que una aplicación consulta una API para obtener la lista de hoteles.

Cada vez que el usuario abre la pantalla se realiza una petición HTTP.

```text
Cliente
    │
    ▼
HotelsAPIService
    │
    ▼
API
```

Esto provoca:

- Múltiples consultas innecesarias.
- Mayor consumo de red.
- Menor rendimiento.
- Tiempo de espera para el usuario.

---

# Solución

Agregar un **Proxy** entre el cliente y el servicio real.

Antes de consultar la API, el Proxy verifica si la información ya existe en caché.

```text
Cliente
    │
    ▼
HotelsServiceProxy
    │
    ├── ¿Existe caché?
    │
    ├── Sí
    │      ▼
    │  Regresar caché
    │
    └── No
           ▼
    HotelsAPIService
           ▼
         API
```

---

# Estructura UML

```text
                 +---------------------------+
                 | HotelsServiceProtocol     |
                 +---------------------------+
                 | getHotels()               |
                 +-------------▲-------------+
                               │
                ┌──────────────┴──────────────┐
                │                             │
+--------------------------------+   +-----------------------------+
| HotelsServiceProxy             |   | HotelsAPIService            |
+--------------------------------+   +-----------------------------+
| - api                          |   | + getHotels()              |
| - session                      |   +-----------------------------+
| - cacheKey                     |
| + getHotels()                  |
| - getHotelsFromCache()         |
| - saveHotelsInCache()          |
+--------------------------------+

                ▲
                │
             Cliente
```

---

# Participantes

## Subject

Define el contrato que utilizarán el cliente, el Proxy y el servicio real.

```swift
protocol HotelsServiceProtocol {
    func getHotels() -> [Hotel]
}
```

---

## Real Subject

Implementa la lógica real del negocio.

En este ejemplo:

```swift
final class HotelsAPIService
```

Su única responsabilidad es consultar la API.

No conoce:

- Caché.
- UserDefaults.
- Persistencia.
- JSON.

---

## Proxy

Implementa el mismo protocolo que el servicio real.

Es responsable de:

- Consultar el caché.
- Decidir si debe llamar a la API.
- Guardar la respuesta.
- Devolver la información al cliente.

---

## Cliente

El cliente únicamente conoce el protocolo.

```swift
let service: HotelsServiceProtocol =
    HotelsServiceProxy(api: HotelsAPIService())
```

No sabe si está utilizando un Proxy o el servicio real.

---

# Flujo de ejecución

```text
Cliente
    │
    ▼
HotelsServiceProxy
    │
    ├── ¿Existe caché?
    │
    ├── Sí
    │      ▼
    │  Regresar hoteles
    │
    └── No
           ▼
     HotelsAPIService
           ▼
      Consultar API
           ▼
     Guardar caché
           ▼
      Regresar hoteles
```

---

# Implementación

El Proxy realiza el siguiente flujo:

1. Busca la información en `UserDefaults`.
2. Si existe, devuelve el caché.
3. Si no existe, consulta el servicio real.
4. Guarda la respuesta.
5. Devuelve los datos al cliente.

El servicio real únicamente obtiene la información desde la API.

---

# Salida esperada

Primera ejecución:

```text
🌐 Consultando hoteles desde la API
```

Segunda ejecución:

```text
📦 Hoteles obtenidos desde caché
```

---

# Ventajas

- Reduce llamadas innecesarias a la API.
- Mejora el rendimiento.
- Centraliza la lógica de acceso.
- Agrega funcionalidades sin modificar el servicio real.
- Favorece el desacoplamiento.
- Facilita agregar nuevas reglas de negocio.

---

# Desventajas

- Incrementa ligeramente la complejidad.
- Agrega una capa adicional al sistema.
- Si el Proxy acumula demasiadas responsabilidades puede violar el principio de responsabilidad única.

---

# Casos de uso

El patrón Proxy es ampliamente utilizado para implementar:

- Caché.
- Lazy Loading.
- Control de permisos.
- Seguridad.
- Registro de logs.
- Rate Limiting.
- Servicios remotos.

---

# Principios SOLID aplicados

## Single Responsibility Principle (SRP)

Cada clase tiene una única responsabilidad.

| Clase | Responsabilidad |
|--------|-----------------|
| `Hotel` | Representar el modelo. |
| `HotelsAPIService` | Obtener los hoteles desde la API. |
| `HotelsServiceProxy` | Controlar el acceso al servicio y administrar el caché. |
| Cliente | Consumir el servicio. |

---

## Open/Closed Principle (OCP)

El Proxy puede extenderse para agregar nuevas funcionalidades como:

- Expiración del caché.
- Validación de autenticación.
- Logs.
- Métricas.
- Reintentos.

Sin modificar el servicio real.

---

## Dependency Inversion Principle (DIP)

El cliente depende del protocolo:

```swift
HotelsServiceProtocol
```

y no de una implementación concreta.

Esto permite sustituir fácilmente el servicio real por un Proxy o un Mock durante las pruebas.

---

# Diferencia con otros patrones estructurales

| Patrón | Objetivo |
|---------|----------|
| Adapter | Convierte una interfaz en otra compatible. |
| Bridge | Separa la abstracción de la implementación. |
| Decorator | Agrega responsabilidades dinámicamente. |
| Facade | Simplifica el acceso a un subsistema complejo. |
| Composite | Trata objetos individuales y grupos de forma uniforme. |
| **Proxy** | Controla el acceso a un objeto mediante un intermediario. |

---

# Conclusión

El patrón **Proxy** proporciona un intermediario entre el cliente y un objeto real para controlar su acceso.

En este ejemplo, el Proxy administra un mecanismo de caché utilizando `UserDefaults`, evitando llamadas innecesarias a la API y mejorando el rendimiento de la aplicación, mientras mantiene desacoplado al cliente de la implementación del servicio.