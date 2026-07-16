# Mediator Pattern (Behavioral)

## Overview

Este proyecto demuestra la implementación del **patrón de diseño Mediator** utilizando Swift y un escenario de **reservación de hotel**.

El objetivo es mostrar cómo varios componentes pueden comunicarse entre sí **sin depender directamente unos de otros**, delegando toda la coordinación a un único objeto: el **Mediator**.

---

# Problem

Sin un Mediator, cada componente necesita conocer a los demás para poder interactuar.

```text
GuestForm  ----------> ConfirmButton
      │                  ▲
      │                  │
      ▼                  │
PaymentSection ----------┘
      ▲
      │
StayDateSelector
```

A medida que la aplicación crece:

* Incrementa el acoplamiento.
* El mantenimiento se vuelve más complejo.
* Es más difícil agregar nuevas funcionalidades.
* Los componentes dejan de tener una única responsabilidad.

---

# Solution

El patrón **Mediator** centraliza toda la comunicación.

```text
                    HotelReservationMediator
                 /          |          |          \
                /           |          |           \
        GuestForm   StayDateSelector  PaymentSection  ConfirmButton
```

Cada componente únicamente conoce al **Mediator**.

Cuando ocurre un cambio, el componente notifica el evento y el Mediator decide qué acciones ejecutar.

---

# Components

## ReservationMediator

Define el contrato para la comunicación entre componentes.

```swift
protocol ReservationMediator {
    func notify(sender:event:)
}
```

---

## ReservationComponent

Clase base de todos los componentes.

Cada componente mantiene únicamente una referencia al Mediator.

---

## GuestForm

Responsable de administrar la información del huésped.

Funciones:

* Capturar nombre.
* Capturar correo electrónico.
* Notificar cuando la información cambia.

---

## StayDateSelector

Responsable de administrar las fechas de hospedaje.

Funciones:

* Seleccionar Check-In.
* Seleccionar Check-Out.
* Notificar cuando las fechas cambian.

---

## PaymentSection

Responsable de administrar el método de pago.

Funciones:

* Guardar titular.
* Guardar últimos cuatro dígitos.
* Notificar cambios.

---

## ConfirmButton

Representa el botón para confirmar la reservación.

No conoce ningún otro componente.

Únicamente cambia su estado cuando el Mediator lo indica.

---

## HotelReservationMediator

Es el corazón del patrón.

Centraliza toda la coordinación del proceso de reservación.

Responsabilidades:

* Recibir eventos.
* Validar el estado de la reservación.
* Habilitar o deshabilitar el botón de confirmar.
* Confirmar la reservación cuando toda la información está completa.

---

# Flow

```text
Usuario

      │

      ▼

GuestForm

      │

      ▼

Mediator.notify()

      │

      ▼

validateReservation()

      │

      ▼

ConfirmButton.setEnabled(true)
```

Cada componente únicamente informa que ocurrió un evento.

Nunca interactúa directamente con otro componente.

---

# Sequence

```text
GuestForm
    │
    ▼
Mediator
    │
    ├── Validate Reservation
    └── Update ConfirmButton

StayDateSelector
    │
    ▼
Mediator
    │
    ├── Validate Reservation
    └── Update ConfirmButton

PaymentSection
    │
    ▼
Mediator
    │
    ├── Validate Reservation
    └── Update ConfirmButton

Confirm Reservation
    │
    ▼
Mediator
    │
    ▼
Reservation Confirmed
```

---

# Example Output

```text
👤 Guest Information Updated
Name : Osvaldo Cespedes
Email: osvaldo@hotel.com

Mediator → Guest information received.
🟢 Confirm Button: Disabled

📅 Stay Dates Updated
Check-In : 2026-07-22
Check-Out: 2026-07-27

Mediator → Stay dates received.
🟢 Confirm Button: Disabled

💳 Payment Updated
Holder : Osvaldo Cespedes
Card   : **** 4589

Mediator → Payment received.
🟢 Confirm Button: Enabled

✅ Reservation Confirmed

Guest : Osvaldo Cespedes
Email : osvaldo@hotel.com
Card  : **** 4589
```

---

# Advantages

* Reduce el acoplamiento entre componentes.
* Centraliza la comunicación.
* Facilita el mantenimiento.
* Mejora la reutilización.
* Facilita agregar nuevos componentes.
* Hace más sencillo escribir pruebas unitarias.
* Cada componente mantiene una única responsabilidad.

---

# Disadvantages

* Si el Mediator concentra demasiada lógica puede convertirse en un **God Object**.
* En proyectos grandes es recomendable dividir la coordinación en varios mediadores especializados.

---

# SOLID Principles Applied

## Single Responsibility Principle (SRP)

Cada componente tiene una única responsabilidad.

* `GuestForm` administra la información del huésped.
* `StayDateSelector` administra las fechas.
* `PaymentSection` administra el método de pago.
* `ConfirmButton` representa el estado del botón.
* `HotelReservationMediator` coordina la comunicación.

---

## Open/Closed Principle (OCP)

Es posible agregar nuevos componentes como:

* CouponSection
* RoomSelector
* LoyaltySection

sin modificar la implementación interna de los componentes existentes.

---

## Liskov Substitution Principle (LSP)

Todos los componentes heredan de `ReservationComponent`, por lo que pueden utilizarse de forma uniforme.

---

## Dependency Inversion Principle (DIP)

Los componentes dependen de la abstracción `ReservationMediator` y no de una implementación concreta.

---

# Real-World Examples

El patrón Mediator aparece con frecuencia en el desarrollo de aplicaciones:

### UIKit

Un `UIViewController` suele actuar como Mediator coordinando:

* UIButton
* UITableView
* UITextField
* UILabel
* UICollectionView

Los controles no se comunican entre sí; todos notifican al ViewController.

---

### Coordinator Pattern

El Coordinator coordina la navegación entre múltiples ViewControllers.

---

### SwiftUI

Un ViewModel puede desempeñar un rol similar al centralizar la coordinación entre la vista, servicios y lógica de negocio.

---

# Project Structure

```text
Mediator
│
├── ReservationEvent
├── ReservationMediator
├── ReservationComponent
│
├── GuestForm
├── StayDateSelector
├── PaymentSection
├── ConfirmButton
│
└── HotelReservationMediator
```

---

# Conclusion

El patrón **Mediator** ayuda a reducir el acoplamiento entre objetos al centralizar toda la comunicación en un único punto.

En este ejemplo, ningún componente conoce a los demás; todos notifican sus cambios al `HotelReservationMediator`, quien decide cómo coordinar el flujo de la reservación.

Este enfoque facilita el mantenimiento, mejora la escalabilidad y permite que cada componente permanezca enfocado en una única responsabilidad.
