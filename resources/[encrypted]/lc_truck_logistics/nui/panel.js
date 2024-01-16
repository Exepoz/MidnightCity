let config;

window.addEventListener('message', async function (event) {
	var item = event.data;
	var list_item = '';
	if (item.utils) {
		if (typeof Lang === 'undefined') {
			await Utils.loadLanguageModules(item.utils)
		}
	}
	if (item.resourceName) {
		Utils.setResourceName(item.resourceName)
	} 
	if (item.showmenu) {
		config = item.dados.config;
		lang = item.dados.config.lang;
		var contracts = item.dados.trucker_available_contracts;
		var users = item.dados.trucker_users;
		var myTrucks = item.dados.trucker_trucks;
		var drivers = item.dados.trucker_drivers;
		var top_truckers = item.dados.top_truckers;
		var loans = item.dados.trucker_loans;
		var trucker_party_members = item.dados.trucker_party_members;
		var trucker_party = item.dados.trucker_party;

		if(item.update != true){
			// Open on first time
			$('#sidebar-ul').empty();
			$('#sidebar-ul').append(`
			<li id="sidebar-main" onclick="openPage('main')">
				<i class="fas fa-user-circle"></i>
				<span class="tooltip">${Utils.translate('sidebar_profile')}</span>
			</li>
			<li onclick="openPage('job')">
				<i class="fas fa-truck-loading"></i>
				<span class="tooltip">${Utils.translate('sidebar_jobs')}</span>
			</li>
			<li onclick="openPage('freight')">
				<i class="fas fa-dolly-flatbed"></i>
				<span class="tooltip">${Utils.translate('sidebar_jobs_2')}</span>
			</li>
			<li onclick="openPage('party')">
				<i class="fas fa-user-group"></i>
				<span class="tooltip">${Utils.translate('sidebar_party')}</span>
			</li>
			<li onclick="openPage('skills')">
				<i class="fas fa-medal"></i>
				<span class="tooltip">${Utils.translate('sidebar_skills')}</span>
			</li>
			<li onclick="openPage('diagnostic')">
				<i class="fas fa-wrench"></i>
				<span class="tooltip">${Utils.translate('sidebar_diagnostic')}</span>
			</li>
			<li onclick="openPage('dealership')">
				<i class="fas fa-shopping-cart"></i>
				<span class="tooltip">${Utils.translate('sidebar_dealership')}</span>
			</li>
			<li onclick="openPage('trucks')">
				<i class="fas fa-truck"></i>
				<span class="tooltip">${Utils.translate('sidebar_mytrucks')}</span>
			</li>
			<li onclick="openPage('recruitment')" id="sidebar-drivers-page">
				<i class="fas fa-user-plus"></i>
				<span class="tooltip">${Utils.translate('sidebar_driver')}</span>
			</li>
			<li onclick="openPage('drivers')" id="sidebar-my-drivers-page">
				<i class="fas fa-users"></i>
				<span class="tooltip">${Utils.translate('sidebar_mydrivers')}</span>
			</li>
			<li onclick="openPage('bank')">
				<i class="fas fa-university"></i>
				<span class="tooltip">${Utils.translate('sidebar_bank')}</span>
			</li>
			<li onclick="closeUI()">
				<i class="fas fa-times"></i>
				<span class="tooltip">${Utils.translate('sidebar_close')}</span>
			</li>
			`);
			$('#main-title-div').empty();
			$('#main-title-div').append(`
				<h4 class="text-uppercase">${Utils.translate('statistics_page_title')}</h4>
				<p>${Utils.translate('statistics_page_desc')}</p>
			`);
			$('#profile-money-span').empty();
			$('#profile-money-span').append(Utils.translate('statistics_page_money'));
			$('#profile-money-earned-span').empty();
			$('#profile-money-earned-span').append(Utils.translate('statistics_page_money_earned'));
			$('#profile-deliveries-span').empty();
			$('#profile-deliveries-span').append(Utils.translate('statistics_page_deliveries'));
			$('#profile-distance-traveled-span').empty();
			$('#profile-distance-traveled-span').append(Utils.translate('statistics_page_distance'));
			$('#profile-exp-1-span').empty();
			$('#profile-exp-1-span').append(Utils.translate('statistics_page_exp'));
			$('#profile-skill-points-span').empty();
			$('#profile-skill-points-span').append(Utils.translate('statistics_page_skill'));
			$('#profile-trucks-span').empty();
			$('#profile-trucks-span').append(Utils.translate('statistics_page_trucks'));
			$('#profile-drivers-span').empty();
			$('#profile-drivers-span').append(Utils.translate('statistics_page_drivers'));
			
			$('#top-truckers-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('statistics_page_top_truckers')}</h4>
				<p>${Utils.translate('statistics_page_top_truckers_desc')}</p>
			`);
			$('#job-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('contract_page_title')}</h4>
				<p>${Utils.translate('contract_page_desc')}</p>
			`);

			$('#freight-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('contract_page_title_freight')}</h4>
				<p>${Utils.translate('contract_page_desc_freight')}</p>
			`);

			$('#trucks-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('trucks_page_title')}</h4>
				<p>${Utils.translate('trucks_page_desc')}</p>
			`);

			$('#drivers-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('mydrivers_page_title')}</h4>
				<p>${Utils.translate('mydrivers_page_desc')}</p>
			`);

			$('#bank-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('bank_page_title')}</h4>
				<p>${Utils.translate('bank_page_desc')}</p>
			`);
			
			$('#recruitment-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('drivers_page_title')}</h4>
				<p>${Utils.translate('drivers_page_desc')}</p>
			`);

			$('#diagnostic-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('diagnostic_page_title')} <small></small></h4>
				<p>${Utils.translate('diagnostic_page_desc')}</p>
			`);
			
			$('#dealership-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('dealership_page_title')}</h4>
				<p>${Utils.translate('dealership_page_desc')}</p>
			`);

			$('#party-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('party_page_title')}</h4>
				<p>${Utils.translate('party_page_desc')}</p>
			`);
			

			$('#skills-title').empty();
			$('#skills-title').append(Utils.translate('skills_page_title'));

			
			$('#withdraw-money-btn').text(Utils.translate('bank_page_withdraw'));
			$('#deposit-money-btn').text(Utils.translate('bank_page_deposit'));
			$('#active-loans-title').text(`${Utils.translate('bank_page_active_loans')}`);
			$('#bank-balance-text').text(`${Utils.translate('bank_page_balance')}`);
			$('#bank-loans-title').text(`${Utils.translate('bank_page_loan_title')}`);
			$('#bank-loans-desc').html(`${Utils.translate('bank_page_loan_desc').format(Utils.currencyFormat(config.max_emprestimo))}`);
			$('#bank-loans-btn').text(`${Utils.translate('bank_page_loan_button')}`);
			$('#loan-value-title').text(`${Utils.translate('bank_page_loan_value_title')}`);
			$('#loan-daily-title').text(`${Utils.translate('bank_page_loan_daily_title')}`);
			$('#loan-remaining-title').text(`${Utils.translate('bank_page_loan_remaining_title')}`);

			$('#loan-modal-title').text(`${Utils.translate('bank_page_loan_title')}`);
			$('#loan-modal-desc').text(`${Utils.translate('bank_page_loan_modal_desc')}`);
			$('#loan-modal-label-4').html(`<span style="font-weight: 600;">${Utils.currencyFormat(config.loans[0][0])}</span> ${Utils.translate('bank_page_loan_modal_item').format(Utils.currencyFormat(config.loans[0][1]))}`);
			$('#loan-modal-label-3').html(`<span style="font-weight: 600;">${Utils.currencyFormat(config.loans[1][0])}</span> ${Utils.translate('bank_page_loan_modal_item').format(Utils.currencyFormat(config.loans[1][1]))}`);
			$('#loan-modal-label-2').html(`<span style="font-weight: 600;">${Utils.currencyFormat(config.loans[2][0])}</span> ${Utils.translate('bank_page_loan_modal_item').format(Utils.currencyFormat(config.loans[2][1]))}`);
			$('#loan-modal-label-1').html(`<span style="font-weight: 600;">${Utils.currencyFormat(config.loans[3][0])}</span> ${Utils.translate('bank_page_loan_modal_item').format(Utils.currencyFormat(config.loans[3][1]))}`);
			$('#loan-modal-cancel').text(`${Utils.translate('bank_page_modal_cancel')}`);
			$('#loan-modal-submit').text(`${Utils.translate('bank_page_loan_modal_submit')}`);

			$('#deposit-modal-title').text(`${Utils.translate('bank_page_deposit_modal_title')}`);
			$('#deposit-modal-desc').text(`${Utils.translate('bank_page_deposit_modal_desc')}`);
			$('#deposit-modal-money-amount').attr('placeholder',Utils.translate('bank_page_modal_placeholder'));
			$('#deposit-modal-cancel').text(`${Utils.translate('bank_page_modal_cancel')}`);
			$('#deposit-modal-submit').text(`${Utils.translate('bank_page_deposit_modal_submit')}`);

			$('#withdraw-modal-title').text(`${Utils.translate('bank_page_withdraw_modal_title')}`);
			$('#withdraw-modal-desc').text(`${Utils.translate('bank_page_withdraw_modal_desc')}`);
			$('#withdraw-modal-money-amount').attr('placeholder',Utils.translate('bank_page_modal_placeholder'));
			$('#withdraw-modal-cancel').text(`${Utils.translate('bank_page_modal_cancel')}`);
			$('#withdraw-modal-submit').text(`${Utils.translate('bank_page_withdraw_modal_submit')}`);

			$('#skills-description-1').empty();
			$('#skills-description-1').append(Utils.translate('skills_page_description'));
			$('#skills-description-2').empty();
			$('#skills-description-2').append(Utils.translate('skills_page_description'));
			$('#skills-description-3').empty();
			$('#skills-description-3').append(Utils.translate('skills_page_description'));
			$('#skills-description-4').empty();
			$('#skills-description-4').append(Utils.translate('skills_page_description'));
			$('#skills-description-5').empty();
			$('#skills-description-5').append(Utils.translate('skills_page_description'));
			$('#product-type-title').empty();
			$('#product-type-title').append(Utils.translate('skills_page_product_type_title'));
			$('#product-type-desc').empty();
			$('#product-type-desc').append(Utils.translate('skills_page_product_type_description'));
			$('#distance-title').empty();
			$('#distance-title').append(Utils.translate('skills_page_distance_title'));
			$('#distance-desc').empty();
			$('#distance-desc').append(Utils.translate('skills_page_distance_description'));
			$('#valuable-skill-title').empty();
			$('#valuable-skill-title').append(Utils.translate('skills_page_valuable_title'));
			$('#valuable-skill-desc').empty();
			$('#valuable-skill-desc').append(Utils.translate('skills_page_valuable_desc'));
			$('#fragile-skill-title').empty();
			$('#fragile-skill-title').append(Utils.translate('skills_page_fragile_title'));
			$('#fragile-skill-desc').empty();
			$('#fragile-skill-desc').append(Utils.translate('skills_page_fragile_desc'));
			$('#fast-skill-title').empty();
			$('#fast-skill-title').append(Utils.translate('skills_page_fast_title'));
			$('#fast-skill-desc').empty();
			$('#fast-skill-desc').append(Utils.translate('skills_page_fast_desc'));

			var form = document.getElementById("party-form-create");
			form.style.opacity = "0";
			form.style.maxHeight = "0";
			form.style.fontSize = "0";
			form.style.position = "absolute"

			var formJoin = document.getElementById("party-form-join");
			formJoin.style.opacity = "0";
			formJoin.style.maxHeight = "0";
			formJoin.style.fontSize = "0";
			formJoin.style.position = "absolute"

			$('#party-form-container-create').empty();
			$('#party-form-container-create').append(`
				<input id="party-name" maxlength="30" class="input-party form-control form-control-sm" name="name" type="text" placeholder="${Utils.translate('party_page_name')}" oninput="Utils.invalidMsg(this);" required>
				<input id="party-desc" maxlength="300" class="input-party form-control form-control-sm" name="desc" type="text" placeholder="${Utils.translate('party_page_subtitle')}" oninput="Utils.invalidMsg(this);" required>
				<input id="party-password" maxlength="20" class="input-party form-control form-control-sm input-pass" name="password" type="password" placeholder="${Utils.translate('party_page_password')}">
				<input id="party-password-confirm" maxlength="20" class="input-party form-control form-control-sm input-pass" name="password-confirm" type="password" placeholder="${Utils.translate('party_page_password_confirm')}">
				<div class="ShowPasswordNotMatchesError" style="display:none;">${Utils.translate('party_page_password_mismatch')}</div>
				<div class="party-members-container">
					<input id="party-members" max="${config.party.max_members}" style="margin-bottom: 0px;" name="members" class="input-party form-control form-control-sm" type="number" placeholder="${Utils.translate('party_page_members')}" oninput="Utils.invalidMsg(this,1,${config.party.max_members});" required>
					<span>${Utils.currencyFormat(0)}</span>
				</div>
				<div class="ShowSubmitErrorCreate" style="display:none;"></div>
				<button class="btn btn-primary btn-block submit-party-form btn-sm" id="submit-party-form">${Utils.translate('party_page_finish_button').format(Utils.currencyFormat(config.party.price_to_create),Utils.currencyFormat(0))}</button>
			`);
			$('#party-create-btn').empty();
			$('#party-create-btn').append(`${Utils.translate('party_page_create')}`);
			$('#party-join-btn').empty();
			$('#party-join-btn').append(`${Utils.translate('party_page_join')}`);

			$('#party-form-container-join').empty();
			$('#party-form-container-join').append(`
				<input id="party-name-join" class="input-party form-control form-control-sm" name="name" type="text" placeholder="${Utils.translate('party_page_name')}" oninput="Utils.invalidMsg(this);" required>
				<input id="party-password-join" class="input-party form-control form-control-sm input-pass" name="password" type="password" placeholder="${Utils.translate('party_page_password')}">
				<div class="ShowSubmitErrorJoin" style="display:none;"></div>
				<button class="btn btn-primary btn-block submit-party-form btn-sm" id="submit-party-form-join">${Utils.translate('party_page_finish_button_2')}</button>
			`);

			$('.sidebar-navigation ul li').removeClass('active');
			$('#sidebar-main').addClass('active');

			if (config.disable_drivers) {
				$('#sidebar-drivers-page').css('display','none');
				$('#sidebar-my-drivers-page').css('display','none');
			}
			if (config.disable_loans) {
				$('#loans-card-container').removeClass('d-flex');
				$('#loans-card-container').css('display','none');
			}

			$('#css-toggle').prop('checked', users.dark_theme).change();

			$(".main").fadeIn(200)
			openPage('main');
		}

		$('#player-info-level').text(config.player_level);
		$('#player-info-skill').text(Utils.numberFormat(users.exp));
		$('#player-info-money').text(Utils.currencyFormat(users.money,0));

		$('#diagnostic-body').empty();
		$('#diagnostic-body').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="text-success">100 %</h3><span>${Utils.translate('diagnostic_page_chassi')}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-truck-field text-success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-engine').empty();
		$('#diagnostic-engine').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="text-success">100 %</h3><span>${Utils.translate('diagnostic_page_engine')}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-car-battery text-success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-transmission').empty();
		$('#diagnostic-transmission').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="text-success">100 %</h3><span>${Utils.translate('diagnostic_page_transmission')}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-tools text-success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-wheels').empty();
		$('#diagnostic-wheels').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="text-success">100 %</h3><span>${Utils.translate('diagnostic_page_wheels')}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-gear text-success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);

		$('#diagnostic-fuel-bar').empty();
		$('#diagnostic-fuel-bar').append(`
			<div class="progress progress-bar-vertical">
				<div class="progress-bar bg-warning progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="height: 100%;"></div>
			</div>
			<img src="img/icons/fuel.png" style="width: 40px;" class="mt-3">
		`);

		$('#new-contracts-1').empty();
		$('#new-contracts-1').append(Utils.translate('new_contracts').format(config.cooldown*2));
		$('#new-contracts-2').empty();
		$('#new-contracts-2').append(Utils.translate('new_contracts').format(config.cooldown*2));
		
		$('#profile-money').empty();
		$('#profile-money').append(Utils.currencyFormat(users.money,0));
		$('#bank-money').empty();
		$('#bank-money').append(Utils.currencyFormat(users.money,0));
		
		$('#withdraw-modal-money-available').text(`${Utils.translate('bank_page_modal_money_available').format(Utils.currencyFormat(users.money))}`);
		$('#deposit-modal-money-available').text(`${Utils.translate('bank_page_modal_money_available').format(Utils.currencyFormat(item.dados.available_money))}`);
		
		$('#profile-money-earned').empty();
		$('#profile-money-earned').append(Utils.currencyFormat(users.total_earned,0));
		$('#profile-deliveries').empty();
		$('#profile-deliveries').append(users.finished_deliveries);
		$('#profile-exp-1').empty();
		$('#profile-exp-1').append(Utils.numberFormat(users.exp));
		$('#profile-exp-2').empty();
		var exp_r = 0
		if (users.exp >= config.required_xp_to_levelup[config.required_xp_to_levelup.length-1]){
			exp_r = 100;
		}else if (config.player_level == 0) {
			max = config.required_xp_to_levelup[config.player_level]
			exp = users.exp
			exp_r = Math.round((exp*100)/max);
		}else{
			for (const key in config.required_xp_to_levelup) {
				if(users.exp < config.required_xp_to_levelup[key]){
					max = config.required_xp_to_levelup[key] - config.required_xp_to_levelup[key-1]
					exp = users.exp - config.required_xp_to_levelup[key-1]
					exp_r = Math.round((exp*100)/max);
					if(exp_r >= 0){
						break;
					}
				}
			}
		}
		$('#profile-exp-2').append('<div class="progress-bar bg-amber accent-4" role="progressbar" style="width: ' + exp_r + '%" aria-valuenow="' + exp_r + '" aria-valuemin="0" aria-valuemax="100"></div>');
		$('#profile-distance-traveled').empty();
		$('#profile-distance-traveled').append(Utils.numberFormat(users.traveled_distance,2) + 'km');
		$('#profile-skill-points').empty();
		$('#profile-skill-points').append(users.skill_points);
		$('#profile-trucks').empty();
		$('#profile-trucks').append(myTrucks.length);
		$('#profile-drivers').empty();
		var drivers_count = 0;
		for (const driver of drivers) {
			if(driver.user_id != null && driver.user_id != undefined){
				drivers_count++;
			}
		}
		$('#profile-drivers').append(drivers_count);

		$('#top-truckers-list').empty();
		var c = 1;
		var icon = "";
		for (const top_users of top_truckers) {
			if(c == 1){
				icon = "fa-medal amber accent-4 font-large-2";
			}else if(c == 2){
				icon = "fa-medal blue-grey lighten-3 font-large-1";
			}else if(c == 3){
				icon = "fa-medal bronze font-large-0";
			}else{
				icon = "fa-check-circle checkicon font-small-3";
			}
			$('#top-truckers-list').append(`
			<li class="d-flex justify-content-between card-theme">
				<div class="d-flex flex-row align-items-center"><i class="fas ` + icon + `"></i>
					<div class="ml-2">
						<h6 class="mb-0">` + top_users.name + ` ` + (top_users.firstname??'') + `</h6>
						<div class="d-flex flex-row mt-1 text-black-50 date-time">
							<div><i class="fas fa-route"></i></i><span class="ml-2">${Utils.translate('top_trucker_distance_traveled').format(Utils.numberFormat(top_users.traveled_distance,2))}</span></div>
							<div class="ml-3"><i class="fas fa-chart-line"></i></i><span class="ml-2">${Utils.translate('top_trucker_exp').format(Utils.numberFormat(top_users.exp))}</span></div>
						</div>
					</div>
				</div>
			</li>`);
			c++;
		}
		

		$('#job-page-list').empty();
		$('#freight-page-list').empty();
		for (const contract of contracts) {
			if (!contract.distance) { continue }
			let icon = 'fas fa-check-circle checkicon'
			let border = ''
			if (contract.external_data) {
				icon = 'fas fa-trophy trophyicon'
				border = ' style="border: 1px solid gold;"'
			}
			list_item = `
			<ul class="list list-inline mb-2">
				<li class="d-flex justify-content-between card-theme"${border}>
					<div class="d-flex flex-row align-items-center"><i class="${icon}"></i>
						<div class="ml-2">
							<h6 class="mb-0">` + contract.contract_name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div><i class="fas fa-route"></i><span class="ml-2">${Utils.translate('contract_page_distance').format(Utils.numberFormat(contract.distance,2))}</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i><span class="ml-2">${Utils.translate('contract_page_reward').format(Utils.currencyFormat(contract.reward))}</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<div class="d-flex flex-column mr-2">
							<div class="profile-image">
							`;
			if(contract.cargo_type == 1) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_explosive') + '"><img src="img/icons/explosive-1.png" width="30"></div>';
			}else if(contract.cargo_type == 2) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_flammablegas') + '"><img src="img/icons/flamable-2.png" width="30"></div>';
			}else if(contract.cargo_type == 3) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_flammableliquid') + '"><img src="img/icons/flamable-3.png" width="30"></div>';
			}else if(contract.cargo_type == 4) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_flammablesolid') + '"><img src="img/icons/flamable-4.png" width="30"></div>';
			}else if(contract.cargo_type == 5) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_toxic') + '"><img src="img/icons/toxic-6.png" width="30"></div>';
			}else if(contract.cargo_type == 6) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_corrosive') + '"><img src="img/icons/corrosive-8.png" width="30"></div>';
			}
			if(contract.fragile == 1) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_fragile') + '"><img src="img/icons/fragile.png" width="30"></div>';
			}
			if(contract.valuable == 1) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_valuable') + '"><img src="img/icons/valuable.png" width="30"></div>';
			}
			if(contract.fast == 1) {
				list_item += '<div data-tooltip-location="left" data-tooltip="' + Utils.translate('contract_page_cargo_urgent') + '"><img src="img/icons/fast.png" width="30"></div>';
			}
			var partystart_btn = '';
			if (trucker_party != undefined && !contract.external_data) {
				partystart_btn = `<button onclick="startContract(${contract.contract_id},true)" type="button" class="btn btn-dark waves-effect waves-light">${Utils.translate('contract_page_button_start_job_party')}</button>`
			}
			let button = `<button onclick="startContract(${contract.contract_id},false)" type="button" class="btn btn-primary waves-effect waves-light">${Utils.translate('contract_page_button_start_job')}</button>`
			if (contract.progress) {
				button = `<button onclick="cancelContract(${contract.contract_id})" type="button" class="btn btn-outline-danger waves-effect waves-light">${Utils.translate('contract_page_button_cancel_job')}</button>`
				partystart_btn = '';
			}
			list_item += `
							</div>
						</div>
						<div class="btn-group" role="group">
							${button}
							${partystart_btn}
						</div>
					</div>
				</li>
			</ul>
			`;
			if(contract.contract_type == 0) {
				$('#job-page-list').append(list_item);
			}else{
				$('#freight-page-list').append(list_item);
			}
		}
		
		$('#skills-desc').empty();
		$('#skills-desc').append(Utils.translate('skills_page_desc').format(users.skill_points));
		setSkill('distance',users.distance);
		setSkill('product_type',users.product_type);
		setSkill('valuable',users.valuable);
		setSkill('fragile',users.fragile);
		setSkill('fast',users.fast);

		$('#dealership-page-list').empty();
		list_item = ``
		for (const key in config.dealership) {
			truck = config.dealership[key];
			list_item += `
				<div class="card"> <img src="` + truck.img + `" class="card-img-top" width="100%">
					<div class="card-body pt-0 px-0">
						<div class="d-flex flex-row justify-content-between mb-0 mt-3 px-3"> <span class="text-muted">${Utils.translate('dealership_page_truck')}</span>
							<h6>` + truck.name + `</h6>
						</div>
						<hr class="mt-2 mx-3">
						<div class="d-flex flex-row justify-content-between px-3 pb-4">
							<div class="d-flex flex-column"><span class="text-muted">${Utils.translate('dealership_page_price')}</span></div>
							<div class="d-flex flex-column">
								<h5 class="mb-0">` + Utils.currencyFormat(truck.price) + `</h5>
							</div>
						</div>
						<div class="d-flex flex-row justify-content-between p-3 card-featured-theme">
							<div class="d-flex flex-column"><small class="text-muted mb-1">${Utils.translate('dealership_page_engine')}</small>
								<div class="d-flex flex-row"><img src="img/icons/engine_icon.png" style="width:40px;">
									<div class="d-flex flex-column justify-content-center ml-1"><small class="ghj text-black-50-theme">` + truck.engine + `</small><small class="ghj text-black-50-theme">` + truck.transmission + `</small></div>
								</div>
							</div>
							<div class="d-flex flex-column"><small class="text-muted mb-2">${Utils.translate('dealership_page_power')}</small>
								<div class="d-flex flex-row"><img src="img/icons/power_icon.png" style="width:36px;">
									<h6 class="ml-1 mt-1 mb-1">${Utils.translate('dealership_page_power_value').format(truck.hp)}</h6>
								</div>
							</div>
						</div>
						<div class="mx-3 mt-3 mb-2"><button onclick="buyTruck('` + key + `')" type="button" class="btn btn-primary btn-block"><small>${Utils.translate('dealership_page_buy_button')}</small></button></div> <small class="d-flex justify-content-center text-muted">${Utils.translate('dealership_page_bottom_text')}</small>
					</div>
				</div>
				`;
		}
		$('#dealership-page-list').append(list_item);

		$('#trucks-page-list').empty();
		list_item = "";
		for (const truck of myTrucks) {
			truck.body = truck.body/10;
			truck.engine = truck.engine/10;
			truck.transmission = truck.transmission/10;
			truck.wheels = truck.wheels/10;
			if(truck.driver == 0){
				$('#diagnostic-title-div').empty();
				$('#diagnostic-title-div').append(`
					<h4 class="text-uppercase">${Utils.translate('diagnostic_page_title')} <small>(${config.dealership[truck.truck_name].name})</small></h4>
					<p>${Utils.translate('diagnostic_page_desc')}</p>
				`);
				var color = "";
				var bgcolor = "";
				
				if (truck.body > 80) {
					color = "text-success";
					bgcolor = "bg-success";
				}else if(truck.body > 40){
					color = "text-warning";
					bgcolor = "bg-warning";
				}else{
					color = "text-danger";
					bgcolor = "bg-danger";
				}
				$('#diagnostic-body').empty();
				$('#diagnostic-body').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.body + ` %</h3><small>${Utils.translate('diagnostic_page_chassi')} (` + Utils.currencyFormat((100-truck.body)*config.repair_price.body) + `)</small>
						</div>
						<div class="align-self-center">
							<i class="fas fa-truck-field ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar ${bgcolor} role="progressbar" style="width: ` + truck.body + `%" aria-valuenow="` + truck.body + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.engine > 80) {
					color = "text-success";
					bgcolor = "bg-success";
				}else if(truck.engine > 40){
					color = "text-warning";
					bgcolor = "bg-warning";
				}else{
					color = "text-danger";
					bgcolor = "bg-danger";
				}
				$('#diagnostic-engine').empty();
				$('#diagnostic-engine').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.engine + ` %</h3><small>${Utils.translate('diagnostic_page_engine')} (` + Utils.currencyFormat((100-truck.engine)*config.repair_price.engine) + `)</small>
						</div>
						<div class="align-self-center">
							<i class="fas fa-car-battery ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar ${bgcolor} role="progressbar" style="width: ` + truck.engine + `%" aria-valuenow="` + truck.engine + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.transmission > 80) {
					color = "text-success";
					bgcolor = "bg-success";
				}else if(truck.transmission > 40){
					color = "text-warning";
					bgcolor = "bg-warning";
				}else{
					color = "text-danger";
					bgcolor = "bg-danger";
				}
				$('#diagnostic-transmission').empty();
				$('#diagnostic-transmission').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.transmission + ` %</h3><small>${Utils.translate('diagnostic_page_transmission')} (` + Utils.currencyFormat((100-truck.transmission)*config.repair_price.transmission) + `)</small>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar ${bgcolor} role="progressbar" style="width: ` + truck.transmission + `%" aria-valuenow="` + truck.transmission + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.wheels > 80) {
					color = "text-success";
					bgcolor = "bg-success";
				}else if(truck.wheels > 40){
					color = "text-warning";
					bgcolor = "bg-warning";
				}else{
					color = "text-danger";
					bgcolor = "bg-danger";
				}
				$('#diagnostic-wheels').empty();
				$('#diagnostic-wheels').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.wheels + ` %</h3><small>${Utils.translate('diagnostic_page_wheels')} (` + Utils.currencyFormat((100-truck.wheels)*config.repair_price.wheels) + `)</small>
						</div>
						<div class="align-self-center">
							<i class="fas fa-gear ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar ${bgcolor} role="progressbar" style="width: ` + truck.wheels + `%" aria-valuenow="` + truck.wheels + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);

				let refuel_btn = ``
				if (truck.fuel < 98) {
					refuel_btn = `<button onclick="refuelTruck(${truck.truck_id})" class="btn btn-danger mt-2">${Utils.currencyFormat((100-truck.fuel)*config.repair_price.fuel,0)}</button>`
				}
				if(truck.fuel > 20){
					bgcolor = "bg-warning";
				}else{
					bgcolor = "bg-danger";
				}
				$('#diagnostic-fuel-bar').empty();
				$('#diagnostic-fuel-bar').append(`
					<div class="fuel-progress-bar-container card-theme d-flex align-items-center flex-column p-3">
						<div class="progress progress-bar-vertical">
							<div class="progress-bar ${bgcolor} progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="height: ${truck.fuel}%;"></div>
						</div>
						<img src="img/icons/fuel.png" style="width: 40px;" class="mt-3">
					</div>
					<div style="height:60px">
						${refuel_btn}
					</div>
				`);
			}
			list_item += `
				<li class="d-flex justify-content-between card-theme">
					<div class="d-flex flex-row align-items-center"><img src="` + config.dealership[truck.truck_name].img + `" class="img-radius img-width" alt="User-Profile-Image">
						<div class="ml-2">
							<h6 class="mb-0">` + config.dealership[truck.truck_name].name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div>
									<i class="fas fa-truck-field"></i><span class="ml-2">${Utils.translate('trucks_page_chassi')}: ` + truck.body + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-car-battery"></i><span class="ml-2">${Utils.translate('trucks_page_engine')}: ` + truck.engine + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">${Utils.translate('trucks_page_transmission')}: ` + truck.transmission + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-gear"></i><span class="ml-2">${Utils.translate('trucks_page_wheels')}: ` + truck.wheels + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-gas-pump"></i><span class="ml-2">${Utils.translate('trucks_page_fuel')}: ` + truck.fuel + `%</span>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						` + getMyTruckHTML(truck) + `
						<button onclick="sellTruck('` + truck.truck_id + `','` + truck.truck_name + `')" class="btn btn-danger">${Utils.translate('trucks_page_sell_button')}</button>
					</div>
				</li>
				`;
		}
		$('#trucks-page-list').append(list_item);

		$('#recruitment-page-list').empty();
		$('#drivers-page-list').empty();
		list_item = ``
		for (const driver of drivers) {
			if (driver.user_id == null || driver.user_id == undefined){
				list_item += `
					<div class="card user-card">
						<div class="card-block">
							<div class="user-image">
								<img src="` + driver.img + `" class="img-radius" alt="User-Profile-Image">
							</div>
							<h6 class="mt-4 mb-2">` + driver.name + `</h6>
							<p class="text-muted">${Utils.translate('drivers_page_hiring_price').format(Utils.currencyFormat(driver.price))}</p>
							<hr>
							<p class="text-muted m-0">${Utils.translate('drivers_page_product_type')}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.product_type) + `
							</ul>
							<p class="text-muted m-0">${Utils.translate('drivers_page_distance')}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.distance) + `
							</ul>
							<p class="text-muted m-0">${Utils.translate('drivers_page_valuable')}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.valuable) + `
							</ul>
							<p class="text-muted m-0">${Utils.translate('drivers_page_fragile')}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fragile) + `
							</ul>
							<p class="text-muted m-0">${Utils.translate('drivers_page_urgent')}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fast) + `
							</ul>
							<div onclick="hireDriver('` + driver.driver_id + `')" class="mx-3 mt-3 mb-2"><button type="button" class="btn btn-primary btn-block"><small>${Utils.translate('drivers_page_hire_button')}</small></button></div>
						</div>
					</div>
					`;
			}else{
				let fuel_color = `amber`;
				let refuel_btn = ``
				let refuel_bar = ``
				let truck_assigned = myTrucks.find(truck => truck.driver == driver.driver_id)
				if (truck_assigned) {
					refuel_bar = `<div class="d-flex flex-row text-black-50 small">
						<div class="d-flex align-items-center mr-3">
							<img src="img/icons/fuel.png" width="35px">
							<div class="ml-1">
								<span>${Utils.translate('drivers_page_driver_fuel')}</span>
								<div id="vehicle-health" class="progress mt-0 mb-0" style="height: 10px; width: 200px;"><div class="progress-bar bg-${fuel_color}" role="progressbar" style="width: ${truck_assigned.fuel}%" aria-valuenow="0.0" aria-valuemin="0" aria-valuemax="100"></div></div>
							</div>
						</div>
					</div>`
					if (truck_assigned.fuel < 98) {
						refuel_btn = `<a class="dropdown-item text-black-50" onclick="refuelTruck(${truck_assigned.truck_id})">${Utils.translate('drivers_page_refuel_button').format(Utils.currencyFormat((100-truck_assigned.fuel)*config.repair_price.fuel,0))}</a>`
						if (truck_assigned.fuel < 20) {
							fuel_color = "danger"
						}
					}
				}
				$('#drivers-page-list').append(`
					<li class="d-flex justify-content-between card-theme">
						<div class="d-flex flex-row align-items-center">
							<img src="` + driver.img + `" class="img-radius img-width" alt="User-Profile-Image">
							<div class="ml-2">
								<h6 class="mb-0">` + driver.name + `</h6>
								<div class="d-flex flex-row mt-1 text-black-50 date-time">
									<div>
										<i class="fas fa-coins"></i><span class="ml-2">${Utils.translate('drivers_page_hiring_price').format(Utils.currencyFormat(driver.price))}</span>
									</div>
									<div class="ml-3">
										<i class="fas fa-medal"></i><span class="ml-2">${Utils.translate('drivers_page_skills')}: ${Utils.translate('drivers_page_product_type')} (` + driver.product_type + `) ${Utils.translate('drivers_page_distance')} (` + driver.distance + `) <BR>${Utils.translate('drivers_page_valuable')} (` + driver.valuable + `) ${Utils.translate('drivers_page_fragile')} (` + driver.fragile + `) ${Utils.translate('drivers_page_urgent')} (` + driver.fast + `)</span>
									</div>
								</div>
							</div>
						</div>
						<div class="d-flex flex-row align-items-center">
							${refuel_bar}
							<div class="d-flex flex-column mr-3">
								<select style="min-width:200px" id="select-truck" class="selectpicker form-control" onchange="setDriver(this.options[this.selectedIndex].getAttribute('driver_id'),this.options[this.selectedIndex].getAttribute('truck_id'));">
									` + getDriverAvailableTrucksHTML(myTrucks,driver,config) + `
								</select>
							</div> 
							<div class="dropdown mr-2">
								<svg data-toggle="dropdown" class="dropdown-options-svg" xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:svgjs="http://svgjs.com/svgjs" width="512" height="512" x="0" y="0" viewBox="0 0 515.555 515.555" style="enable-background:new 0 0 512 512" xml:space="preserve"><g><path xmlns="http://www.w3.org/2000/svg" d="m496.679 212.208c25.167 25.167 25.167 65.971 0 91.138s-65.971 25.167-91.138 0-25.167-65.971 0-91.138 65.971-25.167 91.138 0" data-original="#000000" style="" class=""></path><path xmlns="http://www.w3.org/2000/svg" d="m303.347 212.208c25.167 25.167 25.167 65.971 0 91.138s-65.971 25.167-91.138 0-25.167-65.971 0-91.138 65.971-25.167 91.138 0" data-original="#000000" style="" class=""></path><path xmlns="http://www.w3.org/2000/svg" d="m110.014 212.208c25.167 25.167 25.167 65.971 0 91.138s-65.971 25.167-91.138 0-25.167-65.971 0-91.138 65.971-25.167 91.138 0" data-original="#000000" style="" class=""></path></g></svg>
								<div class="dropdown-menu">
									${refuel_btn}
									<a class="dropdown-item" onclick="fireDriver(${driver.driver_id})" style="color:#ff0000c2;">${Utils.translate('drivers_page_fire_button')}</a>
								</div>
							</div>
						</div>
					</li>
				`);
			}
		}
		$('#recruitment-page-list').append(list_item);

		$('#loan-table-body').empty();
		$('#loan-table-container').css('display','none');
		for (const loan of loans) {
			$('#loan-table-body').append(`
				<tr>
					<td>${Utils.currencyFormat(loan.loan)}</td>
					<td>${Utils.currencyFormat(loan.day_cost)}</td>
					<td class="text-danger">${Utils.currencyFormat(loan.remaining_amount)}</td>
					<td><button class="btn btn-outline-primary" style="min-width: 200px;" onclick="payLoan(${loan.id})" >${Utils.translate('bank_page_loan_pay')}</button></td>
				</tr>
			`);
			$('#loan-table-container').css('display','');
		}

		if (trucker_party != undefined) {
			var quit_str = `<button onclick="quitParty()" class="btn btn-danger">${Utils.translate('party_quit')}</button>`;
			if (trucker_party.owner == 1) {
				quit_str = `<button onclick="deleteParty()" class="btn btn-danger">${Utils.translate('party_delete')}</button>`;
			}
			$('#party-title-div').empty();
			$('#party-title-div').append(`
				<h4 class="text-uppercase">${trucker_party.name} <small>(${trucker_party.members_count}/${trucker_party.members})</small></h4>
				<div class="party-title-container">
					<p>${trucker_party.description}</p>
					${quit_str}
				</div>
			`);

			$("#party-form-container-base").css("display", "none");
			$("#party-container-members").css("display", "");
			
			$('#party-container-members').empty();
			for (const member of trucker_party_members) {
				var kick_str = '';
				if (trucker_party.owner == 1 && trucker_party.user_id != member.user_id) {
					kick_str = `<button onclick="kickParty(\'${member.user_id}\')" class="btn btn-danger">${Utils.translate('party_kick')}</button>`;
				}
				var owner_str = '';
				if (member.owner) {
					owner_str = `<div data-tooltip-location="left" data-tooltip="${Utils.translate('party_leader')}"><img src="img/icons/crown.png" width="30"></div>`;
				}
				var online_str = 'fas fa-xmark-circle xicon';
				if (member.online) {
					online_str = 'fas fa-check-circle checkicon';
				}
				$('#party-container-members').append(`
					<ul class="list list-inline mb-2">
						<li class="d-flex justify-content-between card-theme">
							<div class="d-flex flex-row align-items-center"><i class="${online_str}" aria-hidden="true"></i>
								<div class="ml-2">
									<h6 class="mb-0">${member.name} ${(member.firstname??'')}</h6>
									<div class="d-flex flex-row mt-1 text-black-50 date-time">
										<div>
											<i class="fas fa-route"></i><span class="ml-2">${Utils.translate('party_finished_deliveries').format(member.finished_deliveries)}</span>
										</div>
										<div class="ml-3">
											<i class="fas fa-clock"></i><span class="ml-2">${Utils.translate('party_joined_time').format(Utils.timeConverter(member.joined_at))}</span>
										</div>
									</div>
								</div>
							</div>
							<div class="d-flex flex-row align-items-center">
								<div class="d-flex flex-column mr-2">
									<div class="profile-image">
										${owner_str}
									</div>
								</div>
								${kick_str}
							</div>
						</li>
					</ul>
				`);
			}
		} else {
			$('#party-title-div').html(`
				<h4 class="text-uppercase">${Utils.translate('party_page_title')}</h4>
				<p>${Utils.translate('party_page_desc')}</p>
			`);
			$("#party-form-container-base").css("display", "");
			$("#party-container-members").css("display", "none");
		}

		$(function () {
			$(".input-pass").blur(function () {
				var PasswordVal=$('#party-password').val();
				var ConfirmPasswordVal=$('#party-password-confirm').val();
				if(PasswordVal != ConfirmPasswordVal && ConfirmPasswordVal.length > 0 && PasswordVal.length > 0) {
					$('.ShowPasswordNotMatchesError').show();
				} else {
					$('.ShowPasswordNotMatchesError').hide();
				}
			});
			$("#party-members").keyup(function () {
				if ($(this).val() > config.party.max_members) {
					this.value = config.party.max_members;
				}
				if ($(this).val() && $(this).val() <= 0) {
					this.value = 1;
				}
				$('.party-members-container span').text(Utils.currencyFormat($(this).val() * config.party.price_per_member));
				$('#submit-party-form').text(Utils.translate('party_page_finish_button').format(Utils.currencyFormat(config.party.price_to_create),Utils.currencyFormat($(this).val() * config.party.price_per_member)));
			});
		});

		$('.sidebar-navigation ul li').on('click', function() {
			$('li').removeClass('active');
			$(this).addClass('active');
		});
	}
	if (item.hidemenu){
		$(".main").fadeOut(200)
	}
});

function getDriverLevelHTML(value){
	var html = "";
	for (var i = 1; i <= 6; i++) {
		if(i <= value){
			html += '<li class="actived bg-success"></li>';
		}else{
			html += '<li></li>';
		}
	}
	return html;
}

function getDriverAvailableTrucksHTML(myTrucks,driver,config){
	var html = "";
	var i = 1;
	var has_truck = null;
	for (const truck of myTrucks) {
		if (truck.driver == driver.driver_id) {
			has_truck = truck.truck_id;
			html += '<option selected="selected">' + config.dealership[truck.truck_name].name +'</option>';
		}else{
			if (truck.driver == null){
				html += '<option truck_id="' + truck.truck_id + '" driver_id="' + driver.driver_id + '">' + config.dealership[truck.truck_name].name +'</option>';
			}
		}
	}
	if (has_truck == null) {
		html = '<option selected="selected">' + Utils.translate('drivers_page_pick_truck') + '</option>' + html;
	}else{
		html = '<option driver_id="' + driver.driver_id + '">' + Utils.translate('drivers_page_pick_truck') + '</option>' + html;
	}
	return html;
}

function getMyTruckHTML(truck){
	return truck.driver==0 ? `<button onclick="spawnTruck(` + truck.truck_id + `)" class="btn btn-primary mr-2">${Utils.translate('trucks_page_spawn')}</button> <button onclick="setDriver(null,'` + truck.truck_id + `')" class="btn btn-outline-primary mr-2">${Utils.translate('trucks_page_remove')}</button>` : `<button onclick="setDriver('0','` + truck.truck_id + `')" class="btn btn-primary mr-2">${Utils.translate('trucks_page_select')}</button>`
}

function setSkill(id,newValue){
	$('#'+id).empty();
	for (var i = 1; i <= 6; i++) {
		if(i <= newValue){
			if(i == 1){
				$('#'+id).append('<div class="steps bg-success"> <span><i class="fas fa-check"></i></span> </div>');
			}else{
				$('#'+id).append('<span class="line bg-success"></span><div class="steps bg-success"> <span><i class="fas fa-check"></i></span> </div>');
			}
		}else{
			if(i == 1){
				$('#'+id).append('<div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span> </div>');
			}else{
				$('#'+id).append('</div> <span class="redline"></span><div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span>');
			}
		}
	}
}

function openPage(pageN){
	$(".pages").css("display", "none");
	$(`.${pageN}-page`).css("display", "block");

	var titleHeight = $(`#${pageN}-title-div`).outerHeight(true) ?? 0;
	var footerHeight = $(`#${pageN}-footer-div`).outerHeight(true) ?? 0;
	$(':root').css(`--${pageN}-title-height`, (titleHeight+footerHeight) + 'px');
}

