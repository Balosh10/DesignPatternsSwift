import Foundation

// MARK: - Analytics

/// Define el contrato que debe cumplir cualquier proveedor de analítica.
///
/// ## Principios SOLID
///
/// - ISP (Interface Segregation Principle)
///   El protocolo contiene únicamente el comportamiento necesario.
///
/// - OCP (Open/Closed Principle)
///   Permite agregar nuevos proveedores de analítica sin modificar
///   el código de la fachada.
protocol Analytics: AnyObject {

    /// Inicializa el proveedor de analítica.
    func configure()

}

// MARK: - DataDog Analytics

/// Implementación concreta del proveedor DataDog.
final class DataDogAnalytics: Analytics {

    func configure() {
        print("📊 Inicializando DataDog...")
    }

}

// MARK: - Pendo Analytics

/// Implementación concreta del proveedor Pendo.
final class PendoAnalytics: Analytics {

    func configure() {
        print("📊 Inicializando Pendo...")
    }

}

// MARK: - Session

/// Representa la sesión autenticada del usuario.
struct Session {

    let name: String

    let lastName: String

    let id: String

}

// MARK: - Session Manager

/// Define el contrato encargado de administrar
/// la sesión del usuario.
///
/// ## Principios SOLID
///
/// - DIP (Dependency Inversion Principle)
///   Los clientes dependen de este protocolo
///   y no de una implementación concreta.
protocol SessionManagerProtocol {

    /// Guarda la sesión.
    func saveSession(_ session: Session) async

    /// Elimina la sesión.
    func clearSession() async

}

// MARK: - SessionManager

/// Responsable de administrar la sesión.
///
/// Se implementa como Actor para garantizar
/// acceso seguro en escenarios concurrentes.
actor SessionManager: SessionManagerProtocol {

    static let shared = SessionManager()

    private(set) var session: Session?

    func saveSession(_ session: Session) {

        self.session = session

        print("💾 Sesión almacenada correctamente.")

    }

    func clearSession() {

        session = nil

        print("🗑️ Sesión eliminada.")

    }

}

// MARK: - Profile Configuration

/// Contrato encargado de configurar
/// el perfil del usuario.
///
/// ## Principios SOLID
///
/// - ISP (Interface Segregation Principle)
protocol ProfileConfiguratorProtocol: AnyObject {

    /// Configura el perfil.
    func configure()

}

// MARK: - ProfileConfigurator

/// Configura el perfil del usuario.
final class ProfileConfigurator: ProfileConfiguratorProtocol {

    func configure() {

        print("👤 Configurando perfil del usuario...")

    }

}

// MARK: - Facade

/// # Facade Pattern
///
/// `ApplicationFacade` proporciona una interfaz simple
/// para inicializar varios subsistemas de la aplicación.
///
/// El cliente no necesita conocer:
///
/// - Cómo se configura el perfil.
/// - Cómo se inicializan las herramientas de analítica.
/// - Cómo se administra la sesión.
///
/// Únicamente interactúa con un único punto de acceso:
///
/// ```swift
/// let facade = ApplicationFacade(...)
/// await facade.initialize()
/// ```
///
/// De esta forma se reduce el acoplamiento entre el
/// cliente y los distintos subsistemas.
///
/// ## Principios SOLID
///
/// ### ✅ SRP (Single Responsibility Principle)
///
/// La fachada únicamente coordina la inicialización
/// de los diferentes componentes.
///
/// ### ✅ OCP (Open/Closed Principle)
///
/// Es posible agregar nuevos proveedores de analítica
/// sin modificar esta clase.
///
/// Basta con crear una nueva implementación de
/// `Analytics`.
///
/// ### ✅ LSP (Liskov Substitution Principle)
///
/// La fachada trabaja mediante protocolos,
/// permitiendo sustituir cualquier implementación.
///
/// ### ✅ ISP (Interface Segregation Principle)
///
/// Los protocolos son pequeños y específicos.
///
/// ### ✅ DIP (Dependency Inversion Principle)
///
/// La fachada depende de abstracciones:
///
/// - Analytics
/// - ProfileConfiguratorProtocol
/// - SessionManagerProtocol
///
/// En ningún momento depende de implementaciones
/// concretas.
final class ApplicationFacade {

