class Combattant: Character {
    private let startWeapon = Weapon(name: "Epée simple", power: Constants.Combattant.startWeaponPower)
    
    init(name: String) {
        super.init(name: name, health: Constants.Combattant.maxHealth, icon: "🗡", weapon: startWeapon, action: Constants.Combattant.action)
    }
}
