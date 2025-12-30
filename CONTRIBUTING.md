# Contributing Guidelines

Thank you for your interest in improving the **n8n-self-healing-monitor**! We welcome contributions from the community.

## How to Contribute
1. **Fork the repository** to your own GitHub account.
2. **Create a feature branch**: 
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Test your changes thoroughly in your own n8n instance.
4. **Commit with clear messages:
   ```bash
   git commit -m 'Add amazing feature'
   ```
5. **Push to branch:
  ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request against the main branch.

## ⚠️ Important: Workflow Safety
**Before submitting a Pull Request that includes `.json` workflow files:**
* **Sanitize Credentials:** Ensure all API keys, SSH passwords, and Webhook URLs are removed or replaced with placeholders (e.g., `YOUR_WEBHOOK_URL`).
* **Clear Pin Data:** In n8n, ensure no execution data is pinned to the nodes (which often contains personal server logs).
* **Use Credentials Nodes:** Do not hardcode passwords in "Set" nodes; reference n8n Credential IDs instead.

## Code Standards
- **Style:** Follow the existing node layout (left-to-right flow).
- **Comments:** Add "Note" nodes in n8n for complex logic or large Javascript blocks.
- **Documentation:** Update `README.md` if adding new environment variables or dependencies.
- **Validation:** Test with at least 3 different services (e.g., a mix of valid and invalid URLs).

## Reporting Issues
- Use the issue template.
- Include your **n8n version** (e.g., 1.x.x).
- Provide workflow execution logs (redacted).
- Describe expected vs. actual behavior.

## Security Vulnerabilities
**Do not open public issues for security bugs** (e.g., exposed SSH keys or injection vulnerabilities).
Email: [your-email]@example.com
