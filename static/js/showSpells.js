//gives tab element matching the current url the active class in addition to its other classes

const currentBrowsingClass = window.location.href.split('-')[1];
document.querySelector(`#${currentBrowsingClass}-tab`).classList.add('active')




//populates the offcanvas on spell card button click

const spellCardBtns = document.querySelectorAll(".spell-card-btn");

for (const btn of spellCardBtns) {
    btn.addEventListener('click', (evt) => {
        //retrieve spell slug from button's id
        const id = btn.getAttribute('id');
        const slug = id.slice(4);
        console.log(slug)

        //fetch request on spell slug from api
        fetch(`https://api.open5e.com/spells/${slug}`)
            .then(res => res.json())
            .then(spellObj => {
                
                //populate the offCanvas with cool deets from the api
                const offCanvasTitle = document.querySelector('#offCanvasLabel');

                offCanvasTitle.innerText = spellObj.name;
                if (spellObj.ritual === "yes") {
                    offCanvasTitle.insertAdjacentText('beforeend', ' (R)')
                };
                if (spellObj.concentration === "yes") {
                    offCanvasTitle.insertAdjacentText('beforeend', ' (C)')
                };

                document.querySelector('#level-school').innerText = `${spellObj.school} ${spellObj.level}`;
                document.querySelector('#casting-time').innerText = `Casting time: ${spellObj.casting_time}`;
                document.querySelector('#range').innerText = `Range: ${spellObj.range}`;

                const compMat = document.querySelector('#components-materials');
                compMat.innerText = `Components: ${spellObj.components}`;
                if (spellObj.components.includes('M')) {
                    compMat.innerText = `Components: ${spellObj.components} (${spellObj.material})`
                };

                document.querySelector('#duration').innerText = `Duration: ${spellObj.duration}`;
                document.querySelector('#classes').innerText = `Available to: ${spellObj.dnd_class}`;
                document.querySelector('#description').innerText = `Description: ${spellObj.desc}`;

                if (spellObj.higher_level != "") {
                    const higherLevelDesc = document.querySelector('#hl-description');
                    higherLevelDesc.setAttribute('hidden', 'false');
                    higherLevelDesc.innerText = `At higher levels: ${spellObj.higher_level}`;
                }
                

            })
    })
}