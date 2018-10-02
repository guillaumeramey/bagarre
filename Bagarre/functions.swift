// ****************************************************************
// * BONUS : asks the user how many characters he wants in a team *
// ****************************************************************

func selectTeamSize() -> Int {
    var numberOfCharacters = 0
    
    print("Combien de personnages par équipe ?")
    while numberOfCharacters == 0 {
        if let choice = Int(readLine()!) {
            numberOfCharacters = choice
        } else {
            print("Choix impossible !")
        }
    }
    
    return numberOfCharacters
}

// *****************************************************
// * creates a team with as much characters as we want *
// *****************************************************

func createTeam(_ teamNumber: Int, _ name: String, _ teamSize: Int) -> Team {
    let team = Team(teamNumber, name)
    
    while team.count() < teamSize {
        print("\nChoisissez le personnage n°\(team.count() + 1) de l'équipe " + name + " :"
            + "\n1. 🗡 Combattant"
            + "\n      -> Attaquant équilibré, esquive améliorée "
            + "\n2. 🧙🏻‍♀️ Mage"
            + "\n      -> Peut soigner ses alliés"
            + "\n3. 🛡 Colosse"
            + "\n      -> Très endurant mais peu puissant, peut protéger ses alliés"
            + "\n4. ⛏ Nain"
            + "\n      -> Puissant attaquant mais peu endurant")
        if let choice = readLine() {
            switch choice {
            case "1":
                team.addCharacter(Character(selectCharacterName(), .combattant))
            case "2":
                team.addCharacter(Character(selectCharacterName(), .mage))
            case "3":
                team.addCharacter(Character(selectCharacterName(), .colosse))
            case "4":
                team.addCharacter(Character(selectCharacterName(), .nain))
            default:
                print("Faire un choix entre 1 et 4")
            }
        }
    }
    
    return team
}


// ********************************************
// * asks the user to enter a name for a team *
// ********************************************

var teamNameList: [String] = [] // contains the names of all teams to avoid duplicates

func selectTeamName() -> String {
    var teamName = ""
    
    print("\nChoisissez un nom pour votre équipe :")
    
    while teamName == "" {
        if let name = readLine() {
            if teamNameList.contains(name.uppercased()) {
                print("Nom déjà pris ! Choisissez-en un autre :")
            } else {
                teamNameList.append(name.uppercased())
                teamName = name
            }
        }
    }
    
    return teamName
}


// *************************************************
// * asks the user to enter a name for a character *
// *************************************************

var characterNameList: [String] = [] // contains the names of all characters to avoid duplicates

func selectCharacterName() -> String {
    var characterName = ""
    
    print("Choisissez un nom pour votre personnage :")
    
    while characterName == "" {
        if let name = readLine() {
            if characterNameList.contains(name.uppercased()) {
                print("Nom déjà pris ! Choisissez-en un autre :")
            } else {
                characterNameList.append(name.uppercased())
                characterName = name
            }
        }
    }
    
    return characterName
}


// ***********************************************
// * BONUS : asks the user to select a game mode *
// ***********************************************

func selectGameMode() -> String {
    var gameMode = ""
    
    print("\nChoisissez un mode de jeu :"
        + "\n1. Normal (1 personnage / tour)"
        + "\n2. Bonus (toute l'équipe / tour)")
    
    while gameMode == "" {
        if let choice = readLine() {
            switch choice {
            case "1":
                gameMode = "Normal"
            case "2":
                gameMode = "Bonus"
            default:
                print("Faire un choix entre 1 et 2")
            }
        }
    }
    
    return gameMode
}


// *****************************
// * main function : game turn *
// *****************************

func play(_ activeTeam: Team, _ targetTeam: Team) {
    let activeCharacter: Character
    let targetCharacter: Character
    let action: String
    
    // player chooses a character to play
    print("\nChoisissez le personnage qui va agir :")
    activeCharacter = activeTeam.selectCharacter(target: false)
    
    // chance that a chest appears
    if Int.random(in: 1 ... 100) <= chanceForChest {
        print("\n🎁 Un coffre apparait !\n")
        activeCharacter.actionList.append("Ouvrir le coffre")
    }
    
    // player chooses an action if he has more than 1 choice
    if activeCharacter.actionList.count > 1 {
        activeCharacter.cancelProtect() // the protection only lasts one turn
        action = activeCharacter.selectAction()
    } else {
        action = activeCharacter.actionList[0]
    }
    
    switch action {
    case "Attaquer":
        print("Choisissez qui " + activeCharacter.name + " va attaquer :")
        targetCharacter = targetTeam.selectCharacter(target: true)
        activeCharacter.attack(targetCharacter)
    case "Soigner":
        print("Choisissez qui " + activeCharacter.name + " va soigner :")
        targetCharacter = activeTeam.selectCharacter(target: true)
        activeCharacter.heal(targetCharacter)
    case "Protéger":
        // if the colossus is the only character alive, there's no protection possible
        if activeTeam.livingCharacters() > 1 {
            print("Choisissez qui " + activeCharacter.name + " va protéger :")
            targetCharacter = activeTeam.selectCharacter(target: true)
            // the colossus can't protect himself
            if targetCharacter === activeCharacter {
                print("\n🛡 " + activeCharacter.name + " ne peut pas se protéger lui-même !")
            } else {
                activeCharacter.protect(targetCharacter)
            }
        } else {
            print("\n🛡 Il n'y a personne à protéger !")
        }
    case "Ouvrir le coffre":
        if Int.random(in: 1 ... 2) == 1 {
            activeCharacter.openWeaponChest() // 1/2 chance of a new weapon
        } else {
            activeCharacter.openPotionChest() // 1/2 chance of a health potion
        }
    case "Boire une potion de soin":
        activeCharacter.drinkPotion()
    default:
        break
    }
    
    // the chest disappears
    if activeCharacter.actionList.contains("Ouvrir le coffre") {
        activeCharacter.actionList.remove(at:activeCharacter.actionList.firstIndex(of: "Ouvrir le coffre")!)
    }

    activeCharacter.hasPlayed = true
}


// **************************************************************
// * BONUS : calls the main function depending on the team size *
// **************************************************************

func playBonus(_ activeTeam: Team, _ targetTeam: Team) {
    for _ in 1 ... activeTeam.livingCharacters() {
        if targetTeam.isAlive() {
            play(activeTeam, targetTeam)
        }
    }
}
