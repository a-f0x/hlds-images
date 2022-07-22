#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta>

enum _:score
{
	frags,
	Float:dmg,
	hs
}

new niceP[33][score]

new hudsync

public plugin_init()
{
	register_plugin( "aga", "1.0", "Got Milk?")

	RegisterHam(Ham_TakeDamage, "player", "hook_TakeDamage")
	register_event("DeathMsg", "Event_DeathMessage", "a")
	register_logevent("event_round_end", 2, "1=Round_End")
	register_event("HLTV", "event_round_start", "a", "1=0", "2=0");

	hudsync = CreateHudSyncObj()
}

public event_round_end ()
{
	new Players[32], num, tmpf, Float:tmpd, tmpid
	get_players( Players, num )

	for( new i; i < 32; i++)
	{
		if ( niceP[i][frags] > tmpf )
		{
			tmpid = i
			tmpf = niceP[i][frags]
			tmpd = niceP[i][dmg]
		}
		else if ( niceP[i][frags] == tmpf && niceP[i][dmg] > tmpd)
		{
			tmpid = i
			tmpf = niceP[i][frags]
			tmpd = niceP[i][dmg]
		}
	}

	if ( tmpf > 0 )
	{
		new name[32], msg[1024];
		get_user_name(tmpid, name, 31);

		format( msg, charsmax(msg), "Best Player: %s^nKills: %d Damage: %d", name, tmpf, floatround(tmpd, floatround_round) )

		set_hudmessage(200, 100, 0, -1.0, 0.17, 0, 5.0)
		ShowSyncHudMsg(0, hudsync, msg)
	}
}

public hook_TakeDamage(Victim, inflictor, Attacker, Float:damage, damagebits)
{
	if( inflictor == Attacker )
		niceP[Attacker][dmg] += damage
	else
	{
		static classname[32]
		pev (inflictor, pev_classname, classname, 31)
		if( equal (classname, "grenade") )
			niceP[Attacker][dmg] += damage
	}

	if ( get_pdata_int(Victim, 75, 5) == HIT_HEAD )
		niceP[Attacker][hs]++

	return HAM_IGNORED
}

public Event_DeathMessage()
	niceP[read_data(1)][frags]++

public event_round_start ( ) 
	for (new i; i < 32; i++)
		for ( new j; j < 3; j++)
			niceP[i][j] = 0

public client_disconnect(id)
	for ( new j; j < 3; j++)
		niceP[id][j] = 0