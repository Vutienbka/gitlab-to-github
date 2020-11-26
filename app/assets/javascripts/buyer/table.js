$(document).ready(function() {
  $("tr").click(function() {
    var claim_id = $(this).find("td:first").html();
    window.location.href = '/suppliers/claims/' + claim_id;
  });
  $('[data-toggle="tooltip"]').tooltip();
});