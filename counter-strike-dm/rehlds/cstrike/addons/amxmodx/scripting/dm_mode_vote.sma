#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

enum _:TASKS 
{
	TASK_VOTE_INIT = 1445,
	TASK_VOTE_TIME,
	TASK_VOTE_COUNTDOWN
};

enum _:MODES
{
	NORMAL = 0,
	HEAD
};

#define get_percent(%1,%2) ( ( %1 ) * 100 ) / ( %1 + %2 )

#define SERVER_TAG " DM VOTE "

new g_iMaxPlayers, g_iOnlyHead, g_iVoteTime, g_iVoteCountdown = 7;

new cvar_votetime, cvar_blockknife_dmg, cvar_voteinit_time;

new g_vote[ 2 ], g_hasvoted[ 33 ];

new const sound_countdown[ ][ ] = {
	"misc/one.wav",
	"misc/two.wav",
	"misc/three.wav",
	"misc/four.wav",
	"misc/five.wav"
};

public plugin_precache( )
{
	for( new i = 0; i < sizeof sound_countdown; i++ )
		precache_sound( sound_countdown[ i ] );
}

public plugin_init( )
{
	register_plugin( "DeatMatch Mod's Vote", "v1.0", "Neeeeeeeeeel.-" );
	
	register_dictionary( "dm_vote.txt" );
	
	cvar_votetime = register_cvar( "dm_vote_time", "15" );
	
	cvar_blockknife_dmg = register_cvar( "dm_block_knife_dmg", "1" );
	
	cvar_voteinit_time = register_cvar( "dm_voteinit_time", "40" );
	
	RegisterHam( Ham_TraceAttack, "player", "fw_TraceAttack" );
    
	g_iMaxPlayers = get_maxplayers( );
	
	set_task( get_pcvar_float( cvar_voteinit_time ), "show_vote", TASK_VOTE_INIT );
}

public client_putinserver( id )
	g_hasvoted[ id ] = 0;

public show_vote( )
{
	if( g_iVoteCountdown == 7 )
	{
		g_iVoteCountdown--;
		set_task( 1.0, "show_vote", TASK_VOTE_COUNTDOWN, _, _, "b" );
		
		return PLUGIN_HANDLED;
	}
	
	else if( g_iVoteCountdown )
	{
		set_hudmessage( 85, 255, 0, -1.0, 0.09, 1, 6.0, 1.0 );
		
		if( g_iVoteCountdown != 1 )
		{
			for( new i = 1; i <= g_iMaxPlayers; i++ )
			{
				if( is_user_connected( i ) )
					show_hudmessage( i, "%L", i, "VOTE_STARTS_IN", g_iVoteCountdown - 1 )
			}
			
			PlaySound( g_iVoteCountdown - 2 );
			
			g_iVoteCountdown--;
			
			return PLUGIN_HANDLED;
		}			
		
		else
		{
			for( new i = 1; i <= g_iMaxPlayers; i++ )
			{
				if( is_user_connected( i ) )
					show_hudmessage( i, "%L", i, "VOTE_STARTING" )
			}
		}
	}
	
	remove_task( TASK_VOTE_COUNTDOWN );
	
	g_iVoteTime = get_pcvar_num( cvar_votetime );
	
	set_task( 1.0, "time_vote", TASK_VOTE_TIME, _, _, "b" );
	
	for( new i = 1; i <= g_iMaxPlayers; i++ )
	{
		if( is_user_connected( i ) )
			show_menu_vote( i );
	}
	
	return PLUGIN_HANDLED;
}

public time_vote( )
{
	if( !g_iVoteTime )
	{
		remove_task( TASK_VOTE_TIME );
		
		finish_vote( );
		
		return PLUGIN_HANDLED;
	}
	
	set_hudmessage( 85, 255, 0, -1.0, 0.09, 1, 6.0, 1.0 );
	
	for( new i = 1; i <= g_iMaxPlayers; i++ )
	{
		if( is_user_connected( i ) )
			show_hudmessage( i, "%L", i, "VOTE_FINISHS_IN", g_iVoteTime );
	}
	
	g_iVoteTime--;
	
	return PLUGIN_HANDLED;
}

