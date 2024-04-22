//
//  Product.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 27/03/24.
//

import Foundation

// Propiedades de la clase

// Estructura que representa un producto
struct Product: Decodable {
    let title: String      // Título del producto
    let img: String        // URL de la miniatura del producto
    let price: Int         // Precio original del producto
    
    // Enumeración privada para mapear las claves de codificación
    private enum CodingKeys: String, CodingKey {
        case title
        case img = "thumbnail"  // Mapeo de la clave "thumbnail" a la propiedad img
        case price              // La clave y la propiedad tienen el mismo nombre, no es necesario mapear explícitamente
    }
}
