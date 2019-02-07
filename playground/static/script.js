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

  async function getEvaluation(code) {
    const response = await fetch('/check', {
      method: "POST",
      headers: { "Content-Type": "text/plain", },
      body: code
    });
    return await response.json();
  }

  async function checkCode(code) {
    output.classList.add('loading');
    const { errors, result } = await getEvaluation(code)
    setErrors(errors);
    setResult(result);
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

  function setResult(result) {
    if (!editor) return;
    const pre = editor.editorRoot.querySelector('pre');
    if (!pre) return;
    pre.dataset.result = `#=> ${result}`;
  }

  const debouncedCheckCode = debounce(checkCode, 300);

  document.addEventListener("DOMContentLoaded", function () {
    output = document.querySelector('#output');

    window.editor = editor = new CodeFlask('#editor', {
      language: 'ruby',
      lineNumbers: true
    });

    checkCode(editor.getCode());

    editor.onUpdate(debouncedCheckCode);
  });

})();