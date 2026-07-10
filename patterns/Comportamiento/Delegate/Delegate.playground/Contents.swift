import Foundation


// MARK: - Model

/// Representa los estados posibles de una orden.
enum OrderStatus {

    /// Orden creada por el mesero.
    case created

    /// Orden enviada a cocina.
    case preparing

    /// Orden terminada por el chef.
    case ready

    /// Orden entregada al cliente.
    case delivered
}


/// Representa una orden realizada por un cliente.
///
/// La orden contiene la información necesaria para que
/// el restaurante pueda procesarla.
struct Order {

    /// Número de mesa donde se generó la orden.
    let table: Int

    /// Cantidad de platos solicitados.
    var dishes: Int

    /// Cantidad de bebidas solicitadas.
    var drinks: Int

    /// Estado actual de la orden.
    var status: OrderStatus
}



// MARK: - Waiter Delegation

/// Contrato de comunicación hacia el mesero.
///
/// El administrador utiliza este contrato para delegar
/// responsabilidades relacionadas con las mesas y entrega
/// de pedidos.
protocol WaiterInputDelegate: AnyObject {

    /// Asigna mesas que serán responsabilidad del mesero.
    func assignTables(_ tables: [Int])


    /// Entrega una orden lista al mesero.
    func deliverOrder(_ order: Order)

}



/// Contrato de salida del mesero.
///
/// El mesero utiliza este delegado para enviar solicitudes
/// hacia el administrador del restaurante.
protocol WaiterOutputDelegate: AnyObject {

    /// Envía una nueva orden creada por el mesero.
    func createOrder(_ order: Order)


    /// Actualiza una orden existente.
    func updateOrder(_ order: Order)


    /// Solicita la cuenta de una mesa.
    func requestBill(for table: Int)

}



// MARK: - Chef Delegation

/// Contrato utilizado por el administrador
/// para enviar órdenes al chef.
///
/// El administrador delega la preparación de alimentos
/// al responsable de cocina.
protocol ChefInputDelegate: AnyObject {

    /// Envía una orden para preparar.
    func prepareOrder(_ order: Order)

}



/// Contrato utilizado por el chef para notificar
/// resultados de preparación.
///
/// El chef no conoce quién recibirá la información,
/// solamente conoce el contrato.
protocol ChefOutputDelegate: AnyObject {

    /// Notifica que una orden terminó correctamente.
    func orderDidFinish(_ order: Order)


    /// Notifica un error durante la preparación.
    func orderPreparationFailed(
        _ order: Order,
        error: String
    )

}



// MARK: - Waiter

/// Representa al mesero.
///
/// Responsabilidades:
/// - Atender mesas.
/// - Crear órdenes.
/// - Actualizar pedidos.
/// - Solicitar cuentas.
final class Waiter: WaiterInputDelegate {


    /// Comunicación hacia el administrador.
    weak var delegate: WaiterOutputDelegate?


    private var orders: [Order] = []



    /// Recibe las mesas asignadas por el administrador.
    func assignTables(_ tables: [Int]) {

        print(
            "🧑‍🍳 Mesero tiene asignadas las mesas:",
            tables
        )
    }



    /// Crea una nueva orden y la envía al administrador.
    func createOrder() {

        let order = Order(
            table: 1,
            dishes: 5,
            drinks: 5,
            status: .created
        )


        orders.append(order)


        print(
            "🧑‍🍳 Mesero crea una orden:",
            order
        )


        delegate?.createOrder(order)
    }



    /// Actualiza una orden existente.
    func updateOrder() {

        guard var order = orders.first else {
            return
        }


        order.dishes = 4
        order.drinks = 4


        print(
            "📝 Mesero actualiza orden:",
            order
        )


        delegate?.updateOrder(order)
    }



    /// Solicita la cuenta de una mesa.
    func requestBill() {

        delegate?.requestBill(for: 1)
    }



    /// Recibe una orden terminada por cocina.
    func deliverOrder(_ order: Order) {

        print(
            "🍽️ Mesero entrega orden:",
            order
        )


        print("Cliente comiendo...")
        print("Cliente solicita cuenta...")


        requestBill()
    }

}



// MARK: - Chef

/// Representa al cocinero.
///
/// Responsabilidad:
/// - Preparar órdenes.
/// - Informar resultados.
final class Chef: ChefInputDelegate {


    /// Delegado encargado de recibir resultados.
    weak var delegate: ChefOutputDelegate?



    /// Prepara una orden recibida.
    func prepareOrder(_ order: Order) {

        var order = order

        order.status = .preparing


        print(
            "👨‍🍳 Chef preparando:",
            order
        )


        print("Cocinando...")
        print("Cocinando...")


        order.status = .ready


        delegate?.orderDidFinish(order)
    }

}



// MARK: - Restaurant Manager

/// Administrador del restaurante.
///
/// Es el coordinador principal.
///
/// Responsabilidades:
/// - Asignar mesas.
/// - Recibir órdenes.
/// - Enviar órdenes a cocina.
/// - Coordinar entrega de pedidos.
final class RestaurantManager {


    /// Delegado encargado de atender mesas.
    weak var waiterDelegate: WaiterInputDelegate?


    /// Delegado encargado de preparar órdenes.
    weak var chefDelegate: ChefInputDelegate?



    /// Asigna mesas al mesero.
    func assignTables() {

        let tables = [1,2,3,4,5]


        print(
            "👨‍💼 Administrador asigna mesas:",
            tables
        )


        waiterDelegate?.assignTables(tables)
    }

}



// MARK: - Restaurant Manager Input

/// El administrador recibe solicitudes
/// provenientes del mesero.
extension RestaurantManager: WaiterOutputDelegate {


    func createOrder(_ order: Order) {

        print(
            "👨‍💼 Administrador recibe orden:",
            order
        )


        chefDelegate?.prepareOrder(order)
    }



    func updateOrder(_ order: Order) {

        print(
            "👨‍💼 Administrador actualiza orden:",
            order
        )
    }



    func requestBill(for table: Int) {

        print(
            "💵 Administrador genera cuenta mesa:",
            table
        )
    }

}



// MARK: - Chef Output

/// El administrador recibe notificaciones
/// provenientes del chef.
extension RestaurantManager: ChefOutputDelegate {


    func orderDidFinish(_ order: Order) {

        print(
            "👨‍💼 Administrador recibe orden terminada:",
            order
        )


        waiterDelegate?.deliverOrder(order)
    }



    func orderPreparationFailed(
        _ order: Order,
        error: String
    ) {

        print(
            "❌ Error preparando orden:",
            error
        )
    }

}



// MARK: - Client

let manager = RestaurantManager()

let waiter = Waiter()

let chef = Chef()



// Delegaciones

// Administrador → Mesero
manager.waiterDelegate = waiter

// Mesero → Administrador
waiter.delegate = manager

// Administrador → Chef
manager.chefDelegate = chef

// Chef → Administrador
chef.delegate = manager



// Flujo del restaurante

manager.assignTables()

waiter.createOrder()