function createParty() {
	var form = document.getElementById("party-form-create");
	var form2 = document.getElementById("party-form-join");
	if (form.style.opacity === "1" || form2.style.opacity === "1") {
		form.style.opacity = "0";
		form.style.maxHeight = "0";
		form.style.fontSize = "0";

		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		setTimeout(function(){ form.style.position = "absolute" }, 300);
		setTimeout(function(){ form2.style.position = "absolute" }, 300);

	} else {
		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		
		form.style.opacity = "1";
		form.style.maxHeight = "1000px";
		form.style.fontSize = "15px";
		form.style.position = "";
	}
}

function joinParty() {
	var form = document.getElementById("party-form-join");
	var form2 = document.getElementById("party-form-create");
	if (form.style.opacity === "1" || form2.style.opacity === "1") {
		form.style.opacity = "0";
		form.style.maxHeight = "0";
		form.style.fontSize = "0";

		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		setTimeout(function(){ form.style.position = "absolute" }, 300);
		setTimeout(function(){ form2.style.position = "absolute" }, 300);

	} else {
		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";

		form.style.opacity = "1";
		form.style.maxHeight = "1000px";
		form.style.fontSize = "15px";
		form.style.position = "";
	}
	
}

$(document).ready( function() {
	$('#css-toggle').on('change', function(){
		if($(this).prop("checked") == false){
			// Light theme
			$('#css-bs-light').prop('disabled', false);
			$('#css-light').prop('disabled', false);
			$('#css-bs-dark').prop('disabled', true);
			$('#css-dark').prop('disabled', true);
			$('#dark-theme-icon').css("display", "");
			$('#light-theme-icon').css("display", "none");
			changeTheme(0)
		} else if($(this).prop("checked") == true){
			// Dark theme
			$('#css-bs-dark').prop('disabled', false);
			$('#css-dark').prop('disabled', false);
			$('#css-bs-light').prop('disabled', true);
			$('#css-light').prop('disabled', true);
			$('#dark-theme-icon').css("display", "none");
			$('#light-theme-icon').css("display", "");
			changeTheme(1)
		}
	});
    
	$("#party-form-create").on('submit', function(e){
		e.preventDefault();
		var form = $('#party-form-create').serializeArray();
		if(form[2].value !== form[3].value)	{
			$('.ShowPasswordNotMatchesError').show();
			return;
		}
		Utils.post("createParty",{name:form[0].value,desc:form[1].value,pass:form[2].value,cpass:form[3].value,members:form[4].value})
	});

	$("#party-form-join").on('submit', function(e){
		e.preventDefault();
		var form = $('#party-form-join').serializeArray();
		Utils.post("joinParty",{name:form[0].value,pass:form[1].value})
	});

	$("#form-deposit-money").on('submit', function(e){
		e.preventDefault();
		var form = $('#form-deposit-money').serializeArray();
		$('#deposit-modal-money-amount').val(null);
		$("#deposit-modal").modal('hide');
		Utils.post("depositMoney",{amount:form[0].value})
	});

	$("#form-withdraw-money").on('submit', function(e){
		e.preventDefault();
		var form = $('#form-withdraw-money').serializeArray();
		$('#withdraw-modal-money-amount').val(null);
		$("#withdraw-modal").modal('hide');
		Utils.post("withdrawMoney",{amount:form[0].value})
	});

	$("#form-loan").on('submit', function(e){
		e.preventDefault();
		var form = $('#form-loan').serializeArray();
		$("#loans-modal").modal('hide');
		Utils.post("loan",{loan_id:form[0].value})
	});
})

