# 🔄 Patrones de Comportamiento (Behavioral Patterns)

Los **Patrones de Comportamiento** (Behavioral Patterns) se enfocan en definir **cómo interactúan y colaboran los objetos** dentro de una aplicación.

Su objetivo es distribuir correctamente las responsabilidades, reducir el acoplamiento entre clases y facilitar la comunicación entre diferentes componentes del sistema.

A diferencia de los patrones **Creacionales**, que se encargan de la creación de objetos, y los **Estructurales**, que organizan su composición, los patrones de comportamiento describen **cómo los objetos intercambian información y ejecutan tareas de manera eficiente**.

---

# 🎯 Objetivos

- Mejorar la comunicación entre objetos.
- Reducir el acoplamiento.
- Encapsular comportamientos.
- Facilitar la extensión del sistema.
- Promover el cumplimiento de los principios SOLID.

---

# 📚 Patrones incluidos

| Patrón | Descripción |
|---------|-------------|
| **Observer** | Permite que múltiples objetos sean notificados automáticamente cuando otro objeto cambia de estado. |
| **Strategy** | Encapsula diferentes algoritmos o comportamientos para que puedan intercambiarse dinámicamente. |
| **Delegate** | Permite que un objeto delegue parte de su comportamiento a otro objeto mediante un protocolo. Es uno de los patrones más utilizados en iOS. |
| **Command** | Encapsula una petición como un objeto, permitiendo ejecutar, almacenar o deshacer acciones. |
| **State** | Permite que un objeto cambie su comportamiento cuando cambia su estado interno. |

---

# 📂 Estructura

```text
BehavioralPatterns/
│
├── Observer/
│   ├── Observer.playground
│   └── README.md
│
├── Strategy/
│   ├── Strategy.playground
│   └── README.md
│
├── Delegate/
│   ├── Delegate.playground
│   └── README.md
│
├── Command/
│   ├── Command.playground
│   └── README.md
│
└── State/
    ├── State.playground
    └── README.md
```

Cada patrón incluye:

- 📖 Explicación teórica.
- 🎯 Problema que resuelve.
- ✅ Solución propuesta.
- 🏗️ Estructura del patrón.
- 💻 Implementación completa en Swift.
- 📈 Ventajas y desventajas.
- 💡 Casos de uso reales en iOS.
- 🧠 Principios SOLID relacionados.
- 🔄 Comparación con patrones similares cuando aplica.