class ELOMatch {

    constructor() {
        this.players = [];
    }

    addPlayer(name, place, elo) {
        let player = {
            name: name,
            place: place,
            eloPre: elo,
            eloChange: 0
        };

        this.players.push(player);
    }

    getPlayers() {
        return this.players;
    }

    getELO(name) {
        for (let i = 0; i < this.players.length; i++) {
            if (this.players[i].name === name) {
                return this.players[i].eloPost;
            }
        }
    }

    getELOChange(name) {
        for (let i = 0; i < this.players.length; i++) {
            if (this.players[i].name === name) {
                return this.players[i].eloChange;
            }
        }
    }

    calculateELOs() {
        const n = this.players.length;
        const k = 32 / (n - 1);

        for (let i = 0; i < n; i++) {
            const curPlace = this.players[i].place;
            const curELO = this.players[i].eloPre;

            for (let j = 0; j < n; j++) {
                if (i !== j) {
                    const oppPlace = this.players[j].place;
                    let oppELO = this.players[j].eloPre;
                    let s;

                    if (curPlace < oppPlace) {
                        s = 1;
                    } else if (curPlace === oppPlace) {
                        s = 0.5;
                    } else {
                        s = 0;
                    }

                    const ea = 1 / (1 + Math.pow(10, (oppELO - curELO) / 400));
                    this.players[i].eloChange += Math.round(k * (s - ea));
                }
            }

            this.players[i].eloPost = this.players[i].eloPre + this.players[i].eloChange;
        }
    }
}

onNet("rahe-racing:server:calculateRatings", (raceId, players) => {
    let raceMatch = new ELOMatch();

    for (let player of players) {
        raceMatch.addPlayer(player.identifier, player.result.finishPosition, player.rating);
    }

    raceMatch.calculateELOs();
    let changedPlayers = raceMatch.getPlayers();

    let queryParameters = [];
    for (let changedPlayer of changedPlayers) {
        queryParameters.push([changedPlayer.eloPost, changedPlayer.name])
    }

    let query = 'UPDATE ra_racing_user_settings SET rating = ? WHERE player_identifier = ?';
    exports.oxmysql.prepare(query, queryParameters, () => {
        emit('rahe-racing:server:ratingsUpdated', raceId, changedPlayers);
    });
});
