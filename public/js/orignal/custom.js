//Original Application
var do_on_load = function() {
    // Handler for .ready() called.

    //autocomplete
    $('input.autocomplete').each(function(){
        var input = $(this);
        input.autocomplete(input.attr('data-autocomplete-url'),{
            matchContains:1,//also match inside of strings when caching
            mustMatch:1,//allow only values from the list
            selectFirst:1,//select the first item on tab/enter
            removeInitialValue:0//when first applying $.autocomplete
        });
    });

    //bind events data table
    $(".datatable").dataTable();

    //Auto hide error box
    setTimeout(function() {
        $("#error_explanation").fadeOut('slow');
    }, 3000);

    $(".person-list input[type=checkbox]" ).bind("change", addedWho);

    updatePriceSummary();
    //bind addons and choices controls
    $(".price-option").bind("change", priceOptions);


    $(".guest-detail > a").bind("click",function () {

        $(this).parent('div').toggleClass('open');

        if($(this).next('div#address_detail').length==1)
            $(this).next('div#address_detail').toggleClass('show');
        else
            $(this).next().next('div#address_detail').toggleClass('show');

    });


}
//fix for turbolinks request
$(document).ready(do_on_load);
//$(window).bind('page:change', do_on_load)


function addedWho(){

    $('input:checkbox.person').each(function () {
        var personspanid = this.id.match(/\d+/)+'_person';

        if ($(this).is(':checked'))
        {
            var person_name = $(this).attr('data-person-name');
            var person_price =  $(this).attr('data-item-amount');

            if ($('#'+personspanid).length == 0)
            {
                if (person_price > 0 )
                    $('#who-view').append("<li id="+personspanid+">"+person_name+"&nbsp;&nbsp;&nbsp;$<span id="+person_price+" class='item-price-summary'>"+  parseFloat(person_price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,') +"</span></li>");
                else
                    $('#who-view').append("<li id="+personspanid+">"+person_name+"&nbsp;&nbsp;&nbsp;<span id="+person_price+" class='item-price-summary'>$0.00</span></li>") ;
            }

        }
        else
        {

            $('#'+personspanid).remove();

        }
    });

    updatePriceSummary();
}

function dragAbleChoice(){
    $( ".choiceContainer" ).sortable({
        items: "ul:not(.last)",
        handle: '.choiceHandle'
    });
}
function dragAbleAddon(){
    $( ".addonContainer" ).sortable({
        //items: "ul:not(.last)"
        handle: '.handle'
    });


}
function addElement(spanid,option_text,span_price,new_option_price){
    $('#what-view').append("<li id="+spanid+">"+option_text+"&nbsp;&nbsp;&nbsp;$<span id="+span_price+" class='item-price-summary'>"+parseFloat(new_option_price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,')+"</span></li>");
}
function updateElement(span_price,new_option_price){
    $('#'+span_price).html(parseFloat(new_option_price).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
}
function priceOptions() {

    var choice_level;
    var ctrltype = $(this)[0].type
    var fld_name = this.id

    if (fld_name.indexOf("addon_value") >= 0)  //addon level drop down
    {
        choice_level = "addon";
        var fld_name = fld_name.replace('addon_value','registration_choices_attributes_'+$(this).val()+'__choice_price')
        var option_text = $("#"+this.id+" option:selected").text();
        var option_price = $('#'+fld_name).val();

    }
    else //choice level
    {
        choice_level = "child";
        fld_name = fld_name.replace("value","price");
        var option_text = $('label[for="' + this.id + '"]').text();
        var option_price = $('#'+fld_name).val();

    }

    var spanid =  $(this).attr('data-type')+'_span';
    var span_price =  $(this).attr('data-type')+'_span_price'
    var total_price = 0

    if (ctrltype=='checkbox')
    {
        var new_option_price = 0;
        $(document).find('[data-type*="'+$(this).attr('data-type')+'"]').each(function(){
            if ($(this).is(':checked'))
            {
                new_option_price += parseFloat(option_price);

            }
        })

        if ($('#'+span_price).length != 0)
        {

            updateElement(span_price,new_option_price)
        }
        else
            addElement(spanid,option_text,span_price,new_option_price);

        if (new_option_price == 0)
            $('#'+spanid).remove();
    }
    else if(ctrltype=='select-one' && choice_level=='child')
    {
        var  new_option_price = 0;
        $(document).find('[data-type*="'+$(this).attr('data-type')+'"]').each(function(){
            new_option_price += $(this).val() * option_price;

        });


        if ($('#'+span_price).length != 0)
        {

            updateElement(span_price,new_option_price)
        }
        else
            addElement(spanid,option_text,span_price,new_option_price);

        if (new_option_price == 0)
            $('#'+spanid).remove();

    }
    else if(ctrltype=='select-one' && choice_level=='addon')
    {
        //console.log('tru')
        var  new_option_price = 0;
        var i = 0;
        var myaddarr = new Array();
        $(document).find('[data-type*="'+$(this).attr('data-type')+'"]').each(function(){
            i++;


            var option_val = $("#"+this.id+" option:selected").val();
            var option_text = $("#"+this.id+" option:selected").text();
            var option_price = $("#"+this.id+" option:selected").attr("data-price");

            var fld_id = this.id

            var choice=$("#"+fld_id).parent().parent().find("input[type=hidden]").first();
            var choice_id=choice.val();
            var j=1;

            $("#"+fld_id).parent().parent().find("input[type=hidden]").each(function(){
                this.id=this.id.replace('choices_attributes_'+choice_id,'choices_attributes_'+option_val);
                this.name=this.name.replace('choices_attributes['+choice_id+']','choices_attributes['+option_val+']');
                switch (j){
                    case 1:
                        this.value=option_val;
                        break;
                    case 2:
                        this.value=1;
                        break;
                    case 3:
                        this.value=option_price;
                        break;
                }
                j=j+1;
            });

            //console.log(option_price);
            myaddarr[i] = option_text+'#'+option_price;
            //new_option_price += $(this).val() * option_price;
        });

        var num_of_opts = $('#'+this.id+' option').size();


        $('#'+this.id+' option').each(function()
        {
            //console.log($(this).text())
            // add $(this).val() to your list
            var innercount = 0;
            for (var i = 1; i < myaddarr.length; i++) {
                var stradd = myaddarr[i];

                var add_data = stradd.split('#');

                if (add_data[0]==$(this).text())
                    innercount +=  parseFloat(add_data[1]);
            }

            var spanid =  $(this).val().toString()+'_span';

            var span_price =  $(this).val().toString()+'_span_price';
            option_text =  $(this).text();
            new_option_price =  innercount;

            $('#'+spanid).remove();

            if (new_option_price > 0)
                addElement(spanid,option_text,span_price,new_option_price);
            else {
//                alert('Check-1');
            }
        });

    }
    updatePriceSummary();

}

function updatePriceSummary(){

    var max_price=parseFloat($("#registration_max_price").val());
    if(max_price > 0)     {
        $("#totalCartAmountHolder").html('Total $ <span id="total_summary"></span>');
        $("#total_summary").html(totalPrice);
    }
    else
        $("#total_summary").html("Free");


}
function totalPrice() {

    var a = 0.00,max_price=parseFloat($("#registration_max_price").val());
    $(".item-price-summary").each(function() {
        a += parseFloat($(this).html().replace('$',''));
    });

    a=a.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');

    $("#registration_amount_total").val(a);

    if (a > max_price)
        a=max_price;

    $("#registration_amount_payable").val(a);

    return a;
}

function addOnTypes_handler(select){
    // Do some code here
    var optionSelected = $(select).find("option:selected");
    var valueSelected  = optionSelected.val();
    //console.log(valueSelected);

    if(valueSelected=="Addons::Scale"){
        $(select).parent().parent().find(".range_from").parent().parent().show();
        $(select).parent().parent().find(".range_to").parent().parent().show();
    }
    else{
        $(select).parent().parent().find(".range_from").parent().parent().hide();
        $(select).parent().parent().find(".range_to").parent().parent().hide();
    }

    if(valueSelected=="Addons::Text"){
        $(select).parent().parent().find(".choices").hide();
    } else{
        $(select).parent().parent().find(".choices").show();
    }

    if(valueSelected=="Addons::Radio"){
        $(select).parent().parent().find(".price").hide();
    } else{
        $(select).parent().parent().find(".price").show();
    }
}

//add dynamic addon/choices block
function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");

    var select;

    if (association=='addons'){
        $(".addonContainer").append(content.replace(regexp, new_id));
        select = $(".addonContainer").last().find(".addon_type").first();
    }
    else {

        $(link).parent().before(content.replace(regexp, new_id));
        select =$(link).parent().parent().parent().parent().find(".addon_type");
    }



    addOnTypes_handler(select);

    dragAbleAddon();
    dragAbleChoice();

}

//remove dynamic addon/choices block
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".fields").hide();
}



//add person specific addon
function add_person_fields(link, association, content,person_content) {

    var person =$('.autocomplete').val();

    if (person=='') {
        alert('You must select a guest');
        return false;
    }
    var person_name =person.split('(')[0];
    var person_id= person.split('(')[1];

    person_name=person_name.substring(0, person_name.length - 1);
    person_id=person_id.substring(0, person_id.length - 1);

    if($(".person-list").find("li[data-person='"+person_name+"']").length>0){
        alert('You have already selected this guest');
        $('.autocomplete').val('');
        return false;
    }

    // console.log();
    addPersonAddon(person_id,person_name,association,content);

    $(".person-list").append(person_content.replace(/{demo_id}/g,person_id).replace(/{demo_name}/g,person_name));


    $('.autocomplete').val('');

    $(".person-list input[type=checkbox]" ).bind("change", addedWho);
    addedWho();

}

function addPersonAddon(person_id,person_name,association,content){
    var new_id = new Date().getTime();

    var regexp = new RegExp("new_" + association, "g");

    $(".addons").append(content.replace(regexp, new_id));

    var options_person = $(".options-person").last();

    options_person.find(".person-name").html(person_name);

    options_person.attr('data-for-person-id', person_id);
    options_person.attr('data-for-person-name', person_name);

    options_person.find('[for*="registration"]').each(function(){
        $(this).attr('for',$(this).attr('for').replace('registration_registration_guests_attributes_','registration_registration_guests_attributes_'+person_id)) ;
    });

    options_person.find('*').each(function(){
        $(this).attr('id',   $(this).attr('id')   ? $(this).attr('id').replace('registration_registration_guests_attributes_','registration_registration_guests_attributes_'+person_id) : '') ;
        $(this).attr('name', $(this).attr('name') ? $(this).attr('name').replace('registration_guests_attributes[]','registration_guests_attributes['+person_id+']') : '') ;
    });

    options_person.find(".price-option" ).bind("change", priceOptions);
}

function personCartToggle(el,id,person_name,association,content) {

    if(el.checked){ //If the user CHECKED the box ADD the person to the cart

        addPersonAddon(id,person_name,association,content);

        $(el).prev("input[type=hidden]").val("0");


        $('[data-for-person-id="' + id + '"]').find(".price-option").each(function(){
            $(this).bind("change",priceOptions);
        });

    } else { //If they UNCHECKED the box remove the person

        $('[data-for-person-id="' + id + '"]').find(".price-option").each(function(){
            $(this).unbind("change");
            //console.log(this);
        });

        $('[data-for-person-id="' + id + '"]').remove();
        $(el).prev("input[type=hidden]").val("1");

        fireAllEvenets();
        resetSummary();
    }
}

function addGuest( association, content,person_content){
    //Get guest number & increment, then write back
    var numGuests = parseInt(jQuery(document).data('tcEvents.guests')) + 1;
    jQuery(document).data('tcEvents.guests', numGuests);

    var guest_id= numGuests;
    var guest_name ='Guest ' + numGuests;

    var new_id = new Date().getTime();

    var regexp = new RegExp("new_" + association, "g");

    $(".addons").append(content.replace(regexp, new_id).replace(/{guest_id}/g,guest_id).replace(/{guest_name}/g,guest_name).replace(/guest_id/g,guest_id));

    var guestEl = jQuery(person_content.replace(/{guest_id}/g,guest_id).replace('guestTemplate','guestTemplate'+guest_id).replace(/{guest_name}/g,guest_name));

    //Add a name attribute for the addPersonalOptions function
    jQuery(guestEl).find('input[type=checkbox]').attr('data-person-name',guest_name );

    //Insert guest
    jQuery(guestEl).insertBefore('#guests').slideDown();

    $('.options-person').last().find('.price-option').bind("change", priceOptions);

    $("input.tel").mask("(999) 999-9999");

    addedWho();

}

function removeGuest(el,id) {

    addedWho();
    var templateid='#guestTemplate'+id;
    $(templateid).remove();
    $('[data-for-person-id="' + id + '"]').remove();
    fireAllEvenets();
    resetSummary();
}

function validateform(){

    var datefrom = $('#event_start_date').val();
    var dateto = $('#event_end_date').val();

    var hourfrom = $('#event_start_time_4i').val();
    var minutefrom = $('#event_start_time_5i').val();

    var hourto = $('#event_end_time_4i').val();
    var minuteto = $('#event_end_time_5i').val();

    var datefrom = new Date(datefrom+" "+hourfrom+":"+minutefrom+":"+"00");
    var dateto = new Date(dateto+" "+hourto+":"+minuteto+":"+"00");


    if (datefrom > dateto)
    {
        alert('Date from cannot be greater then date to');
        return false;
    }

    if (datefrom.getTime() > dateto.getTime())
    {
        alert('Time from cannot be greater then time to');
        return false;
    }

    if ($('#event_base_price').val() < 0)
    {
        alert('Base price cannot be less then zero');
        return false;

    }
    else if ($('#event_max_price').val() < 0)
    {
        alert('Max price cannot be less then zero');
        return false;
    }

    if (parseFloat($('#event_base_price').val()) > parseFloat($('#event_max_price').val()))
    {
        alert('Base price cannot be more then Max price');
        return false;
    }

    if (parseInt($('#event_seats').val()) < 0)
    {
        alert('Seats cannot be less then zero');
        return false;

    }

}

function validateRange(fld_range){

    var classname = $(fld_range).attr('class');
    if (classname.indexOf("range_to") >= 0)
    {
        if (parseInt($(fld_range).parent().parent().parent().find(".range_from").val()) >  parseInt($(fld_range).val()))
        {
            alert('Range from cannot be larger then range to');
            $(fld_range).focus();
        }

    }
}

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 46 || charCode > 57))
        return false;

    return true;
}

function fireAllEvenets(){
    $(document).find('.price-option').each(function(){
        $(this).trigger("change");
        //console.log(this);
    });
}

function resetSummary(){

    if ($(document).find('.options-person').length <= 0)
        $('#what-view').find('li').remove();
}

function toggleRow(btn,id){
    var ojgClass=".detail_"+id.toString();
    if ($(btn).html()=='Show details') {
        $(ojgClass).show('slow');
        $(btn).html('Hide details');
    }
    else
    {
        $(ojgClass).hide('slow');
        $(btn).html('Show details');
    }
}

/*
 Autosorting function for jQuery datatables. Looks for a table with the classes datatable and autosort
 If it finds thead>tr>th[data-autosort] and then sorts the table by that TH's index in the direction indicated
 by the data-sortdir attribute.

 @author JM Addington <jm@jmaddington.com>
 */
function autosort() {
    $('.datatable.autosort').each(function() {
        var n = 0;
        parent = this;
        $(this).find('thead').find('tr').children().each(function() {
            if ($(this).attr('data-autosort') == 'true') {
                $(parent).dataTable().fnSort( [[n, $(this).attr('data-sortdir')]]);
            }
            n++;
        })
    });
}


