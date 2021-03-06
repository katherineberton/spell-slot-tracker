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


function castCantrip(spellSlug) {

  //trigger the flask route that adds a cantrip to the db
  fetch(`/cast-cantrip/${charId}?spell-slug=${spellSlug}`)
  
}


//------------------------------------------spells known

//select spells known section
const spellsKnown = document.querySelector('#spells-known')

//fetch all slugs associated with spells known by character id
fetch(`/list-spells-known-2/${charId}`)
  .then(res => res.json())
  .then(spells => {

    //for each spell slug in the list
    for (const spell of spells) {

      //call spell details fetch function
      spell_details_fetch(spell.spell_slug)

        //then use that info to populate the button
        .then(info => {

          //create the button
          spellsKnown.insertAdjacentHTML(
            'beforeend',
              `<button
              class="btn cast-cantrip-button btn-outline-primary"
              id="${spell.spell_slug}">
                <img src="/static/img/magic.svg">
                ${info.name}
              </button>`
          )
          
          //add the "castCantrip" event listener to it
          document.querySelector(`#${spell.spell_slug}`).addEventListener(
            'click',
            () => castCantrip(spell.spell_slug)
          );
        })
    }
  }
)









//------------------------------------------------board


fetch(`/get-all-slots/${charId}`)
  .then(res => res.json())
  .then(slotList => {
    
  //for each slot in the list of slots:
  for (const [i, slot] of slotList.entries()) {

      //select the relevant section of the page
      const buttonDiv = document.querySelector(`#buttons-level-${slot.slot_level}`)
      
      //if it was used by a spell, disable button and populate with spell name
      if (slot.spell_type_id) {
        buttonDiv.insertAdjacentHTML('beforeend', `<button class="btn used-button" disabled=true>${slot.spell_name}</button>`)
      
      //if it was used for something else, disable button and populate with note content
      } else if (slot.slot_reference) {
        buttonDiv.insertAdjacentHTML('beforeend', `<button class="btn used-button" disabled=true>${slot.slot_reference}</button>`)

      //if it's still available
      } else {
        buttonDiv.insertAdjacentHTML('beforeend', `
                                                  <button type="button"
                                                  class="btn slot-button"
                                                  data-bs-toggle="modal"
                                                  data-bs-target="#spellModal" 
                                                  slotLevel="${slot.slot_level}"
                                                  id="cast-pos-${i}">
                                                  <img src="/static/img/magic.svg">
                                                    CAST
                                                  </button>
                                                  `)
      }
      
    }
  })


const spellModal = document.querySelector('#spellModal');


//customizes the appearance of the modal and sets the attribute to the
//slot level associated with the button used to show it
//also sets the modal's hidden input to the id of the button used to
//trigger it which will allow for it to be disabled on form submit
spellModal.addEventListener('show.bs.modal', (evt) => {

  const slotLevel = evt.relatedTarget.getAttribute('slotLevel');
  const btnId = evt.relatedTarget.getAttribute('id');
  
  document.querySelector('#slotSpan').innerText = slotLevel
  document.querySelector("#slot-used").setAttribute("value", slotLevel)
  document.querySelector("#button-used").setAttribute("value", btnId)

})



const spellCastForm = document.querySelector('#castingForm')


//on form submit:
spellCastForm.addEventListener('submit', (evt) => {
  evt.preventDefault();

  //retrieves slotLevel for fetch req from hidden input "slot used" generated by modal shown
  slotLevel = document.querySelector('#slot-used').getAttribute('value');
  //retrieves btnId for dom manip from hidden input "button used" generated by modal shown
  btnId = document.querySelector('#button-used').value;
  //retrieves spellCast for fetch req from form input
  spellCast = document.querySelector('#spell-cast').value;
  //if slot used on a spell, retrieves spellName for dom manip from option element in form
  if (spellCast != "other") {
    spellName = document.querySelector(`#dropdown-${spellCast}`).getAttribute('name');
    note = null;
  } else {
    note = document.querySelector('#note').value;
  }
 

  //sets up fetch request
  const formInputs = {
    slotLevel: slotLevel,
    spellCast: spellCast,
    note: note,
  };

  //carries out fetch request
  fetch(`/handle-use-slot/${charId}`, {
    method: 'POST',
    body: JSON.stringify(formInputs),
    headers: {
      'Content-Type': 'application/json',
    },
  })

  //selects the button used to generate the form, disables it,
  //displays spell cast or note on it
  const btnUsed = document.querySelector(`#${btnId}`);
  btnUsed.setAttribute("disabled", true);
  if (spellCast === "other") {
    btnUsed.innerText = note;
  } else {
    btnUsed.innerText = spellName;
  }

})


const slotRecoverButtons = document.querySelectorAll('.slot-recover')

for (const button of slotRecoverButtons) {
  button.addEventListener('click', (evt) => {
    const id = evt.target.getAttribute('id'); // "add-slot-{level}"

    //split the above id into components, retrieve last element
    const idSplit = id.split('-');
    const level = idSplit[idSplit.length - 1]

    fetch(`/handle-add-slot/${charId}`, {
      method: 'POST',
      body: JSON.stringify({slotLevel: level}),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    document.location.reload();
  })
}

