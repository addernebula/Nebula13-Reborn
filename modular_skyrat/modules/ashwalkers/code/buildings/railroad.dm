/obj/item/stack/rail_track
	name = "railroad tracks"
	singular_name = "railroad track"
	desc = "A primitive form of transportation. Place on any floor to start building a railroad."
	icon = 'modular_skyrat/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "rail_item"
	merge_type = /obj/item/stack/rail_track

/obj/item/stack/rail_track/ten
	amount = 10

/obj/item/stack/rail_track/fifty
	amount = 50

/obj/item/stack/rail_track/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isopenturf(target) || !proximity_flag)
		return ..()
	var/turf/target_turf = get_turf(target)
	var/obj/structure/railroad/check_rail = locate() in target_turf
	if(check_rail || !use(1))
		return ..()
	to_chat(user, span_notice("You place [src] on [target_turf]."))
	new /obj/structure/railroad(get_turf(target))

/obj/structure/railroad
	name = "railroad track"
	desc = "A primitive form of transportation. You may see some rail carts on it."
	icon = 'modular_skyrat/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "rail"
	anchored = TRUE

/obj/structure/railroad/Initialize(mapload)
	. = ..()
	for(var/obj/structure/railroad/rail in range(1))
		addtimer(CALLBACK(rail, /atom/proc/update_appearance), 5)

/obj/structure/railroad/Destroy()
	. = ..()
	for(var/obj/structure/railroad/rail in range(1))
		if(rail == src)
			continue
		addtimer(CALLBACK(rail, /atom/proc/update_appearance), 5)

/obj/structure/railroad/update_appearance(updates)
	icon_state = "rail"
	var/turf/src_turf = get_turf(src)
	for(var/direction in GLOB.cardinals)
		var/obj/structure/railroad/locate_rail = locate() in get_step(src_turf, direction)
		if(!locate_rail)
			continue
		icon_state = "[icon_state][direction]"
	return ..()

/obj/structure/railroad/crowbar_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	if(!do_after(user, 2 SECONDS, src))
		return
	tool.play_tool_sound(src)
	new /obj/item/stack/rail_track(get_turf(src))
	qdel(src)

/obj/vehicle/ridden/rail_cart
	name = "rail cart"
	desc = "A wonderful form of locomotion. It will only ride while on tracks. It does have storage"
	icon = 'modular_skyrat/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "railcart"
	/// The mutable appearance used for the overlay over buckled mobs.
	var/mutable_appearance/railoverlay

/obj/vehicle/ridden/rail_cart/examine(mob/user)
	. = ..()
	. += span_notice("<br><b>Alt-Click</b> to attach a rail cart to this cart.")

/obj/vehicle/ridden/rail_cart/Initialize(mapload)
	. = ..()
	attach_trailer()
	railoverlay = mutable_appearance(icon, "railoverlay")
	railoverlay.layer = ABOVE_MOB_LAYER
	railoverlay.plane = GAME_PLANE_UPPER
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/rail_cart)
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/added_storage = GetComponent(/datum/component/storage)
	added_storage.max_combined_w_class = 21
	added_storage.max_w_class = WEIGHT_CLASS_NORMAL
	added_storage.max_items = 21

/obj/vehicle/ridden/rail_cart/post_buckle_mob(mob/living/M)
	. = ..()
	update_overlays()

/obj/vehicle/ridden/rail_cart/post_unbuckle_mob(mob/living/M)
	. = ..()
	update_overlays()

/obj/vehicle/ridden/rail_cart/update_overlays()
	. = ..()
	if(has_buckled_mobs())
		add_overlay(railoverlay)
	else
		cut_overlay(railoverlay)

/obj/vehicle/ridden/rail_cart/relaymove(mob/living/user, direction)
	var/obj/structure/railroad/locate_rail = locate() in get_step(src, direction)
	if(!canmove || !locate_rail)
		return FALSE
	if(is_driver(user))
		return relaydrive(user, direction)
	return FALSE

/obj/vehicle/ridden/rail_cart/AltClick(mob/user)
	. = ..()
	attach_trailer()

/obj/vehicle/ridden/rail_cart/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/datum/component/storage/rail_storage = GetComponent(/datum/component/storage)
	rail_storage.open_storage(user)

/// searches the cardinal directions to add this cart to another cart's trailer
/obj/vehicle/ridden/rail_cart/proc/attach_trailer()
	if(trailer)
		remove_trailer()
		return
	for(var/direction in GLOB.cardinals)
		var/obj/vehicle/ridden/rail_cart/locate_cart = locate() in get_step(src, direction)
		if(!locate_cart || locate_cart.trailer == src)
			continue
		add_trailer(locate_cart)
		break

/datum/component/riding/vehicle/rail_cart
	vehicle_move_delay = 0.5
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/rail_cart/handle_specials()
	. = ..()
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 13), TEXT_SOUTH = list(0, 13), TEXT_EAST = list(0, 13), TEXT_WEST = list(0, 13)))
	set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
	set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	set_vehicle_dir_layer(EAST, OBJ_LAYER)
	set_vehicle_dir_layer(WEST, OBJ_LAYER)
