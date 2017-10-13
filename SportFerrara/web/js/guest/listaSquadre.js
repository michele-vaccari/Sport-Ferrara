f = document;

function viewSquadra(index) {
  s = f.forms["viewForm"+index];
  s.submit();
  return;
}

function viewRosa(index) {
  r = f.forms["viewFormRosa"+index];
  r.submit();
  return;
}

function viewTornei(index) {
  t = document.forms["viewFormTornei"+index];
  t.submit();
  return;
}