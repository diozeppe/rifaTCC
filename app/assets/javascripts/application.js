// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.mask
//= require jquery-ui
//= require jquery-ui/i18n/datepicker-pt-BR
//= require Chart.min
//= require dropzone
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require cable

$.jMaskGlobals.watchDataMask = true;

var raffleImages;

$(document).on('turbolinks:load', function(){

  setAlertbehaviour();
  attachNavbarFixedTopBehaviour();
  attachFooterFixedBottomBehaviour();
  attachRaffleFilesBeforeSubmit();
  attachFormValidationReturn();
  doDisableFrom();
  doInputFormating();
  doTicketInitialization();
  doChartInitialization();
  doDropZoneInitialization();

});

function urltoFile(url, filename, mimeType){
  return (fetch(url)
    .then(function(res){return res.arrayBuffer();})
    .then(function(buf){return new File([buf], filename,{type:mimeType});})
    );
  }

function setAlertbehaviour(){
    $(".alert").delay(2000).slideUp(500, function(){
    $(".alert").alert('close');
  });
}

function attachFormValidationReturn(){
    $("form.has-validation-return").bind("ajax:error", function(data){
    var objResponse = data.detail[0];
    doInputErrorMessages(objResponse.model, objResponse.error);
  });
}

function attachNavbarFixedTopBehaviour(){
  window.addEventListener('scroll', function() {
      if (window.scrollY > navbar_height) {
        document.getElementById('navbar').classList.add('fixed-top');
        document.getElementById('navbar').classList.remove('navbar-initial');
        navbar_height = document.querySelector('.navbar').offsetHeight;
        document.body.style.paddingTop = navbar_height + 'px';
      } else {
        document.getElementById('navbar').classList.remove('fixed-top');
        document.getElementById('navbar').classList.add('navbar-initial');
        document.body.style.paddingTop = '0';
      } 
  });
}

function attachFooterFixedBottomBehaviour(){
  var hasVScroll = document.body.scrollHeight > document.body.clientHeight;

  if (!hasVScroll) {
    $('#footer').addClass('fixed-bottom');
  }
}

function attachRaffleFilesBeforeSubmit(){
  $('#newRaffleForm').submit(function(e){
    e.preventDefault();
    e.stopPropagation();

    var formData = new FormData ($('#newRaffleForm')[0]);

    raffleImages.getAcceptedFiles().forEach(function(e,i){
       formData.append('images['+i+']', e);
    });

    $.ajax({
        type: 'POST',
        url: $('#newRaffleForm').attr('action'),
        data: formData ,
        processData: false,
        contentType: false,

        error: function (response, error) {
          var objResponse = response.responseJSON;
          doInputErrorMessages(objResponse.model, objResponse.error);
        }
    });
  });

}


function doDropZoneInitialization() {
  if ($('#raffleImages').length) {
  Dropzone.options.raffleImages = {
    paramName: "images",
    maxFiles: 5,
    maxFilesize: 2,
    acceptedFiles: 'image/*',
    enctype: "multipart/form-data",
    addRemoveLinks: true,
    uploadMultiple: true,
    autoProcessQueue: false,
    autoDiscovery: false,


    dictDefaultMessage: "Arraste arquivos aqui para enviar",
    dictFallbackMessage: "Seu navegador não suporta a função de arrastar arquivos",
    dictFallbackText: "Use o link acima para enviar arquivos",
    dictFileTooBig: "Arquivo muito grande ({{filesize}}MiB). Tamanho máximo: {{maxFilesize}}MiB.",
    dictInvalidFileType: "Formato do arquivo é invalido",
    dictResponseError: "Erro ao enviar arquivo",
    dictCancelUpload: "Cancelar envio",
    dictUploadCanceled: "Envio cancelado",
    dictCancelUploadConfirmation: "Tem certeza que deseja cancelar o envio?",
    dictRemoveFile: "Remover arquivo",
    dictRemoveFileConfirmation: null,
    dictMaxFilesExceeded: "Limite máximo de arquivos atingido"
  };

  var form = $("form#newRaffleForm");

  $("div#raffleImages").addClass('dropzone');
  raffleImages = new Dropzone("div#raffleImages", { url: form.attr('action') });  
}
}

function addTicketOnHold(id){
  e = document.querySelectorAll('[data-id="' + id + '"]')[0];
  e.classList.remove ('ticket-open');
  e.classList.add ('ticket-on-hold');
  e.setAttribute('data-selected', true);
}

function addTicketOpen(id){
  e = document.querySelectorAll('[data-id="' + id + '"]')[0];
  e.classList.remove ('ticket-on-hold');
  e.classList.add ('ticket-open');
  e.setAttribute('data-selected', false);
}

function setSelectedArray(strArr){
    sessionStorage.setItem('selected_tickets' + $('#session_id').val(), strArr);
  }

function getSelectedArray(){
  try{
      var selected = sessionStorage.getItem('selected_tickets' + $('#session_id').val(), '').split(';');
  }catch (e){
      var selected = [];
  }

  return selected;
}

function setSelectedTickets(){
  var selected = getSelectedArray();
  for(var i = 0; i < selected.length; i++){$('[data-id="' + selected[i] + '"]').each(function(){addTicketOnHold(this.getAttribute('data-id'))})}
}

