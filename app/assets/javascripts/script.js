var playKutu = function () {

  function loader() {
      $(window).on("load", function () {
          $(".pageload").fadeOut("slow");
      });
  }

  function initDropdownMenu(){
    $('.dropdown.header').hover(function() {
      $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeIn(500);
    }, function() {
      $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeOut(500);
    });    
  }
  
  function injectAsidebar(jQuery) {
    $.fn.asidebar = function asidebar(status) {
      switch (status) {
        case "open":
          var that = this;
          // fade in backdrop
          if ($(".aside-backdrop").length === 0) {
            $("body").append("<div class='aside-backdrop'></div>");
          }
          $(".aside-backdrop").addClass("in");


          function close() {
            $(that).asidebar.apply(that, ["close"]);
          }

          // slide in asidebar
          $(this).addClass("in");
          $(this).find("[data-dismiss=aside], [data-dismiss=asidebar]").on('click', close);
          $(".aside-backdrop").on('click', close);
          break;
        case "close":
          // fade in backdrop
          if ($(".aside-backdrop.in").length > 0) {
            $(".aside-backdrop").removeClass("in");
          }

          // slide in asidebar
          $(this).removeClass("in");
          break;
        case "toggle":
          if($(this).attr("class").split(' ').indexOf('in') > -1) {
            $(this).asidebar("close");
          } else {
            $(this).asidebar("open");
          }
          break;
      }
    }
  }

  // support browser and node
  if (typeof jQuery !== "undefined") {
    injectAsidebar(jQuery);
  } else if (typeof module !== "undefined" && module.exports) {
    module.exports = injectAsidebar;
  }
  
  function initFormReg() {
    /*
        Form
    */
    $('.registration-form fieldset:first-child').fadeIn('slow');
    
    $('.registration-form input[type="text"], .registration-form input[type="password"], input[type="email"] .registration-form textarea').on('focus', function() {
    	$(this).removeClass('input-error');
    });
    
    // next step
    $('.registration-form .btn-next').on('click', function() {
    	var parent_fieldset = $(this).parents('fieldset');
    	var next_step = true;
    	
    	parent_fieldset.find('input[type="text"], input[type="password"], input[type="email"]').each(function() {
    		if( $(this).val() == "" ) {
    			$(this).addClass('input-error');
    			next_step = false;
    		}
    		else {
    			$(this).removeClass('input-error');
    		}
    	});
    	
    	if( next_step ) {
    		parent_fieldset.fadeOut(400, function() {
	    		$(this).next().fadeIn();
	    	});
    	}
    	
    });
    
    // previous step
    $('.registration-form .btn-previous').on('click', function() {
    	$(this).parents('fieldset').fadeOut(400, function() {
    		$(this).prev().fadeIn();
    	});
    });
    
    // submit
    $('.registration-form').on('submit', function(e) {
    	
    	$(this).find('input[type="text"], input[type="password"], input[type="email"]').each(function() {
    		if( $(this).val() == "" ) {
    			e.preventDefault();
    			$(this).addClass('input-error');
    		}
    		else {
    			$(this).removeClass('input-error');
    		}
    	});
    	
    });

  }

  function homeSlideShow() {
    var $carousel   = $('.owl-carousel')
    if(!$carousel.length) return;
    
    $carousel.owlCarousel({
        loop: true,
        margin: 5,
        nav: false,
        autoplay: true,
        autoplaySpeed: 1000,
        responsive: {
            0:{
                items:1
            },
            600:{
                items:1
            },
            1000:{
                items:1
            }
          }
      })
  }

  function initAccordion() {  
	   	var d = document,
      accordionToggles = d.querySelectorAll('.js-accordionTrigger'),
      setAria,
      setAccordionAria,
      switchAccordion,
      touchSupported = ('ontouchstart' in window),
      pointerSupported = ('pointerdown' in window);

      skipClickDelay = function(e){
        e.preventDefault();
        e.target.click();
      }

			setAriaAttr = function(el, ariaType, newProperty){
			el.setAttribute(ariaType, newProperty);
			};
			setAccordionAria = function(el1, el2, expanded){
				switch(expanded) {
			  case "true":
			  	setAriaAttr(el1, 'aria-expanded', 'true');
			  	setAriaAttr(el2, 'aria-hidden', 'false');
			  	break;
			  case "false":
			  	setAriaAttr(el1, 'aria-expanded', 'false');
			  	setAriaAttr(el2, 'aria-hidden', 'true');
			  	break;
			  default:
			break;
				}
		};
		//function
		switchAccordion = function(e) {
		  console.log("triggered");
			e.preventDefault();
			var thisAnswer = e.target.parentNode.nextElementSibling;
			var thisQuestion = e.target;
			if(thisAnswer.classList.contains('is-collapsed')) {
				setAccordionAria(thisQuestion, thisAnswer, 'true');
			} else {
				setAccordionAria(thisQuestion, thisAnswer, 'false');
			}
		  	thisQuestion.classList.toggle('is-collapsed');
		  	thisQuestion.classList.toggle('is-expanded');
				thisAnswer.classList.toggle('is-collapsed');
				thisAnswer.classList.toggle('is-expanded');
		 	
		  	thisAnswer.classList.toggle('animateIn');
			};
			for (var i=0,len=accordionToggles.length; i<len; i++) {
				if(touchSupported) {
		      accordionToggles[i].addEventListener('touchstart', skipClickDelay, false);
		    }
		    if(pointerSupported){
		      accordionToggles[i].addEventListener('pointerdown', skipClickDelay, false);
		    }
		    accordionToggles[i].addEventListener('click', switchAccordion, false);
		 }

	}

  return {
      init: function () {
          loader();
          injectAsidebar();
          initFormReg();
          initAccordion();
          homeSlideShow();
          initDropdownMenu();
      }
  };
}();

! function ($) {
    playKutu.init();
}(window.jQuery);