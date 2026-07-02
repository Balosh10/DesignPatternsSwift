import Foundation

// MARK: - Tipos seguros (evitan strings inválidos)

/// Tipos de pan disponibles para la hamburguesa.
/// Usamos `enum` para evitar errores de escritura y limitar opciones válidas.
enum BreadType {
    case regular
    case wholeGrain
    case brioche
}

/// Tipos de carne disponibles.
/// Esto hace el código más seguro que usar Strings.
enum MeatType {
    case beef
    case chicken
    case vegetarian
}

// MARK: - Modelo final

/// Representa una hamburguesa ya construida.
///
/// IMPORTANTE:
/// - Es un objeto INMUTABLE (usa `let`)
/// - No se modifica después de ser creada
/// - Es el resultado final del Builder
struct Burger {

    let bread: BreadType
    let meat: MeatType
    let onion: Bool
    let tomato: Bool
    let avocado: Bool

    // MARK: - Builder

    /// Builder para construir una `Burger` paso a paso.
    ///
    /// 🧠 MODELO MENTAL DEL BUILDER:
    ///
    /// 1. Estado inicial:
    ///    - Se crea un Builder con valores por defecto
    ///    - Esto es solo configuración, NO la hamburguesa
    ///
    /// 2. Encadenamiento (method chaining):
    ///    - Cada función devuelve una NUEVA versión del Builder
    ///    - No se modifica el original (struct = inmutabilidad)
    ///    - Se va acumulando el estado paso a paso
    ///
    /// 3. build():
    ///    - Toma el estado final acumulado
    ///    - Crea la instancia real de `Burger`
    ///
    /// 🔥 IMPORTANTE:
    /// El Builder NO construye la hamburguesa hasta `build()`.
    /// Solo guarda configuración.
    struct Builder {

        // MARK: Estado interno (configuración base)

        /// Estado inicial del pan
        private var bread: BreadType = .regular

        /// Estado inicial de la carne
        private var meat: MeatType = .beef

        /// Ingredientes opcionales (por defecto no incluidos)
        private var onion: Bool = false
        private var tomato: Bool = false
        private var avocado: Bool = false

        // MARK: Encadenamiento de métodos (method chaining)

        /// Cambia el tipo de pan.
        ///
        /// 🔁 Encadenamiento:
        /// Devuelve un nuevo Builder con el estado actualizado.
        func bread(_ bread: BreadType) -> Builder {
            var copy = self
            copy.bread = bread
            return copy
        }

        /// Cambia el tipo de carne.
        func meat(_ meat: MeatType) -> Builder {
            var copy = self
            copy.meat = meat
            return copy
        }

        /// Activa o desactiva cebolla.
        func onion(_ add: Bool) -> Builder {
            var copy = self
            copy.onion = add
            return copy
        }

        /// Activa o desactiva tomate.
        func tomato(_ add: Bool) -> Builder {
            var copy = self
            copy.tomato = add
            return copy
        }

        /// Activa o desactiva aguacate.
        func avocado(_ add: Bool) -> Builder {
            var copy = self
            copy.avocado = add
            return copy
        }

        // MARK: Construcción final

        /// Construye la hamburguesa final.
        ///
        /// 🧠 Aquí ocurre la transformación real:
        /// Builder (configuración acumulada) → Burger (objeto final)
        func build() -> Burger {
            return Burger(
                bread: bread,
                meat: meat,
                onion: onion,
                tomato: tomato,
                avocado: avocado
            )
        }
    }
}

// MARK: - Ejemplo de uso

/// 🧠 Encadenamiento de métodos (method chaining)
///
/// Esto funciona porque:
/// - cada función devuelve `Builder`
/// - por lo tanto el siguiente método puede ejecutarse sobre el resultado
///
/// Flujo real:
/// Builder → Builder → Builder → Builder → Burger
let burger = Burger.Builder()
    .bread(.brioche)      // devuelve Builder
    .meat(.chicken)      // devuelve Builder
    .onion(true)         // devuelve Builder
    .avocado(true)       // devuelve Builder
    .build()             // devuelve Burger

print(burger)
