//
//  ProductDetailViewController.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 26/03/24.
//
import UIKit

class ProductDetailViewController: UIViewController {
    
    // Propiedades para mostrar los detalles del producto
    var product: Product!
    var productImageView: UIImageView!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la vista
        
        //Configuro color
        view.backgroundColor = .white
        
        // Cambiar el color del botón de retroceso en la barra de navegación
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // Crear y configurar el stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Configurar la imagen del producto
        productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(productImageView)
        
        // Configurar el título del producto
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        
        // Añadir restricciones de altura y anchura para la imagen del producto
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 100), // Anchura fija de 200 puntos
            productImageView.heightAnchor.constraint(equalToConstant: 100) // Altura fija de 200 puntos
        ])
        
        // Añadir restricciones para el stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Mostrar los detalles del producto
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
                        self.productImageView.image = image
                    }
                } else {
                    print("Unable to convert data to UIImage")
                }
            }
            task.resume()
        }
        
        titleLabel.text = product.title
    }
}
