//
//  AppLogger.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque usamos OSLog ao invés de print() (subsystem/category, Console.app, níveis, performance)
// TODO: Explicar o padrão de um logger por subsistema (networking, cache, persistence)

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "dev.luizmello.blueprint"

    static let networking = Logger(subsystem: subsystem, category: "networking")
    static let cache = Logger(subsystem: subsystem, category: "cache")
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
    static let location = Logger(subsystem: subsystem, category: "location")
}
