Greet =
  greet: -> console.log("Hello!")

Bye =
  greet: -> console.log("Bye!")

RaidDatatables =
  init: ->
    $('#raid_table').DataTable()

module.exports =
  Greet: Greet
  Bye: Bye
  RaidDatatables: RaidDatatables
