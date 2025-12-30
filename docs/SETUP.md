# 🛠️ Setup Guide

This guide will walk you through setting up the AI Server Technician workflow from scratch.

---

## 📋 Prerequisites
* **n8n Instance:** Self-hosted (v1.0+ recommended).
* **Google Cloud Account:** To access the Sheets API.
* **Discord Server:** With "Manage Webhooks" permissions.
* **Docker Host:** SSH access to the server running your containers.

---

## Step 1: Google Sheets Configuration
The workflow uses Google Sheets as a database to store your targets and execution logs.

### 1.1 Enable Google Sheets API
1.  Go to the [Google Cloud Console](https://console.cloud.google.com/).
2.  Create a new project (e.g., `n8n-home-lab`).
3.  Search for **"Google Sheets API"** in the top bar and click **Enable**.

### 1.2 Create a Service Account
1.  In your Google Cloud project, go to **IAM & Admin > Service Accounts**.
2.  Click **+ Create Service Account**.
3.  **Name:** `n8n-bot` (or similar).
4.  Click **Create and Continue** (Role assignment is optional for basic sheet access).
5.  Click **Done**.
6.  Click on the newly created email address (e.g., `n8n-bot@project-id.iam.gserviceaccount.com`).
7.  Go to the **Keys** tab -> **Add Key** -> **Create new key**.
8.  Select **JSON** and download the file. **Keep this safe!** You will need it for n8n.

### 1.3 Prepare the Spreadsheet
1.  Create a new Google Sheet.
2.  **Share the Sheet:** Click the "Share" button and paste the **Service Account Email** (from step 1.2) as an **Editor**.
3.  **Create Tab 1: `Targets`** (Case sensitive).
    * **Row 1 Headers:**
        * `Name` (e.g., "Plex")
        * `URL` (e.g., "http://192.168.1.50:32400")
        * `Container_Name` (e.g., "plex")
        * `Active_Monitoring` (TRUE/FALSE)
        * `Current_Status` (Leave empty)
        * `Last_Checked` (Leave empty)
4.  **Create Tab 2: `Logs`** (Case sensitive).
    * **Row 1 Headers:**
        * `Timestamp`
        * `Target_Name`
        * `URL`
        * `Status_Code`
        * `Outcome`
5.  **Get the Sheet ID:** Copy the long string of characters from your browser's address bar (between `/d/` and `/edit`).

---

## Step 2: Discord Webhook Setup
We use Discord to receive real-time alerts when a service goes down or recovers.

1.  Open Discord and go to your server.
2.  Right-click the channel where you want alerts (e.g., `#uptime-alerts`) and click **Edit Channel**.
3.  Go to **Integrations** > **Webhooks**.
4.  Click **New Webhook**.
5.  **Name:** `AI Monitor`.
6.  Click **Copy Webhook URL**.
    * *Security Warning:* Do not share this URL publicly. It allows anyone to post to your channel.

---

## Step 3: SSH Configuration
For the "Self-Healing" feature, n8n needs to SSH into your server to run `docker restart`.

### 3.1 Security Best Practice (Dedicated User)
Avoid using `root`! Create a limited user on your Docker host:

```bash
# On your server terminal
sudo adduser n8n_monitor
sudo usermod -aG docker n8n_monitor
```
### 3.2 SSH Keys (Recommended)
1.  **Generate a key pair** on the machine running n8n (or your local PC):
    ```bash
    ssh-keygen -t ed25519 -C "n8n_access"
    ```
2.  **Copy the public key** to your Docker host:
    ```bash
    ssh-copy-id -i ~/.ssh/id_ed25519.pub n8n_monitor@192.168.1.50
    ```
3.  **Save the Private Key:** Copy the content of the *private* key file (usually `id_ed25519` without the `.pub` extension). You will paste this into n8n.
---

## Step 4: Import & Configure Workflow

### 4.1 Import the File
1.  Open your n8n dashboard.
2.  Click **Add workflow** > **... (Menu)** > **Import from File**.
3.  Select the `workflow/ai-server-monitor.json` file from this repository.

### 4.2 Configure Credentials
You will see several nodes with warning signs. Configure them in this order:

1.  **Google Sheets Nodes:**
    * Open the `Read Targets` node.
    * Create a new **Google API Credential**.
    * Upload the JSON key file from Step 1.2.
    * **Critical:** In the "Document" field, select "By ID" and paste your **Sheet ID** from Step 1.3.
    * *Repeat this for the `Update Target` and `Log Result` nodes.*

2.  **SSH Restart Node:**
    * Open the node and create a new **SSH Credential**.
    * **Host:** Your Docker server IP.
    * **User:** `n8n_monitor` (or your chosen user).
    * **Auth:** Select "Private Key" and paste the key from Step 3.2.

3.  **Discord Alert Node:**
    * Open the node.
    * Replace `https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE` with the URL from Step 2.

4.  **Google Gemini Node:**
    * Create a new **Google PaLM API** credential.
    * Paste your API Key (Get one from [Google AI Studio](https://aistudio.google.com/)).

### 4.3 Verify & Test
1.  Click **Execute Workflow** at the bottom of the canvas.
2.  **Check Output:**
    * Did the Google Sheet update?
    * Did you get a Discord notification?
3.  **Activate:** Once tested, toggle the **Active** switch to `On` to run it automatically every 30 minutes.
   
