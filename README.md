# 🧩 DesignPatternsSwift

Proyecto educativo en Swift enfocado en la comprensión e implementación práctica de los patrones de diseño más utilizados en desarrollo iOS.

El objetivo no es solo aprender la teoría, sino entender **cuándo, por qué y cómo aplicar cada patrón en proyectos reales**, siguiendo buenas prácticas de arquitectura en Swift.

---

# 🎯 Objetivo del proyecto

- Aprender patrones de diseño desde cero
- Implementarlos en Swift con ejemplos prácticos
- Entender casos de uso reales en desarrollo iOS
- Mejorar el diseño de código y arquitectura

---

# 🧠 Categorías de patrones

## 🟡 Creacionales (creación de objetos)
Patrones que controlan cómo se crean los objetos.

- Builder ✅ (implementado)
- Factory Method
- Abstract Factory
- Prototype
- Singleton

---

## 🔵 Estructurales (organización del código)
Patrones que definen cómo se estructuran los objetos y clases.

- Adapter
- Decorator
- Facade
- Composite
- Bridge
- Proxy
- Template Method

---

## 🟢 Comportamiento (interacción entre objetos)
Patrones que definen cómo se comunican los objetos.

- Strategy
- Observer
- Delegate (muy usado en iOS)
- Command
- State
- Chain of Responsibility
- Mediator
- Iterator
- Visitor
- Memento
- Interpreter

---

# 🧾 Teoría breve por categoría

- **Creacionales:** se centran en encapsular la lógica de creación de objetos para separar esa responsabilidad del resto del código. Ayudan a crear sistemas más flexibles y a soportar variaciones en la creación (por ejemplo, `Builder`, `Factory Method`, `Abstract Factory`, `Prototype`, `Singleton`).

- **Estructurales:** se ocupan de cómo se componen clases y objetos para formar estructuras más grandes, facilitando la reutilización y la reducción de complejidad (por ejemplo, `Adapter`, `Facade`, `Decorator`, `Proxy`, `Composite`, `Bridge`).

- **Comportamiento:** describen patrones de comunicación y responsabilidades entre objetos, definiendo algoritmos y flujos de control (por ejemplo, `Observer`, `Strategy`, `Command`, `State`, `Delegate`).

---

# 🚀 Orden recomendado de aprendizaje

Para este proyecto, una ruta de estudio muy sólida para desarrollo iOS profesional es la siguiente:

## Creacionales
1. Builder
2. Factory Method
3. Abstract Factory
4. Prototype
5. Singleton

## Estructurales
6. Adapter
7. Decorator
8. Facade
9. Proxy
10. Composite
11. Bridge
12. Template Method

## Comportamiento
13. Strategy
14. Observer
15. Command
16. State
17. Delegate
18. Chain of Responsibility
19. Mediator
20. Iterator
21. Visitor
22. Memento
23. Interpreter

Esta ruta permite pasar de la creación de objetos a la arquitectura de componentes y al diseño de sistemas más mantenibles.

---

# 🍔 Ejemplo implementado

### Builder Pattern

Ejemplo de construcción fluida de objetos:

```swift
let hamburguesa = Hamburguesa.Builder()
    .pan(.brioche)
    .carne(.pollo)
    .cebolla(true)
    .aguacate(true)
    .build()
```

---

**Contenido y uso**

- **Ejecutar:** abre el playground `Builder.playground` o `PD-Builder.playground` en Xcode (recomendado Xcode 12+ / Swift 5+).
- **Estructura:** el código de los patrones se organiza bajo la carpeta `patterns/`.

---

# 📚 Tabla de contenidos

- [🎯 Objetivo del proyecto](#-objetivo-del-proyecto)
- [🧠 Categorías de patrones](#-categorías-de-patrones)
- [🚀 Orden recomendado de aprendizaje](#-orden-recomendado-de-aprendizaje)
- [🍔 Ejemplo implementado](#-ejemplo-implementado)
- [📦 Patrones implementados](#-patrones-implementados)
- [⚙️ Cómo ejecutar](#️-cómo-ejecutar)
- [🤝 Contribuir](#-contribuir)

---

# 📦 Patrones implementados

- Creacionales:
    - Builder — ejemplo y playground en [Builder.playground](Builder.playground)

---

# ⚙️ Cómo ejecutar

1. Abre el proyecto en Xcode.
2. Para ver el ejemplo `Builder`, abre [Builder.playground](Builder.playground) o el playground `PD-Builder.playground`.
3. Recomendado: Xcode 12 o superior, Swift 5.

---

# 🤝 Contribuir

Gracias por tu interés en contribuir. Crea un fork, añade tu implementación bajo `patterns/` y abre un Pull Request describiendo el patrón y el archivo principal que añadiste. Lee [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