function showSelectedTickets(){
    var selected = getSelectedArray();

    $('#selected_tickets_list').html("");

    for(var i = 0; i < selected.length; i++){
       if (selected[i] != '') {
        $('#selected_tickets_list').html(document.getElementById('selected_tickets_list').innerHTML + '<div class="ticket ticket-on-hold" data-id="'+ selected[i] +'" onclick="removeTicketFromList('+selected[i]+');addTicketOpen('+selected[i]+');"><div class="ticket-number text-center">' + selected[i] + '</div></div>');
       }
    }
}

function addTicketToList(id){
  var selected = getSelectedArray();
  e = document.querySelectorAll('[data-id="' + id + '"]')[0];
  selected.push(e.getAttribute('data-id'));
  for(var i = 0; i < selected.length; i++){if (selected[i] == ''){selected.splice(i, 1);}}
  setSelectedArray(selected.join(';'));
  $('#selected_tickets_hidden').val(selected.join(';'));
  showSelectedTickets();
  calculateFinalPrice();
}

function removeTicketFromList(id){
  var selected = getSelectedArray();
  e = document.querySelectorAll('[data-id="' + id + '"]')[0];
  for(var i = 0; i < selected.length; i++){if (selected[i] === e.getAttribute('data-id')){selected.splice(i, 1);}}
    for(var i = 0; i < selected.length; i++){if (selected[i] == ''){selected.splice(i, 1);}}
  setSelectedArray(selected.join(';'));
  $('#selected_tickets_hidden').val(selected.join(';'));
  showSelectedTickets();
  calculateFinalPrice();
}

function calculateFinalPrice(){
  var unitValue = parseFloat($('#unit_value').val());
  var tickets = getSelectedArray().length
  $('#final_value').html('R$ '  + (unitValue *  tickets).toFixed(2).replace(/\./g, ','));
}

function doTicketInitialization(){
  if ($('#selected_tickets_hidden').length > 0) {
  $("form.has-error-feedback").bind("ajax:error", function(data){
    var objResponse = data.detail[0];

    if (objResponse.newTicketList) {
      $('#selected_tickets_hidden').val(objResponse.newTicketList);
      setSelectedArray(objResponse.newTicketList);
      showSelectedTickets();
      calculateFinalPrice();
      $('#error_message').html('Os números: ' + objResponse.alreadyTaken + ' já foram reservados ou comprados e foram removidos da lista');
    }

    if (objResponse.error) {
     $('#error_message').html(objResponse.error); 
    }
  });


  var selected = getSelectedArray();

  $('#selected_tickets_hidden').val(selected.join(';'));

  setSelectedTickets();
  showSelectedTickets();
  calculateFinalPrice();

  $('.ticket').click(function(e){
    var selected = getSelectedArray();

    if (this.classList.contains('ticket-open')) {
      addTicketOnHold(this.getAttribute('data-id'));
      addTicketToList(this.getAttribute('data-id'));
    }else{
      addTicketOpen(this.getAttribute('data-id'));
      removeTicketFromList(this.getAttribute('data-id'));
    }
  });

}
}

function doInputFormating(){
  $('.currency').mask('#.##0,00', {reverse: true});
  $('.datepicker').datepicker();
}

function doDisableFrom(){
  $("div.disabled").find("input.form-control").prop("disabled", true);
  $("div.disabled").find("textarea.form-control").prop("disabled", true);
  $("div.disabled").find("select").prop("disabled", true);
}

function doInputErrorMessages(model, errors_json) {
  $('.is-invalid').removeClass('is-invalid');
  $('.invalid-feedback').html('');

  Object.keys(errors_json).forEach(function(key) {
    if (model != '') {
      document.getElementsByName(model + '[' + key + ']')[0].className += ' is-invalid';
    }else{
      document.getElementsByName(key)[0].className += ' is-invalid';
    }
    $('#' + key + '_feedback').html(errors_json[key].join(','));
  })
}


//
// Chart JS Helpers
//
function doChartInitialization(){
  $('.raffleProgessChart').each(function(e){
    var ctxP = this;
    var myPieChart = new Chart(ctxP, {
      type: 'doughnut',
      data: {
        labels: ["Vendidos", "Em Aberto"],
        datasets: [{
          data: [this.getAttribute('data-tickets-sold'), this.getAttribute('data-tickets-open')],
          backgroundColor: ["#fed18c", "#fe664f"],
          hoverBackgroundColor: ["#ffa926", "#ff3112"]
        }]
      },
      options: {
        responsive: true
      }
    });  
  });

  $('#soldChart').each(function(e){
    $.get('get_sales', function(data){
      var chart = new Chart($('#soldChart'), data);
    });
  });

  $('#userRegistrationChart').each(function(e){
    $.get('get_user_registrations', function(data){
      var chart = new Chart($('#userRegistrationChart'), data);
    });
  });

  $('#institutionRegistrationChart').each(function(e){
    $.get('get_institution_registrations', function(data){
      var chart = new Chart($('#institutionRegistrationChart'), data);
    });
  });

  $('#newRafflesChart').each(function(e){
    $.get('get_new_raffles', function(data){
      var chart = new Chart($('#newRafflesChart'), data);
    });
  });

  $('#revenueChart').each(function(e){
    $.get('get_revenue', function(data){
      var chart = new Chart($('#revenueChart'), data);
    });
  });
  
}