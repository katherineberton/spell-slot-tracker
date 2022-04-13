// const userSection = document.querySelector("#user-facts");

// fetch('/get-user-fav-spell')
//     .then(res => res.json())
//     .then(favSpell => {
//         userSection.innerHTML = `<p>Your favorite spell is ${favSpell[2]}. It was cast by ${favSpell[1]} ${favSpell[3]} times.</p>`
//     })

//add this fun fact back in when I think of more things you might want to know about on the user level





const characterSection = document.querySelector("#character-facts");

fetch('/list-characters-fact-sheet')
    .then(res => res.json())
    .then(characters => {
        for (const character of characters) {

            let daysDisplay;
            if (character.num_days === 1) {
                daysDisplay = '1 day'
            } else {
                daysDisplay = `${character.num_days} days`
            }
            
            let favSpellDisplay;
            let favSpellNumTimes;
            if (character.fav_spell.length > 0) {
                if (character.fav_spell[1] === 1) {
                    favSpellNumTimes = 'once.'
                } else {
                    favSpellNumTimes = `${character.fav_spell[1]} times.`
                }

                favSpellDisplay = `Favorite spell: ${character.fav_spell[0]}, cast ${favSpellNumTimes}`
            } else {
                favSpellDisplay = `Have ${character.character_name} cast some spells and we'll tell you which is their favorite!`
            }

            let favUpcastSpellDisplay;
            let favUpcastNumTimes;
            if (character.fav_upcast_spell.length > 0) {
                if (character.fav_upcast_spell[1] === 1) {
                    favUpcastNumTimes = 'once.'
                } else {
                    favUpcastNumTimes = `${character.fav_upcast_spell[1]} times.`
                }
                favUpcastSpellDisplay = `Favorite spell to upcast: ${character.fav_upcast_spell[0]}, upcast ${favUpcastNumTimes}`
            } else {
                favUpcastSpellDisplay = `Upcast some spells with ${character.character_name} and we'll tell you which one they like to upcast the most!`
            }

            let favSpellsLevelDisplay = '';
            for (const level in character.fav_spell_each_level) {
                const fave = character.fav_spell_each_level[level];
                if (fave.length > 0) {
                    favSpellsLevelDisplay += `<li>Favorite level ${level} spell: ${fave[0]}! Total casts: ${fave[1]}.</br></li>`
                } else {
                    favSpellsLevelDisplay += `<li>No favorite level ${level} spells yet.</br></li>`
                }
            }

            let spellCountDisplay = '';
            for (const item of character.spell_level_count) {

                let level;
                if (item[0] === 0) {
                    level = 'Cantrip'
                } else {
                    level = item[0]
                }

                spellCountDisplay += `<tr><td>${level}</td><td>${item[1]}</td></tr>`
            }


            characterSection.insertAdjacentHTML('beforeend',`
            <div class="card character-facts-sheet" style="width: 36rem;">
                <div class="card-body" id="${character.character_id}-card">
                    <h5 class="card-title">${character.character_name}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">
                        Level ${character.character_level} ${character.player_class} - Adventuring for ${daysDisplay}
                    </h6>
                    <div class="card-text" id="${character.character_id}-body">
                        <p id="${character.character_id}-fav-spell">${favSpellDisplay}</p>
                        <p id="${character.character_id}-fav-upcast">${favUpcastSpellDisplay}</p>
                        <p id="${character.character_id}-fav-levels">
                            ${favSpellsLevelDisplay}
                        </p>
                        <table id="${character.character_id}-spell-count">
                            <tr>
                                <th>Level</th>
                                <th>Total spells cast</th>
                            </tr>
                            ${spellCountDisplay}
                        </table>
                    </div>
                </div>
            </div>
            `)
        }

    })
