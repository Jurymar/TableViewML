//
//  ViewController.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 25/03/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    var products: [String] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la tabla
        tableView.frame = view.bounds
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Configurar la barra de búsqueda
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Reiniciar el temporizador cada vez que el usuario escribe en el searchBar
        timer?.invalidate()
        
        // Configurar un temporizador para que la búsqueda se realice después de 0.3 segundos de que el usuario haya dejado de escribir
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.performSearch(searchText)
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
}
