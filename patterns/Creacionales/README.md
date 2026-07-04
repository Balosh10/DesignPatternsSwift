# Patrones Creacionales (Creational Design Patterns)

Los **patrones creacionales** son un grupo de patrones de diseño cuyo objetivo es **controlar y abstraer la creación de objetos**, reduciendo el acoplamiento entre el código cliente y las implementaciones concretas.

En lugar de crear objetos directamente con `init`, estos patrones encapsulan la lógica de creación para hacer el sistema más flexible, reutilizable y escalable.

---

# Conceptos importantes

Antes de estudiar los patrones creacionales es fundamental comprender dos conceptos de Programación Orientada a Objetos.

---

## Abstracción

La **abstracción** consiste en exponer solo lo necesario y ocultar los detalles internos.

El cliente sabe **qué hace un objeto**, pero no **cómo lo hace**.

### Ejemplo

Comprar una casa:

> “Quiero una casa de 3 habitaciones”

No necesitas saber:

- Cómo se construye la cimentación
- Cómo se instalan tuberías
- Qué materiales se usan

Solo interactúas con el resultado.

---

## Encapsulamiento

El **encapsulamiento** protege el estado interno de un objeto y controla cómo puede modificarse.

En Swift se logra mediante:

```swift
private
fileprivate
internal
public
```

### Ejemplo

La constructora controla:

- Diseño estructural
- Materiales
- Instalaciones

El cliente no modifica directamente nada interno.

---

# Relación con SOLID

## S - Single Responsibility Principle

Cada patrón/fábrica tiene una única responsabilidad: crear objetos.

---

## O - Open/Closed Principle

Puedes agregar nuevas implementaciones sin modificar el código existente.

```text
BurgerKingFactory
McDonaldsFactory
KFCFactory
```

---

## L - Liskov Substitution Principle

Las implementaciones pueden sustituir la abstracción sin romper el sistema.

```swift
let factory: ComboFactory = BurgerKingFactory()
```

---

## I - Interface Segregation Principle

Las interfaces deben ser pequeñas y específicas del dominio.

```swift
protocol ComboFactory {
    func makeHamburguesa()
    func makePapas()
    func makeBebida()
}
```

---

## D - Dependency Inversion Principle

El código cliente depende de **protocolos**, no de implementaciones concretas.

```swift
class Client {

    private let factory: ComboFactory

}
```

---

# Orden recomendado de estudio

## 1. Builder

Construye objetos complejos paso a paso.

Evita inicializadores con muchos parámetros.

```text
HouseBuilder → House
```

---

## 2. Factory Method

Delega la creación de objetos a una fábrica.

```text
HouseFactory → House
```

---

## 3. Abstract Factory

Crea **familias de objetos relacionados y compatibles entre sí**.

Permite cambiar toda la familia sin modificar el cliente.

Ejemplo:

Burger King:

```text
🍔 Whopper
🍟 Papas BK
🥤 Coca-Cola BK
```

McDonald's:

```text
🍔 Big Mac
🍟 Papas McDonald's
🥤 Coca-Cola McDonald's
```

---

## 4. Prototype

Crea nuevos objetos clonando una instancia existente.

Útil cuando la creación es costosa o repetitiva.

```text
Objeto original → clone() → nuevo objeto
```

---

## 5. Singleton

Garantiza una única instancia de un objeto en toda la aplicación.

```text
AppConfig.shared
```

### ⚠️ Importante

Puede generar **estado global compartido**, lo que aumenta el acoplamiento si se usa incorrectamente.

---

# Evolución de los patrones

```text
Builder
↓
Construcción paso a paso

Factory Method
↓
Una fábrica crea un objeto

Abstract Factory
↓
Una fábrica crea familias de objetos relacionados

Prototype
↓
Clona objetos existentes

Singleton
↓
Una única instancia global
```

---

# Resumen

| Patrón | Propósito | Ejemplo |
|--------|----------|--------|
| Builder | Construcción paso a paso | Casa |
| Factory Method | Delegar creación | Casa |
| Abstract Factory | Familias de objetos | Restaurante combo |
| Prototype | Clonar objetos | Copia de casa |
| Singleton | Instancia única | Configuración global |

---

# Objetivo del repositorio

Este repositorio tiene como objetivo aprender patrones de diseño en **Swift**, explicando:

- Teoría clara
- Problema que resuelve
- Implementación práctica
- Casos de uso en iOS
- Relación con POO
- Relación con SOLID

Cada patrón incluye su propio README con ejemplos prácticos.
