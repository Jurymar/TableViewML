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
        if let imageURL = URL(string: product.img),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            productImageView.image = image
        }
        titleLabel.text = product.title
    }
}
