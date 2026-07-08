# 🌳 Composite Pattern - Swift

Ejemplo práctico del patrón de diseño **Composite** implementado en Swift.

El objetivo de este ejemplo es comprender cómo podemos construir estructuras jerárquicas de objetos donde elementos individuales y grupos de elementos puedan tratarse de la misma manera.

Este patrón es especialmente importante en desarrollo iOS porque frameworks como **UIKit** y **SwiftUI** utilizan conceptos similares para construir árboles de componentes.

---

# 📚 ¿Qué es el patrón Composite?

**Composite** es un patrón de diseño estructural que permite organizar objetos en estructuras de árbol.

Su principal característica es que permite tratar:

- Objetos individuales (**Leaf**).
- Grupos de objetos (**Composite**).

mediante una misma abstracción.

---

# 🎯 Problema que resuelve

Imagina una pantalla compleja:

```
ProfileScreen
│
├── HeaderView
│   ├── Image
│   └── Label
│
├── InformationView
│   ├── Email
│   └── Phone
│
└── Button
```

Sin Composite, el cliente tendría que conocer cada componente:

```swift
imageView.configure()

nameLabel.configure()

emailLabel.configure()

button.configure()
```

Esto provoca:

- Mayor acoplamiento.
- Código difícil de mantener.
- Dependencia de la estructura interna.

---

# ✅ Usando Composite

El cliente solamente conoce el componente principal:

```swift
ProfileScreenView()
```

Internamente la estructura puede ser:

```
ProfileScreenView
        |
        |
     VStack
        |
 ┌──────┼────────┐
 ▼      ▼        ▼
Header Info   Button
  |
  |
 ┌──────┐
 ▼      ▼
Image Label
```

La complejidad queda encapsulada.

---

# 🧩 Estructura del patrón

```
              Component
                  |
        --------------------
        |                  |
        ▼                  ▼
      Leaf             Composite
                         |
                  ----------------
                  |       |      |
                  ▼       ▼      ▼
                Leaf    Leaf   Leaf
```

---

# 🏗️ Componentes del ejemplo

## Component

Define la abstracción común.

En SwiftUI:

```swift
View
```

es la abstracción principal.

Todos los elementos implementan:

```swift
View
```

---

## Leaf

Son elementos individuales que no contienen otros componentes.

Ejemplos:

```swift
Text()
```

```swift
Image()
```

```swift
Button()
```

---

## Composite

Son componentes que contienen otros componentes.

Ejemplos:

```swift
VStack
```

```swift
HStack
```

```swift
ZStack
```

```swift
ProfileScreenView
```

---

# 📱 Ejemplo en SwiftUI

Una pantalla puede estar compuesta así:

```
ProfileScreenView
│
├── HeaderView
│   ├── AvatarView
│   └── NameView
│
├── InformationView
│   ├── EmailView
│   └── LocationView
│
└── ActionButtonView
```

El cliente únicamente utiliza:

```swift
ProfileScreenView()
```

No necesita conocer los componentes internos.

---

# 🍎 Composite en UIKit

UIKit utiliza una estructura similar:

```
UIView
│
├── UIButton
├── UILabel
├── UIImageView
│
└── UIView
     |
     ├── UILabel
     └── UIButton
```

Todos heredan de:

```swift
UIView
```

Por eso podemos hacer:

```swift
view.addSubview(button)

view.addSubview(containerView)
```

sin importar si es un elemento simple o un contenedor.

---

# 🧱 Principios SOLID aplicados

## S — Single Responsibility Principle

Cada componente tiene una responsabilidad específica.

Ejemplo:

| Componente | Responsabilidad |
|-|-|
| AvatarView | Mostrar imagen |
| NameView | Mostrar nombre |
| InformationView | Agrupar información |
| ProfileScreenView | Coordinar componentes |

---

# O — Open / Closed Principle

El sistema puede extenderse agregando nuevos componentes.

Ejemplo:

```swift
struct LocationView: View {

    var body: some View {

        Text("México")

    }

}
```

No es necesario modificar los componentes existentes.

---

# L — Liskov Substitution Principle

Todos los componentes pueden sustituirse porque cumplen la misma abstracción:

```swift
View
```

Ejemplo:

```swift
let component: any View = Text("Hola")
```

También:

```swift
let component: any View = Button("Aceptar") {}
```

---

# I — Interface Segregation Principle

Cada componente implementa únicamente lo necesario.

SwiftUI utiliza una abstracción simple:

```swift
protocol View {

    associatedtype Body : View

}
```

Los componentes no necesitan implementar comportamientos que no utilizan.

---

# D — Dependency Inversion Principle

Los componentes dependen de abstracciones:

```swift
View
```

No dependen directamente de otros componentes concretos.

Ejemplo:

```swift
VStack {

    Text()

    Button()

}
```

`VStack` no necesita conocer detalles internos de `Text` o `Button`.

---

# 🧠 Ejemplo del flujo

```
Cliente
  |
  ▼
ProfileScreenView
  |
  ├── HeaderView
  |       |
  |       ├── AvatarView
  |       └── NameView
  |
  ├── InformationView
  |
  └── Button
```

---

# 🚀 ¿Cuándo utilizar Composite?

Utiliza Composite cuando:

✅ Necesitas representar estructuras jerárquicas.

✅ Existen objetos individuales y grupos de objetos.

✅ Quieres tratar ambos tipos de objetos de la misma manera.

Ejemplos:

- Árbol de vistas UI.
- Menús dinámicos.
- Sistemas de permisos.
- Categorías y subcategorías.
- Componentes reutilizables.
- Formularios dinámicos.

---

# ⚠️ ¿Cuándo NO utilizar Composite?

Evítalo cuando:

- No existe una estructura jerárquica.
- Los objetos no tienen comportamientos comunes.
- La abstracción agrega complejidad innecesaria.

---

# 📌 Composite en iOS

Este patrón aparece constantemente en:

## UIKit

```
UIView
 ├── UILabel
 ├── UIButton
 └── UIView
```

## SwiftUI

```swift
VStack {

    Text()

    Image()

    Button()

}
```

SwiftUI está construido alrededor de la composición de pequeñas vistas para crear interfaces complejas.

---

# 🎯 Conclusión

El patrón **Composite** permite construir sistemas complejos a partir de componentes simples.

Su principal beneficio es que el cliente trabaja con una abstracción común y no necesita conocer la estructura interna del árbol.

En iOS esto se refleja claramente en:

- `UIView` y `subviews`.
- `UIStackView`.
- `SwiftUI View`.
- Composición de componentes reutilizables.

Composite ayuda a crear interfaces:

- Más escalables.
- Más reutilizables.
- Más fáciles de mantener.

---

# 📖 Referencias

- Design Patterns: Elements of Reusable Object-Oriented Software  
  Gang of Four (GoF)

- Apple Developer Documentation

- SwiftUI Documentation