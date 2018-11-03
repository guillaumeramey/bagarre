struct Constants {
    
    // Chance for a chest to appear
    static let chanceOfChest = 50
    
    // Number of teams
    static let numberOfTeams = 3
    
    // Number of characters in a team
    static let charactersInTeam = 2
    
    // Characters
    struct Combattant {
        static let maxHealth = 100
        static let startWeaponPower = 10
        static let action = "Attaquer"
    }
    
    struct Colosse {
        static let maxHealth = 150
        static let startWeaponPower = 5
        static let action = "Attaquer"
    }
    
    struct Mage {
        static let maxHealth = 100
        static let startWeaponPower = 15
        static let action = "Soigner"
    }
    
    struct Nain {
        static let maxHealth = 50
        static let startWeaponPower = 15
        static let action = "Attaquer"
    }
    
}
