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
        
        view.backgroundColor = .white
        
        // Cambiar el color del botón de retroceso en la barra de navegación
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // Configurar la imagen del producto
        productImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200))
        productImageView.contentMode = .scaleAspectFit
        view.addSubview(productImageView)
        
        // Configurar el título del producto
        titleLabel = UILabel(frame: CGRect(x: 20, y: 320, width: view.frame.width - 40, height: 100))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(titleLabel)
        
        // Mostrar los detalles del producto
        if let imageURL = URL(string: product.img),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            productImageView.image = image
        }
        titleLabel.text = product.title
    }
}

