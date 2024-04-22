//
//  ProductDetailViewController.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 26/03/24.
//
import UIKit

// Definición de la clase ProductDetailViewController, que hereda de UIViewController
class ProductDetailViewController: UIViewController {
    
    // Propiedades para mostrar los detalles del producto
    var product: Product! // Instancia del producto que se mostrará
    
    // Instancias de las vistas que se utilizarán para mostrar los detalles del producto
    var productImageView: UIImageView! // Vista de imagen del producto
    var titleLabel: UILabel! // Etiqueta para mostrar el título del producto
    var priceLabel: UILabel! // Etiqueta para mostrar el precio original del producto
    
    // Método llamado después de que la vista cargue
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la vista
        
        // Configurar el color de fondo de la vista
        view.backgroundColor = .white
        
        // Cambiar el color del botón de retroceso en la barra de navegación
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Crear y configurar el stack view para organizar las vistas de forma vertical
        let stackView = UIStackView()
        stackView.axis = .vertical // Organización vertical
        stackView.alignment = .center // Centrar las vistas horizontalmente
        stackView.spacing = 20 // Espaciado entre las vistas
        stackView.translatesAutoresizingMaskIntoConstraints = false // No usar restricciones automáticas
        view.addSubview(stackView) // Agregar el stack view a la vista principal
        
        // Configurar la vista de imagen del producto
        productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFit // Escalar la imagen para ajustarla al tamaño de la vista
        productImageView.translatesAutoresizingMaskIntoConstraints = false // No usar restricciones automáticas
        stackView.addArrangedSubview(productImageView) // Agregar la vista de imagen al stack view
        
        // Configurar la etiqueta para mostrar el título del producto
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0 // Permitir múltiples líneas
        titleLabel.textAlignment = .center // Centrar el texto horizontalmente
        titleLabel.font = UIFont.systemFont(ofSize: 20) // Establecer el tamaño de la fuente
        titleLabel.translatesAutoresizingMaskIntoConstraints = false // No usar restricciones automáticas
        stackView.addArrangedSubview(titleLabel) // Agregar la etiqueta al stack view
        
        // Configurar la etiqueta para mostrar el precio del producto
        priceLabel = UILabel()
        priceLabel.numberOfLines = 1 // Mostrar en una sola línea
        priceLabel.textAlignment = .center // Centrar el texto horizontalmente
        priceLabel.font = UIFont.systemFont(ofSize: 16) // Establecer el tamaño de la fuente
        priceLabel.translatesAutoresizingMaskIntoConstraints = false // No usar restricciones automáticas
        stackView.addArrangedSubview(priceLabel) // Agregar la etiqueta al stack view
        
        // Añadir restricciones de altura y anchura para la vista de imagen del producto
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 100), // Ancho fijo de 100 puntos
            productImageView.heightAnchor.constraint(equalToConstant: 100) // Alto fijo de 100 puntos
        ])
        
        // Añadir restricciones para el stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Espacio desde la parte superior segura
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Espacio desde el borde izquierdo
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20) // Espacio desde el borde derecho
        ])
        
        // Mostrar los detalles del producto
        
        // Verificar si hay una URL válida para la imagen del producto
        if let imageURL = URL(string: product.img) {
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL) { (data, response, error) in
                // Verificar si hay un error al obtener la imagen
                guard error == nil else {
                    print("Error fetching image: \(error!.localizedDescription)")
                    return
                }
                
                // Verificar si se recibieron datos
                guard let imageData = data else {
                    print("No data received")
                    return
                }
                
                // Convertir los datos en una imagen
                if let image = UIImage(data: imageData) {
                    // Actualizar la interfaz de usuario en el hilo principal
                    DispatchQueue.main.async { [self] in
                        productImageView.image = image
                    }
                } else {
                    print("Unable to convert data to UIImage")
                }
            }
            task.resume() // Iniciar la tarea de carga de la imagen
        }
        
        // Asignar el título y el precio del producto a las etiquetas correspondientes
        titleLabel.text = product.title
        priceLabel.text = "$ \(product.price)" // Formatear el precio con un símbolo de dólar
    }
}
