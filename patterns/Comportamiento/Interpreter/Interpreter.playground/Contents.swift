import Foundation

// MARK: - Context

struct User {

    let name: String
    let isAdmin: Bool
    let isActive: Bool
    let isPremium: Bool

}

// MARK: - Abstract Expression

protocol Expression {

    func interpret(context: User) -> Bool

}

// MARK: - Terminal Expressions

final class AdminExpression: Expression {

    func interpret(context: User) -> Bool {
        context.isAdmin
    }

}

final class ActiveExpression: Expression {

    func interpret(context: User) -> Bool {
        context.isActive
    }

}

final class PremiumExpression: Expression {

    func interpret(context: User) -> Bool {
        context.isPremium
    }

}

// MARK: - Non Terminal Expressions

final class AndExpression: Expression {

    private let left: Expression
    private let right: Expression

    init(
        left: Expression,
        right: Expression
    ) {
        self.left = left
        self.right = right
    }

    func interpret(context: User) -> Bool {

        left.interpret(context: context)
        &&
        right.interpret(context: context)

    }

}

final class OrExpression: Expression {

    private let left: Expression
    private let right: Expression

    init(
        left: Expression,
        right: Expression
    ) {
        self.left = left
        self.right = right
    }

    func interpret(context: User) -> Bool {

        left.interpret(context: context)
        ||
        right.interpret(context: context)

    }

}

final class NotExpression: Expression {

    private let expression: Expression

    init(expression: Expression) {
        self.expression = expression
    }

    func interpret(context: User) -> Bool {

        !expression.interpret(context: context)

    }

}

// MARK: - Datos de prueba

let users = [

    User(
        name: "Juan",
        isAdmin: true,
        isActive: true,
        isPremium: false
    ),

    User(
        name: "Pedro",
        isAdmin: false,
        isActive: true,
        isPremium: true
    ),

    User(
        name: "Ana",
        isAdmin: true,
        isActive: false,
        isPremium: false
    ),

    User(
        name: "Luis",
        isAdmin: false,
        isActive: true,
        isPremium: false
    )

]

// MARK: - Expresión:
// (Admin AND Active) OR Premium

let expression = OrExpression(

    left: AndExpression(

        left: AdminExpression(),

        right: ActiveExpression()

    ),

    right: PremiumExpression()

)

// MARK: - Interpretación

print("========== Interpreter ==========\n")

for user in users {

    let hasAccess = expression.interpret(context: user)

    print("""
    Usuario : \(user.name)
    Admin   : \(user.isAdmin)
    Active  : \(user.isActive)
    Premium : \(user.isPremium)

    ¿Tiene acceso? \(hasAccess ? "✅ Sí" : "❌ No")

    -------------------------------
    """)

}
