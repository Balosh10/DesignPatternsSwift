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
- Singleton

---

## 🔵 Estructurales (organización del código)
Patrones que definen cómo se estructuran los objetos y clases.

- Adapter
- Decorator
- Facade
- Composite
- Bridge

---

## 🟢 Comportamiento (interacción entre objetos)
Patrones que definen cómo se comunican los objetos.

- Observer
- Strategy
- Delegate (muy usado en iOS)
- Command
- State

---

# 🚀 Orden recomendado de aprendizaje

Para entenderlos de forma progresiva:

### 🥇 Nivel 1 (fundamentos)
- Builder
- Factory Method
- Singleton

### 🥈 Nivel 2 (muy usados en iOS real)
- Delegate
- Observer
- Strategy

### 🥉 Nivel 3 (arquitectura avanzada)
- Adapter
- Facade
- Decorator

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
