# 🧩 DesignPatternsSwift

Proyecto educativo en Swift para aprender y practicar los patrones de diseño más comunes en desarrollo iOS.

El propósito de este repositorio no es solo mostrar teoría, sino ofrecer ejemplos claros, organizados y ejecutables con playgrounds para comprender cuándo y cómo aplicar cada patrón en proyectos reales.

---

## 🎯 Objetivo del proyecto

- Aprender patrones de diseño desde cero.
- Implementarlos en Swift con ejemplos prácticos.
- Entender casos de uso reales en desarrollo iOS.
- Mejorar la estructuración y mantenibilidad del código.

---

## 🧠 Estructura del repositorio

Los ejemplos están organizados por categorías dentro de [patterns](patterns):

- [patterns/Creacionales](patterns/Creacionales) para patrones de creación de objetos.
- [patterns/Estructurales](patterns/Estructurales) para la composición y organización de clases.
- [patterns/Comportamiento](patterns/Comportamiento) para la interacción entre objetos.

---

## 📦 Patrones incluidos

### Creacionales
- Builder
- Factory Method
- Abstract Factory
- Prototype
- Singleton

### Estructurales
- Adapter
- Decorator
- Facade
- Composite
- Bridge
- Proxy

### Comportamiento
- Strategy
- Observer
- Delegate
- Command
- State
- Chain of Responsibility
- Mediator
- Iterator
- Visitor
- Memento
- Interpreter
- Template Method

---

## 🚀 Cómo ejecutar los ejemplos

1. Abre el proyecto en Xcode 12 o superior.
2. Dirígete a la carpeta del patrón que quieras revisar, por ejemplo [patterns/Creacionales/Builder/Builder.playground](patterns/Creacionales/Builder/Builder.playground).
3. Ejecuta el playground para ver el ejemplo en acción.

Ejemplo rápido:

```swift
let hamburguesa = Hamburguesa.Builder()
    .pan(.brioche)
    .carne(.pollo)
    .cebolla(true)
    .aguacate(true)
    .build()
```

---

## 📚 Ruta recomendada de estudio

1. Builder
2. Factory Method
3. Abstract Factory
4. Prototype
5. Singleton
6. Adapter
7. Decorator
8. Facade
9. Proxy
10. Composite
11. Bridge
12. Strategy
13. Observer
14. Command
15. State
16. Delegate
17. Chain of Responsibility
18. Mediator
19. Iterator
20. Visitor
21. Memento
22. Interpreter
23. Template Method

Esta ruta permite pasar de la creación de objetos a la organización del código y finalmente a la interacción entre componentes.

---

## 🤝 Contribuir

Si quieres colaborar, crea un fork del repositorio, añade tu ejemplo bajo [patterns](patterns) y abre un pull request describiendo el patrón y el objetivo del cambio. Consulta [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

