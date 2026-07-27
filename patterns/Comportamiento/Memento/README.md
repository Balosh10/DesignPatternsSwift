# Memento Pattern (Patrón Memento)

## Introducción

El **Patrón Memento** es un patrón de comportamiento (*Behavioral Pattern*) descrito por la **Gang of Four (GoF)**.

Su objetivo es **capturar y almacenar el estado interno de un objeto sin exponer su implementación**, permitiendo restaurarlo posteriormente cuando sea necesario.

Es uno de los patrones más utilizados para implementar funcionalidades como:

- Undo / Redo
- Historial de cambios
- Guardado automático
- Checkpoints
- Recuperación de estado

---

# Problema

Imaginemos un editor de texto.

El usuario escribe:

```
Hola
```

Después escribe:

```
Hola Mundo
```

Después:

```
Hola Mundo!!!
```

Ahora presiona **Undo**.

El editor debe regresar al estado anterior.

```
Hola Mundo
```

Sin el patrón Memento, una clase externa tendría que conocer todas las propiedades internas del editor para restaurarlas.

Esto rompe el principio de encapsulación.

El patrón Memento resuelve este problema permitiendo que el propio objeto cree una "fotografía" de sí mismo.

---

# Solución

El objeto que contiene la información crea un **Snapshot (Memento)** de su estado.

Posteriormente ese Snapshot puede almacenarse y utilizarse para restaurar el objeto cuando sea necesario.

```
Estado actual
      │
      ▼
+--------------+
|  Originator  |
+--------------+
      │
 save()
      │
      ▼
+--------------+
|   Memento    |
+--------------+
      │
      ▼
+--------------+
|  Caretaker   |
+--------------+
```

---

# Participantes

## Originator

Es el objeto cuyo estado queremos guardar.

Responsabilidades:

- Crear un Snapshot.
- Restaurar un Snapshot.
- Conocer completamente su estado.

En este proyecto:

```
TextEditor
```

---

## Memento

Representa una fotografía del estado del Originator.

Características:

- Inmutable.
- No contiene lógica.
- Solo almacena datos.

En este proyecto:

```
EditorMemento
```

---

## Caretaker

Administra el historial de snapshots.

Responsabilidades:

- Guardar estados.
- Implementar Undo.
- Implementar Redo.

No conoce el estado interno del Originator.

En este proyecto:

```
HistoryManager
```

---

# Arquitectura

```
                Usuario
                    │
                    ▼
             +--------------+
             | TextEditor   |
             | Originator   |
             +--------------+
                    │
              save()
                    │
                    ▼
            +----------------+
            | EditorMemento  |
            +----------------+
                    │
                    ▼
          +--------------------+
          | HistoryManager     |
          | Caretaker          |
          +--------------------+
            ▲              │
            │              │
            └──── restore()┘
```

---

# Flujo del ejemplo

## Paso 1

Estado inicial

```
""
```

Se guarda un Snapshot.

```
Snapshot 0
```

---

## Paso 2

El usuario escribe:

```
Hola
```

Nuevo Snapshot.

```
Snapshot 1
```

---

## Paso 3

El usuario escribe:

```
Hola Mundo
```

Nuevo Snapshot.

```
Snapshot 2
```

---

## Paso 4

El usuario escribe:

```
Hola Mundo!!!
```

Todavía no se realiza Undo.

---

## Paso 5

El usuario presiona:

```
Undo
```

HistoryManager devuelve el Snapshot anterior.

```
Hola Mundo
```

---

## Paso 6

El usuario vuelve a presionar:

```
Undo
```

Resultado:

```
Hola
```

---

## Paso 7

El usuario presiona:

```
Redo
```

Resultado:

```
Hola Mundo
```

---

# Estructura del proyecto

```
MementoExample
│
├── EditorMemento.swift
├── TextEditor.swift
├── HistoryManager.swift
└── main.swift
```

---

# Responsabilidad de cada archivo

## EditorMemento.swift

Representa un Snapshot.

```swift
struct EditorMemento
```

Contiene únicamente la información necesaria para restaurar el estado.

---

## TextEditor.swift

Es el Originator.

Funciones principales:

```swift
save()
restore()
write()
replace()
```

Solo esta clase conoce cómo guardar y restaurar su información.

---

## HistoryManager.swift

Es el Caretaker.

Administra:

- Undo Stack
- Redo Stack

Funciones:

```swift
save()

undo()

redo()
```

No conoce absolutamente nada del funcionamiento interno del editor.

---

## main.swift

Simula el comportamiento del usuario.

Ejemplo:

```
Escribir

↓

Guardar

↓

Escribir

↓

Guardar

↓

Undo

↓

Redo
```

---

# Salida esperada

```
Estado inicial

Escribe Hola

Hola

Escribe Mundo

Hola Mundo

Escribe !!!

Hola Mundo !!!

UNDO

Hola Mundo

UNDO

Hola

REDO

Hola Mundo
```

---

# Ventajas

✅ Mantiene el encapsulamiento.

✅ Facilita implementar Undo/Redo.

✅ Separa responsabilidades.

✅ Permite guardar múltiples estados.

✅ Es fácil extender el historial.

---

# Desventajas

❌ Puede consumir mucha memoria.

❌ Los snapshots grandes pueden afectar el rendimiento.

❌ Se recomienda limitar el historial cuando existan miles de cambios.

---

# Casos de uso reales

## Editor de texto

```
Word

Pages

Google Docs
```

Undo / Redo.

---

## Editor de imágenes

```
Photoshop

Pixelmator

Figma
```

Cada modificación crea un Snapshot.

---

## Videojuegos

```
Guardar partida

↓

Continuar después
```

El estado del jugador se restaura completamente.

---

## Formularios

Antes de enviar una solicitud:

```
Guardar estado
```

Si el usuario cancela:

```
Restaurar formulario
```

---

## IDE

```
Xcode

Visual Studio Code

Android Studio
```

Undo / Redo de código.

---

# ¿Cuándo usar Memento?

Utiliza este patrón cuando:

- Necesites implementar Undo.
- Quieras implementar Redo.
- Debas guardar estados del sistema.
- Existan checkpoints.
- Quieras mantener el encapsulamiento.

---

# Comparación con otros patrones

| Patrón | Objetivo |
|---------|----------|
| State | Cambia el comportamiento según el estado actual. |
| Command | Representa acciones como objetos. |
| Memento | Guarda y restaura estados anteriores. |

---

# Resumen

El patrón **Memento** permite capturar y restaurar el estado de un objeto sin exponer sus detalles internos.

En este ejemplo:

- **TextEditor** es el **Originator**.
- **EditorMemento** representa cada **Snapshot**.
- **HistoryManager** administra el historial mediante **Undo** y **Redo**.

Gracias a esta separación de responsabilidades, el sistema mantiene el encapsulamiento y ofrece una solución limpia y extensible para la gestión de estados, siendo ideal para aplicaciones que requieren historial de cambios, recuperación de información o funcionalidades de deshacer y rehacer.