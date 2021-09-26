/obj/item/storage/belt/SecMuramasa
	name = "Security Muramasa Belt"
	desc = "The Sheath that holds the pride of the security team!"
	icon = 'nebula_modular/icons/obj/muramasa/SeMuramasa(Icone_3).dmi'
	icon_state = "muramasa"
	worn_icon = 'nebula_modular/icons/obj/muramasa/SeMuramasa(Cinto_2).dmi'
	worn_icon_state = "muramasa"

/obj/item/storage/belt/SecMuramasa/PopulateContents()
    new /obj/item/melee/SecMuramasa(src)
    update_icon()

/obj/item/storage/belt/SecMuramasa/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(/obj/item/melee/SecMuramasa))
