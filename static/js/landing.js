const levelUpButton = document.querySelector('#level-up-button')




const cantripModal = document.querySelector('#addSpellKnown')

cantripModal.addEventListener('show.bs.modal', (evt) => {

    //retrieves id from the button clicked to trigger the modal
    const id = evt.relatedTarget.getAttribute('id');

    //id is in the form "add-cantrip-{characterId}".
    //split by dash, retrieve last element in the list
    const idComponents = id.split('-');
    const characterId = idComponents[idComponents.length - 1]

    //sets action attribute on form in modal to the appropriate flask route
    document.querySelector("#cantrip-form").setAttribute(
        "action",
        `/handle-add-spell/${characterId}`);

})

