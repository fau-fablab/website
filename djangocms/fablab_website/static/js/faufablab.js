/* SMOOTH SCROLLING
------------------- */

$("a[href^='#'].smooth_scroll").on('click', function(e) {
  // prevent default anchor click behavior
  e.preventDefault();

  // store hash
  var hash = this.hash;

  // animate
  $('html, body').animate({scrollTop: $(hash).offset().top}, 500, function(){
     window.location.hash = hash;
   });
});
