import SwiftUI


// MARK: - Component

/// En SwiftUI el protocolo View representa
/// la abstracción común.
///
/// Todos los componentes implementan View:
///
/// - Text
/// - Image
/// - Button
/// - VStack
/// - HStack
/// - Custom Views
///
/// Esto permite tratarlos de manera uniforme.
protocol ProfileComponent: View {

}


// MARK: - Leaf Components

/// Componente hoja.
///
/// No contiene otros componentes.
struct AvatarView: ProfileComponent {

    var body: some View {

        Image(systemName: "person.circle.fill")
            .font(.system(size: 80))
            .foregroundStyle(.blue)

    }

}


/// Componente hoja.
struct NameView: ProfileComponent {

    let name: String


    var body: some View {

        Text(name)
            .font(.title)
            .bold()

    }

}


/// Componente hoja.
struct EmailView: ProfileComponent {

    let email: String


    var body: some View {

        Text(email)
            .foregroundStyle(.gray)

    }

}


/// Componente hoja.
struct ActionButtonView: ProfileComponent {


    var body: some View {

        Button {

            print("Editar perfil")

        } label: {

            Text("Editar perfil")
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                )

        }

    }

}


// MARK: - Composite Components


/// Composite.
///
/// Contiene otros componentes.
///
/// El cliente no sabe qué elementos internos
/// existen.
struct HeaderView: ProfileComponent {


    let username: String


    var body: some View {

        VStack(spacing: 16) {


            AvatarView()


            NameView(
                name: username
            )


        }

    }

}


/// Otro Composite.
struct InformationView: ProfileComponent {


    var body: some View {

        VStack(spacing: 8) {


            EmailView(
                email: "osvaldo@email.com"
            )


            Text(
                "México"
            )


        }

    }

}



// MARK: - Main Composite


/// Composite raíz.
///
/// Contiene otros Composite y Leaf.
///
/// La pantalla completa es un árbol.
struct ProfileScreenView: ProfileComponent {


    var body: some View {


        VStack(spacing: 30) {


            HeaderView(
                username: "Osvaldo"
            )


            InformationView()


            ActionButtonView()


        }
        .padding()

    }

}


// MARK: - Client


struct ContentView: View {


    var body: some View {


        ProfileScreenView()

    }

}