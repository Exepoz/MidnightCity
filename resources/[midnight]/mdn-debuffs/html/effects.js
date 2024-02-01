"use strict";

var Effects = {

	// DEFUFFS
	bleeding: function(item)
	{
		Effects.show(item, '#e12b40')
	},

	heavybleeding: function(item)
	{
		Effects.show(item, '#e12b40')
	},

	bone: function(item)
	{
		Effects.show(item, '#e12b40')
	},

	gunshot: function(item)
	{
		Effects.show(item, '#833508')
	},

	burnt: function(item)
	{
		Effects.show(item, '#540303')
	},

	pain: function(item)
	{
		Effects.show(item, '#e12b40')
	},

	alcohol: function(item)
	{
		Effects.show(item, '#2a5c03')
	},

	hot: function(item)
	{
		Effects.show(item, '#ffcf48')
	},

	cold: function(item)
	{
		Effects.show(item, '#1e2460')
	},

	hangry: function(item)
	{
		Effects.show(item, '#654321')
	},

	thirst: function(item)
	{
		Effects.show(item, '#082567')
	},

	// BUFFS
	painkiller: function(item)
	{
		Effects.show(item, '#0095b6')
	},

	godmode: function(item)
	{
		Effects.show(item, '#dae4f2')
	},

	luck: function(item)
	{
		Effects.show(item, '#259918')
	},

	greasy: function(item)
	{
		Effects.show(item, '#c4d149')
	},

	sneaky: function(item)
	{
		Effects.show(item, '#150b33')
	},

	easyhack: function(item)
	{
		Effects.show(item, '#0a7fa6')
	},

	fasthands: function(item)
	{
		Effects.show(item, '#a9c716')
	},


	// SHOW ICON
	show: function(item, color)
	{
		let el = window[`${item.action}`];
		let overlayName = Effects.getNameOverlay(item.action);
		let overlayElem = window[`overlay_${overlayName}`];

		if(item.value && el == null)
		{
			effects_list.innerHTML += Effects.tmp_icon(item.action, color);

			if(overlayName != null && overlayElem == undefined)
			{
				Effects.createOverlay(overlayName)
			}
			if(item.timeout != undefined)
			{
				Effects.decrement(item)
			}
		}
		else if (el != null)
		{
			el.remove();

			if(overlayElem != undefined)
			{
				overlayElem.remove();
			}
		}
	},
	// TIME OUT
	decrement: function(item)
	{
		let step = item.timeout / 25;
		let p1 = 100;

		let timeint = setInterval(function()
		{
			p1 -= 4;

			let svg = document.getElementById(`${item.action}_svg`);
			if (svg == null) {
				clearInterval(timeint);
				return;
			}
			svg.style.strokeDasharray = `${p1} ${100 - p1}`;

			if(p1 < 3)
			{
				clearInterval(timeint);
				svg.style.strokeDasharray = `0 100`;

				setTimeout(function()
				{
					UI.onPostCallback(`https://mdn-debuffs/cb:stopEffect`, { effect: item.action })
				}, 1000)
			}
		}, step);
	},

	tmp_icon: function(effect, color)
	{
		return `<div class="svg-shadow effects-anim" id="${effect}">
					<svg viewBox="0 0 42 42">
						<circle class="svg-circle" id="${effect}_svg" cx="21" cy="21" r="16" fill="rgba(0,0,0,.8)" stroke="${color}" stroke-width="3" stroke-dasharray="100 0" stroke-dashoffset="75"></circle>
					</svg>
					<img src="assets/${effect}.png"/>
				</div>`;
	},

	createOverlay: function(effect)
	{
		overlays.innerHTML += `<img class="overlay" id="overlay_${effect}" src="assets/overlay/${effect}.png"></div>`;
	},

	getNameOverlay: function(effect)
	{
		switch(effect)
		{
			case 'debuff_bleeding':
			case 'debuff_heavybleeding':
				return 'blood';
			case 'debuff_burnt':
				return 'burnt';
			default: return null;
		}
	}
};