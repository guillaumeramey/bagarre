class Nain: Character {
    private let startWeapon = Weapon(name: "Hache simple", power: Constants.Nain.startWeaponPower)
    
    init(name: String) {
        super.init(name: name, health: Constants.Nain.maxHealth, icon: "⛏", weapon: startWeapon, action: Constants.Nain.action)
    }
}
