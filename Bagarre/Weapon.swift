class Weapon {
    let name: String // the name of the weapon
    let power: Int // attack power
    let spirit: Int // heal power
    
    init(_ name: String, power: Int) {
        self.name = name
        self.power = power
        spirit = 1
    }
    
    init(_ name: String, spirit: Int) {
        self.name = name
        self.spirit = spirit
        power = 1
    }
}
