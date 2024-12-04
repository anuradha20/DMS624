// script.js
document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById('loanForm');

    // Add event listener for form submission
    form.addEventListener('submit', (event) => {
        event.preventDefault(); // Prevent actual form submission

        // Collect form data
        const formData = new FormData(form);
        const data = Object.fromEntries(formData.entries());

        // Collect multiple checkbox values for schemeConsent
        const schemeConsent = [];
        form.querySelectorAll('input[name="schemeConsent"]:checked').forEach(input => {
            schemeConsent.push(input.value);
        });
        data.schemeConsent = schemeConsent;

        // Perform basic validation
        if (!data.applicantName || !data.accountNumber || !data.loanAmount) {
            alert("Please fill out all required fields marked with an asterisk (*)!");
            return;
        }

        // Confirmation dialog
        if (confirm("Do you want to submit the application?")) {
            alert("Application submitted successfully!");
            console.log("Submitted Data:", data); // For demonstration, logs data to the console
            form.reset(); // Reset form after submission
        }
    });

    // Tooltip functionality (optional)
    const tooltips = document.querySelectorAll('[data-tooltip]');
    tooltips.forEach(tooltip => {
        tooltip.addEventListener('mouseenter', () => {
            const message = tooltip.getAttribute('data-tooltip');
            const tooltipBox = document.createElement('div');
            tooltipBox.className = 'tooltip-box';
            tooltipBox.innerText = message;
            document.body.appendChild(tooltipBox);

            // Position the tooltip
            const rect = tooltip.getBoundingClientRect();
            tooltipBox.style.left = `${rect.left + window.pageXOffset}px`;
            tooltipBox.style.top = `${rect.top + window.pageYOffset - tooltipBox.offsetHeight - 5}px`;

            tooltip.addEventListener('mouseleave', () => {
                tooltipBox.remove();
            }, { once: true });
        });
    });
});
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
}
