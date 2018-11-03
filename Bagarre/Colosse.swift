class Colosse: Character {
    private let startWeapon = Weapon(name: "Masse simple", power: Constants.Colosse.startWeaponPower)
    
    init(name: String) {
        super.init(name: name, health: Constants.Colosse.maxHealth, icon: "🛡", weapon: startWeapon, action: Constants.Colosse.action)
    }
}
