browsingClass = window.location.href.split('-')[1];

const navLinks = document.querySelectorAll('.spell-tab');

for (const tab of navLinks) {
    if (tab.getAttribute('id').includes(browsingClass)) {
        tab.classList.add('active')
    }
}