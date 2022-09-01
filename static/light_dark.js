function isDarkModeEnabled() {
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
}

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => { //scheme updated
    setColorMode();
});

function setColorMode(){
    mode = ""
    switch(forceDarkMode){
        case 0: 
            mode = "light";
            break;
        case 1:
            mode = "dark";
            break;
        default:
            mode = isDarkModeEnabled() ? "dark" : "light";
    }
    document.body.className = mode;
}

setColorMode() //set the color mode class as soon as the body tag is loaded
