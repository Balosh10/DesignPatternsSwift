# Prototype

## ¿Qué es?

**Prototype** es un patrón de diseño **creacional** cuyo objetivo es crear nuevos objetos **clonando una instancia existente**, en lugar de construirlos desde cero.

La idea principal es:

> En lugar de utilizar `init` para crear un nuevo objeto, se realiza una copia de un objeto que ya existe.

---

# ¿Qué problema resuelve?

Hay ocasiones en las que crear un objeto puede ser costoso.

Por ejemplo:

- Cargar configuraciones desde un servidor.
- Inicializar un mapa.
- Construir un documento PDF.
- Cargar imágenes muy pesadas.
- Crear personajes en un videojuego.
- Configurar un objeto con muchas propiedades.

En estos casos resulta más eficiente clonar un objeto ya existente.

En lugar de:

```swift
let car = Car(...)
```

Se utiliza:

```swift
let car = existingCar.clone()
```

---

# Analogía

Imagina una fotocopiadora.

Tienes un documento original.

```
Documento Original
```

Necesitas diez copias.

No vuelves a escribir el documento diez veces.

Simplemente haces:

```
Documento Original

↓

Fotocopiadora

↓

10 Copias
```

Eso es exactamente el patrón Prototype.

---

# Participantes

## Prototype

Define el contrato para clonar un objeto.

```swift
protocol Prototype {

    func clone() -> Self

}
```

---

## Concrete Prototype

Implementa la lógica necesaria para crear una copia del objeto.

Ejemplo:

```swift
class Car {

    func clone() -> Car {
        Car(...)
    }

}
```

---

## Cliente

El cliente simplemente solicita una copia.

```swift
let copy = original.clone()
```

No necesita conocer cómo se construye el nuevo objeto.

---

# Flujo del patrón

```
Cliente

↓

Objeto Original

↓

clone()

↓

Nuevo Objeto
```

---

# Value Types vs Reference Types

En Swift este es el concepto más importante para comprender Prototype.

---

## Struct (Value Type)

Las `struct` tienen **semántica por valor**.

Cuando se asigna una variable a otra, Swift crea automáticamente una copia independiente.

Ejemplo:

```swift
struct Car {

    var color: String

}

var car1 = Car(color: "Rojo")
var car2 = car1

car2.color = "Azul"
```

Resultado:

```
car1.color = "Rojo"

car2.color = "Azul"
```

Cada variable contiene una copia distinta.

Por esta razón, Prototype suele ser menos necesario con `struct`.

---

## Class (Reference Type)

Las `class` tienen **semántica por referencia**.

Cuando se asigna una variable a otra, ambas apuntan al mismo objeto.

```swift
class Car {

    var color: String

    init(color: String) {
        self.color = color
    }

}

let car1 = Car(color: "Rojo")
let car2 = car1

car2.color = "Azul"
```

Resultado:

```
car1.color = "Azul"

car2.color = "Azul"
```

Solo existe un objeto.

Aquí es donde Prototype cobra importancia.

---

# Shallow Copy

Una **Shallow Copy** crea una nueva instancia del objeto principal, pero **comparte las referencias de los objetos internos**.

```
             Engine
                ▲
                │
        ┌───────┴────────┐
        │                │
     Car A            Car B
```

Modificar el motor desde cualquiera de los dos automóviles afecta a ambos.

---

# Deep Copy

Una **Deep Copy** crea una nueva instancia del objeto principal y también crea copias independientes de todos los objetos internos.

```
Car A

↓

Engine A


Car B

↓

Engine B
```

Cada objeto es completamente independiente.

---

# Ejemplo del repositorio

En este proyecto se utiliza una **Agencia de Automóviles**.

La agencia contiene:

- Inventario de automóviles.
- Automóviles vendidos.

La agencia puede generar dos tipos de copia:

## Shallow Copy

La nueva agencia comparte las mismas referencias de los automóviles.

```
Agencia A

↓

Car 1

↑

Agencia B
```

Modificar un automóvil afecta a ambas agencias.

---

## Deep Copy

La nueva agencia crea copias completamente nuevas de cada automóvil.

```
Agencia A

↓

Car A


Agencia B

↓

Car B
```

Ahora ambas agencias son completamente independientes.

---

# Ventajas

- Reduce el costo de crear objetos complejos.
- Evita reconstruir objetos desde cero.
- Simplifica la creación de objetos similares.
- Disminuye el acoplamiento entre el cliente y la lógica de construcción.

---

# Desventajas

- Implementar una copia profunda puede ser complejo.
- Es necesario decidir entre Shallow Copy y Deep Copy.
- Los objetos con muchas referencias pueden requerir una lógica de clonación más elaborada.

---

# Casos de uso en iOS

Prototype puede utilizarse para:

- Copiar configuraciones.
- Clonar modelos complejos.
- Duplicar documentos.
- Duplicar escenas de videojuegos.
- Copiar objetos de Foundation mediante `NSCopying`.
- Crear estados iniciales reutilizables.

Ejemplo:

```swift
let copy = configuration.copy()
```

o

```swift
let copy = original.clone()
```

---

# Relación con Programación Orientada a Objetos

## Abstracción

El cliente únicamente conoce:

```swift
clone()
```

No necesita conocer cómo se realiza la copia.

---

## Encapsulamiento

Cada objeto es responsable de saber cómo clonarse.

El cliente no necesita copiar manualmente todas sus propiedades.

---

# Relación con SOLID

## S - Single Responsibility Principle

Cada objeto conoce cómo clonarse.

La lógica de clonación no se distribuye por toda la aplicación.

---

## O - Open/Closed Principle

Es posible agregar nuevos objetos clonables sin modificar el código cliente.

---

## L - Liskov Substitution Principle

Cualquier implementación de Prototype puede sustituir a otra.

---

## D - Dependency Inversion Principle

El cliente puede depender de la abstracción (`Prototype`) en lugar de implementaciones concretas.

---

# Comparación con otros patrones creacionales

| Patrón | Objetivo |
|---------|----------|
| Builder | Construir un objeto paso a paso |
| Factory Method | Crear un objeto mediante una fábrica |
| Abstract Factory | Crear familias de objetos relacionados |
| Prototype | Crear objetos clonando otro existente |
| Singleton | Garantizar una única instancia |

---

# ¿Cuándo utilizar Prototype?

Utiliza Prototype cuando:

- Crear un objeto sea costoso.
- Necesites muchas instancias similares.
- Quieras evitar repetir configuraciones complejas.
- Desees desacoplar al cliente del proceso de construcción.
- Existan objetos que puedan reutilizarse como plantilla para generar nuevas instancias.

---

# Conclusión

Prototype permite crear nuevos objetos copiando una instancia existente.

En Swift es especialmente útil cuando se trabaja con **Reference Types (`class`)**, ya que estas no se copian automáticamente.

Comprender la diferencia entre **Value Types**, **Reference Types**, **Shallow Copy** y **Deep Copy** es fundamental para implementar correctamente este patrón.
