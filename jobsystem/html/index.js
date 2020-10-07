$(function () {
	

    window.addEventListener('message', function(event) {
        var item = event.data;	
		
        if (item.type === "ui") {
            if (item.status === true) {
                 $("#container").show();
            } else {
                $("#container").hide();
            }
        }        
    })
	
	document.onkeyup = function(data) {
    if (data.which == 27) {
		$.post('http://inventory/exit', JSON.stringify({}));
		return;
	}
	};
	
    $("#selectspawn").click(function() {
		let inputValue = $('#selectbox option:selected').text();
		$.post('http://spawnselection/selectspawn', JSON.stringify({
			selectBox: inputValue
		}));
		$("#container").hide();
        return;
    })
	
	
	$(document).ready(function(){
		$("#container").hide();
	})
})