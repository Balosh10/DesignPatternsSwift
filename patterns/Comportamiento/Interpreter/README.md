# Interpreter Pattern

## Descripción

El patrón de diseño **Interpreter** es un patrón de comportamiento (**Behavioral Pattern**) que define una representación para la gramática de un lenguaje y proporciona un intérprete para evaluar expresiones escritas en dicho lenguaje.

Cada regla del lenguaje se representa mediante una clase, permitiendo construir árboles de expresiones capaces de interpretar consultas complejas de manera flexible y extensible.

En este ejemplo se implementa un sistema de autorización de usuarios utilizando expresiones booleanas.

---

## Objetivo

Determinar si un usuario tiene acceso a un recurso evaluando la siguiente expresión:

```text
(Admin AND Active) OR Premium
```

Esto significa que un usuario tendrá acceso cuando:

- Sea administrador y esté activo.
- O bien sea un usuario Premium.

---

## Estructura del proyecto

```text
Interpreter.playground
```

Todo el ejemplo se encuentra en un único Playground para facilitar su ejecución.

---

## Participantes

### Context

Contiene la información que será utilizada durante la interpretación.

```swift
struct User
```

Incluye:

- Nombre
- Si es administrador
- Si está activo
- Si es usuario Premium

---

### Abstract Expression

Define la interfaz que todas las expresiones deberán implementar.

```swift
protocol Expression
```

Todas las expresiones implementan el método:

```swift
func interpret(context: User) -> Bool
```

---

### Terminal Expressions

Representan las condiciones básicas del lenguaje.

- `AdminExpression`
- `ActiveExpression`
- `PremiumExpression`

Cada una evalúa una única condición del usuario.

Ejemplo:

```swift
AdminExpression()
```

---

### Non Terminal Expressions

Combinan otras expresiones para formar reglas más complejas.

En este proyecto se implementan:

- `AndExpression`
- `OrExpression`
- `NotExpression`

Estas expresiones reciben otras expresiones mediante composición.

Ejemplo:

```swift
AndExpression(
    left: AdminExpression(),
    right: ActiveExpression()
)
```

---

## Diagrama

```text
                 OR
               /     \
            AND     Premium
           /   \
      Admin   Active
```

Cada nodo interpreta a sus hijos hasta obtener un resultado final.

---

## Flujo de ejecución

El cliente construye el árbol de expresiones.

```swift
let expression = OrExpression(
    left: AndExpression(
        left: AdminExpression(),
        right: ActiveExpression()
    ),
    right: PremiumExpression()
)
```

Posteriormente cada usuario es evaluado.

```swift
expression.interpret(context: user)
```

Cada nodo delega la interpretación a sus hijos hasta obtener un valor booleano.

---

## Salida esperada

```text
========== Interpreter ==========

Usuario : Juan
¿Tiene acceso? ✅ Sí

-------------------------------

Usuario : Pedro
¿Tiene acceso? ✅ Sí

-------------------------------

Usuario : Ana
¿Tiene acceso? ❌ No

-------------------------------

Usuario : Luis
¿Tiene acceso? ❌ No
```

---

## Ventajas

- Sigue el principio Open/Closed.
- Cada regla queda encapsulada en una clase.
- Es sencillo agregar nuevas expresiones.
- Facilita construir árboles de expresiones complejos.
- Permite reutilizar reglas existentes.

---

## Desventajas

- El número de clases puede crecer rápidamente.
- No es recomendable para gramáticas muy complejas.
- Puede resultar excesivo para problemas simples.

---

## Casos de uso

Este patrón suele utilizarse en:

- Motores de reglas de negocio.
- Filtros de búsqueda.
- Consultas tipo SQL.
- Expresiones booleanas.
- Motores de autorización.
- Validadores de permisos.
- Calculadoras.
- Lenguajes específicos de dominio (DSL).

---

## Ejemplo de evaluación

Expresión:

```text
(Admin AND Active) OR Premium
```

### Usuario 1

```text
Admin   = true
Active  = true
Premium = false
```

Evaluación:

```text
(true AND true) OR false

↓

true
```

Resultado:

```text
Acceso permitido
```

---

### Usuario 2

```text
Admin   = true
Active  = false
Premium = false
```

Evaluación:

```text
(true AND false) OR false

↓

false
```

Resultado:

```text
Acceso denegado
```

---

## Diferencias con otros patrones

| Patrón | Diferencia |
|----------|------------|
| Composite | Organiza objetos en forma de árbol. Interpreter normalmente utiliza Composite para representar expresiones. |
| Strategy | Cambia algoritmos. Interpreter interpreta una gramática. |
| Command | Encapsula acciones. Interpreter encapsula reglas de un lenguaje. |
| Visitor | Agrega operaciones sobre estructuras existentes. Interpreter evalúa expresiones. |

---

## Conclusión

El patrón **Interpreter** permite representar una gramática mediante una jerarquía de clases donde cada expresión conoce cómo interpretarse.

Las expresiones terminales representan las condiciones básicas, mientras que las expresiones no terminales combinan otras expresiones para construir reglas más complejas.

Este enfoque facilita la extensión del lenguaje sin modificar el código existente, lo que lo convierte en una excelente opción para motores de reglas, filtros de búsqueda, validadores y lenguajes específicos de dominio.