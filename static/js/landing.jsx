function CantripKnown(props) {

    return (
        <React.Fragment>
            <div className="cantrip-known">
                {props.spellName}
                <form action={`/delete-spell-known/${props.charId}`}>
                    <button className="btn btn-outline-secondary btn-sm delete-cantrip-button" name="spell_to_delete" type="submit" value={props.spellSlug}>
                        Delete
                    </button>
                </form>
            </div>
        </React.Fragment>
    );
}


function CharacterCard(props) {
    const [cantrips, setCantrips] = React.useState([]);

    //populates known cantrips into "cantrips" component state
    React.useEffect( () => {
        fetch(`/list-spells-known-2/${props.charId}`)
            .then(res => res.json())
            .then(cantrips => {
                setCantrips(cantrips)
            })        
    }, []);

    //array of cantrip components
    const cantripComponents = [];

    //loops over component state cantrips
    //adds a component to cantripComponents to each one
    for (const cantrip of cantrips) {
        cantripComponents.push(
            <CantripKnown
             key={`${props.charId}-${cantrip.spell_slug}`}
             spellName={cantrip.spell_name}
             spellSlug={cantrip.spell_slug}
             charId={props.charId}
            />,
        );
    }

    let cantripsSection;
    let addCantButton;
    
    //if paladin or ranger, no cantrips section and no add cantrip button
    if (props.playerClass === 'Paladin' || props.playerClass === 'Ranger') {
        cantripsSection = null;
        addCantButton = null;
    } else {
        //add cantrip button
        addCantButton = (
            <button className="btn btn-outline-primary"
            data-bs-toggle="modal"
            data-bs-target="#addSpellKnown"
            id={`add-cantrip-${props.charId}`}>
            Add a cantrip
            </button>
        );
        //if cantrips known, display them
        if (cantrips.length > 0) {
            cantripsSection = (<div className="col cantrips-section">{cantripComponents}</div>);
        } else { 
            //otherwise, prompt to add one
            cantripsSection =
            (<button className="btn btn-outline-primary"
            data-bs-toggle="modal"
            data-bs-target="#addSpellKnown"
            id={`add-cantrip-${props.charId}`}>
                Add some cantrips!
            </button>);
        }
    }


    return (
            <div className="character-summary col-4 bg-light" id={`char-card-${props.charId}`}>
                <h3 className="character-head">{props.name} | Class: {props.playerClass} | Level: {props.level}</h3>
                <div className="row" id={`cantrips-known-${props.charId}`}>
                    <h5>Cantrips known:</h5>
                    {cantripsSection}
                </div>
                <div className="row" id="actions-bar">
                    <h5>Actions:</h5>
                        <div className="btn-group" role="group">
                            <a className="btn btn-outline-primary" href={`/level-up/${props.charId}`} role="button">Level up</a>
                            <a className="btn btn-outline-primary" href={`/update-character/${props.charId}`} role="button">Update</a>
                            {addCantButton}
                            <a className="btn btn-success" href={`/play/${props.charId}`} role="button">PLAY</a>
                        </div>
                </div>
            </div>
    );
}


function CharacterCardContainer(props) {
    const [characters, setCharacters] = React.useState([]);

    //this fct occurs on every render including the first one 
    React.useEffect( () => {
        fetch('/list-characters')
            .then(res => res.json())
            .then(characters => {
                setCharacters(characters)
            })        
    }, []);

    //array of cards that the characters will be added to
    const characterCards = [];

    //loops over component state characters
    //adds each card to tradingCards in the form of a react fragment
    for (const character of characters) {
        characterCards.push(
            <CharacterCard
            key={character.character_id} 
            name={character.character_name}
            playerClass={character.player_class}
            level={character.character_level}
            charId = {character.character_id}
            />,
        );
    }

    return (
        <React.Fragment>
            <div className="grid">{characterCards}</div>
        </React.Fragment>
    )
}


ReactDOM.render(<CharacterCardContainer />, document.querySelector('#characters-div'))