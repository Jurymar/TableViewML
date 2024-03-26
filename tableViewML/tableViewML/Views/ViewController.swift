//
//  ViewController.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 25/03/24.
//
import UIKit

// Estructura que representa un producto
struct Product: Decodable {
    let title: String      // Título del producto
    let thumbnail: String  // URL de la miniatura del producto
}

// Estructura que representa la respuesta de búsqueda de la API
struct SearchResponse: Decodable {
    let results: [Product]  // Array de productos
}

// Clase principal del controlador de vista
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // Propiedades de la clase
    var tableView: UITableView!  // Vista de tabla para mostrar los productos
    var searchBar: UISearchBar!  // Barra de búsqueda para buscar productos
    var products: [Product] = []  // Array que almacena los productos recuperados de la API
    var timer: Timer?             // Temporizador para controlar la búsqueda
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la tabla y la barra de búsqueda
        setupTableView()
        setupSearchBar()
    }
    
    // Configurar la vista de tabla
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    // Configurar la barra de búsqueda
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        searchBar.sizeToFit() // Ajustar al tamaño del contenido
        tableView.tableHeaderView = searchBar
    }
    
    // Realizar la búsqueda cuando cambia el texto en la barra de búsqueda
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
        } else {
            // Si hay texto de búsqueda, muestra las líneas de separación
            tableView.separatorStyle = .singleLine
        }
    }
    
    // Realizar la búsqueda utilizando la API de MercadoLibre
    func performSearch(_ searchTerm: String?) {
        guard let searchTerm = searchTerm?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = URL(string: "https://api.mercadolibre.com/sites/MLC/search?q=\(searchTerm)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error al realizar la solicitud:", error?.localizedDescription ?? "Error desconocido")
                return
            }
            
            do {
                // Decodificar los datos de respuesta en objetos de tipo SearchResponse
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                
                // Actualizar la lista de productos y recargar la tabla en el hilo principal
                DispatchQueue.main.async {
                    self?.products = searchResponse.results
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error al procesar los datos:", error.localizedDescription)
            }
        }.resume()
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
        if let imageURL = URL(string: product.thumbnail),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // devolver la altura deseada para la celda
        return 120 // altura a 120 puntos
    }
}
