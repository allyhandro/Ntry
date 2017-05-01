const QRCode = require('qrcode');

function main(){
    const labelGroups = document.getElementsByClassName("item-label-group");
    for (let i = 0; i < labelGroups.length; i++){
        const itemLabelDiv = labelGroups[i].childNodes[1];
        const itemId = itemLabelDiv.childNodes[3].id;
        QRCode.toCanvas(itemLabelDiv.childNodes[3], itemId, {version: 2}, function(error) {
            if(error) console.log(error);
        });

        const locationDiv = labelGroups[i].childNodes[3];
        const location = locationDiv.childNodes[3].id;
        QRCode.toCanvas(locationDiv.childNodes[3], location,{version: 2}, function (err) {
            if (err) console.log(err);
        });
    }

}

document.addEventListener('DOMContentLoaded', main);