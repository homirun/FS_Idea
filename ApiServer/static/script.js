let url = "http://api.homirun.pw"

$("#dec").click(function(){
    const request = new XMLHttpRequest();
    request.open("GET", url + "/hm/people/dec/");
    request.send();
    getNow();
});

$("#inc").click(function(){
    const request = new XMLHttpRequest();
    request.open("GET", url + "/hm/people/inc/");
    request.send();
    getNow();
});
$(document).ready(function(){
    getNow();
})

function getNow(){
    const request = new XMLHttpRequest();
    request.open("GET", url + "/hm/people/now/");
    request.send();
    request.onreadystatechange=function(){
        let response = request.responseText;
        document.getElementById("now").innerText = response + "人";
    };
}
