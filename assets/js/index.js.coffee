RaidDatatables =
  init: ->
    $('#raid_table').DataTable({
      ajax: {
        url: "/api/load_raid_servers",
        dataSrc: (data) ->
          return data
        error: (xhr, error, thrown) ->
          console.log xhr.responseJSON
      },
      columns: [
        {data: ( row, type, set, meta ) ->
          return row.name
        , className: 'text-center'},
        {data: ( row, type, set, meta ) ->
          return row.ip
        , className: 'text-center'},
        {data: ( row, type, set, meta ) ->
          return row.username
        , className: 'text-center'},
        {data: ( row, type, set, meta ) ->
          return row.raid_type
        , className: 'text-center'},
        {data: ( row, type, set, meta ) ->
          return row.password
        , className: 'text-center'}
      ],
      autoWidth: false,
      info: false,
      bPaginate: true,
      pageLength: 50
      "language": {
        "emptyTable": "No data available"
      },
      order: [[ 1, "desc" ]],
    })
  showDetectButton: ->
    $("#server-password").on "keyup", ->      
      if $("#server-password").val() != "" && $("#server-username").val() && $("#server-ip").val()
        console.log "hello"
        $(".show-button-raid").removeClass("hide_me")
      else
        $(".show-button-raid").addClass("hide_me")
  hideModal: ->
    $('#add-raid').on 'hidden.bs.modal', (e) ->
      $(".raidDetails")
        .addClass("hide_me")
        .text("")
      return
  createRServer: ->
    $(".save-raid-s").on "click", ->
      console.log "hello"
      data = {}
      data.ip = $("server-ip").val()
      data.username = $("server-username").val()
      data.password = $("server-password").val()

      settings = {
        cache: false,
        data: data,
        dataType: 'json',
        error: onError,
        success: onSuccess,
        contentType: "application/x-www-form-urlencoded",
        type: "POST",
        url: "/api/create_raid"
      };

      sendAJAXRequest(settings);
  appendButton: ->
    $(".dataTables_length > label").hide()
    button = '<div href="#" class="btn btn-primary btn-cursor" data-toggle="modal" data-target="#add-raid">
        <i class="fa fa-plus"></i> Add Server
    </div>'
    $(".dataTables_length").append(button)


sendAJAXRequest = (settings) ->
  headers = undefined
  token = undefined
  xhrRequestChangeMonth = undefined
  token = $('meta[name="csrf-token"]')
  if token.length > 0
    headers = 'X-CSRF-Token': token.attr('content')
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)

onError = (jqXHR, status, error) ->
  # $(".body-raid-dis *").prop('disabled', true)
  cList = $('ul#errorRAID')
  $.each jqXHR.responseJSON.errors, (index, value) ->
    li = $('<li/>').text(value).appendTo(cList)
    return
  $(".raidDetails").removeClass("hide_me")

onSuccess = (data) ->
  console.log data

module.exports =
  RaidDatatables: RaidDatatables
