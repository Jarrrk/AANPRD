var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

function UpdateCursorPos(){
	cursor.style.left = cursorX;
	cursor.style.top = cursorY;
}

function Click(x, y){
	var element = $(document.elementFromPoint(x, y));
	element.focus().click();
}

$(function(){
	window.addEventListener('message', function(event){
		if(event.data.AANPRD_ACTIVE == true){
			$('.AANPRD-init').fadeIn(2500);
		}
		else if(event.data.AANPRD_ACTIVE == false){
			$('.AANPRD-init').fadeOut(2000);
		}
		else if(event.data.eventType == 'click'){
			Click(cursorX - 1, cursorY - 1);
		}
	});

	$(document).mousemove(function(event){
		cursorX = event.pageX;
		cursorY = event.pageY;
		UpdateCursorPos();
	});

	document.onkeyup = function(data){
		if(data.which == 27){ // Escape key
			$.post('http://AANPRD/escape', JSON.stringify({}));
		}
	};

	function AddNewAANPRDHit(hitDetails){

	}
});