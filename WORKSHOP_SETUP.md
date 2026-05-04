# Tududi Workshop — Setup

This should take ~10 minutes. If you hit a snag, skim **Troubleshooting** at the bottom.

## What you need installed

### 1. Node.js (v20 LTS or newer)

- **Mac / Windows:** Download the **LTS** installer from https://nodejs.org and run it.
- **Linux:** Use your package manager (e.g. `sudo apt install nodejs npm`). If it gives you anything older than v20, install [nvm](https://github.com/nvm-sh/nvm) and run `nvm install 20`.

Verify: `node --version` → should print `v20.x` or higher.

### 2. Git

- **Mac:** `xcode-select --install` (or already installed)
- **Windows:** Install **Git for Windows** from https://git-scm.com. Accept the default options — in particular leave "Git from the command line and also from 3rd-party software" selected. This puts `git` and `bash` on your PATH, which the project's start scripts rely on.
- **Linux:** `sudo apt install git`

Verify: `git --version`

---

## Run the project

### Pick a terminal

- **Mac / Linux:** Your default terminal.
- **Windows:** Any of Git Bash, PowerShell, or Windows Terminal will work. If you have no preference, use **Git Bash** (installed with Git above — look for it in your Start Menu). It behaves the same as a Mac/Linux terminal, so any commands shared during the workshop will just work.

### Clone and install

```bash
git clone https://github.com/rchakra4/tududi.git
cd tududi
npm install
```

`npm install` takes 1–3 minutes the first time.

### Start the backend (Terminal 1)

```bash
npm run backend:workshop
```

This creates the database, seeds an admin user, and starts the API on port 3002. Leave it running.

### Start the frontend (Terminal 2)

Open a second terminal, `cd` back into `tududi`, and run:

```bash
npm run frontend:dev
```

### Log in

Open http://localhost:8080 and sign in with:

- **Email:** `admin@example.com`
- **Password:** `password123`

You should see the app. You're set.

Spend a few minutes clicking around, adding some tasks, and exploring the features so you have a feel for the app before the workshop.

To stop everything, hit `Ctrl+C` in each terminal.

---

## Troubleshooting

**`npm install` fails with errors mentioning `node-gyp`, `bcrypt`, or `sqlite3`:**
You're missing a C++ toolchain (only some setups need this).

- **Mac:** `xcode-select --install`
- **Linux:** `sudo apt install build-essential python3`
- **Windows:** Easiest fix is to install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Ubuntu) and re-run the steps inside it.

**`'bash' is not recognized` on Windows:** Git for Windows didn't add bash to your PATH. Reinstall Git and make sure "Git from the command line and also from 3rd-party software" is selected, or just use Git Bash as your terminal.

**Port 8080 or 3002 already in use:**

- **Mac / Linux:** From the project folder, run `npm run kill:all`, then retry.
- **Windows:** Run `netstat -ano | findstr :8080` (and again with `:3002`), find the row whose state is `LISTENING`, note the PID in the last column, then `taskkill /PID <pid> /F`. Works in PowerShell, CMD, or Git Bash.

**Login fails / "no such user":** Stop the backend (`Ctrl+C` in Terminal 1), delete `backend/db/development.sqlite3`, then re-run `npm run backend:workshop`.
