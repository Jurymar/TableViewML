//
//  SearchView.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 25/03/24.
//

import UIKit

class SearchView: UIView {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let searchButton = UIButton()
    
    var products: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configurar la barra de búsqueda
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar en MercadoLibre"
        addSubview(searchBar)
        
        // Configurar la tabla de vista
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        // Configurar el botón de búsqueda
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Buscar", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = .gray
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        addSubview(searchButton)
        
        // Configurar restricciones de diseño
        NSLayoutConstraint.activate([
            // Barra de búsqueda
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            // Tabla de vista
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor),
            
            // Botón de búsqueda
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Configurar la tabla de vista
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func searchButtonTapped() {
        guard let searchTerm = searchBar.text else { return }
        searchProducts(query: searchTerm)
    }
    
    private func searchProducts(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error al codificar la consulta de búsqueda")
            return
        }
        
        guard let url = URL(string: "https://api.mercadolibre.com/sites/MLC/search?q=\(encodedQuery)") else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error al realizar la solicitud:", error?.localizedDescription ?? "Error desconocido")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    let titles = results.compactMap { $0["title"] as? String }
                    DispatchQueue.main.async {
                        self?.products = titles
                        self?.tableView.reloadData()
                    }
                }
            } catch {
                print("Error al procesar los datos:", error.localizedDescription)
            }
        }.resume()
    }
}

extension SearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
}

