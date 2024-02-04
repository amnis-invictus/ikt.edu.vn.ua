function arrayEq(a, b) {
  if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++)
    if (a[i] !== b[i]) return false;
  return true;
}

$('[data-component="grade-groups"]').each(function () {
  const input = this.querySelector('input');
  const gradeSelect = this.querySelector('select[data-target="grades"]');
  const groupSelect = this.querySelector('select[data-target="groups"]');

  let value = JSON.parse(input.value);
  const setValue = function (newValue) {
    value = newValue;
    input.value = JSON.stringify(value);
  };

  $('button[data-action="move-to-groups"]').on('click', function () {
    const options = Array.from(gradeSelect.selectedOptions);
    const grades = options.map(o => parseInt(o.value));
    setValue([...value, grades]);
    const newGroupOption = document.createElement('option');
    newGroupOption.value = grades.join(',');
    newGroupOption.text = options.map(o => o.text).join(', ');
    groupSelect.appendChild(newGroupOption);
    options.forEach(o => o.remove());
  });

  $('button[data-action="move-to-grades"]').on('click', function () {
    const options = Array.from(groupSelect.selectedOptions);
    const groups = options.map(o => o.value.split(',').map(grade => parseInt(grade)));
    const texts = options.map(o => o.text.split(','));
    const newValue = value.filter(a => !groups.some(b => arrayEq(a, b)));
    setValue(newValue);
    options.forEach(o => o.remove());
    groups.forEach((grades, i) => {
      grades.forEach((grade, j) => {
        const newGradeOption = document.createElement('option');
        newGradeOption.value = grade;
        newGradeOption.text = texts[i][j];
        gradeSelect.appendChild(newGradeOption);
      });
    });
  });
});
