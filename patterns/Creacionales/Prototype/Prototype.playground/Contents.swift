import Foundation
import Foundation

// MARK: - Prototype
//
// El patrón Prototype permite crear nuevos objetos
// clonando una instancia existente en lugar de
// construirla desde cero.
//

// MARK: - Car
//
// Car es una clase (Reference Type) para poder demostrar
// la diferencia entre Shallow Copy y Deep Copy.
//

class Car {

    var color: String
    var model: String

    init(color: String, model: String) {
        self.color = color
        self.model = model
    }

    /// Deep Copy del automóvil.
    /// Crea una nueva instancia con los mismos valores.
    func clone() -> Car {
        Car(color: color, model: model)
    }
}

// MARK: - Prototype

protocol Prototype {

    func cloneShallowCopy() -> Self

    func cloneDeepCopy() -> Self

}

// MARK: - Agencia
//
// La agencia contiene una colección de automóviles.
//

class Agencia: Prototype {

    /// Autos disponibles para venta.
    var inventory: [Car] = []

    init() {}

    /// Agrega un automóvil al inventario.
    func addCar(_ car: Car) {
        inventory.append(car)
    }

    /// Muestra el inventario.
    func showInventory() {

        for car in inventory {

            print("\(car.model) - \(car.color)")

        }

    }

    // MARK: Shallow Copy
    //
    // Crea una nueva agencia PERO comparte
    // las mismas referencias de los automóviles.
    //
    // Agencia A --------┐
    //                   │
    //                Car 1
    //                   │
    // Agencia B --------┘
    //

    func cloneShallowCopy() -> Self {

        let copy = type(of: self).init()

        copy.inventory = self.inventory

        return copy

    }

    // MARK: Deep Copy
    //
    // Crea una nueva agencia Y también
    // crea una copia nueva de cada automóvil.
    //
    // Agencia A --> Car A
    //
    // Agencia B --> Car B
    //

    func cloneDeepCopy() -> Self {

        let copy = type(of: self).init()

        copy.inventory = self.inventory.map {
            $0.clone()
        }

        return copy

    }

    required init(dummy: Void = ()) {}

}

// MARK: - Original

let agencia1 = Agencia()

agencia1.addCar(
    Car(color: "Rojo",
        model: "Jetta")
)

agencia1.addCar(
    Car(color: "Azul",
        model: "Golf")
)

print("=== Agencia Original ===")
agencia1.showInventory()

// MARK: - Shallow Copy

let agencia2 = agencia1.cloneShallowCopy()

// Modificamos un automóvil del clon.

agencia2.inventory[0].color = "Negro"

print("\n=== Shallow Copy ===")
agencia2.showInventory()

print("\n=== Original después del Shallow Copy ===")
agencia1.showInventory()

// MARK: - Deep Copy

let agencia3 = agencia1.cloneDeepCopy()

// Modificamos el automóvil del clon.

agencia3.inventory[0].color = "Verde"

print("\n=== Deep Copy ===")
agencia3.showInventory()

print("\n=== Original después del Deep Copy ===")
agencia1.showInventory()
