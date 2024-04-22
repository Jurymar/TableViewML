//
//  SearchResponse.swift
//  tableViewML
//
//  Created by Jurymar Colmenares on 27/03/24.
//

import Foundation

// Estructura que representa la respuesta de búsqueda de la API
struct SearchResponse: Decodable {
    let results: [Product]  // Array de productos
}
