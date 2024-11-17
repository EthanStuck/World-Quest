extends Node
''' This globally stores whether the player has completed each area 
	and whether they currently have each fragment '''

var west_fragment = false # if west fragment is held by player
var west_complete = false # if west area content is complete
var west_added = false # if west fragment is added to statue

var east_fragment = false # if east fragment is held by player
var east_complete = false # if east area content is complete
var east_added = false # if east fragment is added to statue
var east_opened = false # if gates have been opened

var north_fragment = false # if north fragment is held by player
var north_complete = false # if north area content is complete
var north_added = false # if north fragment is added to statue

var south_fragment = false # if south fragment is held by player
var south_complete = false # if south area content is complete
var south_added = false # if south fragment is added to statue

var game_complete = false # if game is complete

var num_carrots = 0
var sword_pickup = false # if player picked up sword
var bucket_collected = false # if player picked up bucket
var rod_pickup = false # if player picked up fishing rod
var water_amount = 0


var at : String # stores where player is coming from
