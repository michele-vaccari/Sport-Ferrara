f = document;

function viewGiocatore(index) {
  g = f.forms["viewGiocatore"+index];
  g.submit();
  return;
}

function viewRosa() {
  f.forms["viewRosaSquadra"].submit();
  return;
}

function viewTornei() {
  f.forms["viewTorneiCorso"].submit();
  return;
}