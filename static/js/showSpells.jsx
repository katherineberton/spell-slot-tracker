// const currentBrowsingClass = window.location.href.split('-')[1];

function SpellCard(props) {
  return(
    <div className="card border-info">
        <div className="card-body">
          <h5 className="card-title" id={`title-${props.spellSlug}`}>
            {props.spellName}
          </h5>
          <h6 className="card-subtitle mb-2 text-muted">Base level: {props.spellLevel}</h6>
          <button className="btn btn-info btn-sm spell-card-btn"
                  type="button"
                  data-bs-toggle="offcanvas"
                  data-bs-target="#offCanvas"
                  aria-controls="offCanvas"
                  id={`btn-react-${props.spellSlug}`}>
            See details
          </button>
        </div>
      </div>
  );
}




function SpellCardContainer(props) {
  const [spells, setSpells] = React.useState([])

  //set state spells to list of spells
  React.useEffect( () => {
    fetch(`browse-${currentBrowsingClass}-spells-2`)
      .then(res => res.json())
      .then(spellData => setSpells(spellData))
  }, []);

  const spellCards = [];

  for (const spell of spells) {
    spellCards.push(
      <SpellCard
       key={spell.spell_name}
       spellSlug={spell.spell_slug}
       spellName={spell.spell_name}
       spellLevel={spell.spell_level}
      />
    )
  }

  return (
    <React.Fragment>
      <div className="grid">{spellCards}</div>
    </React.Fragment>
  )
}

ReactDOM.render(<SpellCardContainer />, document.querySelector('#react-testing'))