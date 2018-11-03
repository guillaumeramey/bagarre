class Mage: Character {
    private let startWeapon = Weapon(name: "Dague simple", power: Constants.Mage.startWeaponPower)
    
    init(name: String) {
        super.init(name: name, health: Constants.Mage.maxHealth, icon: "🧙🏻‍♀️", weapon: startWeapon, action: Constants.Mage.action)
    }
    
    // the mage action is heal instead of attack
    override func action(target: Character) {
        // if the character is already at maximum health, there's no heal possible
        if target.health == target.maxHealth {
            print("\n💊 Les PV de " + target.name + " sont déjà au maximum !")
        } else {
            if name == target.name {
                print("\n💊 " + name + " se soigne et récupère \(weapon.power) PV !")
            } else {
                print("\n💊 " + name + " soigne " + target.name + " qui récupère \(weapon.power) PV !")
            }
            
            // health can't go over maxHealth
            if weapon.power + target.health > target.maxHealth {
                target.health = target.maxHealth
            } else {
                target.health += weapon.power
            }
        }
    }
}
