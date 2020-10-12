# Kyk-RedeemCodes
Simple FiveM resource for warning players.
This is my second public resource so it will probably be broken in some way. If you find any bugs/want to improve this resource you can either make a pull request/make a request in "Issues" or customise this resource to your liking. The code isn't the best either but it works for now.

If you do decide to make your own version of it then it would be nice if you credited me. Thanks and enjoy this resource.

***REQUIREMENTS***
- ES_EXTENDED (1.1.0 is prefered but it should work on most of the versions)
- ASYNC (https://github.com/esx-framework/async/releases) [ You Shoud Already have this ]
- MYSQL-ASYNC (https://github.com/brouznouf/fivem-mysql-async/releases) [ You Shoud Already have this ]

***Commands***
- /warn "target_player_id" "warn_reason_here" | Warns a specific player with a specific reason.
- /warns "targer_player_id" | Prints out all the warns that the target player has.
- /removewarn "target_player_id" "warn_id" | Removes a specified warn from a person.
- /clearwarns "targer_player_id" | Clears all warns for a specific player.

***Ace permissions if needed***
- Allow all admins to access /warn: add_ace group.admin "command.warn" allow
- Allow all admins to access /warns: add_ace group.admin "command.warns" allow
- Allow all admins to access /removewarn: add_ace group.admin "command.removewarn" allow
- Allow all admins to access /clearwarns: add_ace group.admin "command.clearwarns" allow