import Foundation

public enum Biome: Int {
    case desert
    case ocean
    case plains
    static var count: Int { return Biome.plains.rawValue + 1}

    static let desertAnimals = ["Scorpion", "Camel", "Meerkat", "Coyote", "Tarantula", "Vulture", "Rattlesnake", "Bobcat", "Roadrunner", "Mountain Lion"]
    static let oceanAnimals = ["Blue Whale", "Cachalot", "Shark", "Turtle", "Jelly Fish", "Tuna", "Seal", "Sponge Bob", "Dolphin", "Penguin"]
    static let plainsAnimals = ["Tiger", "Elephant", "Zebra", "Jaguar", "Monkey", "Gorilla", "Bear", "Fox", "Rabbit", "Deer"]
    var animals: [String] {
        switch self {
        case .desert: return Biome.desertAnimals
        case .ocean: return Biome.oceanAnimals
        case .plains: return Biome.plainsAnimals
        }
    }


}