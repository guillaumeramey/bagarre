class Team {
    let teamNumber: Int // the number of the team
    let name: String // the name of the team
    var characters = [Character]() // the characters in the team
    
    init(_ teamNumber: Int, _ name: String) {
        self.teamNumber = teamNumber
        self.name = name
    }
    
    // add a character to the team
    func addCharacter(_ character: Character) {
        characters.append(character)
    }
    
    // returns the number of characters in the team
    func count() -> Int {
        return characters.count
    }
    
    // returns the number of living characters in the team
    func livingCharacters() -> Int {
        var livingCharacters = 0
        for character in characters {
            livingCharacters += character.isAlive ? 1 : 0
        }
        return livingCharacters
    }
    
    // returns true if at least one character is alive in the team
    func isAlive() -> Bool {
        return livingCharacters() > 0 ? true : false
    }
    
    // BONUS : resets the hasPlayed state for players
    func resetPlayerState() {
        for character in characters {
            character.hasPlayed = false
        }
    }
    
    // select a character in the team
    func selectCharacter(target: Bool) -> Character {
        var index = 0
        var selectOk = false
        var selectIndex = 0
        var characterInfo: String // displays useful info - different if target or not
        
        for character in characters {
            index += 1
            characterInfo = "\(index). "
            if target {
                characterInfo += character.isAlive ? "" : character.stateIcon + " "
                characterInfo += character.isProtected ? "(🛡)" : ""
                characterInfo += " " + character.name + " " + character.typeIcon + " / PV : \(character.health)/\(character.maxHealth)"
            } else {
                characterInfo += character.stateIcon + " "
                characterInfo += character.isProtected ? "(🛡)" : ""
                characterInfo +=  " " + character.name + " " + character.typeIcon + " / PV : \(character.health)/\(character.maxHealth) / Actions : " + character.actionList.joined(separator: ", ")
            }
            
            print(characterInfo)
        }
        
        while selectOk == false {
            if let choice = Int(readLine()!) {
                switch choice {
                case 1 ... index:
                    selectIndex = choice - 1
                    if characters[selectIndex].isAlive {
                        if characters[selectIndex].hasPlayed == false || target {
                            selectOk = true
                        } else {
                            print("Ce personnage a déjà joué dans ce tour ! Faites un autre choix : ", terminator:"")
                        }
                    } else {
                        print("Ce personnage est mort ! Faites un autre choix : ", terminator:"")
                    }
                default:
                    print("Choix impossible ! Faire un choix entre 1 et \(index) : ", terminator:"")
                }
            } else {
                print("Choix impossible ! Faire un choix entre 1 et \(index) : ", terminator:"")
            }
        }
        
        return characters[selectIndex]
    }
}
