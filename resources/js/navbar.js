$("div.navbar-fixed-top").autoHidingNavbar();
$('.navbar .dropdown').hover(function() {
    if (!navbarCollapsed()) {
        $(this).find('.dropdown-menu').first().stop(true, true).slideDown(300);
    }
}, function() {
    if (!navbarCollapsed()) {
        $(this).find('.dropdown-menu').first().stop(true, true).slideUp(300);
    }
});

function navbarCollapsed() {
    return window.innerWidth < 992;
}

/************************************* Cookie Policy ***********************************************************/
/*
var cookiePolicyAware = $.cookie("cookie-policyAware");
var expiresDate = new Date(2034, 0, 1);
$("#dataviz-navbar").prepend("<div class='cookie-policy'><div class='container'><div><p>We use cookies to ensure the best experience on our website. By continuing to browse this site you are agreeing to our use of cookies. <a href='http://pitchbook.com/cookie-policy'>Our cookie policy</a><span class='close-cookie-policy glyphicon glyphicon-remove-circle'></span></p></div></div></div>")

if (cookiePolicyAware != "true") {
    $.ajax({
        url: "http://pitchbook.com/check-ip-in-eu", success: function (result) {
            result = "true"
            if (result === "true") {
                $(".cookie-policy").show().toggleClass('on');
            }
        }
    });
}
$(".close-cookie-policy").click(function () {
    $.cookie("cookie-policyAware", "true", {expires: expiresDate});
    $(".cookie-policy").slideUp(200).toggleClass('on');
});
*/
/**/
