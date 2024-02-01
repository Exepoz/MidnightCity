"use strict";

var UI = {

    loadEvent: function()
    {
		window.addEventListener('message', (event) =>
		{
			let item = event.data;
			switch(item.action)
			{
				// BUFFS
				case "buff_painkiller": Effects.painkiller(item); break;
				case "buff_godmode": Effects.godmode(item); break;
				case "buff_luck": Effects.luck(item); break;
				case "buff_greasy": Effects.greasy(item); break;
				case "buff_sneaky": Effects.sneaky(item); break;
				case "buff_easyhack": Effects.easyhack(item); break;
				case "buff_fasthands": Effects.fasthands(item); break;

				// DEBUFFS
				case "debuff_pain": Effects.pain(item); break;
				case "debuff_alcohol": Effects.alcohol(item); break;
				case "debuff_bleeding": Effects.bleeding(item); break;
				case "debuff_heavybleeding": Effects.heavybleeding(item); break;
				case "debuff_bone": Effects.bone(item); break;
				case "debuff_gunshot": Effects.gunshot(item); break;
				case "debuff_burnt": Effects.burnt(item); break;
				case "debuff_hot": Effects.hot(item); break;
				case "debuff_cold": Effects.cold(item); break;
				case "debuff_hangry": Effects.hangry(item); break;
				case "debuff_thirst": Effects.thirst(item); break;
			}
		});
    },

    onPostCallback: function(nui, postbody)
    {
		fetch(nui, {
			method: 'POST',
			headers: {'Content-Type': 'application/json; charset=UTF-8'},
			body: JSON.stringify(postbody)
		}).then(res => { /* console.log('Request complete!', res); */ });
    }
};
window.onload = UI.loadEvent();