const currentBrowsingClass = window.location.href.split('-')[1];


function OffcanvasContent(props) {
  const [spellDetails, setSpellDetails] = React.useState(null)

  React.useEffect(() => {
    setSpellDetails(null); // set loading
    
    fetch(`https://api.open5e.com/spells/${props.slug}`)
        .then(res => res.json())
        .then(spellObj => {
          
          setSpellDetails({
                spellName: spellObj.name,
                description: spellObj.desc,
                baseLevel: spellObj.level_int,
                magicSchool: spellObj.school,
                castingTime: spellObj.casting_time,
                range: spellObj.range,
                components: spellObj.components,
                ritual: spellObj.ritual,
                concentration: spellObj.concentration,
                materials: spellObj.material,
                duration: spellObj.duration,
                playerClasses: spellObj.dnd_class,
                hlDescription: spellObj.higher_level
            });
        })
  }, [props.slug]);

  if (!spellDetails) {
    // Loading....
    return <span>Loading...</span>;
  }


  //if spell is ritual and concentration, add (R) and (C) to spell name
  let ritualDisplay, concentrationDisplay;

  if (spellDetails.ritual === 'yes') {
    ritualDisplay = ' (R)';
  }

  if (spellDetails.concentration === 'yes') {
    concentrationDisplay = ' (C)';
  }


  //if spell has material components, show components
  let componentsDisplay = spellDetails.components;

  if (spellDetails.components.includes('M')) {
    componentsDisplay = componentsDisplay + ` (${spellDetails.materials})`;
  }

  //if spell can be upcast, show description of what happens at higher levels
  let higherLevelDisplay = null;
  if (spellDetails.higher_level != "") {
    higherLevelDisplay = (<p>{spellDetails.hlDescription}</p>)
  }

  return (
    <div class="offcanvas-body">
    <p id='level-school'><h5>{spellDetails.spellName}: Level {spellDetails.baseLevel}{ritualDisplay}{concentrationDisplay}</h5></p>
    <p id='casting-time'>Casting time: {spellDetails.castingTime}</p>
    <p id='range'>Range: {spellDetails.range}</p>
    <p id='components-materials'>Components: {componentsDisplay}</p>
    <p id='duration'>Duration: {spellDetails.duration}</p>
    <p id='classes'>Available to: {spellDetails.playerClasses}</p>
    <p id='description'>{spellDetails.description}</p>
    {higherLevelDisplay}
    </div>
  )
}



function SpellCard(props) {

    let ritualDisplay = null;
    let concentrationDisplay = null;

    if (props.ritual === "yes") {
        ritualDisplay = ' (R)'
    }

    if (props.concentration === "yes") {
        concentrationDisplay = ' (C)'
    }

    return(
      <div className="card border-info">
          <div className="card-body">
            <h5 className="card-title" id={`title-${props.spellSlug}`}>
              {props.spellName}{ritualDisplay}{concentrationDisplay}
            </h5>
            <h6 className="card-subtitle mb-2 text-muted">Base level: {props.spellLevel}</h6>
            <button className="btn btn-info btn-sm spell-card-btn"
                    type="button"
                    onClick={() => props.onClick(props.spellSlug)}
                    id={`btn-react-${props.spellSlug}`}>
              See details
            </button>
          </div>
        </div>
    );
  }
  
  
function SpellCardContainer(props) {
    const [spells, setSpells] = React.useState([])

    //spell slug of most recent button clicked
    const [currentSpell, setCurrentSpell] = React.useState(null);

    //display offcanvas
    const [show, setShow] = React.useState(false);
    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);

    //when offcanvas is displayed
    function handleClick(spellSlug) {
      setCurrentSpell(spellSlug)
      setShow(true)
    }

    //set spells state to list of spells
    React.useEffect( () => {
      fetch(`get-${currentBrowsingClass}-spells`)
        .then(res => res.json())
        .then(spellData => setSpells(spellData))
    }, []);
  
    const spellCards = [];
  
    //create SpellCard components for each spell in spell state
    for (const spell of spells) {
      spellCards.push(
        <SpellCard
         key={spell.spell_name}
         spellSlug={spell.spell_slug}
         spellName={spell.spell_name}
         spellLevel={spell.spell_level}
         ritual={spell.ritual}
         concentration={spell.concentration}
         onClick={handleClick}
        />
      )
    }
  
    return (
      <React.Fragment>
        {spellCards}
        <div>
        <ReactBootstrap.Offcanvas show={show} onHide={handleClose} scroll="true">
          <ReactBootstrap.Offcanvas.Header closeButton>
          </ReactBootstrap.Offcanvas.Header>
          <ReactBootstrap.Offcanvas.Body>
            <OffcanvasContent slug={currentSpell} />
          </ReactBootstrap.Offcanvas.Body>
        </ReactBootstrap.Offcanvas>
        </div>
      </React.Fragment>
    )
  }

ReactDOM.render(<SpellCardContainer />, document.querySelector('#spell-cards'))

