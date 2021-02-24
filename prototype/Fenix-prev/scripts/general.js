
$(document.body).click( function(e) {
	$('.dropdown').removeClass('active');
	$('.show-dropMenu').removeClass('active');
});

$('#passwordBtn').click(function() {
	$(this).toggleClass('active')
	if ($(this).hasClass('active')) {
	  $('#password').attr('type','text');	
	} else {
	  $('#password').attr('type','password');
	}
});

$('.dropdown-title').click(function(e) {
	e.stopPropagation();
	$('.dropdown').removeClass('active');
	$(this).parent().toggleClass('active');
});

//
$('.show-about-fenix').click(function(e) {
	$(this).toggleClass('opened')
	$(this).closest('.about-fenix').find('.about-fenix-wr').toggleClass('opened')
});

function selectTheme(theme) {
	$('#selectedTheme').text(theme);
	$('.dropdown').removeClass('active');
}

function selectLanguage(theme) {
	$('#selectedLanguage').text(theme);
	$('.dropdown').removeClass('active');
}

$('#toggleBtn').click(function() {
	$(this).closest('.menu').toggleClass('menu-visibility')
	$(this).toggleClass('visibility')
})

$('.closeAddFenix').click(function() {
	$(this).closest('body').find('.show-modal-cancel').addClass('show')
})

//menu

$('.submenu-items li > a').click(function() {
	$('.submenu-items li > a').removeClass('active')
	$(this).addClass('active')
})

$('.menu-items li').click(function() {
	$('.menu-items li a').removeClass('active')
	$(this).find('a').addClass('active')
})

$('.submenu-back').click(function() {
	$(this).closest('.submenu').removeClass('submenu-active')
});

//submenu settings

$('.submenu-settings-item').click(function() {
	$('.submenu-settings-item').removeClass('active')
	$(this).addClass('active')
})


$('.open-maps').click(function() {
	$(this).closest('body').find('.submenu').addClass('submenu-active')
});



//modal

$('.modal-close-btn').click(function() {
	$(this).closest('.modal-bg').toggleClass('show')
})

$('.modal-open').click(function() {
	$(this).closest('body').find('.modal-bg').toggleClass('show')
})

//extend mode

$('.extend-mode-btn').click(function() {
	$(this).parent().find('.extend-mode-btn').removeClass('active')
	$(this).addClass('active')
})

//show/hidden number phone

$('.number-account').click(function() {
	$(this).toggleClass('number-account-actions')
	$(this).closest('.content').find('.number-phone').toggleClass('hidden')
})


// select active item

$('.config-select-item').click(function() {
	$(this).parent().find('.config-select-item').removeClass('active')
	$(this).addClass('active')
})

//inputs chekced

$('#bindingPhone').on('click', function () {
    if ( $(this).is(':checked') ) {
    	$(this).closest('.config-security-item').find('.bindingPhoneShowed').addClass('show')
    }
})


$('#setPassword').on('click', function () {
    if ( $(this).is(':checked') ) {
    	$(this).closest('.config-security-item').find('.setPasswordShowed').addClass('show')
    }
})

//slim scroll
$(function(){
	$('#scroll-wr').slimScroll({
		height: '80vh',
		color: '#8F90A3',
		size: '5px',
		railOpacity: 1,
		borderRadius: '10px',
		right: '15px'
	});
});