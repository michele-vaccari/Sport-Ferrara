f = document;

function viewSquadra(index) {
  s = f.forms["viewForm"+index];
  s.submit();
  return;
}

function viewReferto(index) {
  r = f.forms["viewFormReferto"+index];
  r.submit();
  return;
}