function closeUI(){
	Utils.post("close","")
}
function startContract(contract_id,party){
	Utils.post("startContract",{id:contract_id,party:party})
}
function cancelContract(contract_id){
	Utils.post("cancelContract",{id:contract_id})
}
function sellTruck(truck_id,truck_name){
	Utils.showDefaultDangerModal(() => Utils.post("sellTruck",{truck_id:truck_id,truck_name:truck_name}), Utils.translate('confirmation_modal_sell_vehicle'));
}
function buyTruck(truck_name){
	Utils.post("buyTruck",{truck_name:truck_name})
}
function spawnTruck(truck_id){
	Utils.post("spawnTruck",{truck_id:truck_id})
}
function refuelTruck(truck_id){
	Utils.post("refuelTruck",{truck_id:truck_id})
}
function fireDriver(driver_id){
	Utils.post("fireDriver",{driver_id:driver_id})
}
function hireDriver(driver_id){
	Utils.post("hireDriver",{driver_id:driver_id})
}
function upgradeSkill(id,i){
	Utils.post("upgradeSkill",{id:id,value:i})
}
function repairTruck(id){
	Utils.post("repairTruck",{id:id})
}
function setDriver(driver_id,truck_id){
	Utils.post("setDriver",{driver_id:driver_id,truck_id:truck_id})
}
function changeTheme(dark_theme){
	Utils.post("changeTheme",{dark_theme})
}
function payLoan(loan_id){
	Utils.post("payLoan",{loan_id:loan_id})
}
function kickParty(user_id){
	Utils.post("kickParty",{user_id:user_id})
}
function deleteParty(){
	Utils.showDefaultDangerModal(() => Utils.post("deleteParty",{}), Utils.translate('confirmation_modal_delete_party'));
}
function quitParty(){
	Utils.post("quitParty",{})
}