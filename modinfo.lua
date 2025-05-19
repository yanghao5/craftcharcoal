name                        = "Craft Charcoal (木炭工艺)"
description                 = "You can use this machine to make coal!"
author                      = "Yang Hao"
version                     = "1.0.1"
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
            {description = "100", data = 100},
			{description = "150 (default)", data = 150},
			{description = "200", data = 200}
		},
		default = 150,
	},
    {
		name = "config_spawn_time",
		label = "Spawn Rate",
		options =	{
            {description = "slow", data = 8},
			{description = "default", data = 4},
			{description = "fast", data = 2},
			{description = "crazy", data = 1}
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