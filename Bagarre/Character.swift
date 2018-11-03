class Character {
    
    let name: String // the name of the character
    let icon: String // character icon
    let maxHealth: Int // the character's maximum health
    var health: Int { // the character's actual health
        didSet {
            if !isAlive {
                print("⚰️ " + name + " est mort !")
            }
        }
    }
    var isAlive: Bool { // true if the character is alive
        return health > 0
    }
    var weapon: Weapon // the character's weapon
    var actionList = ["Passer"] // available actions for the character

    init(name: String, health: Int, icon: String, weapon: Weapon, action: String) {
        self.name = name
        self.health = health
        maxHealth = health
        self.icon = icon
        self.weapon = weapon
        actionList.insert(action, at: 0)
    }
 
    // the character attacks another one
    func action(target: Character) {
        print("\n⚔️ " + name + " frappe " + target.name + " et lui ôte \(weapon.power) PV !")

        // health can't go below 0
        if weapon.power > target.health {
            target.health = 0
        } else {
            target.health -= weapon.power
        }
    }
    
    // select an action for the character
    func selectAction() -> String {
        var index = 0
        
        print("Actions disponibles pour " + name + " :")
        
        for action in actionList {
            index += 1
            print("\(index). \(action)")
        }
        
        while true {
            if let choice = Int(readLine()!) {
                switch choice {
                case 1 ... index:
                    return actionList[choice - 1]
                default:
                    break
                }
            }
            print("Faites un choix entre 1 et \(index) : ", terminator:"")
        }
    }

    // the character opens the chest with a weapon inside
    func openChest() {
        
        // random name & stats for the weapon
        let weaponName1 = ["Epée", "Masse", "Hache", "Lance", "Dague"]
        let weaponName2 = ["puissante", "merveilleuse", "magnifique", "fabuleuse", "superbe"]

        let newWeaponName = weaponName1.randomElement()! + " " + weaponName2.randomElement()!
        let newWeaponPower = Int.random(in: 20 ... 50)
        
        // asks the player if he wants to equip the new weapon
        print("\nNouvelle arme : " + newWeaponName + " / Puissance : \(newWeaponPower)")
        print("Equiper ? (O/N) (Arme actuelle : " + weapon.name + " / Puissance : \(weapon.power)) ", terminator:"")
        
        while true {
            if let choice = readLine() {
                switch choice.uppercased() {
                case "O":
                    weapon = Weapon(name: newWeaponName, power: newWeaponPower)
                    print(name + " équipe sa nouvelle arme")
                    return
                case "N":
                    print(name + " garde son ancienne arme")
                    return
                default:
                    break
                }
            }
            print("Faites un choix entre O et N : ", terminator:"")
        }
    }
    
}
