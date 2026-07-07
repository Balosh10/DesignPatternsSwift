# ☕ Decorator Pattern

El patrón **Decorator** es un patrón de diseño **estructural** que permite agregar nuevas responsabilidades o comportamientos a un objeto **de forma dinámica**, sin modificar su implementación original.

En lugar de crear múltiples subclases para cada combinación posible de funcionalidades, el patrón **Decorator** envuelve un objeto con otros objetos que implementan la misma interfaz, permitiendo extender su comportamiento de forma flexible y reutilizable.

---

# 🎯 Objetivo

Aprender cómo extender el comportamiento de un objeto sin modificar su código fuente, siguiendo el principio **Open/Closed**:

> **Abierto para extensión, cerrado para modificación.**

---

# 🧩 Estructura del patrón

```text
                Coffee (Component)
                     ▲
                     │
             SimpleCoffee
                     ▲
                     │
             CoffeeDecorator
               ▲           ▲
               │           │
      MilkDecorator   SugarDecorator
```

---

# 📦 Componentes

## Component

Define la interfaz común que deberán implementar tanto el objeto original como todos los decoradores.

```swift
protocol Coffee {
    func cost() -> Double
    func description() -> String
}
```

---

## Concrete Component

Es el objeto original al que posteriormente se le agregarán nuevas funcionalidades.

```swift
final class SimpleCoffee: Coffee
```

---

## Decorator

Implementa la misma interfaz que el componente y mantiene una referencia al objeto que está decorando.

```swift
class CoffeeDecorator: Coffee
```

Su responsabilidad principal es delegar las llamadas al objeto decorado.

---

## Concrete Decorators

Son los encargados de agregar nuevas responsabilidades.

En este ejemplo:

- ☕ MilkDecorator
- 🍬 SugarDecorator

Cada uno modifica el comportamiento del objeto original sin alterar su implementación.

---

# 🚀 Ejemplo

```swift
var coffee: Coffee = SimpleCoffee()

coffee = MilkDecorator(coffee: coffee)
coffee = SugarDecorator(coffee: coffee)

print(coffee.description())
print(coffee.cost())
```

Salida:

```text
Descripción: Café simple, con leche, con azúcar
Costo: $7.25
```

---

# 🔄 Flujo de ejecución

Cuando agregamos decoradores, el objeto queda envuelto de la siguiente manera:

```text
SugarDecorator
      │
      ▼
MilkDecorator
      │
      ▼
SimpleCoffee
```

Al ejecutar:

```swift
coffee.description()
```

La llamada viaja hasta el objeto original y posteriormente regresa agregando cada nueva responsabilidad.

```text
SugarDecorator

↓

MilkDecorator

↓

SimpleCoffee

↓

"Café simple"

↑

"Café simple, con leche"

↑

"Café simple, con leche, con azúcar"
```

Lo mismo ocurre con el costo.

```text
5.00

↓

6.50

↓

7.25
```

---

# ✅ Ventajas

- Agrega funcionalidades sin modificar el objeto original.
- Evita crear una gran cantidad de subclases.
- Permite combinar comportamientos dinámicamente.
- Favorece la reutilización de código.
- Cumple con el principio Open/Closed.

---

# ❌ Desventajas

- Puede generar muchas clases pequeñas.
- Si existen demasiados decoradores, el flujo puede ser más difícil de seguir.
- El orden de los decoradores puede afectar el resultado.

---

# 💡 ¿Cuándo utilizar Decorator?

Utiliza este patrón cuando:

- Necesites agregar funcionalidades de forma dinámica.
- No quieras modificar la implementación existente.
- Quieras combinar diferentes comportamientos.
- Quieras evitar una jerarquía enorme de herencia.

---

# 🆚 Decorator vs Builder

| Builder | Decorator |
|----------|-----------|
| Construye un objeto | Agrega comportamiento a un objeto existente |
| Patrón creacional | Patrón estructural |
| Se utiliza durante la creación | Se utiliza durante toda la vida del objeto |
| El Builder desaparece después de crear el objeto | El Decorator permanece envolviendo el objeto |

---

# 🆚 Decorator vs Adapter

| Adapter | Decorator |
|----------|-----------|
| Cambia la interfaz | Mantiene la misma interfaz |
| Hace compatibles dos clases | Agrega nuevas responsabilidades |
| Resuelve incompatibilidades | Extiende el comportamiento |

---

# 🌎 Ejemplos reales en iOS

El patrón Decorator es muy común en aplicaciones iOS empresariales.

Ejemplos:

- Agregar autenticación a un cliente HTTP.
- Registrar logs de las peticiones.
- Implementar reintentos automáticos.
- Agregar caché.
- Medir tiempos de respuesta.
- Registrar métricas en herramientas de observabilidad.

Ejemplo:

```text
MetricsDecorator
        │
        ▼
RetryDecorator
        │
        ▼
LoggingDecorator
        │
        ▼
AuthenticationDecorator
        │
        ▼
URLSessionClient
```

Cada decorador agrega una nueva responsabilidad sin modificar el cliente HTTP original.

---

# 📚 Conclusión

El patrón **Decorator** permite extender el comportamiento de un objeto de manera flexible, reutilizable y desacoplada.

En lugar de modificar una clase existente o crear múltiples subclases para cada combinación posible, se envuelve el objeto con decoradores que implementan la misma interfaz y agregan nuevas responsabilidades.

Es uno de los patrones estructurales más utilizados en proyectos reales por su simplicidad, flexibilidad y facilidad para cumplir con el principio **Open/Closed**.