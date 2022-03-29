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

const spellModal = document.querySelector('#spellModal');

spellModal.addEventListener('show.bs.modal', (evt) => {
  const slotLevel = evt.relatedTarget.getAttribute('slotLevel');
  
  const slotSpan = document.querySelector('#slotSpan');
  
  slotSpan.innerText = slotLevel;
  slotSpan.setAttribute("value", slotLevel)
})

const spellCastForm = document.querySelector('#castingForm')

spellCastForm.addEventListener('submit', (evt) => {
  evt.preventDefault();

  const formInputs = {
    slotLevel: document.querySelector('#slotSpan').getAttribute('value'),
    spellCast: document.querySelector('#spell-cast').value,
    note: document.querySelector('#note').value,
  };

  fetch(`/handle-use-slot/${charId}`, {
    method: 'POST',
    body: JSON.stringify(formInputs),
    headers: {
      'Content-Type': 'application/json',
    },
  })
})