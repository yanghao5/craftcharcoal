name                        = "Craft Charcoal (木炭工艺)"
description                 = "You can use this machine to make coal!"
author                      = "Yang Hao"
version                     = "1.0.0"
forumthread                 = ""
api_version					= 10
dst_compatible 				= true
client_only_mod 			= false
all_clients_require_mod 	= true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
		name = "config_fuel_max",
		label = "Fuel Max",
		options =	{
            {description = "200", data = 200},
            {description = "400", data = 400},
			{description = "800 (default)", data = 800},
			{description = "1600", data = 1600},
            {description = "3200", data = 3200},
		},
		default = 800,
	},
    {
		name = "config_spawn_time",
		label = "Spawn Rate",
		options =	{
            {description = "slow", data = 8},
			{description = "default", data = 4},
			{description = "fast", data = 2},
			{description = "crazy", data = 2}
		},
		default = 4,
	},
    {
		name = "config_recipe",
		label = "Recipe",
		options =	{
            {description = "Easy", data = 1},
			{description = "Hard", data = 2},
		},
		default = 1,
	}
}