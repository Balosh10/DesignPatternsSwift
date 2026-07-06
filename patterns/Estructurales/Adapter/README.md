# 🔌 Adapter Pattern

## ¿Qué es?

El **Adapter** es un **patrón de diseño estructural** cuyo objetivo es permitir que **dos clases con interfaces incompatibles puedan trabajar juntas sin modificar su implementación**.

En otras palabras, el Adapter actúa como un **traductor** entre el **Client** y el **Adaptee**, convirtiendo una interfaz en otra que el cliente pueda entender.

---

# 🎯 Problema

Imagina que tienes una **MacBook** que únicamente dispone de puertos **USB-C**.

La MacBook solo sabe comunicarse mediante dispositivos compatibles con **USB-C**.

Sin embargo, deseas conectar una memoria **USB-A**.

Existe un problema:

- La **MacBook** espera una interfaz USB-C.
- La **Memoria USB** únicamente ofrece una interfaz USB-A.

Ambos dispositivos utilizan interfaces diferentes y no pueden comunicarse directamente.

---

# ✅ Solución

Se agrega un **Adapter** entre ambos.

El Adapter implementa la interfaz que espera la MacBook (**USB-C**) y, de forma interna, traduce esa comunicación hacia la interfaz del dispositivo USB-A.

```text
                 MacBook
                 (Client)

                      │
                      │ connect()
                      ▼

               USBCDevice
                  (Target)

                      ▲
                      │ implementa
                      │

            USBFlashAdapter
                 (Adapter)

                      │
                      │ plugUSB()
                      ▼

            USBFlashDrive
                 (Adaptee)
```

De esta manera:

- La **MacBook** nunca conoce el dispositivo USB-A.
- La **Memoria USB** nunca sabe que existe una MacBook.
- El **Adapter** se encarga de traducir ambas interfaces.

---

# 👥 Participantes

## Client

Es quien utiliza el servicio.

En este ejemplo:

```text
MacBook
```

La MacBook únicamente conoce dispositivos compatibles con USB-C.

Nunca conoce la implementación real del dispositivo.

---

## Target

Es el contrato que espera el Client.

```swift
protocol USBCDevice {

    func connect()

}
```

La MacBook únicamente sabe trabajar con objetos que implementen este protocolo.

---

## Adapter

Es el traductor entre ambas interfaces.

Implementa el Target y adapta las llamadas hacia el Adaptee.

```swift
final class USBFlashAdapter: USBCDevice {

    func connect() {
        flashDrive.plugUSB()
    }

}
```

---

## Adaptee

Es la clase existente con una interfaz incompatible.

```swift
final class USBFlashDrive {

    func plugUSB()

}
```

No entiende `connect()`.

Únicamente conoce `plugUSB()`.

---

# 🔄 Flujo de ejecución

```text
MacBook

↓

connect()

↓

USBFlashAdapter

↓

plugUSB()

↓

USBFlashDrive
```

La MacBook cree que está trabajando con un dispositivo USB-C.

En realidad, el Adapter está traduciendo la llamada hacia un dispositivo USB-A.

---

# 🧠 Analogía del mundo real

Una MacBook solo dispone de puertos USB-C.

Sin embargo, deseas conectar:

- Una memoria USB-A
- Un cable HDMI
- Un adaptador Ethernet

Todos ellos poseen interfaces diferentes.

El **Adapter USB-C** tiene dos caras:

```text
MacBook
     │
 USB-C
     │
┌──────────────┐
│   Adapter    │
└──────────────┘
 │      │
 │      └──── HDMI
 │
 └────────── USB-A
```

Por un lado entiende **USB-C**.

Por el otro entiende **USB-A**, **HDMI**, **Ethernet**, etc.

Su responsabilidad consiste en traducir la comunicación entre ambos mundos.

---

# 💻 Ejecución

```swift
let usbFlashDrive = USBFlashDrive()

let usbAdapter = USBFlashAdapter(
    flashDrive: usbFlashDrive
)

let macBook = MacBook()

macBook.connect(device: usbAdapter)
```

Salida:

```text
💻 MacBook detectó un dispositivo USB-C
🔄 Adaptando USB-C → USB-A
💾 USB-A conectado correctamente...
```

---

# ✅ Ventajas

- Reduce el acoplamiento entre clases.
- Permite reutilizar código existente.
- No modifica el Client.
- No modifica el Adaptee.
- Facilita agregar nuevos dispositivos.
- Favorece el uso de interfaces.
- Mejora la mantenibilidad del sistema.

---

# ❌ Desventajas

- Incrementa el número de clases.
- Agrega un nivel adicional de abstracción.
- Puede volverse innecesario si ambas interfaces ya son compatibles.

---

# 🧩 SOLID

Este ejemplo aplica varios principios SOLID.

## ✅ Single Responsibility Principle (SRP)

Cada clase tiene una única responsabilidad.

- **MacBook** únicamente utiliza dispositivos.
- **USBFlashDrive** únicamente representa una memoria USB.
- **USBFlashAdapter** únicamente adapta interfaces.

---

## ✅ Open/Closed Principle (OCP)

Podemos agregar nuevos adaptadores sin modificar la MacBook.

Ejemplo:

- HDMIAdapter
- EthernetAdapter
- SDCardAdapter

---

## ✅ Liskov Substitution Principle (LSP)

Cualquier implementación de `USBCDevice` puede sustituir a otra.

La MacBook nunca necesita cambiar.

---

## ✅ Interface Segregation Principle (ISP)

`USBCDevice` únicamente expone el comportamiento necesario:

```swift
func connect()
```

No obliga a implementar métodos innecesarios.

---

## ✅ Dependency Inversion Principle (DIP)

La MacBook depende de una abstracción.

```swift
protocol USBCDevice
```

No depende directamente de:

```swift
USBFlashDrive
```

El Adapter también depende del protocolo `USBDrive`, lo que permite sustituir cualquier dispositivo USB-A sin modificar su implementación.

---

# 🚀 Casos de uso reales en iOS

El patrón Adapter es muy común en aplicaciones empresariales.

Ejemplos:

- Adaptar SDKs de Analytics (Firebase, Pendo, Datadog).
- Integrar pasarelas de pago (Stripe, PayPal, Mercado Pago).
- Adaptar APIs REST a modelos de dominio.
- Convertir APIs con Callbacks a Async/Await.
- Integrar bibliotecas de terceros sin acoplar la aplicación.

---

# 📚 Conclusión

El **Adapter Pattern** permite que clases con interfaces incompatibles trabajen juntas mediante una clase intermediaria.

El **Client** únicamente conoce el **Target**.

El **Adapter** implementa ese contrato y traduce las llamadas hacia el **Adaptee**, evitando modificar cualquiera de las dos partes y promoviendo un diseño desacoplado, extensible y fácil de mantener.