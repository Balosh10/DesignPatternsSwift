import Foundation

import Foundation

// MARK: - Productos Abstractos
// Estos protocolos representan los "tipos de productos"
// que todas las familias deben implementar.

/// Producto abstracto: Hamburguesa
/// Define el comportamiento común de cualquier hamburguesa sin importar el restaurante.
protocol Hamburguesa {
    func description() -> String
}

/// Producto abstracto: Papas
/// Representa cualquier tipo de papas dentro de una familia de comida.
protocol Papas {
    func description() -> String
}

/// Producto abstracto: Bebida
/// Representa la bebida dentro del combo.
protocol Bebida {
    func description() -> String
}

// MARK: - Burger King Products
// Implementaciones concretas de la familia Burger King
// Todos los productos están diseñados para ser compatibles entre sí.

/// Hamburguesa concreta de Burger King
struct BurgerKingHamburguesa: Hamburguesa {
    func description() -> String {
        "Whopper"
    }
}

/// Papas concretas de Burger King
struct BurgerKingPapas: Papas {
    func description() -> String {
        "Papas Burger King"
    }
}

/// Bebida concreta de Burger King
struct BurgerKingBebida: Bebida {
    func description() -> String {
        "Coca-Cola BK"
    }
}

// MARK: - McDonald's Products
// Implementación de otra familia de productos
// Mantienen la misma interfaz pero diferente comportamiento.

/// Hamburguesa concreta de McDonald's
struct McDonaldsHamburguesa: Hamburguesa {
    func description() -> String {
        "Big Mac"
    }
}

/// Papas concretas de McDonald's
struct McDonaldsPapas: Papas {
    func description() -> String {
        "Papas McDonald's"
    }
}

/// Bebida concreta de McDonald's
struct McDonaldsBebida: Bebida {
    func description() -> String {
        "Coca-Cola McDonald's"
    }
}

// MARK: - Abstract Factory
// Define la interfaz para crear una familia de productos relacionados.
// Cada implementación concreta representa un restaurante o proveedor.

protocol ComboFactory {

    /// Crea la hamburguesa del combo
    func makeHamburguesa() -> Hamburguesa

    /// Crea las papas del combo
    func makePapas() -> Papas

    /// Crea la bebida del combo
    func makeBebida() -> Bebida
}

// MARK: - Concrete Factory: Burger King
// Responsable de crear toda la familia de productos Burger King.

class BurgerKingFactory: ComboFactory {

    func makeHamburguesa() -> Hamburguesa {
        BurgerKingHamburguesa()
    }

    func makePapas() -> Papas {
        BurgerKingPapas()
    }

    func makeBebida() -> Bebida {
        BurgerKingBebida()
    }
}

// MARK: - Concrete Factory: McDonald's
// Crea la familia completa de productos de McDonald's.

class McDonaldsFactory: ComboFactory {

    func makeHamburguesa() -> Hamburguesa {
        McDonaldsHamburguesa()
    }

    func makePapas() -> Papas {
        McDonaldsPapas()
    }

    func makeBebida() -> Bebida {
        McDonaldsBebida()
    }
}

// MARK: - Client
// El cliente trabaja únicamente con la abstracción (ComboFactory)
// No conoce clases concretas, lo que permite intercambiar familias fácilmente.

class ComboClient {

    /// Fábrica inyectada (Dependency Injection)
    private let factory: ComboFactory

    init(factory: ComboFactory) {
        self.factory = factory
    }

    /// Construye y muestra el combo completo
    func showCombo() {

        let burger = factory.makeHamburguesa()
        let fries = factory.makePapas()
        let drink = factory.makeBebida()

        print("🍔 \(burger.description())")
        print("🍟 \(fries.description())")
        print("🥤 \(drink.description())")
    }
}

// MARK: - Example Usage

// Combo de Burger King
let burgerKingClient = ComboClient(factory: BurgerKingFactory())
burgerKingClient.showCombo()

print("------------------")

// Combo de McDonald's
let mcdonaldsClient = ComboClient(factory: McDonaldsFactory())
mcdonaldsClient.showCombo()
