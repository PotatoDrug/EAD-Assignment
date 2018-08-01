<%@ page import="java.util.ArrayList" %>
<%@ page import="com.spmovy.beans.SeatsJB" %><%--
  Created by IntelliJ IDEA.
  User: Javiery
  Date: 31-Jul-18
  Time: 7:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href='http://fonts.googleapis.com/css?family=Lato:400,700' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="/css/jquery.seat-charts.css">
    <title>Bookings</title>
</head>
<body>
<div class="wrapper">
    <div class="container">
        <div id="seat-map">
            <div class="front-indicator">Front</div>

        </div>
        <div class="booking-details">
            <h2>Booking Details</h2>

            <h3> Selected Seats (<span id="counter">0</span>):</h3>
            <ul id="selected-seats"></ul>

            Total: <b>$<span id="total">0</span></b>

            <button class="checkout-button">Checkout &raquo;</button>

            <div id="legend"></div>
            <%
                ArrayList<String> occupiedseatslist = new ArrayList<String>();
                ArrayList<SeatsJB> seatbeanlist = (ArrayList)request.getAttribute("seatbeanlist");
                for(SeatsJB seatbean : seatbeanlist){
                    occupiedseatslist.add("\"" + seatbean.getRow_col() + "\"");
                }
            %>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="/js/jquery.seat-charts.min.js"></script>

<script>
    var firstSeatLabel = 1;

    $(document).ready(function() {
        var seatarr = [];
        for (var i = 0; i < 10; i++){
            seatarr.push("ssssssssss_ssssssssss");
        }
        var $cart = $('#selected-seats'),
            $counter = $('#counter'),
            $total = $('#total'),
            sc = $('#seat-map').seatCharts({
                map: seatarr,
                seats: {

                    s: {
                        price   : 40,
                        classes : 'economy-class', //your custom CSS class
                        category: 'Economy Class'
                    }

                },
                naming : {
                    top : false,
                    rows : ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
                    getLabel : function (character, row, column) {
                        if (firstSeatLabel > 20){
                            firstSeatLabel = 1;
                        }
                        return firstSeatLabel++;

                    },
                },
                legend : {
                    node : $('#legend'),
                    items : [
                        [ 's', 'available',   'Avaliable'],
                        [ 'f', 'unavailable', 'Already Booked']
                    ]
                },
                click: function () {
                    if (this.status() == 'available') {
                        //let's create a new <li> which we'll add to the cart items
                        $('<li>'+this.data().category+' Seat # '+this.settings.label+': <b>$'+this.data().price+'</b> <a href="#" class="cancel-cart-item">[cancel]</a></li>')
                            .attr('id', 'cart-item-'+this.settings.id)
                            .data('seatId', this.settings.id)
                            .appendTo($cart);

                        /*
                         * Lets update the counter and total
                         *
                         * .find function will not find the current seat, because it will change its stauts only after return
                         * 'selected'. This is why we have to add 1 to the length and the current seat price to the total.
                         */
                        $counter.text(sc.find('selected').length+1);
                        $total.text(recalculateTotal(sc)+this.data().price);

                        return 'selected';
                    } else if (this.status() == 'selected') {
                        //update the counter
                        $counter.text(sc.find('selected').length-1);
                        //and total
                        $total.text(recalculateTotal(sc)-this.data().price);

                        //remove the item from our cart
                        $('#cart-item-'+this.settings.id).remove();

                        //seat has been vacated
                        return 'available';
                    } else if (this.status() == 'unavailable') {
                        //seat has been already booked
                        return 'unavailable';
                    } else {
                        return this.style();
                    }
                }
            });

        //this will handle "[cancel]" link clicks
        $('#selected-seats').on('click', '.cancel-cart-item', function () {
            //let's just trigger Click event on the appropriate seat, so we don't have to repeat the logic here
            sc.get($(this).parents('li:first').data('seatId')).click();
        });

        //let's pretend some seats have already been booked
        sc.get(<%=occupiedseatslist%>).status('unavailable');

    });

    function recalculateTotal(sc) {
        var total = 0;

        //basically find every selected seat and sum its price
        sc.find('selected').each(function () {
            total += this.data().price;
        });

        return total;
    }

</script>
<style>
    body {
        font-family: 'Lato', sans-serif;
    }
    a {
        color: #b71a4c;
    }
    .front-indicator {
        max-width: 700px;
        margin: 5px 32px 15px 32px;
        background-color: #f6f6f6;
        color: #adadad;
        text-align: center;
        padding: 3px;
        border-radius: 5px;
    }
    .wrapper {
        width: 100%;
        text-align: center;
    }
    .container {
        margin: 0 auto;
        width: 90%;
        text-align: left;
    }
    .booking-details {
        float: left;
        text-align: left;
        margin-left: 35px;
        font-size: 12px;
        position: relative;
        height: 401px;
    }
    .booking-details h2 {
        margin: 25px 0 20px 0;
        font-size: 17px;
    }
    .booking-details h3 {
        margin: 5px 5px 0 0;
        font-size: 14px;
    }
    div.seatCharts-cell {
        color: #182C4E;
        height: 25px;
        width: 25px;
        line-height: 25px;

    }
    div.seatCharts-seat {
        color: #FFFFFF;
        cursor: pointer;
    }
    div.seatCharts-row {
        height: 35px;
    }
    div.seatCharts-seat.available {
        background-color: #B9DEA0;

    }
    div.seatCharts-seat.available.first-class {
        /* 	background: url(vip.png); */
        background-color: #3a78c3;
    }
    div.seatCharts-seat.focused {
        background-color: #76B474;
    }
    div.seatCharts-seat.selected {
        background-color: #E6CAC4;
    }
    div.seatCharts-seat.unavailable {
        background-color: #472B34;
    }
    div.seatCharts-container {
        border-right: 1px dotted #adadad;
        width: 200px;
        padding: 20px;
        float: left;
    }
    div.seatCharts-legend {
        padding-left: 0px;
        position: absolute;
        bottom: 16px;
    }
    ul.seatCharts-legendList {
        padding-left: 0px;
    }
    span.seatCharts-legendDescription {
        margin-left: 5px;
        line-height: 30px;
    }
    .checkout-button {
        display: block;
        margin: 10px 0;
        font-size: 14px;
    }
    #selected-seats {
        max-height: 90px;
        overflow-y: scroll;
        overflow-x: none;
        width: 170px;
    }

</style>
</body>
</html>
