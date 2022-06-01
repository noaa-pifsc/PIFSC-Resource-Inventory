
function register_tooltips()
{
  //register the div labels tooltips (display tooltip content above the tooltip calling element)
  $ ("div.tooltip").tooltip({
  position: {
    my: "center bottom",
    at: "center top-10",
    using: tooltip_arrows
  }
  });

  //register the display table's header row's, accordion widget, and accordion widget links as tooltips (display the tooltip content below the tooltip calling element)
  $("h3.tooltip, div#accordion_filter a.tooltip").tooltip({
  position: {
    my: "center bottom-20",
    at: "center top",
    using: tooltip_arrows
  }
});

}
