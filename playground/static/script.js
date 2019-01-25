(function() {

  let editor, output;

  function debounce(func, wait = 100) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        func(...args);
      }, wait);
    };
  }

  async function getErrors(code) {
    const response = await fetch('/check', {
      method: "POST",
      headers: { "Content-Type": "text/plain", },
      body: code
    });
    return await response.json();
  }

  async function checkCode(code) {
    output.classList.add('loading');
    setErrors(await getErrors(code));
    output.classList.remove('loading');
  }

  function setErrors(errors) {
    output.innerHTML = errors.map(error => error.full_message).join('<br>');
    [].forEach.call(editor.elWrapper.querySelectorAll('.error'), t => t.remove());
    errors.forEach(error => {
      const elError = document.createElement('div');
      elError.classList.add('error');
      elError.style.top = `${10 + 20 * (error.line-1)}px`;
      elError.textContent = error.message;
      editor.elWrapper.appendChild(elError);
    });
  }

  const debouncedCheckCode = debounce(checkCode, 300);

  document.addEventListener("DOMContentLoaded", function () {
    editor = document.querySelector('#editor');
    output = document.querySelector('#output');

    window.editor = editor = new CodeFlask('#editor', {
      language: 'ruby',
      lineNumbers: true
    });

    checkCode(editor.getCode());

    editor.onUpdate(debouncedCheckCode);
  });

})();