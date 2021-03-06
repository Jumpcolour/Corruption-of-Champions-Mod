package classes.Items 
{
	import classes.*;
	
	/**
	 * Helper class to get rid of the copy&paste-mess in classes.Items.Mutations
	 * @since July 8, 2016
	 * @author Stadler76
	 */
	public class MutationsHelper extends BaseContent 
	{
		include "../../../includes/appearanceDefs.as";

		// I tend to use bitfields rather than lots of optional boolean params.
		// If I consider a method to be finalized and has only one option I'll refactor this to use a boolean value.

		// restoreArms options
		public static const RESTOREARMS_FROMGOOSKINTF:int = 1;

		// restoreFeet options
		public static const RESTOREFEET_EXCLUDETAUR:int   =  1;
		public static const RESTOREFEET_EXCLUDEGOO:int    =  2;
		public static const RESTOREFEET_EXCLUDENAGA:int   =  4;
		public static const RESTOREFEET_EXCLUDEDRIDER:int =  8;
		public static const RESTOREFEET_FIXBIPED:int      = 16;

		public var changes:int = 0;
		public var changeLimit:int = 1;

		public function MutationsHelper() {}

		public function restoreArms(keepArms:Array = null, options:int = 0):Boolean
		{
			if (keepArms == null) keepArms = [];
			if (keepArms.indexOf(player.armType) >= 0) return false; // For future TFs. Tested and working, but I'm not using it so far (Stadler76)

			if (options & RESTOREARMS_FROMGOOSKINTF) {
				// skin just turned gooey. Now lets fix unusual arms.
				var hasClaws:Boolean = player.clawType != CLAW_TYPE_NORMAL;

				if (hasClaws || player.armType == ARM_TYPE_HARPY) outputText("\n\n");
				if (player.armType == ARM_TYPE_HARPY) {
					outputText("The feathers on your arms melt back into your now gooey skin.");
					if (hasClaws) outputText(" Additionally your ");
				} else if (hasClaws) outputText("Your ");

				if (hasClaws) outputText("now gooey claws melt back into your fingers. Well, who cares, gooey claws aren't very useful in combat to begin with.");
				if (hasClaws || player.armType == ARM_TYPE_HARPY) outputText("  <b>You have normal human arms again.</b>");

				player.clawType = CLAW_TYPE_NORMAL;
				player.clawTone = "";
				player.armType = ARM_TYPE_HUMAN;
				return true;
			}


			if (changes < changeLimit && player.armType != ARM_TYPE_HUMAN && rand(4) == 0) {
				if ([ARM_TYPE_HARPY, ARM_TYPE_SPIDER, ARM_TYPE_SALAMANDER].indexOf(player.armType) >= 0)
					outputText("\n\nYou scratch at your biceps absentmindedly, but no matter how much you scratch, it isn't getting rid of the itch.  Glancing down in irritation, you discover that");

				switch (player.armType) {
					case ARM_TYPE_HARPY:
						outputText(" your feathery arms are shedding their feathery coating.  The wing-like shape your arms once had is gone in a matter of moments, leaving " + player.skinFurScales() + " behind.");
						break;

					case ARM_TYPE_SPIDER:
						outputText(" your arms' chitinous covering is flaking away.  The glossy black coating is soon gone, leaving " + player.skinFurScales() + " behind.");
						break;

					case ARM_TYPE_SALAMANDER:
						outputText(" your once scaly arms are shedding their scales and that your claws become normal human fingernails again.");
						break;

					case ARM_TYPE_PREDATOR:
						switch (player.skinType) {
							case SKIN_TYPE_GOO:
								if (player.clawType != CLAW_TYPE_NORMAL)
									outputText("\n\nYour gooey claws melt into your fingers. Well, who cares, gooey claws aren't very useful in combat to begin with.");
									//Gooey claws? Really?!? I'll take a look at goo TF later ...
								break;

							case SKIN_TYPE_PLAIN:
							case SKIN_TYPE_FUR:
							case SKIN_TYPE_SCALES:
								outputText("\n\nYou feel a sudden tingle in your " + player.claws() + " and then you realize, that they have become normal human fingernails again.");
								break;
						}
						break;

					default:
						outputText(" your unusual arms change more and more until they are normal human arms, leaving " + player.skinFurScales() + " behind.");
				}
				outputText("  <b>You have normal human arms again.</b>");
				player.clawType = CLAW_TYPE_NORMAL;
				player.clawTone = "";
				player.armType = ARM_TYPE_HUMAN;
				changes++;
				return true;
			}

			return false;
		}

		public function restoreFeet(keepFeet:Array = null, options:int = 0):Boolean
		{
			var doRestore:Boolean = false;
			
			if (keepFeet == null) keepFeet = [];
			if (keepFeet.indexOf(player.lowerBody) >= 0) return false; // For future TFs

			//(Centaurs -> Normal Human Legs)
			if (!(options & RESTOREFEET_EXCLUDETAUR) && player.isTaur() && changes < changeLimit) {
				outputText("\n\nYour quadrupedal hind-quarters seizes, overbalancing your surprised front-end and causing you to stagger and fall to your side.  Pain lances throughout, contorting your body into a tightly clenched ball of pain while tendons melt and bones break, melt, and regrow.  When it finally stops, <b>you look down to behold your new pair of human legs</b>!");
				doRestore = true;
			}

			//(Goo -> Normal Human Legs)
			if (!(options & RESTOREFEET_EXCLUDEGOO) && player.isGoo() && changes < changeLimit) {
				outputText("\n\nYour lower body rushes inward, molding into two leg-like shapes that gradually stiffen up.  In moments they solidify into normal-looking legs, complete with regular, human feet.  <b>You now have normal feet!</b>");
				doRestore = true;
			}

			//(Naga -> Normal Human Legs)
			if (!(options & RESTOREFEET_EXCLUDENAGA) && player.isNaga() && changes < changeLimit) {
				outputText("\n\nYou collapse as your sinuous snake-tail tears in half, shifting into legs.  The pain is immense, particularly where your new feet are forming.  <b>You have human legs again.</b>");
				doRestore = true;
			}

			//(Drider -> Normal Human Legs)
			if (!(options & RESTOREFEET_EXCLUDEDRIDER) && player.isDrider() && changes < changeLimit) {
				outputText("\n\nYour legs buckle under you and you fall, smashing your abdomen on the ground."
				          +"  Though your control deserts and you cannot see behind you,"
				          +" still you feel the disgusting sensation of chitin loosening and sloughing off your body,"
				          +" and the dry breeze on your exposed nerves."
				          +"  Reflexively, your legs cling together to protect as much of their now-sensitive surface as possible."
				          +"  When you try to part them, you find you cannot."
				          +"  Several minutes pass uncomforably until you can again bend your legs,"
				          +" and when you do, you find that all the legs of a side bend together.");
				outputText("  <b>You have human legs again.</b>");
				doRestore = true;
			}

			//(Non-human -> Normal Human Legs)
			if ((options & RESTOREFEET_FIXBIPED) && player.isBiped() && player.lowerBody != LOWER_BODY_TYPE_HUMAN && changes < changeLimit) {
				outputText("\n\nYou collapse as your legs shift and twist.  By the time the pain subsides, you notice that you have normal legs and normal feet.  <b>You now have normal feet!</b>");
				doRestore = true;
			}

			if (doRestore) {
				player.lowerBody = LOWER_BODY_TYPE_HUMAN;
				player.legCount = 2;
				changes++;
				return true;
			}

			return false;
		}

		public function removeFeatheryHair():Boolean
		{
			if (changes < changeLimit && player.hairType == HAIR_FEATHER && rand(4) == 0) {
				//(long):
				if (player.hairLength >= 6) outputText("\n\nA lock of your downy-soft feather-hair droops over your eye.  Before you can blow the offending down away, you realize the feather is collapsing in on itself.  It continues to curl inward until all that remains is a normal strand of hair.  <b>Your hair is no longer feathery!</b>", false);
				//(short)
				else outputText("\n\nYou run your fingers through your downy-soft feather-hair while you await the effects of the item you just ingested.  While your hand is up there, it detects a change in the texture of your feathers.  They're completely disappearing, merging down into strands of regular hair.  <b>Your hair is no longer feathery!</b>", false);
				player.hairType = HAIR_NORMAL;
				changes++;
				return true;
			}

			return false;
		}

		public function newLizardSkinTone():String
		{
			if (rand(10) == 0) {
				//rare skinTone
				return rand(2) == 0 ? "purple" : "silver";
			}

			//non rare skinTone
			switch (rand(5)) {
				case 0: return "red";
				case 1: return "green";
				case 2: return "white";
				case 3: return "blue";
				case 4: return "black";
			}

			return "invalid"; // Will never happen. Suppresses 'Error: Function does not return a value.'
		}

		public function gainSnakeTongue():Boolean
		{
			if (player.tongueType != TONGUE_SNAKE && changes < changeLimit) {
				if (player.tongueType == TONGUE_HUMAN) {
					outputText("\n\nYour taste-buds start aching as they swell to an uncomfortably large size. "
					          +"Trying to understand what in the world could have provoked such a reaction, you bring your hands up to your mouth, "
					          +"your tongue feeling like it's trying to push its way past your lips.");
					outputText("  The soreness stops and you stick out your tongue to try and see what would have made it feel the way it did. "
					          +"As soon as you stick your tongue out you realize that it sticks out much further than it did before, "
					          +"and now appears to have split at the end, creating a forked tip.");
					outputText("  <b>The scents in the air are much more noticeable to you with your snake-like tongue.</b>");
				} else {
					outputText("\n\nYour inhuman tongue shortens, pulling tight in the very back of your throat.");
					outputText("  After a moment the bunched-up tongue-flesh begins to flatten out, then extend forwards.");
					outputText("  By the time the transformation has finished, <b>your tongue has changed into a long, forked snake-tongue.</b>");
				}
				player.tongueType = TONGUE_SNAKE;
				dynStats("sen", 5);
				changes++;
				return true;
			}

			return false;
		}

	}
}
