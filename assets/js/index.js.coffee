globalDT = undefined
RaidDatatables =
  init: ->
    globalDT = $('#raid_table').DataTable({
      ajax: {
        url: "/api/load_raid_servers",
        dataSrc: (data) ->
          console.log data
          return data
        error: (xhr, error, thrown) ->
          console.log xhr.responseJSON
      },
      columns: [
        {
          orderable: false,
          data: null,
          defaultContent: '',
        },
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
          return row.password
        , className: 'text-center'}
      ],
      autoWidth: true,
      info: false,
      bPaginate: true,
      pageLength: 50
      "language": {
        "emptyTable": "No data available"
      },
      order: [[ 1, "desc" ]],
      drawCallback: ->
        api = @api()
        $.each api.rows(page: 'current').data(), (i, data) ->
          console.log i
          console.log data
          $("table#raid_table > tbody > tr:eq(#{i}) td:eq(0)")
            .addClass("details-control")
            .html("<i class='fa fa-plus text-center expand-icon' aria-hidden='true'></i>")
    })
  showDetails: ->
    $('#raid_table tbody').on 'click', 'td.details-control', ->
      tr = $(this).closest('tr')
      row = globalDT.row(tr)
      if row.child.isShown()
        row.child.hide()
        tr.removeClass 'shown'
        tr.find('td.details-control').html("<i class='fa fa-plus expand-icon' aria-hidden='true'></i>")
      else
        row.child(format(row.data())).show()
        tr.addClass 'shown'
        tr.find('td.details-control').html("<i class='fa fa-minus expand-icon' aria-hidden='true'></i>")
      return
  showDetectButton: ->
    $("#server-password").on "keyup", ->      
      if $("#server-password").val() != "" && $("#server-username").val() && $("#server-ip").val()
        console.log "hello"
        $(".show-button-raid").removeClass("hide_me")
      else
        $(".show-button-raid").addClass("hide_me")
  hideModal: ->
    $('#add-raid').on 'hidden.bs.modal', (e) ->
      $("#server-ip").val("")
      $("#server-username").val("")
      $("#server-password").val("")
      $("#server-name").val("")
      $(".show-button-raid").addClass("hide_me")
      $(".raidDetails")
        .addClass("hide_me")
        .text("")
      $(".raid-danzel").addClass("hide_me")
      $(".raid-hard").addClass("hide_me")
      return
  createRServer: ->
    $(".save-raid-s").on "click", ->
      console.log "hello"
      data = {}
      data.ip = $("#server-ip").val()
      data.username = $("#server-username").val()
      data.password = $("#server-password").val()
      data.name = $("#server-name").val()
      data.raid_type = $("#server_raid_type").val()
      data.raid_man = $("#server_raid_man").val()
      data.extra = {}
      data.extra.raid = $("#server_raid_full").val()

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
  getRAIDDetails: ->
    $(".churas-button").on "click", ->
      $(".am-progress").css 'display', 'block'
      $(".raid-hard").addClass("hide_me")
      $(".raid-danzel").addClass("hide_me")
      startBar()
      data = {}
      data.ip = $("#server-ip").val()
      data.username = $("#server-username").val()
      data.password = $("#server-password").val()

      settings = {
        cache: false,
        data: data,
        dataType: 'json',
        error: (jqXHR, status, error) ->
          console.log jqXHR.responseJSON.message
          $(".am-progress").css 'display', 'none'
          $(".raid-hard").addClass("hide_me")
          $(".raid-danzel").removeClass("hide_me")
          $(".part-block-raid").html(
            jqXHR.responseJSON.message
            )
        success: (data) ->
          $(".am-progress").css 'display', 'none'
          $(".raid-danzel").addClass("hide_me")
          $(".raid-hard").removeClass("hide_me")
          $(".raid-hardest").html(
            "Raid: Hardware </br> Controller: #{data.message}"
            )
          $("#server_raid_man").val(data.man)
          $("#server_raid_full").val(data.message)
          $(".save-raid-s").prop("disabled", false)
        contentType: "application/x-www-form-urlencoded",
        type: "POST",
        url: "/api/details_about_raid"
      };

      sendAJAXRequest(settings);

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
  globalDT.ajax.reload()
  console.log data

format = (data) ->
  if data
    return "
      <table class='table table-striped'>
        <tbody style='margin-left: 24px;'>
          <tr>
            <th style='background-color: #f1f1f1; font-size: 12px;'>Raid Mystery</th>
          </tr>
          <tr>
            <td>Raid Type</td>
            <td>Hardware</td>
          </tr>
          <tr>
            <td>Raid Info</td>
            <td>#{data.extra.raid}</td>
          </tr>
          <tr>
            <td>Raid Controller</td>
            <td>#{data.raid_man}</td>
          </tr>
        </tbody>
      </table>
    "
  else
    ""

startBar = ->
  $progress = $('.am-progress')
  $progressBar = $('.progress-bar')
  setTimeout (->
    $progressBar.css 'width', '10%'
    setTimeout (->
      $progressBar.css 'width', '20%'
      setTimeout (->
        $progressBar.css 'width', '30%'
        setTimeout (->
          $progressBar.css 'width', '40%'
          setTimeout (->
            $progressBar.css 'width', '50%'
            setTimeout (->
              $progressBar.css 'width', '60%'
              setTimeout (->
                $progressBar.css 'width', '70%'
                setTimeout (->
                  $progressBar.css 'width', '80%'
                  setTimeout (->
                    $progress.css 'display', 'none'
                  ), 500
                  return
                ), 500
                return
              ), 500
              return
            ), 500
            return
          ), 500
          return
        ), 500
        return
      ), 2000
      return
    ), 1000
    return
  ), 1000

module.exports =
  RaidDatatables: RaidDatatables