public finish_vote( )
{
	new result = g_vote[ HEAD ] == g_vote[ NORMAL ] ? 0 : 1;
	
	for( new i = 1; i <= g_iMaxPlayers; i++ )
	{
		if( is_user_connected( i ) )
		{
			if( !result )
				ChatColor( i, "!g[%s] %L", SERVER_TAG, i, "VOTE_NOWINNER" );
			
			else
			{
				ChatColor( i, "!g[%s] %L", SERVER_TAG, i, "VOTE_FINISH", ( g_vote[ HEAD ] + g_vote[ NORMAL ] ) > 0 ? get_percent( g_vote[ HEAD ], g_vote[ NORMAL ] ) : 0, ( g_vote[ HEAD ] + g_vote[ NORMAL ] ) > 0 ? get_percent( g_vote[ NORMAL ], g_vote[ HEAD ] ) : 0 );	
				ChatColor( i, "!g[%s] %L", SERVER_TAG, i, "VOTE_RESULT", g_vote [ HEAD ] > g_vote[ NORMAL ] ? "ХедШот" : "Нормальный" );
			}
		}
	}
	
	g_iOnlyHead = g_vote[ HEAD ] > g_vote[ NORMAL ] ? true : false; 
		
	set_cvar_num( "sv_restart", 1 );
}

public PlaySound( sound )
	client_cmd( 0, "spk ^"%s^"", sound_countdown[ sound ] );
	
public show_menu_vote( id )
{
	new data[ 64 ];
	formatex( data, charsmax( data ), "%L", id, "VOTE_MENU_TITLE" );
	
	new Menu = menu_create( data, "menu_vote" );
	
	formatex( data, charsmax( data ), "Нормальный \r[\y%d%%\r]", ( g_vote[ HEAD ] + g_vote[ NORMAL ] ) > 0 ? get_percent( g_vote[ NORMAL ], g_vote[ HEAD ] ) : 0 );
	menu_additem( Menu, data, "1" );
	
	formatex( data, charsmax( data ), "ХедШот \r[\y%d%%\r]", ( g_vote[ HEAD ] + g_vote[ NORMAL ] ) > 0 ? get_percent( g_vote[ HEAD ], g_vote[ NORMAL ] ) : 0 );
	menu_additem( Menu, data, "2" );
	
	menu_setprop( Menu, MPROP_EXIT, MEXIT_NEVER );
	
	menu_display( id, Menu );
}

public menu_vote( id, Menu, item )
{
	if( g_hasvoted[ id ] )
		return PLUGIN_HANDLED;
	
	new uName[ 33 ];
	get_user_name( id, uName, charsmax( uName ) );
	
	if( item > 1 ) //bugfix
		item = 0;
	
	g_vote[ item ]++;
	
	ChatColor( 0, "!g[%s] %L", SERVER_TAG, id, "VOTE_HAS_CHOOSEN", uName, !item ? "Нормальный" : "ХедШот" );
	
	for( new i = 1; i <= g_iMaxPlayers; i++ )
	{
		if( is_user_connected( i ) )
			show_menu_vote( i );
	}
	
	g_hasvoted[ id ] = true;
	
	return PLUGIN_HANDLED;
}
	
public fw_TraceAttack( victim, attacker, Float:damage, Float:direction[3], trace, damageBits )
{
	if( get_user_weapon( attacker ) == CSW_KNIFE && get_pcvar_num( cvar_blockknife_dmg ) )
		return HAM_SUPERCEDE;
	
	else if( g_iOnlyHead && victim != attacker && ( 1 <= attacker <= g_iMaxPlayers ) && get_tr2( trace, 9/*TR_iHitGroup*/ ) != HIT_HEAD )
	{
		set_tr2( trace, TR_flFraction, 1.0 );
		return HAM_SUPERCEDE;
	}

	return HAM_IGNORED;
}

stock ChatColor( const id, const input[ ], any:... )
{
	new count = 1, players[ 32 ];
	static msg[ 191 ];
	vformat( msg, 190, input, 3 );
	
	replace_all( msg, 190, "!g", "^4" );
	replace_all( msg, 190, "!y", "^1" );
	replace_all( msg, 190, "!team", "^3" );
	replace_all( msg, 190, "!team2", "^0" );
	
	if( id )
		players[ 0 ] = id; 
	else
		get_players( players, count, "ch" );
		
	for( new i = 0; i < count; i++ )
	{
		if( is_user_connected( players[ i ] ) )
		{
			message_begin( MSG_ONE_UNRELIABLE, get_user_msgid( "SayText" ), _, players[ i ] )
			write_byte( players[ i ] );
			write_string( msg );
			message_end( );
		}
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang11274\\ f0\\ fs16 \n\\ par }
*/
