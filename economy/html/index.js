$(function () {
	
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

	function log(bool) {
        if (bool) {
            $("#logcontainer").show();
        } else {
            $("#logcontainer").hide();
        }
    }	
	
	function cash(bool) {
        if (bool) {
            $("#cashdisplay").show();
            $("#displaycash").show();
        } else {
            $("#cashdisplay").hide();
			$("#displaycash").hide();
        }
    }

    window.addEventListener('message', function(event) {
        var item = event.data;
				
		if (item.type === "bank") {
			document.getElementById("balance").innerHTML = "$" + item.bank;
        }	
		
		if (item.type === "cash") {
			document.getElementById("displaycash").innerHTML = "$" + item.cash;
        }		
		
        if (item.type === "ui") {
            if (item.status == true) {
                display(true);
				log(false);
            } else {
                display(false);
				log(false);
            }
        }        
    })    
	
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://economy/exit', JSON.stringify({}));
            return;
        }
    };
	
    $("#withdraw").click(function() {
		let inputValue = $("#amount").val()
		$.post('http://economy/withdraw', JSON.stringify({
			amount: inputValue
		}));
        return;
    })
	
	$("#deposit").click(function() {
		let inputValue = $("#amount").val()
		$.post('http://economy/deposit', JSON.stringify({
			amount: inputValue
		}));
        return;
    })
	
	$("#transfer").click(function() {
		let inputValue = $("#transfer").val()
		$.post('http://economy/transfer', JSON.stringify({
			amount: inputValue
		}));
        return;
    })
	
	$(document).ready(function(){
		$("#container").hide();
		$("#logcontainer").hide();
		$("#cashdisplay").show();
	})
	
})