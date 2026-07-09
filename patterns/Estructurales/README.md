# 🧩 Patrones Estructurales

Los **patrones estructurales** son patrones de diseño enfocados en definir cómo se organizan, relacionan y componen las clases y objetos dentro de un sistema.

Su objetivo principal es crear estructuras más flexibles, reducir el acoplamiento entre componentes y facilitar la reutilización del código.

Estos patrones ayudan a responder preguntas como:

- ¿Cómo puedo adaptar una interfaz existente sin modificar su código?
- ¿Cómo puedo agregar nuevas responsabilidades dinámicamente?
- ¿Cómo puedo simplificar la interacción con sistemas complejos?
- ¿Cómo puedo separar abstracciones de implementaciones?
- ¿Cómo puedo construir estructuras de objetos más escalables?

---

# 📚 Patrones incluidos

## 🔌 Adapter

Permite que objetos con interfaces incompatibles puedan trabajar juntos mediante un adaptador que transforma una interfaz existente en otra esperada por el cliente.

**Ejemplo en iOS:**

Adaptar una librería externa o API antigua a una nueva interfaz utilizada por la aplicación.

---

## 🎨 Decorator

Permite agregar nuevas responsabilidades o comportamientos a un objeto dinámicamente sin modificar su estructura original.

**Ejemplo en iOS:**

Agregar funcionalidades adicionales a componentes mediante composición en lugar de herencia.

---

## 🏛️ Facade

Proporciona una interfaz simplificada para interactuar con un conjunto de subsistemas complejos.

**Ejemplo en iOS:**

Una fachada que coordina autenticación, configuración de usuario, analytics y almacenamiento de sesión durante el inicio de la aplicación.

---

## 🌳 Composite

Permite tratar objetos individuales y grupos de objetos de manera uniforme mediante una estructura jerárquica.

**Ejemplo en iOS:**

Representar componentes de una interfaz donde un elemento puede contener otros elementos hijos.

---

## 🌉 Bridge

Separa una abstracción de su implementación, permitiendo que ambas puedan evolucionar de forma independiente.

**Ejemplo en iOS:**

Separar la lógica de negocio de diferentes implementaciones concretas de servicios o plataformas.

---

# 📂 Organización del proyecto

Cada patrón cuenta con su propia carpeta independiente:

```
Structural/
│
├── Adapter/
│   └── README.md
│
├── Decorator/
│   └── README.md
│
├── Facade/
│   └── README.md
│
├── Composite/
│   └── README.md
│
└── Bridge/
    └── README.md
```

Dentro de cada carpeta encontrarás:

- 📖 Explicación teórica del patrón.
- 🎯 Problema que resuelve.
- 💡 Cuándo utilizarlo.
- 🚫 Cuándo evitarlo.
- 🏗️ Implementación en Swift.
- 🧪 Ejemplo práctico.
- 🧩 Relación con principios SOLID.

---

# 🎯 Objetivo

El objetivo de esta sección es comprender cómo los patrones estructurales permiten diseñar aplicaciones más mantenibles, escalables y fáciles de evolucionar utilizando buenas prácticas de programación orientada a objetos en Swift.