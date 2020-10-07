$(function () {
	
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    window.addEventListener('message', function(event) {
        var item = event.data;
				
		if (item.type === "add") {
			document.getElementById('selectbox').innerHTML = "<option>" + item.added + "</option>";
        }			
		
		if (item.type === "remove") {
				$('#selectbox option:selected').remove();
        }		
		
		if (item.type === "update") {
				document.getElementById('amtcount').innerHTML = "Amount: " + item.amount;
        }
		
        if (item.type === "ui") {
            if (item.status === true) {
                display(true);
            } else {
                display(false);
            }
        }        
    })    
	
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://inventory/exit', JSON.stringify({}));
            return;
        }
    };
	
    $("#use").click(function() {
		let inputValue = $('#selectbox option:selected').text();
		$.post('http://inventory/use', JSON.stringify({
			selectBox: inputValue
		}));
        return;
    })
	
	$("#drop").click(function() {
		let inputValue = $('#selectbox option:selected').text();
		$.post('http://inventory/drop', JSON.stringify({
			selectBox: inputValue
		}));
        return;
    })
	
	$(document).ready(function(){
		display(false);
	})
	
})