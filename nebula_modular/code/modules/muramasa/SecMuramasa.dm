/obj/item/melee/SecMuramasa
	name = "Security Muramasa"
	desc = "Does security need a makeover? Does she need better things to take down raging mobs and People who look like they've got bird poop on their head? So we know very well what security needs! Here it is, SECMuramasa"
	icon_state = "muramasa"
	inhand_icon_state = "muramasa"
	worn_icon_state = "muramasa"
	icon = 'nebula_modular/icons/obj/muramasa/SeMuramasa(icone_1).dmi'
	lefthand_file = 'nebula_modular/icons/obj/muramasa/SeMuramasa(Segurando_Esquerdo_1).dmi'
	righthand_file = 'nebula_modular/icons/obj/muramasa/SeMuramasa(Segurando_Direita_1).dmi'
	force = 30
	throwforce = 30
	block_chance = 70
	armour_penetration = 55
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	max_integrity = 1000
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/melee/SecMuramasa/get_belt_overlay()
	return . += mutable_appearance('nebula_modular/icons/obj/muramasa/SeMuramasa(Cinto_1).dmi', "muramasa")

/obj/item/melee/SecMuramasa/attack(mob/living/victim, obj/katana, params)
	var/list/modifiers = params2list(params)
	if(modifiers[LEFT_CLICK])
		victim.StaminaKnockdown(10)
		attack_verb_continuous = list ("Knocks","Attacks","Knockdown" )
		attack_verb_simple = list ("Knock","Attack","Knock")
		hitsound = 'sound/effects/woodhit.ogg'
	else if(modifiers[RIGHT_CLICK])
		..()
