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

module.exports =
  RaidDatatables: RaidDatatables
