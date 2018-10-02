class Character {
    let name: String // the name of the character
    let type: characterType // the type of the character (enum)
    let typeIcon: String // easy reading during the game
    let strength: Int // the characters have different strengths but the same weapons
    let dodge: Int // the character has a chance to dodge attacks
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
    var actionList: [String] = ["Attaquer"] // contains the available actions for the character
    var hasPlayed = false // BONUS : has the character already played ?
    var stateIcon : String { // an icon to easily see the character state
        if isAlive {
            return hasPlayed ? "❌" : "✅"
        } else {
            return "☠️"
        }
    }
    var protector : Character? // BONUS : exists if the character is currently protected by another one
    var protecting : Character? // BONUS : exists if the character is protecting another one
    var isProtected: Bool { // BONUS : true if the character is protected by another living character
        if protector == nil {
            return false
        } else {
            return protector!.isAlive ? true : false
        }
    }
    var numberOfPotions = 0 // BONUS : the character can find potions in chests and use them on himself
    
    init(_ name: String, _ type: characterType) {
        self.name = name
        self.type = type
        switch type {
        case .combattant:
            typeIcon = combattantTypeIcon
            maxHealth = combattantMaxHealth
            strength = combattantStrength
            dodge = combattantDodge
            weapon = Weapon("Epée simple", power: weaponPower)
        case .colosse:
            typeIcon = colosseTypeIcon
            maxHealth = colosseMaxHealth
            strength = colosseStrength
            dodge = colosseDodge
            weapon = Weapon("Masse simple", power: weaponPower)
        case .mage:
            typeIcon = mageTypeIcon
            maxHealth = mageMaxHealth
            strength = mageStrength
            dodge = mageDodge
            weapon = Weapon("Dague simple", spirit: weaponPower)
            actionList.insert("Soigner", at: 0)
        case .nain:
            typeIcon = nainTypeIcon
            maxHealth = nainMaxHealth
            strength = nainStrength
            dodge = nainDodge
            weapon = Weapon("Hache simple", power: weaponPower)
        }
        health = maxHealth
    }
    
    // the character attacks another one
    func attack(_ target: Character) {
        let damage = weapon.power * strength
        
        // is the target protected ?
        if target.isProtected {
            // dodge ?
            if Int.random(in: 1 ... 100) > target.protector!.dodge {
                print("\n⚔️ " + name + " frappe " + target.name + " mais " + target.protector!.name + " le protège et encaisse \(damage) points de dégats à sa place !")
                target.protector!.takeDamage(damage)
            } else {
                print("\n⚔️ " + name + " frappe " + target.name + " mais " + target.protector!.name + " le protège et esquive l'attaque !")
            }
            target.protector!.cancelProtect()
        } else {
            // dodge ?
            if Int.random(in: 1 ... 100) > target.dodge {
                print("\n⚔️ " + name + " frappe " + target.name + " et lui inflige \(damage) points de dégats !")
                target.takeDamage(damage)
            } else {
                print("\n⚔️ " + name + " frappe " + target.name + " qui esquive l'attaque !")
            }
        }
    }
    
    // the character takes damage
    func takeDamage(_ damage: Int) {
        // health can't go below 0
        if damage > health {
            health = 0
        } else {
            health -= damage
        }
    }
    
    // the character heals another one
    func heal(_ target: Character) {
        let heal = weapon.spirit * strength
        
        // if the character is already at maximum health, there's no heal possible
        if target.health == target.maxHealth {
            print("\n💊 Les PV de " + target.name + " sont déjà au maximum !")
        } else {
            print("\n💊 " + name + " soigne " + target.name + " et lui rend \(heal) PV !")
            target.takeHeal(heal)
        }
    }
    
    // the character receives heal
    func takeHeal(_ heal: Int) {
        // health can't go over maxHealth
        if heal + health > maxHealth {
            health = maxHealth
        } else {
            health += heal
        }
    }
    
    // select an action for the character
    func selectAction() -> String {
        var index = 0
        var selectOk = false
        var selectIndex = 0
        
        print("Actions disponibles pour " + name + " :")
        
        for action in actionList {
            index += 1
            print("\(index). \(action)")
        }
        
        while selectOk == false {
            if let choice = Int(readLine()!) {
                switch choice {
                case 1 ... index:
                    selectIndex = choice - 1
                    selectOk = true
                default:
                    print("Faire un choix entre 1 et \(index) ", terminator:"")
                }
            } else {
                print("Faire un choix entre 1 et \(index) ", terminator:"")
            }
        }
        
        return actionList[selectIndex]
    }

    // the character opens the chest with a weapon inside
    func openWeaponChest() {
        let powerOldWeapon = type == .mage ? weapon.spirit : weapon.power
        let powerNewWeapon: Int
        let weaponName: String
        
        // random name & stats for the weapon
        let weaponName1 = ["Epée", "Masse", "Bâton", "Hache", "Lance", "Dague", "Marteau", "Matraque", "Fouet"]
        let weaponName2 = ["de la chouette 🦉", "du singe 🐒", "du loup 🐺", "de l'aigle 🦅", "du serpent 🐍", "du tigre 🐯", "du lion 🦁", "du dragon 🐲"]
        
        if Int.random(in: 1 ... 100) < 10 { // 10 % chance of a super weapon
            powerNewWeapon = Int.random(in: 0 ... 10) + 21
            weaponName = "Super " + weaponName1.randomElement()!.lowercased() + " " + weaponName2.randomElement()!
        } else {
            powerNewWeapon = Int.random(in: 0 ... 10) + 11
            weaponName = weaponName1.randomElement()! + " " + weaponName2.randomElement()!
        }
        
        // asks the player if he wants to equip the new weapon
        print("\n🎁 " + name + " ouvre le coffre et obtient... " + weaponName + " / Puissance : \(powerNewWeapon) !!")
        print("   Equiper la nouvelle arme (O/N)? (Equipé : " + weapon.name + " / Puissance : \(powerOldWeapon)) ", terminator:"")
        
        var selectOk = false
        
        while selectOk == false {
            if let choice = readLine() {
                switch choice.uppercased() {
                case "O":
                    selectOk = true
                    if type == .mage {
                        weapon = Weapon(weaponName, spirit: powerNewWeapon)
                    } else {
                        weapon = Weapon(weaponName, power: powerNewWeapon)
                    }
                case "N":
                    selectOk = true
                default:
                    print("Faire un choix entre O et N : ", terminator:"")
                }
            } else {
                print("Faire un choix entre O et N : ", terminator:"")
            }
        }
    }
    
    // BONUS : the character opens the chest with a potion inside
    func openPotionChest() {
        print("\n🎁 " + name + " ouvre le coffre et obtient... une potion de soin (\(healthPotion) PV)!!")
        if numberOfPotions == 0 {
            actionList.append("Boire une potion de soin")
        }
        numberOfPotions += 1
    }
    
    // BONUS : the character drinks a health potion
    func drinkPotion(){
        print("\n💊 " + name + " boit une potion de soin et récupère \(healthPotion) PV !")
        takeHeal(healthPotion)
        numberOfPotions -= 1
        if numberOfPotions == 0 {
            actionList.remove(at: actionList.firstIndex(of: "Boire une potion de soin")!)
        }
    }
    
    // BONUS : the character protects another one
    func protect(_ target: Character) {
        print("\n🛡 " + name + " protègera " + target.name + " de la prochaine attaque !")
        target.protector = self
        protecting = target
    }
    
    // BONUS : any action of the protector will cancel the protection
    func cancelProtect() {
        if protecting != nil {
            print("🛡 " + name + " ne protège plus " + protecting!.name + ".")
            protecting!.protector = nil
            protecting = nil
        }
    }
}

// list of the available character types
enum characterType {
    case combattant, mage, colosse, nain
}
