/* credits: t3, fl0wer */
#include <amxmodx>
#include <reapi>

new const PLUGIN_NAME[] = "[ReAPI] Refill Ammo on Kill";
new const PLUGIN_VERSION[] = "0.0.2";

new cvar_refill_ammo_type,
	cvar_refill_access_flag[5],
	cvar_refill_only_headshot;

public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, "steelzzz");
	RegisterHookChain(RG_CBasePlayer_Killed, "CPlayer_Killed_Post", .post = true);

	RegisterCvars();
}

static RegisterCvars()
{
	bind_pcvar_num(create_cvar("refill_ammo_type", "1",
	 .description = "Тип пополнения патрон\n\
	 	 0 - Clip\n\
	 	 1 - BpAmmo\n\
	 	 2 - Clip + BpAmmo",
	 .has_min = true, .min_val = 0.0,
	 .has_max = true, .max_val = 2.0), 
	cvar_refill_ammo_type);

	bind_pcvar_string(create_cvar("refill_ammo_access_flag", "a",
	 .description = "Флаг доступа"), 
	cvar_refill_access_flag, charsmax(cvar_refill_access_flag));

	bind_pcvar_num(create_cvar("refill_ammo_only_headshot", "0",
	 .description = "Пополнить патроны только при убийстве в голову\n\
	 	 0 - Выкл\n\
	 	 1 - Вкл",
	 .has_min = true, .min_val = 0.0,
	 .has_max = true, .max_val = 1.0), 
	cvar_refill_only_headshot);	
	
	AutoExecConfig(true, "refill_ammo_on_kill");	
}

public CPlayer_Killed_Post(iVictim, iAttacker, iGib)
{
	if(!is_user_connected(iAttacker) || iVictim == iAttacker)
	{
		return;
	}

	if(cvar_refill_only_headshot)
	{
		if(!get_member(iVictim, m_bHeadshotKilled))
		{
			return;
		}
	}

	if(cvar_refill_access_flag[0])
	{
		new iFlag = read_flags(cvar_refill_access_flag);

		if((get_user_flags(iAttacker) & iFlag) != iFlag)
		{
			return;
		}
	}

	new iActiveItem = get_member(iAttacker, m_pActiveItem);

	if(is_nullent(iActiveItem))
	{
		return;
	}

	if(rg_get_iteminfo(iActiveItem, ItemInfo_iMaxClip) == -1)
	{
		return;
	}

	switch(cvar_refill_ammo_type)
	{
		case 0: { RequestFrame("refillWeaponClip", iActiveItem); }
		case 1: { rg_instant_reload_weapons(iAttacker, iActiveItem); }
		case 2:
		{
			rg_instant_reload_weapons(iAttacker, iActiveItem);
			RequestFrame("refillWeaponClip", iActiveItem);
		}
	}
}

public refillWeaponClip(iActiveItem)
{
	if(!is_nullent(iActiveItem))
	{
		set_member(iActiveItem, m_Weapon_iClip, rg_get_iteminfo(iActiveItem, ItemInfo_iMaxClip));
	}
}