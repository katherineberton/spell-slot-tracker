/*




*/


const charId = document.querySelector('#char-id').getAttribute('value')

// spells known


//why isn't this return statement doing anything? the print statements are fine
function spell_details_fetch(spell_slug) {
  fetch(`https://api.open5e.com/spells/${spell_slug}`)
  .then(res => res.json())
  .then(function process(details) {
    const name = details["name"];
    //console.log(name)
    const description = details["desc"];
    //console.log(description)
    return {name: name, desc: description};
  })
}


const spellsKnown = document.querySelector('#spells-known ul')


fetch(`/list_spells_known-${charId}`)
  .then(res => res.json())
  .then(lst => {
    for (const spell of lst) {
      spellsKnown.insertAdjacentHTML('beforeend', `<li>${spell}</li>`)
    }
  }
)








// board

const board = document.querySelector('#board')

fetch(`/current_slot_rules-${charId}`)
  .then(res => res.json())
  .then(maxSlots => {
    for (const level in maxSlots) {

      // if there are slots at this level, and it's not a cantrip
      if (maxSlots[level] > 0 && level !== 'cantrips_known') {

        castingLevel = level.slice(-1);
        slotsPerDay = maxSlots[level];

        //tell how many slots per day at the casting level
        board.insertAdjacentHTML('beforeend', `<p>Level ${castingLevel} slots: ${slotsPerDay}</p>`);

        //make that many buttons
        for (let i = 0; i < slotsPerDay; i++) {
          board.insertAdjacentHTML('beforeend', '<button>Cast</button>');
        }
      }
    }
  }
)



