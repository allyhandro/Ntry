function handleGetItems(evt){
    const url = '/' + event.target.id.replace(" ", "-") + '/items';
    const req = new XMLHttpRequest();
    $.ajax({
        type:"POST",
        url: url,
        dataType: 'text',
        data: {
            clientName: event.target.id
        },
        success: function(){
            location.href = url;
        }
    })
}

function main(){
    const itemListBtn = document.getElementsByClassName("itemsBtn");
    for (var i =0; i < itemListBtn.length; i++){
        itemListBtn[i].addEventListener("click", handleGetItems);
    }
}
document.addEventListener("DOMContentLoaded", main);