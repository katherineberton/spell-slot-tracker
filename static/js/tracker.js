/*


add event handler to long rest button


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

//casts cantrip and records in db by sending to flask route
function castCantrip(spellSlug) {
  //trigger the flask route that adds a cantrip to the db
  console.log(spellSlug)
  fetch(`/cast-cantrip/${charId}?spell-slug=${spellSlug}`)
}


//casts spell and records in db by sending to flask route
function castSpell(spellSlug, level, userNote=null) {

  const formInputs = {
    spellCast: spellSlug,
    spellLevel: level,
    note: userNote,
  }

  fetch(
    `/handle-use-slot/${charId}`,
    {
      method: 'POST',
      body: JSON.stringify(formInputs),
      headers: { 'Content-type': 'application/json', }
    }
  )
}


function hi() {
  alert('hi')
}

//-----------------------------------------menu







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
            `<li><button class="cast-cantrip-button"
                         id="${spell}"
                         value="${spell}">
                 ${info.name}
                 </button></li>`
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

          // document.querySelector(`#slot-${castingLevel}-${i}`).addEventListener(
          //   'click',
          //   () => hi()
          // )
          
          //if i make a form to allow the user to select the spell,
          //how do i send it back to the dom
          //so that the event listener on the button can read it?

          //for now i can set the form to be visible always and remove the event handler
          //on the cast button

          //can i put a form inside a button of submit type and have the encircling button 
          //be submit for the form?
          
          
          //an event listener that on a click generates a bootstrap modal or something with a form inside with the drop down of all spells (for now)
          //the form will send info to a flask route that updates the db via a post request i guess
            //think about what data needs to be sent - slot level
          //the form will have a submit button
          //the submit button on the form will have an event listener that changes the button to say "used" and gives it details on what it was used for
          //handler can be defined outside of the fetch

// function handleCasting(btn) {
//   //etc

// }

