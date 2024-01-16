if (Lang == undefined) {
	var Lang = [];
}
Lang['no'] = {
	new_contracts: 'Nye oppdrag hver {0} min',
	top_trucker_distance_traveled: 'Distanse kjørt: {0}km',
	top_trucker_exp: 'EXP: {0}',
	sidebar_profile: 'Din Profil',
	sidebar_jobs: 'Raske Oppdrag',
	sidebar_jobs_2: 'Frakt Oppdrag',
	sidebar_skills: 'Erfaring',
	sidebar_diagnostic: 'Diagnostikk',
	sidebar_dealership: 'Forhandler',
	sidebar_mytrucks: 'Lastebil',
	sidebar_driver: 'Rekrutering',
	sidebar_mydrivers: 'Sjåfører',
	sidebar_bank: 'Konto',
	sidebar_party: 'Gruppe',
	sidebar_close: 'Lukk',

	confirmation_modal_sell_vehicle: 'Er du sikker på at du vil selge dette kjøretøyet?',
	confirmation_modal_delete_party: 'Er du sikker på at du vil oppløse denne gruppa?',

	statistics_page_title: 'Statistikk',
	statistics_page_desc: 'Oversikt over bedriften din',
	statistics_page_money: 'Penger',
	statistics_page_money_earned: 'Total Mengde Tjent',
	statistics_page_deliveries: 'Fullførte Oppdrag',
	statistics_page_distance: 'Distanse Kjørt',
	statistics_page_exp: 'Total erfaring tjent',
	statistics_page_skill: 'Erfaring',
	statistics_page_trucks: 'Lastebiler',
	statistics_page_drivers: 'Sjåfører',
	statistics_page_top_truckers: 'Topp Sjåfører',
	statistics_page_top_truckers_desc: 'Topp 10 lastebilsjåfører i byen',

	contract_page_title: 'Raske Jobber',
	contract_page_desc: 'Her trenger du ikke en egen lastebil. Bedriften fikser alt for deg.',
	contract_page_title_freight: 'Frakt',
	contract_page_desc_freight: 'Tjen mer penger ved å bruke egen lastebil',
	contract_page_distance: 'Distanse: {0}km',
	contract_page_reward: 'Belønning: {0}',
	contract_page_cargo_explosive: 'Eksplosiver',
	contract_page_cargo_flammablegas: 'Brannfarlig Gass',
	contract_page_cargo_flammableliquid: 'Brannfarlig Væske',
	contract_page_cargo_flammablesolid: 'Brannfarlige Stoffer',
	contract_page_cargo_toxic: 'Giftige Stoffer',
	contract_page_cargo_corrosive: 'Etsende Stoffer',
	contract_page_cargo_fragile: 'Skjør Last',
	contract_page_cargo_valuable: 'Verdifull Last',
	contract_page_cargo_urgent: 'Hastelast',
	contract_page_button_start_job: 'Start Oppdrag',
	contract_page_button_start_job_party: 'Start oppdrag i gruppe',
	contract_page_button_cancel_job: 'Avbryt Oppdrag',

	dealership_page_title: 'Forhandler',
	dealership_page_desc: 'Kjøp flere lastebiler til deg selv',
	dealership_page_truck: 'Lastebil',
	dealership_page_price: 'Pris',
	dealership_page_engine: 'MOTOR',
	dealership_page_power: 'HESTEKREFTER',
	dealership_page_power_value: '{0} hp',
	dealership_page_buy_button: 'KJØP',
	dealership_page_bottom_text: '*Legal Disclaimer',

    diagnostic_page_title: 'Diagnostikk',
	diagnostic_page_desc: 'Reparer lastebilen din for å ta oppdrag (Endre lastebil ved å trykke velg på Lastebil siden)',
	diagnostic_page_chassi: 'Reparer Karosseriet',
	diagnostic_page_engine: 'Reparer Motor',
	diagnostic_page_transmission: 'Reparer Girkassen',
	diagnostic_page_wheels: 'Reparer Hjulene',

    trucks_page_title: 'Lastebil',
	trucks_page_desc: 'Se alle lastebilene dine her.',
	trucks_page_chassi: 'Karosseri',
	trucks_page_engine: 'Motor',
	trucks_page_transmission: 'Girkasse',
	trucks_page_wheels: 'Hjul',
	trucks_page_fuel: 'Drivstoff',
	trucks_page_sell_button: 'Selg Lastebil',
	trucks_page_spawn: 'Ta ut Lastebilen',
	trucks_page_remove: 'Avbryt',
	trucks_page_select: 'Velg Lastebil',

    mydrivers_page_title: 'Sjåfører',
	mydrivers_page_desc: 'Du ser alle sjåførene dine her.',

	drivers_page_title: 'Rekrutteringsbyrå',
	drivers_page_desc: 'Rekrutter nye sjåfører for bedriften din',
	drivers_page_hiring_price: 'Pris: {0}',
	drivers_page_skills: 'Erfaring',
	drivers_page_product_type: 'Produkt Type',
	drivers_page_distance: 'Distanse',
	drivers_page_valuable: 'Verdifull Last',
	drivers_page_fragile: 'Skjør Last',
	drivers_page_urgent: 'Tidskritisk Last',
	drivers_page_hire_button: 'ANSETT',
	drivers_page_driver_fuel: 'Drivstoff',
	drivers_page_fire_button: 'Spark sjåfør',
	drivers_page_refuel_button: 'Fyll Lastebil {0}',
	drivers_page_pick_truck: 'Velg en Lastebil',

    skills_page_title: 'Erfaring',
	skills_page_desc: 'Når du jobber så øker du kompetansen din. Jo lengre oppdrag, så får du mer erfaring. Dette gir deg erfaringspoeng som du kan bruke til å åpne opp vanskeligere oppdrag. (Poeng Tilgjengelig: {0})',
	skills_page_description: 'Beskrivelse',
	skills_page_product_type_title: 'Produkt Type (ADR)',
	skills_page_product_type_description: `
		<p>Transportering av farlig gods trenger erfarne sjåfører. Kjøpt et ADR sertifikat for å låse opp nye gods.</p>
		<ul>
			Klasse 1 - Eksplosive:
			<li>Ting som dynamitt, fyrverkeri og ammunisjon</li>
			<BR> Klasse 2 - Gass:
			<li> Brannfarlig, ikke-brannfarlig og giftige gasser som kan medføre død eller seriøs skade hvis man puster det inn </li>
			<BR> Klasse 3 - Brannfarlig væske:
			<li> Farlig væske som bensin, diesel og parafin </li>
			<BR> Klasse 4 - Brannfarlige stoffer:
			<li> Brannfarlige stoffer som nitro, magnesium, selvantennende aluminium, hvit fosfor og mer </li>
			<BR> Klasse 6 - Giftige stoffer
			<li> Gift, stoffer som kan skade personer sin helse </li>
			<BR> Klasse 8 - Etsende stoffer
			<li> Stoffer som kan løse opp stoffer. Eksempler som svovelsyre, saltsyre, kaliumhydroksid og natriumhydroksid </li>
		</ul>`,
	skills_page_distance_title: 'Distanse',
	skills_page_distance_description: `
		<p> Din distanse kompetanse avgjør max distansen du kan kjøre. Ved start så kan du bare kjøre opptil 6km. </p>
		<ul>
			Level 1:
			<li> Oppdrag opptil 6.5km </li>
			<li> 5% bonus for distanse lengre enn 6km </li>
			<li> 10% erfaringsbonus for distanse lengre enn 6km </li>
			<BR> Level 2:
			<li> Oppdrag opptil 7km </li>
			<li> 10% bonus for distanse lengre enn 6.5km </li>
			<BR> Level 3:
			<li> Oppdrag opptil 7.5km </li>
			<li> 15% bonus for distanse lengre enn 7km </li>
			<BR> Level 4:
			<li> Oppdrag opptil 8km </li>
			<li> 20% bonus for distanse lengre enn 7.5km </li>
			<BR> Level 5:
			<li> Oppdrag opptil 8.5km </li>
			<li> 25% bonus for distanse lengre enn 8km </li>
			<BR> Level 6:
			<li> Oppdrag som kan kjøres overalt </li>
			<li> 30% bonus for distanse lengre enn 8.5km </li>
		</ul>`,
	skills_page_valuable_title: 'Verdifull Last',
	skills_page_valuable_desc: `
		<p> Hver last er verdifull, men noen er mer verdifull enn andre. Flere firma lener seg på at profesjonelle sjåfører leverer dette. </p>
		<ul>
			Level 1:
			<li> Verdifull last oppdrag </li>
			<li> 5% bonus for verdifull last </li>
			<li> 20% erfaringsbonus for verdifull last </li>
			<BR> Level 2:
			<li> 10% bonus for verdifull last </li>
			<BR> Level 3:
			<li> 15% bonus for verdifull last </li>
			<BR> Level 4:
			<li> 20% bonus for verdifull last </li>
			<BR> Level 5:
			<li> 25% bonus for verdifull last </li>
			<BR> Level 6:
			<li> 30% bonus for verdifull last </li>
		</ul>`,
	skills_page_fragile_title: 'Skjør Last',
	skills_page_fragile_desc: `
		<p> Denne kompetansen gir deg mulighet til å levvere skjør last, som glass, elektriske dupeditter eller delikate maskiner. </p>
		<ul>
			Level 1:
			<li> Skjør last oppdrag </li>
			<li> 5% bonus for skjør last </li>
			<li> 20% erfaringsbonus for skjør last oppdrag </li>
			<BR> Level 2:
			<li> 10% bonus for skjør last </li>
			<BR> Level 3:
			<li> 15% bonus for skjør last </li>
			<BR> Level 4:
			<li> 20% bonus for skjør last </li>
			<BR> Level 5:
			<li> 25% bonus for skjør last </li>
			<BR> Level 6:
			<li> 30% bonus for skjør last </li>
		</ul>`,
	skills_page_fast_title: 'Tidskritisk Last',
	skills_page_fast_desc: `
		<p> Noen ganger trenger firmaer at last blir levert raskt. Disse jobbene presser sjåføren, men lønnen gjør opp for det. </p>
		<ul>
			Level 1:
			<li> Tidskrtisk last oppdrag </li>
			<li> 5% bonus for tidskritisk last </li>
			<li> 20% erfaringsbonus for tidskritisk last oppdrag </li>
			<BR> Level 2:
			<li> 10% bonus for tidskritisk last </li>
			<BR> Level 3:
			<li> 15% bonus for tidskritisk last </li>
			<BR> Level 4:
			<li> 20% bonus for tidskritisk last </li>
			<BR> Level 5:
			<li> 25% bonus for tidskritisk last </li>
			<BR> Level 6:
			<li> 30% bonus for tidskritisk last </li>
		</ul>`,

	party_page_title: 'Gruppe',
	party_page_desc: 'Lag eller delta i en gruppe for å levere gods med venner.',
	party_page_create: 'Lag gruppe',
	party_page_join: 'Bli medlem av gruppen',
	party_page_name: 'Navn på gruppe*',
	party_page_subtitle: 'Beskrivelse av gruppen*',
	party_page_password: 'Passord',
	party_page_password_confirm: 'Bekreft Passord',
	party_page_members: 'Antall medlemmer*',
	party_page_finish_button: 'Lag gruppe ({0} + {1})',
	party_page_finish_button_2: 'Bli medlem',
	party_page_password_mismatch: '* Feil passord',
	party_leader: 'Gruppeleder',
	party_finished_deliveries: 'Oppdrag fullført i gruppe: {0}',
	party_joined_time: 'Medlem av gruppe siden: {0}',
	party_kick: 'Spark gruppe',
	party_quit: 'Avslutt gruppe',
	party_delete: 'Slett gruppe',

	bank_page_title: 'Bank',
	bank_page_desc: 'Se din bedrift sin bank info her',
    bank_page_withdraw: 'Ta Ut Penger',
	bank_page_deposit: 'Overfør Penger',
	bank_page_balance: 'Saldo:',
	bank_page_active_loans: 'Aktive Lån',

	bank_page_loan_title: 'Lån',
	bank_page_loan_desc: 'Ta ut lån for å investere i bedriften din!<BR>(Max lån: {0})',
	bank_page_loan_button: 'Ta lån',
	bank_page_loan_value_title: 'Lån mengde',
	bank_page_loan_daily_title: 'Daily cost',
	bank_page_loan_remaining_title: 'Gjenstående',
	bank_page_loan_pay: 'Betal Lån',

	bank_page_loan_modal_desc: 'Velg en av lån mulighetene:',
	bank_page_loan_modal_item: '(betal {0} pr dag)',
	bank_page_loan_modal_submit: 'Ta lån',

	bank_page_deposit_modal_title: 'Overfør penger',
	bank_page_deposit_modal_desc: 'Hvor mye ønsker du å overføre?',
	bank_page_deposit_modal_submit: 'Overfør penger',

	bank_page_withdraw_modal_title: 'Ta ut penger',
	bank_page_withdraw_modal_desc: 'Hvor mye ønsker du å ta ut?',
	bank_page_withdraw_modal_submit: 'Ta ut penger',
	
	bank_page_modal_placeholder: 'Saldo',
	bank_page_modal_money_available: 'Tilgjengelig saldo: {0}',
	bank_page_modal_cancel: 'Avbryt',
	
	str_fill_field:"Fyll ut feltet",
	str_invalid_value:"Ugyldig verdi",
	str_more_than:"Må være mer eller likt {0}",
	str_less_than:"Må være mindre eller likt {0}",
};