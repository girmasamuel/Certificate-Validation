document.addEventListener('DOMContentLoaded', function() {
    const body = document.body;
    const themeToggle = document.getElementById('theme-toggle');
    const themeIcon = themeToggle.querySelector('i');
    const fileInput = document.getElementById('file-input');
    const previewContainer = document.getElementById('preview-container');
    const previewContent = document.getElementById('preview-content');
    const uploadForm = document.getElementById('upload-form');

    // Theme toggle functionality
    themeToggle.addEventListener('click', function() {
        body.classList.toggle('dark-theme');
        if (body.classList.contains('dark-theme')) {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        } else {
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
        }
    });

    // File preview functionality
    fileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            previewContainer.classList.remove('d-none');
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewContent.innerHTML = `<img src="${e.target.result}" class="img-fluid" alt="File preview">`;
                }
                reader.readAsDataURL(file);
            } else if (file.type === 'application/pdf') {
                previewContent.innerHTML = `<embed src="${URL.createObjectURL(file)}" type="application/pdf" width="100%" height="200px" />`;
            } else {
                previewContent.textContent = `File name: ${file.name}\nFile size: ${(file.size / 1024).toFixed(2)} KB\nFile type: ${file.type}`;
            }
        } else {
            previewContainer.classList.add('d-none');
            previewContent.innerHTML = '';
        }
    });

    // Form submission
    uploadForm.addEventListener('submit', function(e) {
        e.preventDefault();
        // Here you would typically send the file to a server
        alert('File submitted successfully!');
    });

    // Add some interactivity to the navbar
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Add a subtle parallax effect
    window.addEventListener('scroll', function() {
        const scrollPosition = window.pageYOffset;
        body.style.backgroundPositionY = -scrollPosition * 0.5 + 'px';
    });
});