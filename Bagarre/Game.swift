class Game {
    private var teamNameList: [String] = [] // contains the names of all teams to avoid duplicates
    private var characterNameList: [String] = [] // contains the names of all characters to avoid duplicates
    private var numberOfTurns = 0
    private var teams = [Team]() // contains the players teams
    private var activeTeamIndex = 0 // current team turn
    
    // starts the game
    func start() {
        
        createTeams()
        
        // Random team will begin
        let startingTeamIndex = Int.random(in: 0 ..< teams.count)
        
        print("\nL'équipe " + teams[startingTeamIndex].name + " a gagné le tirage au sort et démarre la partie !")
        activeTeamIndex = startingTeamIndex
        
        // Game loops until one team dies
        while numberOfteamsAlive(in: teams) > 1 {
            
            // add a turn when all teams have played
            if activeTeamIndex == startingTeamIndex {
                numberOfTurns += 1
            }
            
            if teams[activeTeamIndex].livingCharacters() > 0 {
                print("\n******************** Tour n°\(numberOfTurns) | Equipe " + teams[activeTeamIndex].name + " ********************")
                play(activeTeam: teams[activeTeamIndex])
            }
            
            // change the active team
            if activeTeamIndex == teams.count - 1 {
                activeTeamIndex = 0
            } else {
                activeTeamIndex += 1
            }
        }
        
        // victory announcement
        for team in teams {
            if team.livingCharacters() > 0 {
                print("\n🏆 Victoire de l'équipe " + team.name + " en \(numberOfTurns) tours !!!\n")
            }
        }
    }
    
    // Creation of the teams
    private func createTeams() {
        for _ in 1 ... Constants.numberOfTeams {
            let team = Team(name: newTeamName())
            print("\n******************** Composition de l'équipe \(team.name) ********************")
            for _ in 1 ... Constants.charactersInTeam {
                team.addCharacter(newCharacter()!)
            }
            teams.append(team)
        }
    }

    // asks the user to enter a name for a team
    private func newTeamName() -> String {
        print("\nChoisissez un nom d'équipe : ", terminator:"")
        while true {
            if let name = readLine() {
                if teamNameList.contains(name.uppercased()) {
                    print("Nom déjà pris ! Choisissez-en un autre : ", terminator:"")
                } else {
                    teamNameList.append(name.uppercased())
                    return name
                }
            }
        }
    }
    
    // creates a character
    private func newCharacter() -> Character? {
        print("\nChoisissez un personnage :"
            + "\n1. 🗡 Combattant (Attaquant équilibré)"
            + "\n2. 🧙🏻‍♀️ Mage (Peut soigner ses alliés)"
            + "\n3. 🛡 Colosse (Très endurant mais peu puissant)"
            + "\n4. ⛏ Nain (Puissant attaquant mais peu endurant)")
        while true {
            if let choice = readLine() {
                switch choice {
                case "1":
                    return Combattant(name: newCharacterName())
                case "2":
                    return Mage(name: newCharacterName())
                case "3":
                    return Colosse(name: newCharacterName())
                case "4":
                    return Nain(name: newCharacterName())
                default:
                    print("Faites un choix entre 1 et 4 : ", terminator:"")
                }
            }
        }
    }

    // asks the user to enter a name for a character
    private func newCharacterName() -> String {
        print("Choisissez un nom pour votre personnage : ", terminator:"")
        while true {
            if let name = readLine() {
                if characterNameList.contains(name.uppercased()) {
                    print("Nom déjà pris ! Choisissez-en un autre : ", terminator:"")
                } else {
                    characterNameList.append(name.uppercased())
                    return name
                }
            }
        }
    }

    // player turn
    private func play(activeTeam: Team) {
        
        // player chooses a character to play
        print("\nChoisissez le personnage qui va agir :")
        let character = activeTeam.selectCharacter()
        
        // chance that a chest appears
        if Int.random(in: 1 ... 100) <= Constants.chanceOfChest {
            print("\n🎁 Un coffre apparait !\n")
            character.actionList.append("Ouvrir le coffre")
        }
        
        // player chooses an action
        switch character.selectAction() {
        case "Passer":
            print(character.name + " passe son tour")
        case "Attaquer":
            let targetTeam = selectTeam()
            print("Choisissez quel personnage attaquer :")
            character.action(target: targetTeam.selectCharacter())
        case "Soigner":
            print("Choisissez le personnage à soigner :")
            character.action(target: activeTeam.selectCharacter())
        case "Ouvrir le coffre":
            character.openChest()
        default:
            break
        }
        
        // the chest disappears
        if character.actionList.contains("Ouvrir le coffre") {
            character.actionList.remove(at:character.actionList.firstIndex(of: "Ouvrir le coffre")!)
        }
    }
    
    // returns the number of teams with at least one character alive
    private func numberOfteamsAlive(in teams: [Team]) -> Int {
        var count = 0
        for team in teams {
            if team.livingCharacters() > 0 {
                count += 1
            }
        }
        return count
    }
    
    // select a team
    private func selectTeam() -> Team {
        
        // a character cannot attack his own team
        var targetTeams = teams
        targetTeams.remove(at: activeTeamIndex)
    
        // The player chooses a team if there's more than 2
        if targetTeams.count == 1 {
            return targetTeams[0]
        } else {
            var index = 0
            print("Choisissez quelle équipe attaquer :")
            
            // displays useful informations on teams
            for team in targetTeams {
                index += 1
                print("\(index). Equipe : " + team.name + " :")
                // displays useful info on characters in the team
                var charactersInfo = ""
                for character in team.characters {
                    if charactersInfo != "" {
                        charactersInfo += " // "
                    }
                    charactersInfo += character.icon + " " + character.name + " / PV : \(character.health)/\(character.maxHealth)"
                }
                print(charactersInfo)
            }
            
            while true {
                if let choice = Int(readLine()!) {
                    switch choice {
                    case 1 ... index:
                        if targetTeams[choice - 1].livingCharacters() > 0 {
                            return targetTeams[choice - 1]
                        } else {
                            print("Aucun personnage vivant dans cette équipe !")
                        }
                    default:
                        break
                    }
                }
                print("Faites un choix entre 1 et \(index) : ", terminator:"")
            }
        }
    }
}
