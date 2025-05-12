# CHOICES.md — Decisions for Easy Arch

## Major Technical Choices

### 1. **Why Arch Linux?**

There are various other Linux distributions available, such as Ubuntu, Fedora, and Debian. We deliberately chose Arch Linux because it provides:

* **Full user control:** Users get to decide exactly what is installed on their system, without unnecessary bloatware.
* **Rolling release model:** Constant updates ensure users always have access to the latest packages and kernels.
* **Highly customizable:** Arch is known for its minimalism, giving users freedom to tailor their system precisely to their needs.
* **Educational value:** Arch forces users to understand how Linux systems work from the ground up.

However!! We also recognized that Arch’s complexity can be overwhelming and confusing for beginners. 
The installation process is fully manual, and post-install configuration can be very time-consuming. 
Our project solves that issue by having a guided interface that still teaches significant Linux concepts through scripting and automation.

We chose not to simplify distributions that are already beginner-friendly (like Ubuntu or Linux Mint), because they already have installers and GUIs. 
Instead, we saw a unique opportunity in Arch since it is powerful but difficult to install.

### 2. **Bash vs. Python**

We chose **Bash** for these reasons:

* It is preinstalled on all Unix-based systems
* Ideal for quick system-level scripting and task automation
* Better suited for chaining package manager commands and configuring system services
* Lightweight, no need for external dependencies or virtual environments

While Python offers more structure and advanced libraries, it introduced several issues during our testing:

* Python scripts required managing different versions across systems
* Using subprocesses to execute system commands added unnecessary complexity
* Added dependencies for even basic tasks (like user input or filesystem checks)
* Python needs error handling for subprocess management, whereas Bash lets us run commands directly
* It felt slower to work with Python for something so shell-based

We also simply didn't enjoy writing the logic in Python for a tool that is fundamentally tied to the Linux shell. 

### 3. **pacman vs. yay**

* **pacman** is Arch’s official package manager, and comes preinstalled.
* **yay** is an AUR helper that enables access to community packages from the Arch User Repository.

We decided to use **both pacman and yay**, depending on the use case:

* **pacman** is used during the core installation phase for stability and security
* **yay** is offered as an option for users to access extra tools from the AUR post-install

Why not use yay from the start? Because yay depends on `base-devel` and must be installed manually.
It pulls from user-contributed scripts (PKGBUILDs), which could be unstable or insecure if used before the system is fully ready. 
We use pacman for installing critical components like the base system, networking, display servers, and core utilities.
After the base setup, yay becomes helpful for software not available in the official repositories (like certain desktop environments, themes, or niche applications).
This dual approach lets us keep the install secure.

### 4. **Menu-Driven Script Design**

We chose a menu-driven structure for:

* A smoother user experience
* Easier navigation for beginners
* Clearer error handling and step-by-step execution

Each install option is modular (in its own script file), which helps with maintenance, debugging, and scalability.

---

