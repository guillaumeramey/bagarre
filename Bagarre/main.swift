// *************************
// * Creation of the teams *
// *************************

let teamSize = selectTeamSize()

print("\n******************** Création de la première équipe ********************")
let team1 = createTeam(1, selectTeamName(), teamSize)
print("\n******************** Création de la seconde équipe ********************")
let team2 = createTeam(2, selectTeamName(), teamSize)


// ******************************
// * BONUS : choose a game mode *
// ******************************

let gameMode = selectGameMode()


// ***********
// * Fight ! *
// ***********

var countTurn = false
var numberOfTurns = 1

// draws a team to start
var teams = Int.random(in: 1 ... 2) == 1 ? [team1, team2] : [team2, team1]
print("\nL'équipe " + teams[0].name + " a gagné le tirage au sort et démarre la partie !")


// Game loops until one team dies
while teams[0].isAlive() && teams[1].isAlive() {
    print("\n******************** Tour n°\(numberOfTurns) | Equipe " + teams[0].name + " ********************")
    if gameMode == "Normal" {
        play(teams[0], teams[1])
    } else {
        playBonus(teams[0], teams[1])
    }
    teams[0].resetPlayerState()
    
    // switch teams
    teams.append(teams.remove(at: 0))
    
    // add a turn when the 2 teams have played
    if countTurn {
        countTurn = false
        numberOfTurns += 1
    } else {
        countTurn = true
    }
}

// victory announcement
let winner = team1.isAlive() ? team1.name : team2.name

print("\n🏆 Victoire de l'équipe " + winner + " en \(numberOfTurns) tours !!!\n")
