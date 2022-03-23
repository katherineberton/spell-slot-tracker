/*


notes


*/

const charId = document.querySelector('#char-id').getAttribute('value')

//------------------------------------------functions

//get spell name and spell desc from spell slug from the api
function spell_details_fetch(spell_slug) {
  return (
    fetch(`https://api.open5e.com/spells/${spell_slug}`)
      .then(res => res.json())
      .then(
        function process(details) {
          const name = details["name"];

          const description = details["desc"];

          return {name, description}
        }
      )
  )
}

//casts cantrip and records in db
function castCantrip(spellSlug) {
  //trigger the flask route that adds a cantrip to the db
  fetch(`/cast-cantrip/${charId}?spell-slug=${spellSlug}`)
}








//------------------------------------------spells known

//select spells known section
const spellsKnown = document.querySelector('#spells-known ul')

//fetch all slugs associated with spells known by character id
fetch(`/list-spells-known/${charId}`)
  .then(res => res.json())
  .then(spells => {

    //for each spell slug in the list
    for (const spell of spells) {

      //call spell details fetch function
      spell_details_fetch(spell)

        //then use that info to populate the button
        .then(info => {

          //create the button
          spellsKnown.insertAdjacentHTML(
            'beforeend',
            `<li><button class="cast" id="${spell}">${info.name}</button></li>`
          )
          
          //add the "castCantrip" event listener to it
          document.querySelector(`#${spell}`).addEventListener(
            'click',
            () => castCantrip(spell)
          );
        })
    }

  }
)









//------------------------------------------------board

const board = document.querySelector('#board')

fetch(`/current-slot-rules/${charId}`)
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
        for (let i = 1; i <= slotsPerDay; i++) {
          board.insertAdjacentHTML('beforeend', `<button class="cast-${castingLevel}">Level ${castingLevel} CAST</button>`);
          //add event listeners for this button here
        }
      }
    }
  }
)



