function handleAddMore(evt){
    evt.preventDefault();
    const list = document.querySelector('#new-item-form-container');
    const line = document.createElement("hr");
    list.appendChild(line);

    const packing = createFormEle("packing", ["packing"], "text");
    list.appendChild(packing);
    const type = createFormEle("type", ["type"], "text");
    list.appendChild(type);
    const dimensions = createFormEle("dimensions", ["len", "width", "height"], "number");
    list.appendChild(dimensions);
    const title = createFormEle("title", ["title"], "text");
    list.appendChild(title);
    const artist = createFormEle("artist", ["artist"], "text");
    list.appendChild(artist);
    const location = createFormEle("location", ["location"], "text");
    list.appendChild(location);
    const description = createFormEle("description", ["description"], "text");
    list.appendChild(description);
}

function createFormEle(labelText, inputNames, type){
    const div = document.createElement("div");
    div.className = "form-group";

    const label = document.createElement("label");
    const lText = document.createTextNode(labelText);
    label.appendChild(lText);

    div.appendChild(label);

    inputNames.forEach((name) =>{
        const input = document.createElement("input");
        input.setAttribute("type", type);
        input.setAttribute("name", name);
        input.className = name;
        div.appendChild(input);
    });
    return div;
}

function finishValidation (evt){
    evt.preventDefault();
    let redo = false;
    const title = document.getElementsByClassName("title");
    if (title){
        for (let i = 0; i < title.length; i++){
            if (title[i].value === ""){
                const err = document.querySelector("#errorMsg");
                err.innerHTML = "";
                const div = document.createElement("div");
                const text = document.createTextNode("error: all items must have a title");
                div.appendChild(text);
                div.className = "alert alert-danger";
                err.appendChild(div);
                redo = true;
                break;
            }
        }
    }
    if (!redo){
        handleFinish();
    }
}

function handleFinish(){
    // grab everything
    const packing = document.getElementsByClassName("packing");
    const type = document.getElementsByClassName("type");
    const length = document.getElementsByClassName("len");
    const width = document.getElementsByClassName("width");
    const height = document.getElementsByClassName("height");
    const title = document.getElementsByClassName("title");
    const artist = document.getElementsByClassName("artist");
    const location = document.getElementsByClassName("location");
    const description = document.getElementsByClassName("description");

    const clientName = document.querySelector("#clientName").value;
    const items = [];
    for (let i = 0; i < title.length; i++){
        // set default item
        const newItem = {'title': 'none',
                         'packing': 'none',
                         'type': 'none',
                         'dimensions': [0,0,0],
                         'artist': 'unknown',
                         'location': 'undefined',
                         'description': 'art man. ART.'};
        newItem["title"] = title[i].value;
        newItem["packing"] = packing[i].value;
        newItem["type"] = type[i].value;
        newItem["dimensions"] = [length[i].value, width[i].value, height[i].value];
        newItem["artist"] = artist[i].value;
        newItem["location"] = location[i].value;
        newItem["description"] = description[i].value;
        items.push(newItem);
    }
    const data = JSON.stringify(items);
    const req = new XMLHttpRequest();
    req.open('POST', '/register-items');
    req.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    req.send(data);
    req.addEventListener('load', function redirect(){
        window.location = '/print-labels';
    });
}

function main (){
    const addMore = document.querySelector('#addMoreBtn');
    addMore.addEventListener('click', handleAddMore);

    const finish = document.querySelector('#finish');
    finish.addEventListener('click', finishValidation);
}
document.addEventListener("DOMContentLoaded", main);