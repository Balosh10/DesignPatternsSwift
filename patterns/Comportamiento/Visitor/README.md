# Visitor Pattern

> **Categoría:** Behavioral (Behavioral Design Patterns)
>
> **Objetivo:** Permitir agregar nuevas operaciones sobre una estructura de objetos sin modificar las clases de dichos objetos.

---

# Índice

- ¿Qué es Visitor?
- Problema
- Solución
- Estructura
- Componentes
- Flujo del patrón
- Implementación en Swift
- Ejemplo completo
- Flujo de ejecución del ejemplo
- Resultado esperado
- Ventajas
- Desventajas
- Cuándo usarlo
- Cuándo evitarlo
- Casos de uso en iOS
- Conclusión

---

# ¿Qué es Visitor?

El patrón **Visitor** es un patrón de comportamiento (Behavioral Pattern) que permite definir nuevas operaciones sobre un conjunto de objetos **sin modificar sus clases**.

La idea principal consiste en separar:

- Los **datos** (objetos del dominio)
- Las **operaciones** que se realizan sobre ellos

En lugar de agregar métodos como:

- generarPDF()
- calcularImpuestos()
- enviarAnalytics()
- sincronizarCRM()

directamente en las entidades, esas operaciones se implementan en objetos llamados **Visitors**.

Cada Visitor "visita" un objeto y ejecuta una acción específica.

---

# Problema

Supongamos que tenemos una aplicación hotelera.

Existen diferentes tipos de reservaciones.

```text
Reservation
    │
    ├── PalaceReservation
    └── LeBlancReservation
```

Inicialmente únicamente almacenan información.

Posteriormente el negocio solicita nuevas funcionalidades.

- Calcular impuestos
- Generar PDF
- Exportar Excel
- Sincronizar CRM
- Enviar Analytics
- Generar QR
- Validar promociones

Una solución incorrecta sería agregar todas estas funciones dentro de cada clase.

```swift
class PalaceReservation {

    func calculateTaxes(){}

    func generatePDF(){}

    func exportExcel(){}

    func syncCRM(){}

    func analytics(){}

}
```

Conforme crece la aplicación, las entidades terminan con demasiadas responsabilidades.

Esto viola el principio **Single Responsibility** y obliga a modificar constantemente las mismas clases.

---

# Solución

Mover cada operación hacia un Visitor independiente.

```text
                 Reservation
                      ▲
                      │
       ┌──────────────┴──────────────┐
       │                             │
PalaceReservation          LeBlancReservation

                ▲
                │
      accept(visitor)

                │

                ▼

        ReservationVisitor

        ├── TaxVisitor

        ├── PDFVisitor

        ├── CRMVisitor

        ├── AnalyticsVisitor

        └── QRCodeVisitor
```

Cada Visitor implementa una sola responsabilidad.

Las entidades nunca cambian.

---

# Estructura UML

```text
                  +-------------------------+
                  | ReservationVisitor      |
                  +-------------------------+
                  | visit(Palace)           |
                  | visit(LeBlanc)          |
                  +-----------▲-------------+
                              │
             ┌────────────────┼────────────────┐
             │                                 │
   +--------------------+          +--------------------+
   | TaxVisitor         |          | PDFVisitor         |
   +--------------------+          +--------------------+

                              ▲
                              │

                +---------------------------+
                | Reservation               |
                +---------------------------+
                | accept(visitor)           |
                +------------▲--------------+
                             │
              ┌──────────────┴──────────────┐
              │                             │
+---------------------------+   +---------------------------+
| PalaceReservation         |   | LeBlancReservation       |
+---------------------------+   +---------------------------+
```

---

# Componentes

## 1. Element

Representa el objeto que será visitado.

```swift
protocol Reservation {

    func accept(visitor: ReservationVisitor)

}
```

Su única responsabilidad es permitir que un Visitor lo procese.

---

## 2. Concrete Element

Implementaciones concretas del Element.

Ejemplo:

- PalaceReservation
- LeBlancReservation

Cada una implementa:

```swift
func accept(visitor: ReservationVisitor) {

    visitor.visit(self)

}
```

---

## 3. Visitor

Define todas las operaciones posibles para cada tipo de objeto.

```swift
protocol ReservationVisitor {

    func visit(_ reservation: PalaceReservation)

    func visit(_ reservation: LeBlancReservation)

}
```

---

## 4. Concrete Visitor

Implementa una operación específica.

Ejemplo:

- TaxVisitor
- PDFVisitor
- CRMVisitor
- AnalyticsVisitor

Cada Visitor tiene una única responsabilidad.

---

# Flujo del patrón

```text
                 Cliente

                    │

                    ▼

      reservation.accept(visitor)

                    │

                    ▼

      PalaceReservation.accept()

                    │

                    ▼

        visitor.visit(self)

                    │

          ┌─────────┴─────────┐
          ▼                   ▼

    TaxVisitor          PDFVisitor

          │                   │

          ▼                   ▼

 Calcula impuestos     Genera PDF
```

Este mecanismo recibe el nombre de **Double Dispatch**.

La operación ejecutada depende de:

- El tipo del Visitor.
- El tipo del Element.

---

# Implementación en Swift

La implementación completa está formada por los siguientes archivos.

```text
Visitor/

├── Reservation.swift
├── ReservationVisitor.swift
├── PalaceReservation.swift
├── LeBlancReservation.swift
├── TaxVisitor.swift
├── PDFVisitor.swift
└── VisitorExample.swift
```

