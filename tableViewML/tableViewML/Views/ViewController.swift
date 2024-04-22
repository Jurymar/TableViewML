//
//  ViewController.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 25/03/24.
//
// Importación del framework UIKit, que proporciona las clases y funciones para crear interfaces de usuario en iOS
import UIKit

// Clase principal del controlador de vista
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
        
    // Vista de tabla para mostrar los productos
    var tableView: UITableView!
    
    // Barra de búsqueda para buscar productos
    var searchBar: UISearchBar!
    
    // Array que almacena los productos recuperados de la API
    var products: [Product] = []
    
    // Temporizador para controlar la búsqueda
    var timer: Timer?
    
    // Etiqueta para mostrar el texto de marcador de posición
    var placeholderLabel: UILabel!
    
    // Método llamado después de que la vista cargue
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Establecer el título en la barra de navegación
        self.title = "Bienvenido"
        
        // Opcional: Personalizar el color del título en la barra de navegación
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Configurar la barra de búsqueda
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // Configurar la tabla
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Configurar el marcador de posición
        placeholderLabel = UILabel()
        placeholderLabel.text = "Realiza una búsqueda para ver \nlos productos👆."
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 2
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        
        // Configurar constraints para la barra de búsqueda
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Configurar constraints para la tabla
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Configurar constraints para el marcador de posición
        NSLayoutConstraint.activate([
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Eliminar el texto predeterminado del botón de retroceso en la barra de navegación
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // Método para configurar la vista de tabla (no se utiliza actualmente)
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    // Método para configurar la barra de búsqueda (no se utiliza actualmente)
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        searchBar.sizeToFit() // Ajustar al tamaño del contenido
        tableView.tableHeaderView = searchBar // Agregar la barra de búsqueda como subvista de la vista principal
    }
    
    // Método para configurar la etiqueta de marcador de posición (no se utiliza actualmente)
    func setupPlaceholderLabel() {
        placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        placeholderLabel.text = "Realiza una búsqueda para ver           los productos"
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 2 // Establecer el número de líneas en 2
        tableView.backgroundView = placeholderLabel
        placeholderLabel.isHidden = true
    }
    
    // Método para mostrar el marcador de posición si no hay productos (no se utiliza actualmente)
    func showPlaceholderIfNeeded() {
        if products.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    // Método llamado cuando cambia el texto en la barra de búsqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Reiniciar el temporizador
        timer?.invalidate()
        
        // Configurar un temporizador para realizar la búsqueda después de un breve retraso
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.performSearch(searchText)
        }
        if searchText.isEmpty {
            // Si el texto de búsqueda está vacío, oculta las líneas de separación
            tableView.separatorStyle = .none
            placeholderLabel.isHidden = true
        } else {
            // Si hay texto de búsqueda, muestra las líneas de separación
            tableView.separatorStyle = .singleLine
        }
    }
    
    // Utilizar la API de MercadoLibre
    func performSearch(_ searchTerm: String?) {
        guard let searchTerm = searchTerm else { return }
        
        APIService.searchProducts(with: searchTerm) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.products = products
                    self?.tableView.reloadData()
                    self?.placeholderLabel.isHidden = !products.isEmpty
                }
            case .failure(let error):
                print("Error al realizar la búsqueda:", error.localizedDescription)
            }
        }
    }

    // Métodos del protocolo UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = products[indexPath.row]
        
        // Configurar el texto de la celda con el título del producto
        cell.textLabel?.text = product.title
        
        // Ajustar el tamaño del texto
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12) // Tamaño de fuente
        
        // Configurar el número de líneas del texto
        cell.textLabel?.numberOfLines = 2 // Mostrar el texto en dos líneas
        
        // Ajustar la propiedad contentMode para hacer que la imagen se ajuste al tamaño de la celda
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        // Cargar la miniatura del producto de forma asíncrona si está disponible
        if let imageURL = URL(string: product.img) {
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL) { (data, response, error) in
                // Check if there's an error
                guard error == nil else {
                    print("Error fetching image: \(error!.localizedDescription)")
                    return
                }
                
                // Check if data is received
                guard let imageData = data else {
                    print("No data received")
                    return
                }
                
                // Convert data to UIImage
                if let image = UIImage(data: imageData) {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                } else {
                    print("Unable to convert data to UIImage")
                }
            }
            task.resume()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        // Crear una instancia del controlador de vista de detalles y pasar los datos del producto
        let detailViewController = ProductDetailViewController()
        detailViewController.product = product
        
        // Realizar la navegación
        show(detailViewController, sender: nil)
    }

    // Método del protocolo UITableViewDelegate para establecer la altura de las celdas
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura deseada para la celda
        return 120 // Altura a 120 puntos
    }
}
