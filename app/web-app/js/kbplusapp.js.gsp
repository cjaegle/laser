// KBPlusApp.gsp.js
//
$(document).ready(function() {
  console.log("${message(code:'default.locale.label')}");
  console.log(gspLocale);
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.emptytext = 'Edit';
  $.fn.datepicker.defaults.language = gspLocale;
  
  $('.xEditable').editable({
    language: gspLocale,
    datepicker: {
      language: gspLocale
    },
    format: gspDateFormat,
  });

  $('.xEditableValue').editable({
    language: gspLocale,
    datepicker: {
      language: gspLocale
    },
    format: gspDateFormat,
  });
  $(".xEditableManyToOne").editable();
  $(".simpleHiddenRefdata").editable({
    language: gspLocale,
    datepicker: {
      language: gspLocale
    },
    format: gspDateFormat,
    url: function(params) {
      var hidden_field_id = $(this).data('hidden-id');
      $("#"+hidden_field_id).val(params.value);
      // Element has a data-hidden-id which is the hidden form property that should be set to the appropriate value
    }
  });
  
  $(".simpleReferenceTypedown").select2({
    placeholder: "Search for...",
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "<g:createLink controller='ajax' action='lookup'/>",
      dataType: 'json',
      data: function (term, page) {
          return {
              format:'json',
              q: term,
              baseClass:$(this).data('domain')
          };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    }
  });

  $('.dlpopover').popover({html:true,
                          placement:'left',
                          title:'search', 
                          trigger:'click', 
    template: 
'<div class="popover" style="width: 600px;"><div></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"></div></div></div>',
                          'max-width':600, 
                          content:function() {
                          return getContent();}
  });


  semanticUiStuff()

});

function getContent() {
    return $.ajax({
        type: "GET",
        url: "<g:createLink controller='spotlight' action='index'/>",
        cache: false,
        async: false
    }).responseText;
}

function semanticUiStuff() {

    // close semui:messages alerts
    $(".close.icon").click(function(){
        $(this).parent().hide();
    });
}


