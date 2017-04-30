function registerClient (){
    window.location = '/register-client';
}

function handleRegisterMenu(evt){
    const regPanel = document.querySelector('#register-panel');
    regPanel.removeEventListener('click', handleRegisterMenu);
    $('#find-panel').hide();
    $('#registerBtn').hide(500);
    $('#register-panel').animate({height:"100vh", width:"100vw"});
    const regWindow = document.querySelector('#register-window');
    createButton(regWindow, "entypo-plus-circled", "new client", "new-client-btn");
    createButton(regWindow, "entypo-plus-circled", "item to existing client", "item-to-client-btn");
    createButton(regWindow, "entypo-plus-circled", "new location", "new-location-btn");
}

function createButton(parent, className, text, id) {
    const div = document.createElement("div");
    div.className = "user-buttons";
    div.id = id;
    const span = document.createElement("span");
    span.className = className;
    const btnText = document.createElement("h4");
    textContent = document.createTextNode(text);
    btnText.appendChild(textContent);
    div.appendChild(span);
    div.appendChild(btnText);
    parent.appendChild(div);
    return div;
}

function handleFindMenu(){
    const findPanel = document.querySelector('#find-panel');
    findPanel.removeEventListener('click', handleFindMenu);
    window.location = '/find';
    // $('#register-panel').animate({opacity: 0.25, right: "+=150", width: "0"}, 200, function(){
    //     $('#register-panel').hide();
    //     $('#find-panel').animate({height:"100vh", width:"100vw"}, 500, function(){
    //         $('#findBtn').hide();
    //     });
    // });
}

function main (){
    const regPanel = document.querySelector('#register-panel');
    regPanel.addEventListener('click', handleRegisterMenu);

    const findPanel = document.querySelector('#find-panel');
    findPanel.addEventListener('click', handleFindMenu);

    $('body').on('click', '#new-client-btn', registerClient);
    $('#register-panel').hover(function(){
        $('#find-panel').css("opacity", "0.5");
        $(this).css("opacity", "1");
    });
    $('#find-panel').hover(function(){
        $('#register-panel').css("opacity", "0.5");
        $(this).css("opacity", "1");
    });
}

document.addEventListener("DOMContentLoaded", main);