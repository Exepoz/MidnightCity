if (Lang == undefined) {
	var Lang = [];
}
Lang['de'] = {
	new_contracts: 'Neue Aufträge alle {0} Minuten',
	top_trucker_distance_traveled: 'Zurückgelegte Strecke: {0}km',
	top_trucker_exp: 'EXP: {0}',
	sidebar_profile: 'Dein Profil',
	sidebar_jobs: 'Schnelle-Jobs',
	sidebar_jobs_2: 'Fracht-Jobs',
	sidebar_skills: 'Fertigkeiten',
	sidebar_diagnostic: 'Diagnostik',
	sidebar_dealership: 'Autohaus',
	sidebar_mytrucks: 'Meine LKW',
	sidebar_driver: 'Vermittlungsagentur',
	sidebar_mydrivers: 'Meine Fahrer',
	sidebar_bank: 'Bank',
	sidebar_party: 'Gruppe',
	sidebar_close: 'Schließen',	

	confirmation_modal_sell_vehicle: 'Bist du sicher, dass du dieses Fahrzeug verkaufen möchtest?',
	confirmation_modal_delete_party: 'Bist du sicher, dass du diese Gruppe löschen möchtest?',

	statistics_page_title: 'Statistiken',
	statistics_page_desc: 'Statistiken deiner LKW-Firma',
	statistics_page_money: 'Geld',
	statistics_page_money_earned: 'Gesamteinnahmen',
	statistics_page_deliveries: 'Lieferungen',
	statistics_page_distance: 'Zurückgelegte Strecke',
	statistics_page_exp: 'Gesamterhaltene EXP',
	statistics_page_skill: 'Fertigkeitspunkte',
	statistics_page_trucks: 'Lastwagen',
	statistics_page_drivers: 'Fahrer',
	statistics_page_top_truckers: 'Top-Fahrer',
	statistics_page_top_truckers_desc: 'Liste der Top 10 LKW-Fahrer in der Stadt',	

	contract_page_title: 'Schnelljobs',
	contract_page_desc: 'Hier brauchst du keinen eigenen LKW. Die Firma stellt alles für dich bereit.',
	contract_page_title_freight: 'Fracht',
	contract_page_desc_freight: 'Verdiene mehr Geld durch Frachten mit deinem eigenen LKW.',
	contract_page_distance: 'Entfernung: {0}km',
	contract_page_reward: 'Belohnung: {0}',
	contract_page_cargo_explosive: 'Explosive',
	contract_page_cargo_flammablegas: 'Entzündbare Gase',
	contract_page_cargo_flammableliquid: 'Entzündbare Flüssigkeiten',
	contract_page_cargo_flammablesolid: 'Entzündbare Feststoffe',
	contract_page_cargo_toxic: 'Giftige Substanzen',
	contract_page_cargo_corrosive: 'Ätzende Substanzen',
	contract_page_cargo_fragile: 'Empfindliche Fracht',
	contract_page_cargo_valuable: 'Wertvolle Fracht',
	contract_page_cargo_urgent: 'Dringende Fracht',
	contract_page_button_start_job: 'Job starten',
	contract_page_button_start_job_party: 'In Gruppe starten',
	contract_page_button_cancel_job: 'Job abbrechen',
	
	dealership_page_title: 'Autohaus',
	dealership_page_desc: 'Kaufe mehr Lastwagen für dich und deine Fahrer',
	dealership_page_truck: 'Lastwagen',
	dealership_page_price: 'Preis',
	dealership_page_engine: 'MOTOR',
	dealership_page_power: 'LEISTUNG',
	dealership_page_power_value: '{0} PS',
	dealership_page_buy_button: 'KAUFEN',
	dealership_page_bottom_text: '*Rechtlicher Hinweis',
	
	diagnostic_page_title: 'Diagnose',
	diagnostic_page_desc: 'Repariere deinen LKW, um Aufträge ausführen zu können (wechsel deinen LKW, indem du auf die Schaltfläche "Auswählen" auf der Seite "Lastwagen" klickst)',
	diagnostic_page_chassi: 'Karosserie reparieren',
	diagnostic_page_engine: 'Motor reparieren',
	diagnostic_page_transmission: 'Getriebe reparieren',
	diagnostic_page_wheels: 'Reifen reparieren',
	
	trucks_page_title: 'Lastwagen',
	trucks_page_desc: 'Hier siehst du alle deine Lastwagen. Du kannst für jeden Fahrer einen einrichten',
	trucks_page_chassi: 'Karosserie',
	trucks_page_engine: 'Motor',
	trucks_page_transmission: 'Getriebe',
	trucks_page_wheels: 'Räder',
	trucks_page_fuel: 'Kraftstoff',
	trucks_page_sell_button: 'Lastwagen verkaufen',
	trucks_page_spawn: 'Lastwagen erscheinen lassen',
	trucks_page_remove: 'Abwählen',
	trucks_page_select: 'Lastwagen auswählen',
	
	mydrivers_page_title: 'Fahrer',
	mydrivers_page_desc: 'Hier findest du deine Fahrer. Du kannst für jeden Fahrer einen LKW einrichten',
	
	drivers_page_title: 'Rekrutierungsbüro',
	drivers_page_desc: 'Rekrutiere neue Fahrer, die für deine Firma arbeiten',
	drivers_page_hiring_price: 'Preis: {0}',
	drivers_page_skills: 'Fähigkeiten',
	drivers_page_product_type: 'Produkttyp',
	drivers_page_distance: 'Entfernung',
	drivers_page_valuable: 'Wertvoll',
	drivers_page_fragile: 'Zerbrechlich',
	drivers_page_urgent: 'Dringend',
	drivers_page_hire_button: 'Anwerben',
	drivers_page_driver_fuel: 'Kraftstoff',
	drivers_page_fire_button: 'Entlassen',
	drivers_page_refuel_button: 'LKW füllen {0}',
	drivers_page_pick_truck: 'Wählen Sie einen LKW',
	
	skills_page_title: 'Fähigkeiten',
    skills_page_desc: 'Durch Arbeit sammelst Du wertvolle Erfahrung. Je mehr Strecken du zurücklegst, desto mehr Erfahrung sammelst du. Letztendlich verdienst Du auf diese Weise Fähigkeitspunkte, die du hier zuweisen kannst, um deine LKW-Fähigkeiten hervorzuheben. (Verfügbare Fähigkeitspunkte: {0})',
    skills_page_description: 'Beschreibung',
    skills_page_product_type_title: 'Produkttyp (ADR)',
	skills_page_product_type_description: `
		<p>Der Transport gefährlicher Güter erfordert gut ausgebildete Fachleute. Kaufen ADR-Zertifikate, um neue Arten von Fracht freizuschalten.</p>
		<ul>
			Klasse 1 - Explosivstoffe:
			<li>Wie Dynamit, Feuerwerk oder Munition</li>
			<BR> Klasse 2 - Gase:
			<li>Entzündliche, nicht entzündliche und giftige Gase, die bei Einatmen zum Tod oder schweren Verletzungen führen können</li>
			<BR> Klasse 3 - Entzündbare Flüssigkeiten:
			<li>Gefährliche Brennstoffe wie Benzin, Diesel und Kerosin</li>
			<BR> Klasse 4 - Entzündbare Feststoffe:
			<li>Entzündbare Feststoffe wie Nitrocellulose, Magnesium, Sicherheitszündhölzer, selbstentzündliches Aluminium, weißer Phosphor, unter anderem</li>
			<BR> Klasse 6 - Toxische Substanzen
			<li>Gifte, Substanzen, die für die menschliche Gesundheit schädlich sind, wie zum Beispiel Kaliumcyanid, Quecksilberchlorid und Pestizide</li>
			<BR> Klasse 8 - Ätzende Stoffe
			<li>Stoffe, die organisches Gewebe auflösen oder bestimmte Metalle stark korrodieren können. Beispiele hierfür sind Schwefelsäure, Salzsäure, Kaliumhydroxid und Natriumhydroxid</li>
		</ul>`,

	skills_page_distance_title: 'Distanz',
	skills_page_distance_description: `
		<p> Deine Fähigkeit für lange Strecken bestimmt die maximale Entfernung, die du während deiner Schicht zurücklegen kannst. Zu Beginn sind keine Fahrten über 6 km erlaubt. </p>
		<ul>
			Level 1:
			<li> Lieferungen bis zu 6,5 km </li>
			<li> 5% Belohnung für Entfernungen über 6 km </li>
			<li> 10% Erfahrungsbonus für Entfernungen über 6 km </li>
			<BR> Level 2:
			<li> Lieferungen bis zu 7 km </li>
			<li> 10% Belohnung für Entfernungen über 6,5 km </li>
			<BR> Level 3:
			<li> Lieferungen bis zu 7,5 km </li>
			<li> 15% Belohnung für Entfernungen über 7 km </li>
			<BR> Level 4:
			<li> Lieferungen bis zu 8 km </li>
			<li> 20% Belohnung für Entfernungen über 7,5 km </li>
			<BR> Level 5:
			<li> Lieferungen bis zu 8,5 km </li>
			<li> 25% Belohnung für Entfernungen über 8 km </li>
			<BR> Level 6:
			<li> Lieferungen überall möglich </li>
			<li> 30% Belohnung für Entfernungen über 8,5 km </li>
		</ul>`,

	skills_page_valuable_title: 'Wertvolle Fracht',
	skills_page_valuable_desc: `
			<p> Jede Fracht ist wertvoll, aber einige sind wertvoller als andere. Unternehmen verlassen sich nur auf bewährte Spezialisten, um diese Art von Service durchzuführen. </p>
			<ul>
				Level 1:
				<li> Hohe Wert-Entsperrung Jobangebote </li>
				<li> 5% Belohnung für wertvolle Lieferungen </li>
				<li> 20% Erfahrungsbonus für wertvolle Lieferungen </li>
				<BR> Level 2:
				<li> 10% Belohnung für wertvolle Lieferungen </li>
				<BR> Level 3:
				<li> 15% Belohnung für wertvolle Lieferungen </li>
				<BR> Level 4:
				<li> 20% Belohnung für wertvolle Lieferungen </li>
				<BR> Level 5:
				<li> 25% Belohnung für wertvolle Lieferungen </li>
				<BR> Level 6:
				<li> 30% Belohnung für wertvolle Lieferungen </li>
			</ul>`,

	skills_page_fragile_title: 'Fragile Cargo',
	skills_page_fragile_desc: `
		<p> Diese Fähigkeit ermöglicht es Ihnen, empfindliche Frachten wie Glas, Elektronik oder empfindliche Maschinen zu transportieren. </p>
		<ul>
			Level 1:
			<li> Freigeschaltete Jobangebote für empfindliche Fracht </li>
			<li> 5% Belohnung für die Lieferung von empfindlicher Fracht </li>
			<li> 20% Erfahrungsbonus für die Lieferung von empfindlicher Fracht </li>
			<BR> Level 2:
			<li> 10% Belohnung für die Lieferung von empfindlicher Fracht </li>
			<BR> Level 3:
			<li> 15% Belohnung für die Lieferung von empfindlicher Fracht </li>
			<BR> Level 4:
			<li> 20% Belohnung für die Lieferung von empfindlicher Fracht </li>
			<BR> Level 5:
			<li> 25% Belohnung für die Lieferung von empfindlicher Fracht </li>
			<BR> Level 6:
			<li> 30% Belohnung für die Lieferung von empfindlicher Fracht </li>
		</ul>`,
	
	skills_page_fast_title: 'Pünktliche Lieferung',
	skills_page_fast_desc: `
		<p> Manchmal müssen Unternehmen etwas schnell liefern. Diese Aufgaben setzen den Fahrer unter mehr Druck, die Lieferzeit ist kurz, aber die Bezahlung macht die Unannehmlichkeiten wett. </p>
		<ul>
			Level 1:
			<li> Angebote für dringende Fracht </li>
			<li> 5% Belohnung für dringende Frachtlieferungen </li>
			<li> 20% Erfahrungsbonus für dringende Frachtlieferungen </li>
			<BR> Level 2:
			<li> 10% Belohnung für dringende Frachtlieferungen </li>
			<BR> Level 3:
			<li> 15% Belohnung für dringende Frachtlieferungen </li>
			<BR> Level 4:
			<li> 20% Belohnung für dringende Frachtlieferungen </li>
			<BR> Level 5:
			<li> 25% Belohnung für dringende Frachtlieferungen </li>
			<BR> Level 6:
			<li> 30% Belohnung für dringende Frachtlieferungen </li>
		</ul>`,

	party_page_title: 'Party',
	party_page_desc: 'Erstelle oder tritt einer Party bei, um gemeinsam mit Freunden zu liefern.',
	party_page_create: 'Party erstellen',
	party_page_join: 'Party beitreten',
	party_page_name: 'Party-Name*',
	party_page_subtitle: 'Party-Beschreibung*',
	party_page_password: 'Passwort',
	party_page_password_confirm: 'Passwort bestätigen',
	party_page_members: 'Anzahl der Mitglieder*',
	party_page_finish_button: 'Party erstellen ({0} + {1})',
	party_page_finish_button_2: 'Party beitreten',
	party_page_password_mismatch: '* Passwort stimmt nicht überein',
	party_leader: 'Party-Leiter',
	party_finished_deliveries: 'Lieferungen abgeschlossen auf Party: {0}',
	party_joined_time: 'In der Party seit: {0}',
	party_kick: 'Party-Kick',
	party_quit: 'Party verlassen',
	party_delete: 'Party löschen',

	bank_page_title: 'Bank',
	bank_page_desc: 'Hier kannst du die Bankkontoinformationen deines Unternehmens einsehen',
	bank_page_withdraw: 'Geld abheben',
	bank_page_deposit: 'Geld einzahlen',
	bank_page_balance: 'Ihr Kontostand beträgt:',
	bank_page_active_loans: 'Aktive Kredite',
	
	bank_page_loan_title: 'Darlehen',
	bank_page_loan_desc: 'Nehme Kredite für dein Unternehmen auf! <BR> (Höchstbetrag für Darlehen: {0})',
	bank_page_loan_button: 'Darlehen aufnehmen',
	bank_page_loan_value_title: 'Darlehensbetrag',
	bank_page_loan_daily_title: 'Tägliche Kosten',
	bank_page_loan_remaining_title: 'Verbleibender Betrag',
	bank_page_loan_pay: 'Darlehen zurückzahlen',

	bank_page_loan_modal_desc: 'Wähle einen der Kreditarten aus:',
	bank_page_loan_modal_item: '(zahle {0} pro Tag)',
	bank_page_loan_modal_submit: 'Kredit aufnehmen',

	bank_page_deposit_modal_title: 'Geld einzahlen',
	bank_page_deposit_modal_desc: 'Wie viel möchtest du einzahlen?',
	bank_page_deposit_modal_submit: 'Geld einzahlen',

	bank_page_withdraw_modal_title: 'Geld abheben',
	bank_page_withdraw_modal_desc: 'Wie viel möchtest du abheben?',
	bank_page_withdraw_modal_submit: 'Geld abheben',	
	
	bank_page_modal_placeholder: 'Betrag',
	bank_page_modal_money_available: 'Verfügbares Geld: {0}',
	bank_page_modal_cancel: 'Abbrechen',

	str_fill_field: "Dieses Feld ausfüllen",
	str_invalid_value: "Ungültiger Wert",
	str_more_than: "Muss größer oder gleich {0} sein",
	str_less_than: "Muss kleiner oder gleich {0} sein",

};