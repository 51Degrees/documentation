$(document).ready(function(){
  
  $(".is-revealable").click(function(e){
    e.preventDefault();
    
    var $this = $(this),
        $parentPanel = $(this).parents(".g-panel:first"),
        $thisItem = $(this).parents(".g-panel__item:first");
        $thisPanel = $thisItem.find(".g-panel:first");
    
    $parentPanel.find(".g-panel").removeClass("is-active");
    $parentPanel.find(".g-panel__item").removeClass("is-active");
    $parentPanel.find(".is-revealable").removeClass("is-active");
    
    $thisItem.addClass("is-active");
    $thisPanel.addClass("is-active");
    $this.addClass("is-active");
  });
  
  $(".is-reversable").click(function(e){
    e.preventDefault();
    
    var $this = $(this),
        $parentItem = $(this).parents(".g-panel__item:first");
    
    $parentItem.removeClass("is-active").find(".is-active").removeClass("is-active");
  });
  
  $(".g-options .is-selectable").change(function(e){
    var $this = $(this),
        thisId = $this.attr("id"),
        $panel = $this.parents(".g-panel__item:first");
    
    if(thisId.includes("--alternative")) {
      $panel.find(".is-selectable:first").click();
    } else {
      $panel.find(".is-selectable:last").click();
      if($this.is(":checked")) {
        addToBasket($this.attr("id"), $this.data("property"));
      } else {
        removeFromBasket($this.attr("id"));
      }
    }
  });
  
  $(".is-openable a").click(function(e){
    e.preventDefault();
    
    var $this = $(this),
        $parent = $this.parent(".is-openable");
    
    $parent.toggleClass("is-opened");
  });
  
  $(".is-openable input").keypress(function(e){
    
    var $this = $(this),
        $parent = $this.closest(".is-openable");
    
    $parent.addClass("is-opened");
  });
  
  $(".g-panel").find(".is-revealable:first").click();
  
  $(".g-footer__next input").change(function(){
    $(".g-footer__next .b-btn").toggleClass('b-btn--disabled');
  });
  
});

function addToBasket(id, property) {
  $(".g-basket__properties").append("<li data-id='" + id + "' class='g-basket__item'><a class='g-basket__remove' href='#'>" + property + "<span class='c-option__additional'><span class='c-option__vendor'><img src='/images/icon-feature-vendor-google.png' alt='Vendor' /></span><span class='c-option__billable'><span>Billable</span></span></span></a></li>");
  updateCounter();
}

function removeFromBasket(id) {
  $(".g-basket__properties").find("li[data-id='" + id + "']").remove();
  updateCounter();
}

function updateCounter(count) {
  var $counter = $(".g-basket__count"),
      $properties = $(".g-basket__properties li");
  
  $counter.html($properties.length);
  $(".c-category__link.is-active").find(".c-category__count--selected").html($properties.length).show();
}