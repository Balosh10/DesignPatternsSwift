import UIKit


// MARK: - Component

/// Contrato común para componentes de UI.
///
/// Todos los componentes pueden ser configurados
/// independientemente de si son hojas o contenedores.
protocol ViewComponent {

    func configure()

}


// MARK: - Leaf Components

/// Componente hoja.
/// No contiene otros componentes.
final class ProfileImageView: UIImageView, ViewComponent {


    func configure() {

        image = UIImage(systemName: "person.circle")

        contentMode = .scaleAspectFit

    }

}


/// Componente hoja.
final class NameLabel: UILabel, ViewComponent {


    func configure() {

        text = "Osvaldo Céspedes"

        font = .boldSystemFont(ofSize: 24)

        textAlignment = .center

    }

}


/// Componente hoja.
final class EmailLabel: UILabel, ViewComponent {


    func configure() {

        text = "osvaldo@email.com"

        textAlignment = .center

    }

}


/// Componente hoja.
final class EditButton: UIButton, ViewComponent {


    func configure() {

        setTitle(
            "Editar perfil",
            for: .normal
        )

        backgroundColor = .systemBlue

        layer.cornerRadius = 10

    }

}



// MARK: - Composite Component

/// Composite.
///
/// Un UIView que contiene otros componentes.
///
/// Puede contener:
///
/// - Leaf components
/// - Otros Composite components
///
/// Todos son tratados como ViewComponent.
final class HeaderView: UIView, ViewComponent {


    private let imageView = ProfileImageView()

    private let nameLabel = NameLabel()


    func configure() {

        imageView.configure()

        nameLabel.configure()


        addSubview(imageView)

        addSubview(nameLabel)


        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            imageView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            imageView.widthAnchor.constraint(
                equalToConstant: 80
            ),

            imageView.heightAnchor.constraint(
                equalToConstant: 80
            ),


            nameLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 16
            ),

            nameLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            )

        ])

    }

}



// MARK: - Another Composite

final class InfoView: UIView, ViewComponent {


    private let emailLabel = EmailLabel()


    func configure() {


        emailLabel.configure()


        addSubview(emailLabel)


        emailLabel.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([

            emailLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            emailLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor
            )

        ])

    }

}



// MARK: - Main Composite

/// Composite principal de la pantalla.
///
/// Contiene otros composites:
///
/// ProfileView
/// ├── HeaderView
/// ├── InfoView
/// └── Button
final class ProfileView: UIView, ViewComponent {


    private let headerView = HeaderView()

    private let infoView = InfoView()

    private let editButton = EditButton()



    func configure() {


        headerView.configure()

        infoView.configure()

        editButton.configure()



        addSubview(headerView)

        addSubview(infoView)

        addSubview(editButton)



        headerView.translatesAutoresizingMaskIntoConstraints = false

        infoView.translatesAutoresizingMaskIntoConstraints = false

        editButton.translatesAutoresizingMaskIntoConstraints = false



        NSLayoutConstraint.activate([


            headerView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 40
            ),

            headerView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            headerView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),


            infoView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 40
            ),

            infoView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),


            editButton.topAnchor.constraint(
                equalTo: infoView.bottomAnchor,
                constant: 40
            ),

            editButton.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),

            editButton.widthAnchor.constraint(
                equalToConstant: 200
            ),

            editButton.heightAnchor.constraint(
                equalToConstant: 50
            )

        ])

    }

}

final class ProfileViewController: UIViewController {


    private let profileView = ProfileView()


    override func loadView() {

        view = profileView

    }


    override func viewDidLoad() {

        super.viewDidLoad()

        profileView.configure()

    }

}
