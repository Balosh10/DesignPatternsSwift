import Foundation

// MARK: - Component
/// Protocolo que define el comportamiento que debe tener cualquier tipo de café.
///
/// Tanto el café base como todos los decoradores implementan esta interfaz,
/// lo que permite tratarlos de la misma manera.
protocol Coffee {

    /// Regresa el costo total del café.
    func cost() -> Double

    /// Regresa la descripción del café.
    func description() -> String
}

// MARK: - Concrete Component
/// Implementación base del café.
///
/// Representa el objeto original al que posteriormente se le podrán agregar
/// nuevas responsabilidades mediante decoradores.
final class SimpleCoffee: Coffee {

    /// Precio base del café.
    private let baseCost: Double = 5.0

    func cost() -> Double {
        baseCost
    }

    func description() -> String {
        "Café simple"
    }
}

// MARK: - Decorator
/// Decorador base.
///
/// Implementa la misma interfaz (`Coffee`) y recibe otro objeto `Coffee`.
/// Su única responsabilidad es delegar las llamadas al objeto decorado.
///
/// Todos los decoradores concretos heredarán de esta clase.
class CoffeeDecorator: Coffee {

    /// Referencia al objeto que será decorado.
    let coffee: Coffee

    init(coffee: Coffee) {
        self.coffee = coffee
    }

    func cost() -> Double {
        coffee.cost()
    }

    func description() -> String {
        coffee.description()
    }
}

// MARK: - Concrete Decorator
/// Agrega leche al café.
///
/// Incrementa el costo y modifica la descripción.
final class MilkDecorator: CoffeeDecorator {

    override func cost() -> Double {
        coffee.cost() + 1.5
    }

    override func description() -> String {
        "\(coffee.description()), con leche"
    }
}

// MARK: - Concrete Decorator
/// Agrega azúcar al café.
///
/// Incrementa el costo y modifica la descripción.
final class SugarDecorator: CoffeeDecorator {

    override func cost() -> Double {
        coffee.cost() + 0.75
    }

    override func description() -> String {
        "\(coffee.description()), con azúcar"
    }
}

// MARK: - Uso

/// Creamos el objeto base.
var coffee: Coffee = SimpleCoffee()

/// Agregamos leche.
coffee = MilkDecorator(coffee: coffee)

/// Agregamos azúcar.
coffee = SugarDecorator(coffee: coffee)

print("Descripción: \(coffee.description())")
print("Costo: $\(coffee.cost())")
