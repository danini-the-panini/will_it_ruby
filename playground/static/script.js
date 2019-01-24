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

  async function checkCode() {
    output.classList.add('loading');
    output.textContent = 'Loading...';
    const errors = await getErrors(editor.value);
    output.textContent = errors.map(error => error.full_message).join('<br>');
    output.classList.remove('loading');
  }

  const debouncedCheckCode = debounce(checkCode, 300);

  document.addEventListener("DOMContentLoaded", function () {
    editor = document.querySelector('.editor');
    output = document.querySelector('.output');

    checkCode();

    editor.addEventListener('input', debouncedCheckCode, false);
    editor.addEventListener('change', debouncedCheckCode, false);
  });

})();