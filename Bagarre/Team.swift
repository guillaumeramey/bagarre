class Team {
    let name: String // the name of the team
    var characters = [Character]() // the characters in the team
    
    init(name: String) {
        self.name = name
    }
    
    // add a character to the team
    func addCharacter(_ character: Character) {
        characters.append(character)
    }
    
    // returns the numbers of characters alive
    func livingCharacters() -> Int {
        var count = 0
        for character in characters {
            if character.isAlive {
                count += 1
            }
        }
        return count
    }

    // asks the user to select a character in the team
    func selectCharacter() -> Character {
        var index = 0
        
        // displays useful info on characters
        for character in characters {
            index += 1
            print("\(index). " + character.icon + " " + character.name + " / PV : \(character.health)/\(character.maxHealth)")
        }

        while true {
            if let choice = Int(readLine()!) {
                switch choice {
                case 1 ... index:
                    if characters[choice - 1].isAlive {
                        return characters[choice - 1]
                    } else {
                        print("Ce personnage est mort !")
                    }
                default:
                    break
                }
            }
            print("Faites un choix entre 1 et \(index) : ", terminator:"")
        }
    }
}