    // MARK: Properties

    /// Encargado de configurar el perfil.
    private let profileConfigurator: ProfileConfiguratorProtocol

    /// Administrador de la sesión.
    private let sessionManager: SessionManagerProtocol

    /// Sesión autenticada.
    private let userSession: Session

    /// Colección de proveedores de analítica.
    ///
    /// Gracias a este arreglo es posible agregar
    /// nuevos proveedores sin modificar la fachada.
    private let analyticsServices: [Analytics]

    // MARK: Initializer

    init(
        userSession: Session,
        profileConfigurator: ProfileConfiguratorProtocol = ProfileConfigurator(),
        sessionManager: SessionManagerProtocol = SessionManager.shared,
        analyticsServices: [Analytics] = [
            DataDogAnalytics(),
            PendoAnalytics()
        ]
    ) {

        self.userSession = userSession
        self.profileConfigurator = profileConfigurator
        self.sessionManager = sessionManager
        self.analyticsServices = analyticsServices

    }

    // MARK: Public Methods

    /// Inicializa todos los subsistemas
    /// necesarios para la aplicación.
    func initialize() async {

        configureProfile()

        configureAnalytics()

        await sessionManager.saveSession(userSession)

        print("✅ Aplicación inicializada correctamente.")

    }

}

// MARK: - Private Methods

private extension ApplicationFacade {

    /// Configura el perfil del usuario.
    func configureProfile() {

        profileConfigurator.configure()

    }

    /// Inicializa todos los proveedores
    /// de analítica registrados.
    ///
    /// Gracias al polimorfismo la fachada
    /// desconoce qué implementación está
    /// ejecutando.
    func configureAnalytics() {

        analyticsServices.forEach {

            $0.configure()

        }

    }

}

// MARK: - Authentication Service

/// Servicio encargado de autenticar al usuario.
///
/// ## Responsabilidad
/// Simular el proceso de autenticación y devolver
/// una sesión válida.
///
/// ## Principio SOLID
/// - SRP (Single Responsibility Principle)
///   Esta clase únicamente conoce el proceso
///   de autenticación.
final class AuthenticationService {

    /// Autentica al usuario.
    ///
    /// - Returns: Una sesión válida.
    func authenticate() async -> Session {

        print("🔐 Validando credenciales...")

        try? await Task.sleep(for: .seconds(2))

        print("✅ Usuario autenticado.")

        return Session(
            name: "Osvaldo",
            lastName: "Cespedes",
            id: "Hernandez"
        )

    }

}

// MARK: - New Analytics Example

/// Ejemplo de un nuevo proveedor de analítica.
///
/// Gracias al protocolo `Analytics`,
/// esta clase puede incorporarse al sistema
/// sin modificar la implementación de
/// `ApplicationFacade`.
///
/// ## Principio SOLID
/// - OCP (Open/Closed Principle)
final class FirebaseAnalytics: Analytics {

    func configure() {

        print("📊 Inicializando Firebase Analytics...")

    }

}

// MARK: - Client

/// El cliente únicamente conoce la Fachada.
///
/// No necesita conocer:
///
/// • SessionManager
/// • ProfileConfigurator
/// • DataDogAnalytics
/// • PendoAnalytics
///
/// Todo el proceso queda encapsulado dentro
/// de `ApplicationFacade`.
Task {

    let authenticationService = AuthenticationService()

    let session = await authenticationService.authenticate()

    let facade = ApplicationFacade(
        userSession: session,

        analyticsServices: [
            DataDogAnalytics(),
            PendoAnalytics(),

            // Basta con agregar una nueva implementación.
            // No es necesario modificar ApplicationFacade.
            FirebaseAnalytics()
        ]
    )

    await facade.initialize()

}
