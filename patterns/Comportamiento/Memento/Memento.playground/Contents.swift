import Foundation


/// ----------------------------------------------------------------------
/// MARK: - Memento
/// ----------------------------------------------------------------------
///
/// El Memento representa una fotografía (Snapshot) del estado del
/// TextEditor en un momento específico.
///
/// Responsabilidades:
/// - Guardar el estado del editor.
/// - No contiene lógica.
/// - Es inmutable.
///
struct EditorMemento {

    /// Texto almacenado.
    let text: String

    /// Fecha en la que fue creado el snapshot.
    let createdAt: Date

    init(text: String) {
        self.text = text
        self.createdAt = Date()
    }
}


/// ----------------------------------------------------------------------
/// MARK: - Originator
/// ----------------------------------------------------------------------
///
/// Es el objeto cuyo estado queremos guardar.
///
/// El Originator es el único que conoce cómo crear y restaurar
/// sus propios snapshots.
///
/// Ninguna otra clase puede modificar directamente su estado.
///
final class TextEditor {

    // MARK: Properties

    /// Texto actual del editor.
    private var text: String = ""

    // MARK: Public Methods

    /// Agrega texto al contenido actual.
    ///
    /// - Parameter value: Texto a agregar.
    func write(_ value: String) {
        text += value
    }

    /// Reemplaza completamente el contenido.
    func replace(with value: String) {
        text = value
    }

    /// Muestra el contenido.
    func show() {
        print(text)
    }

    /// Devuelve el contenido actual.
    func currentText() -> String {
        text
    }

    // MARK: Memento

    /// Crea un Snapshot del estado actual.
    ///
    /// Solo el Originator sabe exactamente qué propiedades
    /// necesita guardar.
    func save() -> EditorMemento {
        EditorMemento(text: text)
    }

    /// Restaura el estado utilizando un Snapshot.
    ///
    /// - Parameter memento: Estado previamente guardado.
    func restore(_ memento: EditorMemento) {
        text = memento.text
    }
}

/// ----------------------------------------------------------------------
/// MARK: - Caretaker
/// ----------------------------------------------------------------------
///
/// Es el administrador del historial.
///
/// No conoce cómo funciona internamente el TextEditor.
/// Solo almacena Mementos.
///
/// También implementa:
///
/// - Undo
/// - Redo
///
final class HistoryManager {

    // MARK: Properties

    /// Historial para Undo.
    private var undoStack: [EditorMemento] = []

    /// Historial para Redo.
    private var redoStack: [EditorMemento] = []

    // MARK: Save

    /// Guarda un nuevo snapshot.
    ///
    /// Siempre que exista una nueva modificación,
    /// el historial de Redo deja de ser válido.
    func save(_ snapshot: EditorMemento) {

        undoStack.append(snapshot)

        // Nuevo cambio invalida el Redo.
        redoStack.removeAll()
    }

    // MARK: Undo

    /// Obtiene el snapshot anterior.
    ///
    /// Parámetros:
    /// - current: Estado actual del editor.
    ///
    /// Retorna:
    /// Snapshot anterior si existe.
    func undo(current: EditorMemento) -> EditorMemento? {

        guard let previous = undoStack.popLast() else {
            return nil
        }

        redoStack.append(current)

        return previous
    }

    // MARK: Redo

    /// Recupera un estado previamente deshecho.
    func redo(current: EditorMemento) -> EditorMemento? {

        guard let next = redoStack.popLast() else {
            return nil
        }

        undoStack.append(current)

        return next
    }

    // MARK: Debug

    func printStatus() {

        print("""
        -----------------------------
        Undo: \(undoStack.count)
        Redo: \(redoStack.count)
        -----------------------------
        """)
    }
}


let editor = TextEditor()
let history = HistoryManager()

//---------------------------------------------------------
// Estado inicial
//---------------------------------------------------------

history.save(editor.save())

print("--------------------------------")
print("Estado inicial")
editor.show()

//---------------------------------------------------------
// Usuario escribe Hola
//---------------------------------------------------------

editor.write("Hola")

history.save(editor.save())

print("--------------------------------")
print("Escribe Hola")
editor.show()

//---------------------------------------------------------
// Usuario escribe Mundo
//---------------------------------------------------------

editor.write(" Mundo")

history.save(editor.save())

print("--------------------------------")
print("Escribe Mundo")
editor.show()

//---------------------------------------------------------
// Usuario escribe !!!
//---------------------------------------------------------

editor.write(" !!!")

print("--------------------------------")
print("Escribe !!!")
editor.show()

//---------------------------------------------------------
// Undo
//---------------------------------------------------------

print("--------------------------------")
print("UNDO")

if let snapshot = history.undo(current: editor.save()) {
    editor.restore(snapshot)
}

editor.show()

//---------------------------------------------------------
// Undo
//---------------------------------------------------------

print("--------------------------------")
print("UNDO")

if let snapshot = history.undo(current: editor.save()) {
    editor.restore(snapshot)
}

editor.show()

//---------------------------------------------------------
// Redo
//---------------------------------------------------------

print("--------------------------------")
print("REDO")

if let snapshot = history.redo(current: editor.save()) {
    editor.restore(snapshot)
}

editor.show()

history.printStatus()




