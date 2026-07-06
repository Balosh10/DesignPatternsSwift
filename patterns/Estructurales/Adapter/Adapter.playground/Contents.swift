import Foundation

//==============================================================
// MARK: - Target
//==============================================================

/*
 El Target representa el contrato que espera el Client.

 La MacBook únicamente sabe trabajar con dispositivos
 que implementen esta interfaz.

 No le importa si detrás existe:

 - Una memoria USB-A
 - Un adaptador HDMI
 - Un lector de tarjetas SD
 - Un adaptador Ethernet

 Mientras implementen este contrato, la MacBook podrá
 utilizarlos sin conocer su implementación.
 */

protocol USBCDevice {

    /// Conecta un dispositivo compatible con USB-C.
    func connect()

}

//
// SOLID
//
// DIP (Dependency Inversion Principle)
//
// El Client depende de una abstracción
// y no de una implementación concreta.
//

//==============================================================
// MARK: - Adaptee Contract
//==============================================================

/*
 Este protocolo representa la interfaz propia
 de los dispositivos USB-A.

 La MacBook NO conoce este contrato.

 Únicamente el Adapter interactúa con él.
 */

protocol USBDrive {

    /// Conecta un dispositivo mediante USB-A.
    func plugUSB()

}

//==============================================================
// MARK: - Adaptee
//==============================================================

/*
 Clase existente.

 Representa una memoria USB tradicional
 cuya interfaz es incompatible con la MacBook.

 La MacBook espera:

 connect()

 Pero esta clase únicamente entiende:

 plugUSB()
 */

final class USBFlashDrive: USBDrive {

    func plugUSB() {
        print("💾 USB-A conectado correctamente...")
    }

}

//==============================================================
// MARK: - Adapter
//==============================================================

/*
 El Adapter es el corazón del patrón.

 Tiene dos responsabilidades principales:

 1. Implementar el Target (USBCDevice)
    para que la MacBook pueda comunicarse con él.

 2. Traducir las llamadas del Target
    hacia la interfaz del Adaptee.

 La MacBook cree que está hablando con un
 dispositivo USB-C.

 En realidad, el Adapter traduce la llamada
 hacia un dispositivo USB-A.
 */

final class USBFlashAdapter: USBCDevice {

    /// Referencia al dispositivo USB-A.
    private let flashDrive: USBDrive

    init(flashDrive: USBDrive) {
        self.flashDrive = flashDrive
    }

    /*
     Traducción de interfaces.

     MacBook
        │
        ▼
     connect()

     Adapter
        │
        ▼
     plugUSB()

     USBFlashDrive
     */

    func connect() {

        print("🔄 Adaptando USB-C → USB-A")

        flashDrive.plugUSB()

    }

}

//
// SOLID
//
// SRP (Single Responsibility Principle)
//
// El Adapter únicamente adapta interfaces.
//
// No contiene lógica de negocio.
//
//
//
// DIP (Dependency Inversion Principle)
//
// El Adapter tampoco depende de
// USBFlashDrive.
//
// Depende del protocolo:
//
// USBDrive
//
// Lo que permite cambiar el Adaptee
// por cualquier otro dispositivo USB-A.
//

//==============================================================
// MARK: - Client
//==============================================================

/*
 El Client representa la MacBook.

 Observa que la MacBook NO conoce:

 - USBFlashDrive
 - HDMI
 - Ethernet
 - SD Card

 Únicamente conoce el Target:

 USBCDevice

 Esto reduce el acoplamiento
 y facilita extender el sistema.
 */

final class MacBook {

    func connect(device: USBCDevice) {

        print("💻 MacBook detectó un dispositivo USB-C")

        device.connect()

    }

}

//
// SOLID
//
// OCP (Open/Closed Principle)
//
// Si mañana aparece:
//
// HDMIAdapter
// EthernetAdapter
// SDCardAdapter
//
// La MacBook NO necesita modificarse.
//
//
//
// LSP (Liskov Substitution Principle)
//
// Cualquier Adapter que implemente
// USBCDevice podrá sustituir a otro.
//
//
//
// ISP (Interface Segregation Principle)
//
// USBCDevice únicamente expone:
//
// connect()
//
// No obliga a implementar métodos
// innecesarios.
//

//==============================================================
// MARK: - Demo
//==============================================================

// Adaptee

let usbFlashDrive = USBFlashDrive()

// Adapter

let usbAdapter = USBFlashAdapter(
    flashDrive: usbFlashDrive
)

// Client

let macBook = MacBook()

// La MacBook únicamente conoce:
//
// USBCDevice
//
// Nunca conoce USBFlashDrive.

macBook.connect(device: usbAdapter)
