#include <amxmodx>
#include <engine>
#include <hamsandwich>

public plugin_init()
{
    register_plugin("Parachute", "1.0", "maeStro");
    RegisterHam(Ham_ObjectCaps, "player", "FwdHamObjectCaps");
}

public FwdHamObjectCaps(id)
{
    if (!is_user_alive(id)||get_entity_flags(id) & FL_ONGROUND) return;
    static Float:velocity[3];
    entity_get_vector(id, EV_VEC_velocity, velocity);
    if(velocity[2] < 0)
    {
        velocity[2] = (velocity[2] + 40.0 < -100) ? velocity[2] + 40.0 : -100.0;
        entity_set_vector(id, EV_VEC_velocity, velocity);
    }
}