Cada archivo tiene una responsabilidad claramente definida.

| Archivo | Responsabilidad |
|----------|-----------------|
| Reservation | Protocolo Element |
| ReservationVisitor | Protocolo Visitor |
| PalaceReservation | Concrete Element |
| LeBlancReservation | Concrete Element |
| TaxVisitor | Calcula impuestos |
| PDFVisitor | Genera PDF |
| VisitorExample | Ejecuta el ejemplo |

---

# Ejemplo completo

Creamos dos reservaciones.

```swift
let reservations: [Reservation] = [

    PalaceReservation(
        guestName: "Carlos",
        reservationNumber: "PAL-1001",
        total: 3000
    ),

    LeBlancReservation(
        guestName: "María",
        reservationNumber: "LB-2020",
        total: 5000
    )

]
```

Posteriormente creamos un Visitor.

```swift
let taxVisitor = TaxVisitor()
```

Recorremos todas las reservaciones.

```swift
reservations.forEach {

    $0.accept(visitor: taxVisitor)

}
```

Más tarde aparece una nueva necesidad.

Generar PDFs.

No modificamos ninguna reservación.

Simplemente creamos otro Visitor.

```swift
let pdfVisitor = PDFVisitor()

reservations.forEach {

    $0.accept(visitor: pdfVisitor)

}
```

Las clases de reservación permanecen exactamente iguales.

---

# Flujo de ejecución del ejemplo

```text
Inicio

   │

   ▼

Crear reservaciones

   │

   ▼

Crear TaxVisitor

   │

   ▼

Recorrer reservaciones

   │

   ▼

accept(visitor)

   │

   ▼

visitor.visit(self)

   │

   ▼

Calcular impuestos

   │

   ▼

Crear PDFVisitor

   │

   ▼

Recorrer reservaciones

   │

   ▼

accept(visitor)

   │

   ▼

visitor.visit(self)

   │

   ▼

Generar PDF

   │

   ▼

Fin
```

---

# Resultado esperado

```text
======== TAX VISITOR ========

Palace Resorts

Guest: Carlos

Reservation: PAL-1001

Taxes: 480

----------------------------------

Le Blanc

Guest: María

Reservation: LB-2020

Taxes: 900

======== PDF VISITOR ========

Generating Palace PDF...

Generating Le Blanc PDF...
```

---

# Ventajas

✅ Cumple el principio Open/Closed.

✅ Permite agregar nuevas operaciones sin modificar las entidades.

✅ Mantiene las clases del dominio pequeñas.

✅ Centraliza la lógica de negocio.

✅ Facilita pruebas unitarias.

✅ Reduce responsabilidades dentro de las entidades.

✅ Muy útil cuando existen muchas operaciones sobre los mismos objetos.

---

# Desventajas

❌ Agregar un nuevo tipo de elemento requiere modificar todos los Visitors.

❌ Puede aumentar considerablemente la cantidad de clases.

❌ No es recomendable cuando la jerarquía de objetos cambia constantemente.

---

# ¿Cuándo usar Visitor?

Utiliza Visitor cuando:

- La estructura de objetos es estable.
- Agregas nuevas operaciones frecuentemente.
- Deseas mantener las entidades enfocadas únicamente en representar datos.
- Existen múltiples procesos independientes sobre los mismos objetos.

---

# ¿Cuándo evitarlo?

Evita Visitor cuando:

- Los tipos de objetos cambian constantemente.
- Solo existe una operación.
- El costo de modificar todos los Visitors es mayor que el beneficio.

---

# Casos de uso en iOS

Visitor aparece con frecuencia en:

### Compiladores

Recorrido de árboles sintácticos (AST).

---

### SwiftSyntax

Apple utiliza Visitors para recorrer el árbol de sintaxis de Swift.

---

### Exportación de documentos

- PDF
- Excel
- CSV

---

### Analytics

Enviar eventos a:

- Firebase
- Datadog
- Pendo

---

### Validadores

Aplicar reglas distintas sobre diferentes entidades.

---

### Generadores de código

Herramientas que recorren modelos y generan archivos automáticamente.

---

# Comparación con otros patrones

| Visitor | Strategy |
|----------|----------|
| Agrega operaciones | Cambia algoritmos |
| Usa Double Dispatch | No |
| Se centra en objetos | Se centra en comportamiento |

| Visitor | State |
|----------|-------|
| Agrega operaciones | Cambia comportamiento interno |
| No cambia estado | El estado cambia dinámicamente |

---

# Conclusión

El patrón **Visitor** permite agregar nuevas funcionalidades a una estructura de objetos sin modificar las clases existentes.

En el ejemplo desarrollado:

- **Reservation** representa el **Element**.
- **PalaceReservation** y **LeBlancReservation** son los **Concrete Elements**.
- **ReservationVisitor** define el contrato de los Visitors.
- **TaxVisitor** y **PDFVisitor** implementan operaciones independientes.

Gracias a este diseño, si en el futuro se requiere incorporar nuevas funcionalidades como:

- Exportar Excel
- Generar QR
- Enviar Analytics
- Sincronizar CRM
- Generar Voucher
- Validar promociones

únicamente será necesario crear un nuevo **Visitor**, manteniendo intactas las clases del dominio.

Este enfoque favorece un código más limpio, extensible y alineado con los principios SOLID, especialmente **Open/Closed Principle (OCP)** y **Single Responsibility Principle (SRP)**.