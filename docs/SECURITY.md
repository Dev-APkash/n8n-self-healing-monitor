# 🛡️ Security Best Practices

## Overview
This workflow executes remote SSH commands on your Docker host. Because it bridges the gap between external web alerts (Discord/Google Sheets) and your internal infrastructure, security is paramount. Follow these guidelines to prevent unauthorized access.

## Critical Security Measures

### 1. Container Whitelist (REQUIRED)
**Never skip this step.** To prevent a compromised Google Sheet from restarting arbitrary system services, you should validate container names in the Code Node.

Edit the `Code in JavaScript` node to include an allowlist:
```javascript
const ALLOWED_CONTAINERS = [
  'plex',
  'radarr',
  'sonarr',
  'homeassistant'
];

// In the loop, add this check:
if (!ALLOWED_CONTAINERS.includes(containerName)) {
   item.json.alert_title = "⛔ Security Block: Unauthorized Container Request";
   continue; // Skip this item
}
```
### 2. SSH Key Security
* **Use a Dedicated Key:** Generate a specific SSH key pair (`id_ed25519_n8n`) solely for this workflow. Do not reuse your personal root key.
* **Restrict Permissions:** Ensure the private key file on the n8n server is read-only for the owner:
    ```bash
    chmod 600 ~/.ssh/id_ed25519_n8n
    ```
* **Least Privilege User:** Create a limited user on the target host that *only* belongs to the docker group:
    ```bash
    sudo useradd -m -G docker n8n-monitor
    # Verify it cannot run sudo
    su - n8n-monitor
    sudo ls /root # Should fail
    ```

### 3. Google Sheets Access Control
The Google Sheet acts as the "Command & Control" center for this workflow. If an attacker gains access to it, they could manipulate which URLs are scanned.
* **Service Account Only:** Share the sheet *only* with the specific Service Account email (e.g., `n8n-bot@project.iam.gserviceaccount.com`).
* **Do Not Publish:** Never set the sheet sharing settings to "Anyone with the link".
* **Key Rotation:** If you accidentally commit your Service Account JSON key to GitHub, **revoke it immediately** in the Google Cloud Console and generate a new one.

### 4. Network Security
* **Internal Traffic Only:** Ideally, your n8n instance and your Docker host should communicate over a private local network (LAN) or a secure VPN (like Tailscale or WireGuard).
* **Firewall Rules (UFW):** Restrict SSH access on the Docker host to only accept connections from the n8n IP address:
    ```bash
    # On Docker Host
    sudo ufw allow from <n8n_ip_address> to any port 22
    ```
* **Do not expose SSH:** Never open port 22 directly to the public internet.

## Threat Model

| Threat Scenario | Risk Level | Mitigation |
| :--- | :--- | :--- |
| **Compromised Google Sheet** | High | An attacker could change a Target URL to an internal IP (SSRF) or change a Container Name. **Mitigation:** The `ALLOWED_CONTAINERS` whitelist prevents them from restarting critical system containers (like `traefik` or database containers). |
| **Compromised n8n Instance** | Critical | An attacker gains access to the SSH key. **Mitigation:** Using a limited `n8n-monitor` user ensures they only get Docker access, not Root access to the host OS. |
| **Man-in-the-Middle** | Low | An attacker intercepts the webhook payload. **Mitigation:** Use HTTPS for all webhook and API connections. Discord and Google APIs enforce this by default. |

## Reporting Vulnerabilities
If you discover a security vulnerability within this workflow, please open an Issue in this repository with the tag `security` or contact the maintainer directly.
