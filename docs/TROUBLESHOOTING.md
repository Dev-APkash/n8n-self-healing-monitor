# 🔧 Troubleshooting Guide

## Common Issues

### Issue: "Container not in whitelist"
**Symptom:** The service stays down, and no restart attempt is made, even though the workflow ran.

**Solution:**
1. Check the **Container_Name** column in your Google Sheet.
2. Verify it is an **exact match** (case-sensitive) to the container name on your host (run `docker ps --format "{{.Names}}"` to check).
3. Update the `ALLOWED_CONTAINERS` array in the **Code Node** if you added a new service.

### Issue: SSH Connection Timeout
**Symptom:** The workflow errors out at the "SSH Restart" node with `ETIMEDOUT` or `ECONNREFUSED`.

**Solution:**
1. **Check IP:** Ensure the `Host` IP in your n8n credentials matches your Docker server.
2. **Firewall:** Verify port 22 is open on the host (`sudo ufw status`).
3. **Network:** If n8n is in Docker, ensure it can reach the host IP (try pinging the host from the n8n container).
4. **Key Permissions:** Ensure the private key used in n8n matches the public key in `~/.ssh/authorized_keys` on the host.

### Issue: Discord Webhook 404
**Symptom:** The "Discord Alert" node fails with `404 Not Found`.

**Solution:**
1. **Invalid URL:** The Webhook URL might be incomplete or copied incorrectly.
2. **Deleted Webhook:** The webhook may have been deleted in Discord Server Settings.
3. **Fix:** Go to **Discord > Server Settings > Integrations > Webhooks**, generate a new URL, and update the **Discord Alert** node in n8n.

## Debug Mode
If the workflow behaves unexpectedly, you can enable verbose logging in your n8n instance:

```bash
# If running via Docker
docker run -e N8N_LOG_LEVEL=debug ...
```
Or check the specific Execution Log in the n8n UI:

## Go to the Executions tab on the left sidebar.

- Click on the failed execution.

- Click on the node that failed to see the full JSON input/output.
