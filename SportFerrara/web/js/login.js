f = document;

function isEmpty(value) {
  
  if (value == null || value.length == 0)
    return true;
  
  for (var count = 0; count < value.length; count++) {
    if (value.charAt(count) != " ") return false;
  }
  
  return true;
}

function submitLogin() {
  
  if (isEmpty(logonForm.email.value)) {
    $(document).ready(function () {
      $.jAlert({
        'title': 'Campo E-mail vuoto!',
        'content': 'Inserire una <b>E-mail</b>',
        'theme': 'green'
        //'btns': { 'text': 'Chiudi' }
      });
    });
    return;
  }
  
  if (isEmpty(logonForm.password.value)) {
    $(document).ready(function () {
      $.jAlert({
        'title': 'Campo Password vuoto!',
        'content': 'Inserire una <b>Password</b>',
        'theme': 'green'
        //'btns': { 'text': 'Chiudi' }
      });
    });
    return;
  }
  
  f.logonForm.submit();
}

function submitLoginGuest() {
  
  f.logonGuest.submit();
}